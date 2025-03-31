import T "../sale_types";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";

module {
    public func variantToText(err : T.TransferError) : Text {
        switch (err) {
            case (#BadBurn(details)) {
                return "BadBurn: min_burn_amount = " # Nat.toText(details.min_burn_amount);
            };
            case (#BadFee(details)) {
                return "BadFee: expected_fee = " # Nat.toText(details.expected_fee);
            };
            case (#CreatedInFuture(details)) {
                return "CreatedInFuture: ledger_time = " # Nat64.toText(details.ledger_time);
            };
            case (#Duplicate(details)) {
                return "Duplicate: duplicate_of = " # Nat.toText(details.duplicate_of);
            };
            case (#GenericError(details)) {
                return "GenericError: error_code = " # Nat.toText(details.error_code) # ", message = " # details.message;
            };
            case (#InsufficientFunds(details)) {
                return "InsufficientFunds: balance = " # Nat.toText(details.balance);
            };
            case (#TemporarilyUnavailable) {
                return "TemporarilyUnavailable";
            };
            case (#TooOld) {
                return "TooOld";
            };
        };
    };

    public func monthToSeconds(month : Nat) : Nat {
        month * 30 * 24 * 60 * 60;
    };

    // private func hasValidICFCMembership(user_principal : Base.PrincipalId) : async Result.Result<(Bool, T.MembershipType), T.Error> {
    //     let icfc_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
    //         getICFCMembership : SaleCommands.GetICFCMembership -> async Result.Result<SaleQueries.ICFCMembershipDTO, T.Error>;
    //     };

    //     let icfcMembershipDTO : SaleCommands.GetICFCMembership = {
    //         principalId = user_principal;
    //     };

    //     let membershipResult = await icfc_canister.getICFCMembership(icfcMembershipDTO);
    //     switch (membershipResult) {
    //         case (#ok(membershipDTO)) {
    //             let membershipType = membershipDTO.membershipType;

    //             switch (membershipType) {
    //                 case (#Expired) {
    //                     return #ok(false, membershipType);
    //                 };
    //                 case (#NotClaimed) {
    //                     return #ok(false, membershipType);
    //                 };
    //                 case (#NotEligible) {
    //                     return #ok(false, membershipType);
    //                 };
    //                 case (#Lifetime) {
    //                     return #ok(true, membershipType);
    //                 };
    //                 case (#Monthly) {
    //                     return #ok(true, membershipType);
    //                 };
    //                 case (#Seasonal) {
    //                     return #ok(true, membershipType);
    //                 };
    //                 case (#Founding) {
    //                     return #ok(true, membershipType);
    //                 };

    //             };
    //         };
    //         case (#err(_)) {
    //             return #err(#NotEligible);
    //         };
    //     };

    // };
};
