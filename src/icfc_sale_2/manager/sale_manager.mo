import Environment "../../backend/environment";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import List "mo:base/List";
import TrieMap "mo:base/TrieMap";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Text "mo:base/Text";
import SaleCommands "../commands/sale_commands";
import SaleQueries "../queries/sale_queries";
import Ids "mo:waterway-mops/Ids";
import T "../sale_types";
import DTO "../dtos/dtos";
import Timer "mo:base/Timer";
import Debug "mo:base/Debug";
import Int "mo:base/Int";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import SNSToken "../sns-wrappers/ledger";
import Account "../../backend/lib/Account";
import Utils "../utils/utils";

module {
    public class SaleManager() {
        private var TOTAL_ICFC_PACKETS : Nat = 1000;
        private var icfcPacketsRemaining : Nat = 1000;

        private var saleParticipants : TrieMap.TrieMap<Ids.PrincipalId, List.List<T.ClaimedRecord>> = TrieMap.TrieMap<Ids.PrincipalId, List.List<T.ClaimedRecord>>(
            Text.equal,
            Text.hash,
        );
        private var icfcDistributions : [T.ICFCDistribution] = [];

        public func claimICFCPackets(dto : SaleCommands.ParticipateInSale) : async Result.Result<(), T.Error> {
            if (icfcPacketsRemaining == 0) {
                return #err(#NoPacketsRemaining);
            };

            if (icfcPacketsRemaining < dto.packets) {
                return #err(#InsufficientPacketsRemaining);
            };

            let user_principal = dto.principalId;
            var claimID : Nat = 0;
            let user = saleParticipants.get(user_principal);
            switch (user) {
                case (null) {
                    let claimedRecord : T.ClaimedRecord = {
                        claimedOn = Time.now();
                        packetsClaimed = dto.packets;
                        claimId = 1;
                    };
                    claimID := 1;
                    saleParticipants.put(user_principal, List.fromArray([claimedRecord]));
                };
                case (?participations) {
                    let claimedRecord : T.ClaimedRecord = {
                        claimedOn = Time.now();
                        packetsClaimed = dto.packets;
                        claimId = List.size(participations) + 1;
                    };
                    claimID := List.size(participations) + 1;
                    let updatedParticipations = List.append(participations, List.fromArray([claimedRecord]));
                    saleParticipants.put(user_principal, updatedParticipations);
                };

            };
            icfcPacketsRemaining := icfcPacketsRemaining - dto.packets;
            await scheduleDistribution(user_principal, dto.packets, claimID);
            return #ok(());
        };

        public func getUsersICFCDistributions(dto : SaleQueries.GetICFCDistributions) : async Result.Result<[T.ICFCDistribution], T.Error> {
            let allDistributions = icfcDistributions;
            let userDistributions = Array.filter<T.ICFCDistribution>(
                allDistributions,
                func(entry : T.ICFCDistribution) : Bool {
                    entry.principalId == dto.principalId;
                },
            );
            return #ok(userDistributions);
        };

        public func getUserParticipation(dto : SaleQueries.GetUserParticipation) : async Result.Result<DTO.UserParticipationDTO, T.Error> {
            let user_principal = dto.principalId;
            let user = saleParticipants.get(user_principal);
            switch (user) {
                case (null) {
                    return #ok({ participations = [] });
                };
                case (?participations) {
                    return #ok({ participations = List.toArray(participations) });
                };
            };
        };

        public func getProgress() : async Result.Result<DTO.SaleProgressDTO, T.Error> {
            let result : DTO.SaleProgressDTO = {
                totalPackets = TOTAL_ICFC_PACKETS;
                remainingPackets = icfcPacketsRemaining;
            };
            return #ok(result);
        };

        // stable storage getters and setters
        public func getStableICFCPacketsRemaining() : Nat {
            return icfcPacketsRemaining;
        };

        public func setStableICFCPacketsRemaining(stableICFCPacketsRemaining : Nat) {
            icfcPacketsRemaining := stableICFCPacketsRemaining;
        };

        public func getStableSaleParticipants() : [(Ids.PrincipalId, [T.ClaimedRecord])] {
            var data : [(Ids.PrincipalId, [T.ClaimedRecord])] = [];
            for ((key, value) in saleParticipants.entries()) {
                data := Array.append(data, [(key, List.toArray(value))]);
            };
            return data;
        };

        public func setStableSaleParticipants(participants : [(Ids.PrincipalId, [T.ClaimedRecord])]) {
            let data : TrieMap.TrieMap<Ids.PrincipalId, List.List<T.ClaimedRecord>> = TrieMap.TrieMap<Ids.PrincipalId, List.List<T.ClaimedRecord>>(
                Text.equal,
                Text.hash,
            );
            for (users in Iter.fromArray(participants)) {
                data.put(users.0, List.fromArray(users.1));
            };
            saleParticipants := data;
        };

        public func getStableICFCDistributions() : [T.ICFCDistribution] {
            return icfcDistributions;
        };

        public func setStableICFCDistributions(pendingDistributions : [T.ICFCDistribution]) {
            icfcDistributions := pendingDistributions;
        };

        public func restoreDistributionTimers() : async () {
            let now = Time.now();
            var newPending : [T.ICFCDistribution] = [];

            for (distribution : T.ICFCDistribution in icfcDistributions.vals()) {
                if ((distribution.time > now) and (distribution.distributionStatus == #Pending)) {
                    let delay = (distribution.time - now) / 1_000_000_000;
                    ignore Timer.setTimer<system>(
                        #seconds(Int.abs(delay)),
                        func() : async () {
                            let res = await distributeTokens(distribution.principalId, distribution.amount);
                            switch (res) {
                                case (#ok(_)) {
                                    //    remove from pending
                                    let updatedDistributions = Array.filter<T.ICFCDistribution>(
                                        icfcDistributions,
                                        func(entry : T.ICFCDistribution) : Bool {
                                            entry != distribution;
                                        },
                                    );
                                    // update status to completed
                                    let updatedDistribution : T.ICFCDistribution = {
                                        principalId = distribution.principalId;
                                        amount = distribution.amount;
                                        time = distribution.time;
                                        claimId = distribution.claimId;
                                        installment = distribution.installment;
                                        distributionStatus = #Completed;
                                    };
                                    // update the list
                                    icfcDistributions := Array.append(updatedDistributions, [updatedDistribution]);
                                    icfcDistributions := updatedDistributions;
                                };
                                case (#err(err)) {
                                    Debug.print("Error distributing tokens: " # Utils.variantToText(err));
                                };
                            };
                        },
                    );

                    let newDistribution : T.ICFCDistribution = {
                        principalId = distribution.principalId;
                        amount = distribution.amount;
                        time = distribution.time;
                        claimId = distribution.claimId;
                        installment = distribution.installment;
                        distributionStatus = distribution.distributionStatus;
                    };
                    newPending := Array.append(newPending, [newDistribution]);
                };
            };

            icfcDistributions := newPending;

        };

        private func scheduleDistribution(principal : Ids.PrincipalId, packets : Nat, claimId : Nat) : async () {
            let totalTokens = packets * 10000;
            let installmentAmount = totalTokens / 6;
            let now = Time.now();

            let threeMonths = Utils.monthToSeconds(3);
            let sixMonths = Utils.monthToSeconds(6);

            for (i in Iter.range(0, 5)) {
                let delay = if (i == 0) threeMonths else (threeMonths + (i * sixMonths));
                let distributionTime = now + delay;

                let newDistribution : T.ICFCDistribution = {
                    principalId = principal;
                    amount = installmentAmount;
                    time = distributionTime;
                    claimId = claimId;
                    installment = i + 1;
                    distributionStatus = #Pending;
                };

                icfcDistributions := Array.append(icfcDistributions, [newDistribution]);

                ignore Timer.setTimer<system>(
                    #seconds(delay),
                    func() : async () {
                        let res = await distributeTokens(principal, installmentAmount);
                        switch (res) {
                            case (#ok(_)) {
                                // remove from pending
                                let updatedDistributions = Array.filter<T.ICFCDistribution>(
                                    icfcDistributions,
                                    func(entry : T.ICFCDistribution) : Bool {
                                        entry != newDistribution;
                                    },
                                );
                                // update status to completed
                                let updatedDistribution : T.ICFCDistribution = {
                                    principalId = principal;
                                    amount = installmentAmount;
                                    time = distributionTime;
                                    claimId = claimId;
                                    installment = i + 1;
                                    distributionStatus = #Completed;
                                };
                                // update the list
                                icfcDistributions := Array.append(updatedDistributions, [updatedDistribution]);
                                icfcDistributions := updatedDistributions;
                            };
                            case (#err(err)) {
                                Debug.print("Error distributing tokens: " # Utils.variantToText(err));
                            };

                        };
                    },
                );
            };
        };

        private func distributeTokens(principal : Ids.PrincipalId, amount : Nat) : async Result.Result<(), T.TransferError> {

            let icfc_ledger : SNSToken.Interface = actor (Environment.SNS_LEDGER_CANISTER_ID);
            let transfer_fee = await icfc_ledger.icrc1_fee();

            let e8s_amount = amount * 100_000_000;

            let transfer_dto : T.TransferArg = {
                from_subaccount = ?Account.defaultSubaccount();
                to = {
                    owner = Principal.fromText(principal);
                    subaccount = ?Account.defaultSubaccount();
                };
                amount = e8s_amount - transfer_fee;
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
        }


    };
};
