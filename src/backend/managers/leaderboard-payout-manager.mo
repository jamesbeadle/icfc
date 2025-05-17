import Array "mo:base/Array";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Text "mo:base/Text";

import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import Enums "mo:waterway-mops/base/enums";
import PayoutManager "mo:waterway-mops/product/wwl/payout-management/manager";
import Ids "mo:waterway-mops/base/ids";
import Ledger "mo:waterway-mops/base/def/sns-wrappers/ledger";
import ICFCQueries "mo:waterway-mops/product/icfc/queries";
import RewardPayoutCommands "mo:waterway-mops/product/openfpl/reward-payout-commands";
import RewardPayoutResponses "mo:waterway-mops/product/openfpl/reward-payout-responses";

import ICFCTypes "../types";
import PayoutCommands "../commands/payout-commands";
import Utilities "../utilities/utilities";

module {
    public class RewardPayoutManager() {

        private let tokenManager = PayoutManager.PayoutManager();
        private var openfpl_reward_requests : [ICFCTypes.OpenFPLPayoutRequest] = [];

        public func getOpenFPLRewardRequests() : [ICFCTypes.OpenFPLPayoutRequest] {
            return openfpl_reward_requests;
        };

        public func addLeaderboardPayoutRequest(dto : RewardPayoutCommands.PayoutRequest) : async Result.Result<(), Enums.Error> {
            // check if the request already exists
            var request = Array.find(
                openfpl_reward_requests,
                func(entry : ICFCTypes.OpenFPLPayoutRequest) : Bool {
                    entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and entry.app == dto.app
                },
            );

            switch (request) {
                case (null) {
                    openfpl_reward_requests := Array.append<ICFCTypes.OpenFPLPayoutRequest>(
                        openfpl_reward_requests,
                        [{
                            app = dto.app;
                            currency = dto.currency;
                            totalEntries = Array.size(dto.leaderboard);
                            totalPaid = 0;
                            status = #Pending;
                        }],
                    );
                    return #ok(());
                };
                case (?request) {
                    return #err(#AlreadyExists);
                };
            };
        };

        public func payoutLeaderboard(dto : PayoutCommands.PayoutLeaderboard) : async Result.Result<RewardPayoutResponses.LeaderboardPayoutResponse, Enums.Error> {
            // find the request in the list
            var request = Array.find(
                openfpl_reward_requests,
                func(entry : ICFCTypes.OpenFPLPayoutRequest) : Bool {
                    entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and entry.app == dto.app
                }
            );
            

            switch (request) {
                case (null) {
                    return #err(#NotFound);
                };
                case (?request) {
                    if (request.status == #Paid) {
                        return #err(#NotAllowed);
                    } else {
                        let token = request.currency;
                        let ?ledgerCanisterID = Utilities.getTokenLedgerId(token) else {
                            return #err(#InvalidData);
                        };

                        // get the ICFC links
                        let ?appCanisterId = CanisterIds.getAppCanisterId(dto.app) else {
                            return #err(#NotFound);
                        };
                        var icfcLinks : [ICFCQueries.ICFCLinks] = [];

                        var appCanister = actor (appCanisterId) : actor {
                            getICFCProfileLinks : (dto : ICFCQueries.GetICFCLinks) -> async Result.Result<[ICFCQueries.ICFCLinks], Enums.Error>;
                        };

                        let res = await appCanister.getICFCProfileLinks({});
                        switch (res) {
                            case (#ok(links)) {
                                icfcLinks := links;
                            };
                            case (#err(err)) {
                                return #err(err);
                            };
                        };

                        // TODO pay out the users
                        var leaderboardPayout = request.leaderboard;
                        var totalPaid = request.totalPaid;
                        for (entry : InterAppCallCommands.LeaderboardEntry in Iter.fromArray(leaderboardPayout)) {
                            let icfcProfileLink = Array.find(
                                icfcLinks,
                                func(link : ICFCQueries.ICFCLinks) : Bool {
                                    link.subAppUserPrincipalId == entry.appPrincipalId;
                                },
                            );
                            if (entry.payoutStatus == #Pending and hasValidSubscription(icfcProfileLink)) {
                                let appPrincipal = entry.appPrincipalId;
                                let amount = entry.rewardAmount;
                                switch (amount) {
                                    case (null) {};
                                    case (?amount) {
                                        // payout to ICFC account
                                        let icfcPrincipal = switch (icfcProfileLink) {
                                            case (?link) link.icfcPrincipalId;
                                            case (null) return #err(#InvalidData);
                                        };
                                        let res = await payoutUser(icfcPrincipal, amount, ledgerCanisterID);

                                        switch (res) {
                                            case (#ok(_)) {
                                                // update the leaderboard entry
                                                leaderboardPayout := Array.map(
                                                    leaderboardPayout,
                                                    func(entry : InterAppCallCommands.LeaderboardEntry) : InterAppCallCommands.LeaderboardEntry {
                                                        if (entry.appPrincipalId == appPrincipal) {
                                                            return {
                                                                appPrincipalId = entry.appPrincipalId;
                                                                rewardAmount = entry.rewardAmount;
                                                                payoutStatus = #Paid;
                                                                payoutDate = ?Int.abs(Time.now());
                                                            };
                                                        } else {
                                                            return entry;
                                                        };
                                                    },
                                                );
                                                totalPaid += 1;

                                            };
                                            case (#err(_)) {
                                                return #err(#IncorrectSetup);
                                            };
                                        };
                                    };

                                };
                            };
                        };

                        // update the request
                        //todo: add the response result


                        leaderboard_payout_requests := Array.map(
                            leaderboard_payout_requests,
                            func(entry : ICFCTypes.PayoutRequest) : ICFCTypes.PayoutRequest {
                                if (entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and entry.app == dto.app) {
                                    return {
                                        seasonId = entry.seasonId;
                                        gameweek = entry.gameweek;
                                        app = entry.app;
                                        leaderboard = leaderboardPayout;
                                        currency = entry.currency;
                                        totalEntries = entry.totalEntries;
                                        totalPaid = totalPaid;
                                        status = #Pending;
                                    };
                                } else {
                                    return entry;
                                };
                            },
                        );
                        return #ok({
                            seasonId = dto.seasonId;
                            gameweek = dto.gameweek;
                            app = dto.app;
                            leaderboard = leaderboardPayout;
                            currency = request.currency;
                            totalEntries = request.totalEntries;
                            totalPaid = totalPaid;
                            status = #Pending;
                        });
                    };
                };
            };
        };

        public func getStableLeaderboardPayoutRequests() : [ICFCTypes.OpenFPLPayoutRequest] {
            return openfpl_reward_requests;
        };

        public func setStableLeaderboardPayoutRequests(requests : [ICFCTypes.OpenFPLPayoutRequest]) {
            openfpl_reward_requests := requests;
        };

        private func payoutUser(principal : Ids.PrincipalId, amount : Nat64, tokenledgerId : Text) : async Result.Result<(), Ledger.TransferError> {
            let _ = await tokenManager.payoutUser(principal, amount, tokenledgerId);
        };

        private func hasValidSubscription(profile : ?ICFCQueries.ICFCLinks) : Bool{
            switch (profile) {
                case (null) {
                    return false;
                };
                case (?profile) {
                    switch (profile.subscriptionType) {
                        case (#Expired) {
                            return false;
                        };
                        case (#NotClaimed) {
                            return false;
                        };
                        case (#NotEligible) {
                            return false;
                        };
                        case (_) {
                            return true;
                        };
                    };
                };
            };
        };

    };

};
