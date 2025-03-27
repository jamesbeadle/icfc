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
import Base "mo:waterway-mops/BaseTypes";
import T "../sale_types";
import DTO "../dtos/dtos";

module {
    public class SaleManager() {
        private var TOTAL_ICFC_PACKETS : Nat = 1000;
        private var icfcPacketsRemaining : Nat = 1000;

        private var saleParticipants : TrieMap.TrieMap<Base.PrincipalId, List.List<T.ClaimedRecord>> = TrieMap.TrieMap<Base.PrincipalId, List.List<T.ClaimedRecord>>(
            Text.equal,
            Text.hash,
        );

        public func claimICFCPackets(dto : SaleCommands.ParticipateInSale) : async Result.Result<(), T.Error> {
            if (icfcPacketsRemaining == 0) {
                return #err(#NoPacketsRemaining);
            };

            if (icfcPacketsRemaining < dto.packets){
                return #err(#InsufficientPacketsRemaining);
            };

            let hasMembership = await hasValidICFCMembership(dto.principalId);
            switch (hasMembership) {
                case (#ok(false, _)) {
                    return #err(#NotEligible);
                };
                case (#err(_)) {
                    return #err(#NotEligible);
                };
                case (#ok(true, membership)) {

                    let user_principal = dto.principalId;
                    let claimedRecord : T.ClaimedRecord = {
                        claimedOn = Time.now();
                        packetsClaimed = dto.packets;
                        membershipType = membership;
                    };

                    let user = saleParticipants.get(user_principal);
                    switch (user) {
                        case (null) {
                            saleParticipants.put(user_principal, List.fromArray([claimedRecord]));
                        };
                        case (?participations) {
                            let updatedParticipations = List.append(participations, List.fromArray([claimedRecord]));
                            saleParticipants.put(user_principal, updatedParticipations);
                        };

                    };
                    icfcPacketsRemaining := icfcPacketsRemaining - dto.packets;
                    return #ok(());

                };
            };
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

        public func get_progress() : async Result.Result<DTO.SaleProgressDTO, T.Error> {
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

        public func getStableSaleParticipants() : [(Base.PrincipalId, [T.ClaimedRecord])] {
            var data : [(Base.PrincipalId, [T.ClaimedRecord])] = [];
            for ((key, value) in saleParticipants.entries()) {
                data := Array.append(data, [(key, List.toArray(value))]);
            };
            return data;
        };

        public func setStableSaleParticipants(participants : [(Base.PrincipalId, [T.ClaimedRecord])]) {
            let data : TrieMap.TrieMap<Base.PrincipalId, List.List<T.ClaimedRecord>> = TrieMap.TrieMap<Base.PrincipalId, List.List<T.ClaimedRecord>>(
                Text.equal,
                Text.hash,
            );
            for (users in Iter.fromArray(participants)) {
                data.put(users.0, List.fromArray(users.1));
            };
            saleParticipants := data;
        };

        private func hasValidICFCMembership(user_principal : Base.PrincipalId) : async Result.Result<(Bool, T.MembershipType), T.Error> {
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
                            return #ok(false, membershipType);
                        };
                        case (#NotClaimed) {
                            return #ok(false, membershipType);
                        };
                        case (#NotEligible) {
                            return #ok(false, membershipType);
                        };
                        case (#Lifetime) {
                            return #ok(true, membershipType);
                        };
                        case (#Monthly) {
                            return #ok(true, membershipType);
                        };
                        case (#Seasonal) {
                            return #ok(true, membershipType);
                        };
                        case (#Founding) {
                            return #ok(true, membershipType);
                        };

                    };
                };
                case (#err(_)) {
                    return #err(#NotEligible);
                };
            };

        };
    };
};
