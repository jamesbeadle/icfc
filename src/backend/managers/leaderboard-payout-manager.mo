import Array "mo:base/Array";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Text "mo:base/Text";

import Account "mo:waterway-mops/base/def/account";
import Enums "mo:waterway-mops/base/enums";
import ICRCTokenManager "mo:waterway-mops/product/wwl/payout-management/manager";
import Ids "mo:waterway-mops/base/ids";
import InterAppCallCommands "mo:waterway-mops/product/icfc/inter-app-call-commands";
import Ledger "mo:waterway-mops/base/def/sns-wrappers/ledger";

import ICFCTypes "../types";
import PayoutCommands "../commands/payout-commands";
import PayoutQueries "../queries/payout-queries";
import Utilities "../utilities/utilities";
import T "../types";

module {
    public class LeaderboardPayoutManager() {

        private let tokenManager = ICRCTokenManager.ICRCTokenManager();
        private var leaderboard_payout_requests : [ICFCTypes.PayoutRequest] = [];

        public func getLeaderboardPayoutRequests() : [ICFCTypes.PayoutRequest] {
            return leaderboard_payout_requests;
        };

        public func addLeaderboardPayoutRequest(dto : InterAppCallCommands.LeaderboardPayoutRequest) : async Result.Result<(), Enums.Error> {
            // check if the request already exists
            var request = Array.find(
                leaderboard_payout_requests,
                func(entry : ICFCTypes.PayoutRequest) : Bool {
                    entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and entry.app == dto.app
                },
            );

            switch (request) {
                case (null) {
                    leaderboard_payout_requests := Array.append<ICFCTypes.PayoutRequest>(
                        leaderboard_payout_requests,
                        [{
                            seasonId = dto.seasonId;
                            gameweek = dto.gameweek;
                            app = dto.app;
                            leaderboard = dto.leaderboard;
                            token = dto.token;
                            totalEntries = Array.size(dto.leaderboard);
                            totalEntriesPaid = 0;
                        }],
                    );
                    return #ok(());
                };
                case (?request) {
                    return #err(#AlreadyExists);
                };
            };
        };

        public func payoutLeaderboard(dto : PayoutCommands.PayoutLeaderboard) : async Result.Result<ICFCTypes.PayoutRequest, Enums.Error> {
            // find the request in the list
            let ?appText = BaseUtilities.appToText(dto.app)else{
                return #err(#NotFound);
            };
            var request = Array.find(
                leaderboard_payout_requests,
                func(entry : ICFCTypes.PayoutRequest) : Bool {
                    entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and Text.equal(entry.app, appText)
                },
            );

            switch (request) {
                case (null) {
                    return #err(#NotFound);
                };
                case (?request) {
                    if (request.totalEntries == request.totalEntriesPaid) {
                        return #err(#NotAllowed);
                    } else {
                        let token = request.token;
                        let ?ledgerCanisterID = Utilities.getTokenLedgerId(token) else {
                            return #err(#InvalidData);
                        };

                        // get the ICFC links
                        let ?appCanisterId = BaseUtilities.getAppCanisterId(dto.app) else {
                            return #err(#NotFound);
                        };
                        var icfcLinks : [PayoutQueries.ICFCLinks] = [];

                        var appCanister = actor (appCanisterId) : actor {
                            getICFCProfileLinks : (dto : PayoutQueries.GetICFCLinks) -> async Result.Result<[PayoutQueries.ICFCLinks], Enums.Error>;
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

                        // pay out the users
                        var leaderboardPayout = request.leaderboard;
                        var totalPaid = request.totalEntriesPaid;
                        for (entry : LeaderboardPayoutCommands.LeaderboardEntry in Iter.fromArray(leaderboardPayout)) {
                            let icfcProfileLink = Array.find(
                                icfcLinks,
                                func(link : PayoutQueries.ICFCLinks) : Bool {
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
                                                    func(entry : LeaderboardPayoutCommands.LeaderboardEntry) : LeaderboardPayoutCommands.LeaderboardEntry {
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
                        leaderboard_payout_requests := Array.map(
                            leaderboard_payout_requests,
                            func(entry : ICFCTypes.PayoutRequest) : ICFCTypes.PayoutRequest {
                                if (entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and Text.equal(entry.app, appText)) {
                                    return {
                                        seasonId = entry.seasonId;
                                        gameweek = entry.gameweek;
                                        app = entry.app;
                                        leaderboard = leaderboardPayout;
                                        token = entry.token;
                                        totalEntries = entry.totalEntries;
                                        totalEntriesPaid = totalPaid;
                                    };
                                } else {
                                    return entry;
                                };
                            },
                        );
                        return #ok({
                            seasonId = dto.seasonId;
                            gameweek = dto.gameweek;
                            app = appText;
                            leaderboard = leaderboardPayout;
                            token = request.token;
                            totalEntries = request.totalEntries;
                            totalEntriesPaid = totalPaid;
                        });
                    };
                };
            };
        };

        public func getStableLeaderboardPayoutRequests() : [ICFCTypes.PayoutRequest] {
            return leaderboard_payout_requests;
        };

        public func setStableLeaderboardPayoutRequests(requests : [ICFCTypes.PayoutRequest]) {
            leaderboard_payout_requests := requests;
        };

        private func payoutUser(principal : Ids.PrincipalId, amount : Nat64, tokenledgerId : Text) : async Result.Result<(), Ledger.TransferError> {
            let _ = await tokenManager.payoutUser(principal, amount, tokenledgerId);
        };

        private func hasValidSubscription(profile : ?PayoutQueries.ICFCLinks) : Bool{
            return false; // TODO
        };

        /*

            Moving away from membership based ICRC SNS token to subscription based ckBTC - So this code can be removed for now.

            private func isValidICFCProfile(profile : ?PayoutQueries.ICFCLinks) : Bool {
                switch (profile) {
                    case (null) {
                        return false;
                    };
                    case (?profile) {
                        switch (profile.membershipType) {
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

        */

    };

};
