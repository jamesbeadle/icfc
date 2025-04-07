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
import AccountIdentifier "mo:account-identifier";
import Enums "mo:waterway-mops/Enums";
import Environment "../environment";
import SaleTypes "../sale_types";

module {
    public class SaleManager() {

        private var icfcPacksRemaining : Nat = 1000;

        private var saleParticipants : TrieMap.TrieMap<Ids.PrincipalId, List.List<T.PurchaseRecord>> = TrieMap.TrieMap<Ids.PrincipalId, List.List<T.PurchaseRecord>>(
            Text.equal,
            Text.hash,
        );
        private var icfcDistributions : [T.ICFCDistribution] = [];

        public func claimICFCPacks(dto : SaleCommands.ParticipateInSale) : async Result.Result<(), SaleTypes.Error> {
            if (icfcPacksRemaining == 0) {
                return #err(#NoPacketsRemaining);
            };
            let packsToClaim = await getPacksToClaim(dto.principalId);
            switch (packsToClaim) {
                case (#ok(packs)) {
                    if (packs < 1) {
                        return #err(#InEligible);
                    };
                    if (icfcPacksRemaining < packs) {
                        return #err(#InsufficientPacketsRemaining);
                    };

                    let user_principal = dto.principalId;
                    var claimID : Nat = 0;
                    let user = saleParticipants.get(user_principal);
                    switch (user) {
                        case (null) {
                            let PurchaseRecord : T.PurchaseRecord = {
                                purchasedOn = Time.now();
                                packsPurchased = packs;
                                purchaseId = 1;
                            };
                            claimID := 1;
                            saleParticipants.put(user_principal, List.fromArray([PurchaseRecord]));
                        };
                        case (?participations) {
                            let PurchaseRecord : T.PurchaseRecord = {
                                purchasedOn = Time.now();
                                packsPurchased = packs;
                                purchaseId = List.size(participations) + 1;
                            };
                            claimID := List.size(participations) + 1;
                            let updatedParticipations = List.append(participations, List.fromArray([PurchaseRecord]));
                            saleParticipants.put(user_principal, updatedParticipations);
                        };

                    };
                    icfcPacksRemaining := icfcPacksRemaining - packs;
                    await scheduleDistribution(user_principal, packs, claimID);
                    return #ok(());
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
                totalPacks = Environment.TOTAL_ICFC_PACKS;
                remainingPacks = icfcPacksRemaining;
                packCostinICP = Environment.ICFC_PACK_PRICE_IN_ICP;
            };
            return #ok(result);
        };

        // stable storage getters and setters
        public func getStableICFCPacksRemaining() : Nat {
            return icfcPacksRemaining;
        };

        public func setStableICFCPacksRemaining(stableicfcPacksRemaining : Nat) {
            icfcPacksRemaining := stableicfcPacksRemaining;
        };

        public func getStableSaleParticipants() : [(Ids.PrincipalId, [T.PurchaseRecord])] {
            var data : [(Ids.PrincipalId, [T.PurchaseRecord])] = [];
            for ((key, value) in saleParticipants.entries()) {
                data := Array.append(data, [(key, List.toArray(value))]);
            };
            return data;
        };

        public func setStableSaleParticipants(participants : [(Ids.PrincipalId, [T.PurchaseRecord])]) {
            let data : TrieMap.TrieMap<Ids.PrincipalId, List.List<T.PurchaseRecord>> = TrieMap.TrieMap<Ids.PrincipalId, List.List<T.PurchaseRecord>>(
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
                            // Debug.print("Distributing tokens to " # distribution.principalId # " for purchaseId: " # Nat.toText(distribution.purchaseId) # " with amount: " # Nat.toText(distribution.installment));
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
                                        purchaseId = distribution.purchaseId;
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
                        purchaseId = distribution.purchaseId;
                        installment = distribution.installment;
                        distributionStatus = distribution.distributionStatus;
                    };
                    newPending := Array.append(newPending, [newDistribution]);
                };
            };

            icfcDistributions := newPending;

        };

        private func scheduleDistribution(principal : Ids.PrincipalId, packs : Nat, purchaseId : Nat) : async () {
            let totalTokens = packs * 10000;
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
                    purchaseId = purchaseId;
                    installment = i + 1;
                    distributionStatus = #Pending;
                };

                icfcDistributions := Array.append(icfcDistributions, [newDistribution]);

                ignore Timer.setTimer<system>(
                    #seconds(delay),
                    func() : async () {
                        let res = await distributeTokens(principal, installmentAmount);
                        // Debug.print("Distributing tokens to " # principal # " for purchaseId: " # Nat.toText(purchaseId) # " with amount: " # Nat.toText(installmentAmount));
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
                                    purchaseId = purchaseId;
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
                from_subaccount = ?AccountIdentifier.defaultSubaccount();
                to = {
                    owner = Principal.fromText(principal);
                    subaccount = ?AccountIdentifier.defaultSubaccount();
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
        };

        private func getPacksToClaim(principalId : Ids.PrincipalId) : async Result.Result<Nat, Enums.Error> {
            let backend_canister = actor (CanisterIds.ICFC_BACKEND_CANISTER_ID) : actor {
                getICPBalance : (user_principal : Ids.PrincipalId) -> async Result.Result<Nat, Enums.Error>;
                completeICFCPackPurchase : (user_principal : Ids.PrincipalId, amount : Nat) -> async Result.Result<(), Enums.Error>;
            };
            let res = await backend_canister.getICPBalance(principalId);
            switch (res) {
                case (#ok(balance)) {

                    let one_packect_cost_e8s = Nat.sub(Environment.ICFC_PACK_PRICE_IN_ICP * 100_000_000, 10_000);
                    Debug.print("One pack cost in e8s: " # Nat.toText(one_packect_cost_e8s));
                    Debug.print("User balance in e8s: " # Nat.toText(balance));
                    var eligiblePacks = Nat.div(balance, one_packect_cost_e8s);

                    if (eligiblePacks == 0) {
                        return #err(#InEligible);
                    };
                    if (icfcPacksRemaining < eligiblePacks) {
                        return #err(#InsufficientPacketsRemaining);
                    };

                    eligiblePacks := Nat.min(eligiblePacks, icfcPacksRemaining);
                    var amount = Nat.mul(eligiblePacks, one_packect_cost_e8s);
                    let res = await backend_canister.completeICFCPackPurchase(principalId, amount);
                    switch (res) {
                        case (#ok(_)) {
                            return #ok(eligiblePacks);
                        };
                        case (#err(err)) {
                            return #err(err);
                        };
                    };

                };
                case (#err(err)) {
                    return #err(err);
                };
            };
        };

    };
};
