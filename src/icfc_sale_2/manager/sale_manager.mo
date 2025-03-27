import Environment "../../backend/environment";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import List "mo:base/List";
import SaleCommands "../commands/sale_commands";
import SaleQueries "../queries/sale_queries";
import Base "mo:waterway-mops/BaseTypes";
import T "../sale_types";
import DTO "../dtos/dtos";

module {
    public class SaleManager() {
        private var TOTAL_ICFC_PACKETS : Nat = 1000;
        private var icfcPacketsRemaining : Nat = 1000;

        private var saleParticipants : [T.SaleParticipant] = [];

        public func claimICFCPackets(dto : SaleCommands.ParticipateInSale) : async Result.Result<(), T.Error> {
            if (icfcPacketsRemaining == 0) {
                return #err(#NoPacketsRemaining);
            };

            let hasMembership = await hasValidICFCMembership(dto.principalId);
            switch (hasMembership) {
                case (#ok(false)) {
                    return #err(#NotEligible);
                };
                case (#err(_)) {
                    return #err(#NotEligible);
                };
                case (#ok(true)) {

                    let particapantsBuffer = Buffer.fromArray<T.SaleParticipant>(saleParticipants);
                    particapantsBuffer.add({
                        user = Principal.fromText(dto.principalId);
                        icfc_staked = 10_000 * Nat.pow(10, 8);
                        time = Nat64.fromNat(Int.abs(Time.now()));
                    });
                    saleParticipants := Buffer.toArray(particapantsBuffer);

                    icfcPacketsRemaining := icfcPacketsRemaining - 1;
                    return #ok(());

                };
            };
        };

        public func getUserParticipation(dto : SaleQueries.GetUserParticipation) : async Result.Result<DTO.UserParticipationDTO, T.Error> {
            let user_principal = dto.principalId;
            let all_participants = List.fromArray(saleParticipants);
            let user_participants = List.filter<T.SaleParticipant>(
                all_participants,
                func(participant : T.SaleParticipant) {
                    return participant.user == Principal.fromText(user_principal);
                },
            );
            let result : DTO.UserParticipationDTO = {
                participations = List.toArray(user_participants);
            };
            return #ok(result);
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

        public func getStableSaleParticipants() : [T.SaleParticipant] {
            return saleParticipants;
        };

        public func setStableSaleParticipants(participants : [T.SaleParticipant]) {
            saleParticipants := participants;
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
