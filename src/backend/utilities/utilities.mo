import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Int64 "mo:base/Int64";
import Float "mo:base/Float";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Ids "mo:waterway-mops/Ids";
import CanisterIds "mo:waterway-mops/CanisterIds";
import T "../icfc_types";
import SNSGovernance "mo:waterway-mops/sns-wrappers/governance";

module Utilities {

    public func getMembershipExpirationDate(membershipType : T.MembershipType) : Int {
        let now = Time.now();
        switch (membershipType) {
            case (#Monthly) { now + (30 * 24 * 60 * 60 * 1_000_000_000) };
            case (#Seasonal) { now + (365 * 24 * 60 * 60 * 1_000_000_000) };
            case (#Lifetime) {
                now + (100 * 365 * 24 * 60 * 60 * 1_000_000_000);
            };
            case (#Founding) {
                now + (1000 * 365 * 24 * 60 * 60 * 1_000_000_000);
            };
            case (#NotClaimed) { now };
            case (#Expired) { now };
            case (#NotEligible) { now };
        };
    };

    public func convertSecondsToYears(seconds : Int) : Float {
        let secondsInAYear = 31_536_000;
        Float.fromInt(seconds) / Float.fromInt(secondsInAYear);
    };

    public func getMembershipType(neurons : [SNSGovernance.Neuron]) : T.EligibleMembership {

        var eligibleNeuronIds : [Blob] = [];

        let icfc_e8s : Nat64 = 100_000_000;
        let oneK_ICFC_e8s : Nat64 = 1_000 * icfc_e8s;
        let tenK_ICFC_e8s : Nat64 = 10_000 * icfc_e8s;
        let hundredK_ICFC_e8s : Nat64 = 100_000 * icfc_e8s;
        let million_ICFC_e8s : Nat64 = 1_000_000 * icfc_e8s;

        let padding : Nat64 = 5_000_000;

        var total_staked : Nat64 = 0;

        for (neuron in neurons.vals()) {
            switch (neuron.dissolve_state) {
                case (?dissolve_state) {
                    switch (dissolve_state) {
                        case (#DissolveDelaySeconds(dissolve_delay)) {
                            if (convertSecondsToYears(Int64.toInt(Int64.fromNat64(dissolve_delay))) > 2.0) {
                                total_staked += neuron.cached_neuron_stake_e8s;
                                switch (neuron.id) {
                                    case (?neuronId) {
                                        eligibleNeuronIds := Array.append(eligibleNeuronIds, [neuronId.id]);
                                    };
                                    case null {};
                                };
                            };
                        };
                        case (#WhenDissolvedTimestampSeconds(_)) {

                        };
                    };
                };

                case (null) {

                };
            };
        };

        if (total_staked + padding >= million_ICFC_e8s) {
            let dto : T.EligibleMembership = {
                membershipType = #Founding;
                eligibleNeuronIds = eligibleNeuronIds;
            };
            return dto;
        } else if (total_staked + padding >= hundredK_ICFC_e8s) {
            let dto : T.EligibleMembership = {
                membershipType = #Lifetime;
                eligibleNeuronIds = eligibleNeuronIds;
            };
            return dto;
        } else if (total_staked + padding >= tenK_ICFC_e8s) {
            let dto : T.EligibleMembership = {
                membershipType = #Seasonal;
                eligibleNeuronIds = eligibleNeuronIds;
            };
            return dto;
        } else if (total_staked + padding >= oneK_ICFC_e8s) {
            let dto : T.EligibleMembership = {
                membershipType = #Monthly;
                eligibleNeuronIds = eligibleNeuronIds;
            };
            return dto;
        } else {
            let dto : T.EligibleMembership = {
                membershipType = #NotEligible;
                eligibleNeuronIds = [];
            };
            return dto;
        };
    };

    public func getTotalMaxStaked(neurons : [SNSGovernance.Neuron]) : Nat64 {

        var total_staked : Nat64 = 0;

        for (neuron in neurons.vals()) {
            switch (neuron.dissolve_state) {
                case (?dissolve_state) {
                    switch (dissolve_state) {
                        case (#DissolveDelaySeconds(dissolve_delay)) {
                            if (convertSecondsToYears(Int64.toInt(Int64.fromNat64(dissolve_delay))) > 2.0) {
                                total_staked += neuron.cached_neuron_stake_e8s;
                            };
                        };
                        case (#WhenDissolvedTimestampSeconds(_)) {

                        };
                    };
                };

                case (null) {

                };
            };
        };
        let e8s : Nat64 = 100_000_000;
        total_staked := total_staked / e8s;

        return total_staked;
    };

    public func isUsernameValid(username : Text) : Bool {
        if (Text.size(username) < 5 or Text.size(username) > 20) {
            return false;
        };

        let isAlphanumeric = func(s : Text) : Bool {
            let chars = Text.toIter(s);
            for (c in chars) {
                if (not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or (c == ' '))) {
                    return false;
                };
            };
            return true;
        };

        if (not isAlphanumeric(username)) {
            return false;
        };
        return true;
    };

    public func canUpgradeMembership(currentMembership : T.MembershipType, newMembership : T.MembershipType) : Bool {
        switch (currentMembership) {
            case (#Founding) { false };
            case (#Lifetime) {
                newMembership == #Founding;
            };
            case (#Seasonal) {
                newMembership == #Founding or newMembership == #Lifetime;
            };
            case (#Monthly) {
                newMembership == #Founding or newMembership == #Lifetime or newMembership == #Seasonal;
            };
            case (#Expired) { true };
            case (#NotClaimed) { true };
            case (#NotEligible) { true };
        };
    };

    public func isSubApp(caller : Ids.PrincipalId) : Bool {
        let allowed = [
            CanisterIds.FOOTBALL_GOD_BACKEND_CANISTER_ID,
            CanisterIds.OPENFPL_BACKEND_CANISTER_ID,
            CanisterIds.OPENWSL_BACKEND_CANISTER_ID,
            CanisterIds.JEFF_BETS_BACKEND_CANISTER_ID,
            CanisterIds.TRANSFER_KINGS_BACKEND_CANISTER_ID,
        ];
        for (principal in allowed.vals()) {
            if (principal == caller) {
                return true;
            };
        };
        return false;
    };

};
