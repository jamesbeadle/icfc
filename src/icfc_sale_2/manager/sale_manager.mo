import SNSToken "../sns-wrappers/ledger";
import Environment "../../backend/environment";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import SaleCommands "../commands/sale_commands";
import SaleQueries "../queries/sale_queries";
import Base "mo:waterway-mops/BaseTypes";
import T "../sale_types";
import Account "../lib/Account";

module {
    public class SaleManager() {
        private var ICP_GOAL : Nat = 48000;
        private var saleStartTime : Nat64 = 0;
        private var saleEndTime : Nat64 = 0;
        private var icpLedger : SNSToken.Interface = actor (Environment.NNS_LEDGER_CANISTER_ID);
        private var isSaleActive : Bool = (Nat64.fromNat(Int.abs(Time.now())) >= saleStartTime and Nat64.fromNat(Int.abs(Time.now())) < saleEndTime);
        private var goal : Nat = ICP_GOAL * Nat.pow(10, Nat8.toNat(8));
        private type Subaccount = Blob;
        private var icpExchange : Float = 0.0048; //0.0048 ICP per ICFC
        private var saleCompleted : Bool = false;

        private var saleParticipants : [T.SaleParticipant] = [];

        public func getGoal() : Nat {
            return goal;
        };

        // public func getUserICPBalance() : async Float {
        //     let icpBalance = await icpLedger.balance();
        //     return icpBalance;
        // };

        public func getICPGoal() : Nat {
            return ICP_GOAL;
        };

        public func getICPExchange() : Float {
            return icpExchange;
        };

        public func getSaleActive() : Bool {
            return isSaleActive;
        };

        public func getSaleStartTime() : Nat64 {
            return saleStartTime;
        };

        // sale fail funcitons
        private func return_participants_ICP() : async Result.Result<Nat, Text> {
            let participants = saleParticipants;
            saleParticipants := [];
            let fee = await icpLedger.icrc1_fee();
            var total = 0;
            for (participant in Array.vals(participants)) {
                let transfer_result = await icpLedger.icrc1_transfer({
                    from_subaccount = ?Account.defaultSubaccount();
                    to = {
                        owner = Principal.fromText(Environment.ICFC_SALE_2_CANISTER_ID);
                        subaccount = ?Account.principalToSubaccount(participant.user);
                    };
                    amount = participant.amount - fee;
                    fee = ?fee;
                    memo = null;
                    created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
                });

                switch (transfer_result) {
                    case (#Ok(_)) {
                        total += participant.amount;
                    };
                    case (#Err(err)) {
                        return #err("Transfer failed: " # debug_show (err));
                    };
                };
            };
            return #ok(total);
        };

        // stable storage getters and setters

        public func setStableSaleCompleted(stableSaleCompleted : Bool) {
            saleCompleted := stableSaleCompleted;
        };

        public func getStableSaleCompleted() : Bool {
            return saleCompleted;
        };

        public func setStableSaleStartTime(startTime : Nat64) {
            saleStartTime := startTime;
        };

        public func getStableSaleStartTime() : Nat64 {
            return saleStartTime;
        };

        public func setStableSaleEndTime(endTime : Nat64) {
            saleEndTime := endTime;
        };

        public func getStableSaleEndTime() : Nat64 {
            return saleEndTime;
        };

        public func setStableICPGoal(stableICPGoal : Nat) {
            ICP_GOAL := stableICPGoal;
            goal := ICP_GOAL * Nat.pow(10, Nat8.toNat(8));
        };

        public func getStableICPGoal() : Nat {
            return ICP_GOAL;
        };

        public func setStableICPExchange(exchange : Float) {
            icpExchange := exchange;
        };

        public func getStableICPExchange() : Float {
            return icpExchange;
        };

        public func setStableSaleActive(active : Bool) {
            isSaleActive := active;
        };

        public func getStableSaleActive() : Bool {
            return isSaleActive;
        };

        public func setStableSaleParticipants(participants : [T.SaleParticipant]) {
            saleParticipants := participants;
        };

        public func getStableSaleParticipants() : [T.SaleParticipant] {
            return saleParticipants;
        };

        private func hasValidICFCMembership(user_principal : Base.PrincipalId) : async Result.Result<Bool, T.Error> {
            let icfc_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
                getICFCMembership : SaleCommands.GetICFCMembership -> async Result.Result<SaleQueries.ICFCMembershipDTO, T.Error>;
            };

            let icfcMembershipDTO : SaleCommands.GetICFCMembership = {
                principalId = user_principal;
            };

            let membershipResult = await icfc_canister.getICFCMembership(icfcMembershipDTO);
            switch (membershipResult) {
                case (#ok(membershipDTO)) {
                    let membershipType = membershipDTO.membershipType;

                    switch (membershipType) {
                        case (#Expired) {
                            return #ok(false);
                        };
                        case (#NotClaimed) {
                            return #ok(false);
                        };
                        case (#NotEligible) {
                            return #ok(false);
                        };
                        case (#Lifetime) {
                            return #ok(true);
                        };
                        case (#Monthly) {
                            return #ok(true);
                        };
                        case (#Seasonal) {
                            return #ok(true);
                        };
                        case (#Founding) {
                            return #ok(true);
                        };

                    };
                };
                case (#err(_)) {

                    return #ok(false);
                };
            };

        };
    };
};
