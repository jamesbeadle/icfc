import ICFCTypes "mo:waterway-mops/ICFCTypes";
import Enums "mo:waterway-mops/Enums";
import Ids "mo:waterway-mops/Ids";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import PayoutCommands "../commands/payout_commands";
import T "../icfc_types";
import SNSLedger "mo:waterway-mops/def/Ledger";
import LeaderboardPayoutCommands "mo:waterway-mops/football/LeaderboardPayoutCommands";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Account "mo:waterway-mops/Account";

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
                    // add the request to the list
                    leaderboard_payout_requests := Array.append(
                        leaderboard_payout_requests,
                        [{
                            seasonId = dto.seasonId;
                            gameweek = dto.gameweek;
                            payoutStatus = #Pending;
                            payoutDate = null;
                            app = dto.app;
                            entries = dto.entries;
                            token = dto.token;
                        }],
                    );
                    return #ok(());
                };
                case (?request) {
                    return #err(#AlreadyExists);
                };
            };
        };

        public func payoutLeaderboard(dto : PayoutCommands.PayoutLeaderboard) : async Result.Result<(), Enums.Error> {
            // find the request in the list
            var request = Array.find(
                leaderboard_payout_requests,
                func(entry : ICFCTypes.PayoutRequest) : Bool {
                    entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and entry.app == dto.app
                },
            );

            switch (request) {
                case (null) {
                    return #err(#NotFound);
                };
                case (?request) {
                    if (request.payoutStatus == #Paid) {
                        return #err(#NotAllowed);
                    } else {
                        // pay out the users
                        for (entry : LeaderboardPayoutCommands.LeaderboardEntry in Iter.fromArray(request.entries)) {
                            let principal = entry.principalId;
                            let amount = entry.rewardAmount;
                            switch (amount) {
                                case (null) {

                                };
                                case (?amount) {
                                    let res = await payoutUser(principal, amount);
                                    switch (res) {
                                        case (#ok(_)) {

                                        };
                                        case (#err(_)) {
                                            return #err(#InvalidData);
                                        };
                                    };
                                };

                            };
                        };

                        // update the request
                        leaderboard_payout_requests := Array.map(
                            leaderboard_payout_requests,
                            func(entry : ICFCTypes.PayoutRequest) : ICFCTypes.PayoutRequest {
                                if (entry.seasonId == dto.seasonId and entry.gameweek == dto.gameweek and entry.app == dto.app) {
                                    return {
                                        seasonId = entry.seasonId;
                                        gameweek = entry.gameweek;
                                        payoutStatus = #Paid;
                                        payoutDate = ?Int.abs(Time.now());
                                        app = entry.app;
                                        entries = entry.entries;
                                        token = entry.token;
                                    };
                                } else {
                                    return entry;
                                };
                            },
                        );
                        return #ok(());
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

        private func payoutUser(principal : Ids.PrincipalId, amount : Nat64) : async Result.Result<(), T.TransferError> {

            let icfc_ledger : SNSLedger.Interface = actor (CanisterIds.ICFC_SNS_LEDGER_CANISTER_ID);
            let transfer_fee = await icfc_ledger.icrc1_fee();

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
            let res : T.TransferResult = await icfc_ledger.icrc1_transfer(transfer_dto);
            switch (res) {
                case (#Ok(_)) {
                    return #ok();
                };
                case (#Err(err)) {
                    return #err(err);
                };
            };
        };

    };

};
