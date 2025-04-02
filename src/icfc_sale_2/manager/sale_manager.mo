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
import CanisterIds "mo:waterway-mops/CanisterIds";
import T "../sale_types";
import Timer "mo:base/Timer";
import Debug "mo:base/Debug";
import Int "mo:base/Int";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import SNSLedger "mo:waterway-mops/def/Ledger";
import SaleUtilities "../utilities/sale-utilities";
import Account "mo:waterway-mops/Account";
import Enums "mo:waterway-mops/Enums";

module {
    public class SaleManager() {
        private var TOTAL_ICFC_PACKETS : Nat = 1000;
        private var icfcPacketsRemaining : Nat = 1000;

        private var saleParticipants : TrieMap.TrieMap<Ids.PrincipalId, List.List<T.ClaimedRecord>> = TrieMap.TrieMap<Ids.PrincipalId, List.List<T.ClaimedRecord>>(
            Text.equal,
            Text.hash,
        );
        private var icfcDistributions : [T.ICFCDistribution] = [];

        public func claimICFCPackets(dto : SaleCommands.ParticipateInSale) : async Result.Result<(), Enums.Error> {
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

        public func refreshParticipant(dto : SaleCommands.RefreshParticipant) : async Result.Result<(), Enums.Error> {
            let backend_canister = actor (CanisterIds.ICFC_BACKEND_CANISTER_ID) : actor {
                getICPBalance : (user_principal : Ids.PrincipalId) -> async Result.Result<Nat, Enums.Error>;
            };
            let res = await backend_canister.getICPBalance(dto.principalId);
            switch (res) {
                case (#ok(balance)) {
                    let user = saleParticipants.get(dto.principalId);
                    switch (user) {
                        case (null) {
                            return #err(#NotFound);
                        };
                        case (?participations) {
                            var totalClaimedPackets : Nat = 0;
                            for (participation : T.ClaimedRecord in List.toArray(participations).vals()) {
                                totalClaimedPackets := totalClaimedPackets + participation.packetsClaimed;
                            };

                            let total_icp_value = totalClaimedPackets * 48;
                            let total_icp_value_e8s = total_icp_value * 100_000_000;
                            let total_claims = List.size(participations);
                            let total_fees_paid = total_claims * 10_000;
                            let total_actual_icp_value = Nat.sub(total_icp_value_e8s, total_fees_paid);

                            if (balance < total_actual_icp_value) {
                                return #err(#InsufficientFunds);
                            };
                            if (balance == total_actual_icp_value) {
                                return #err(#AlreadyClaimed);
                            };

                            // Check if any unclaimed packets are remaining
                            if (balance > total_actual_icp_value) {
                                let remainingPackets = Nat.div(Nat.sub(balance, total_actual_icp_value), 48);
                                if (remainingPackets > icfcPacketsRemaining) {
                                    return #err(#NoPacketsRemaining);
                                };
                                if (remainingPackets == 0) {
                                    return #err(#InEligible);
                                };
                                let claimedRecord : T.ClaimedRecord = {
                                    claimedOn = Time.now();
                                    packetsClaimed = remainingPackets;
                                    claimId = total_claims + 1;
                                };
                                let updatedParticipations = List.append(participations, List.fromArray([claimedRecord]));
                                saleParticipants.put(dto.principalId, updatedParticipations);
                                icfcPacketsRemaining := Nat.sub(icfcPacketsRemaining, remainingPackets);
                                await scheduleDistribution(dto.principalId, remainingPackets, total_claims + 1);
                            };
                            return #ok(());
                        };
                    };
                };
                case (#err(err)) {
                    return #err(err);
                };
            };
        };

        public func getUsersICFCDistributions(dto : SaleQueries.GetICFCDistributions) : async Result.Result<[T.ICFCDistribution], Enums.Error> {
            let allDistributions = icfcDistributions;
            let userDistributions = Array.filter<T.ICFCDistribution>(
                allDistributions,
                func(entry : T.ICFCDistribution) : Bool {
                    entry.principalId == dto.principalId;
                },
            );
            return #ok(userDistributions);
        };

        public func getUserParticipation(dto : SaleQueries.GetUserParticipation) : async Result.Result<SaleQueries.UserParticipation, Enums.Error> {
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

        public func getProgress() : async Result.Result<SaleQueries.SaleProgress, Enums.Error> {
            let result : SaleQueries.SaleProgress = {
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
                            // Debug.print("Distributing tokens to " # distribution.principalId # " for claimId: " # Nat.toText(distribution.claimId) # " with amount: " # Nat.toText(distribution.installment));
                            switch (res) {
                                case (#ok(_)) {

                                    let updatedDistributions = Array.filter<T.ICFCDistribution>(
                                        icfcDistributions,
                                        func(entry : T.ICFCDistribution) : Bool {
                                            entry != distribution;
                                        },
                                    );

                                    let updatedDistribution : T.ICFCDistribution = {
                                        principalId = distribution.principalId;
                                        amount = distribution.amount;
                                        time = distribution.time;
                                        claimId = distribution.claimId;
                                        installment = distribution.installment;
                                        distributionStatus = #Completed;
                                    };

                                    icfcDistributions := Array.append(updatedDistributions, [updatedDistribution]);
                                };
                                case (#err(err)) {
                                    Debug.print("Error distributing tokens: " # SaleUtilities.variantToText(err));
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

            let threeMonths = SaleUtilities.monthToSeconds(3);
            let sixMonths = SaleUtilities.monthToSeconds(6);

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
                        // Debug.print("Distributing tokens to " # principal # " for claimId: " # Nat.toText(claimId) # " with amount: " # Nat.toText(installmentAmount));
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
                            };
                            case (#err(err)) {
                                Debug.print("Error distributing tokens: " # SaleUtilities.variantToText(err));
                            };

                        };
                    },
                );
            };
        };

        private func distributeTokens(principal : Ids.PrincipalId, amount : Nat) : async Result.Result<(), T.TransferError> {

            let icfc_ledger : SNSLedger.Interface = actor (CanisterIds.ICFC_SNS_LEDGER_CANISTER_ID);
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
