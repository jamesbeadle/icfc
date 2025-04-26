import ICFCTypes "../icfc_types";
import Enums "mo:waterway-mops/Enums";
import Ids "mo:waterway-mops/Ids";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Text "mo:base/Text";
import PayoutCommands "../commands/payout_commands";
import T "../icfc_types";
import SNSLedger "mo:waterway-mops/def/Ledger";
import LeaderboardPayoutCommands "mo:waterway-mops/football/LeaderboardPayoutCommands";
import Account "mo:waterway-mops/Account";
import BaseUtilities "mo:waterway-mops/BaseUtilities";
import Utilities "../utilities/utilities";
import PayoutQueries "../queries/payout_queries";

module {
    public class LeaderboardPayoutManager() {

        private var leaderboard_payout_requests : [ICFCTypes.PayoutRequest] = [];

        public func getLeaderboardPayoutRequests() : [ICFCTypes.PayoutRequest] {
            return leaderboard_payout_requests;
        };

        public func addLeaderboardPayoutRequest(dto : LeaderboardPayoutCommands.LeaderboardPayoutRequest) : async Result.Result<(), Enums.Error> {
            // check if the request already exists
            var request = Array.find(
                leaderboard_payout_requests,
                func(entry : ICFCTypes.PayoutRequest) : Bool {
                    entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and entry.app == dto.app
                },
            );

            switch (request) {
                case (null) {
                    leaderboard_payout_requests := Array.append(
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
                            if (entry.payoutStatus == #Pending and isValidICFCProfile(icfcProfileLink)) {
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

        private func payoutUser(principal : Ids.PrincipalId, amount : Nat64, tokenledgerId : Text) : async Result.Result<(), T.TransferError> {
            let token_ledger : SNSLedger.Interface = actor (tokenledgerId);
            let transfer_fee = await token_ledger.icrc1_fee();

            let e8s_amount = amount;

            let transfer_dto : T.TransferArg = {
                from_subaccount = ?Account.defaultSubaccount();
                to = {
                    owner = Principal.fromText(principal);
                    subaccount = ?Account.defaultSubaccount();
                };
                amount = Nat64.toNat(e8s_amount) - transfer_fee;
                created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
                memo = null;
                fee = ?transfer_fee;
            };
            let res : T.TransferResult = await token_ledger.icrc1_transfer(transfer_dto);
            switch (res) {
                case (#Ok(_)) {
                    return #ok();
                };
                case (#Err(err)) {
                    return #err(err);
                };
            };
        };

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

    };

};
