import Array "mo:base/Array";
import Text "mo:base/Text";

import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import Ids "mo:waterway-mops/base/ids";

import Enums "mo:waterway-mops/base/enums";

module Utilities {

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

    public func getTokenLedgerId(token : Enums.Currency) : ?Ids.CanisterId {
        switch (token) {
            case (#CKBTC) {
                ?CanisterIds.CKBTC_LEDGER_CANISTER_ID;
            };
            case (_) { null };
        };
    };

    public func isValidCanisterId(caller : Ids.CanisterId) : Bool {
        let validCanisters = [
            CanisterIds.OPENFPL_BACKEND_CANISTER_ID,
            CanisterIds.OPENWSL_BACKEND_CANISTER_ID,
            CanisterIds.JEFF_BETS_BACKEND_CANISTER_ID,
            CanisterIds.TRANSFER_KINGS_BACKEND_CANISTER_ID,
            CanisterIds.FOOTBALL_GOD_BACKEND_CANISTER_ID,
        ];

        return Array.find(
            validCanisters,
            func(x : Ids.CanisterId) : Bool {
                x == caller;
            },
        ) != null;
    };

};
