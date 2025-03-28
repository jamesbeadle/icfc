import Nat64 "mo:base/Nat64";
import Hash "mo:base/Hash";
import Text "mo:base/Text";
import Int64 "mo:base/Int64";
import Principal "mo:base/Principal";
import Float "mo:base/Float";
import Nat32 "mo:base/Nat32";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import Management "management";
import Cycles "mo:base/ExperimentalCycles";
import Char "mo:base/Char";

module Utils {

    public let eqNat8 = func(a : Nat8, b : Nat8) : Bool {
        a == b;
    };

    public let hashNat8 = func(key : Nat8) : Hash.Hash {
        Nat32.fromNat(Nat8.toNat(key) % (2 ** 32 - 1));
    };

    public let eqNat16 = func(a : Nat16, b : Nat16) : Bool {
        a == b;
    };

    public let hashNat16 = func(key : Nat16) : Hash.Hash {
        Nat32.fromNat(Nat16.toNat(key) % (2 ** 32 - 1));
    };

    public let eqNat32 = func(a : Nat32, b : Nat32) : Bool {
        a == b;
    };

    public let hashNat32 = func(key : Nat32) : Hash.Hash {
        Nat32.fromNat(Nat32.toNat(key) % (2 ** 32 - 1));
    };

    public let eqNat = func(a : Nat, b : Nat) : Bool {
        a == b;
    };

    public let hashNat = func(key : Nat) : Hash.Hash {
        Nat32.fromNat(key % (2 ** 32 - 1));
    };

    public func validateHexColor(hex : Text) : Bool {

        if (Text.size(hex) != 7 or not Text.startsWith(hex, #text "#")) {
            return false;
        };

        let hexChars = "0123456789abcdefABCDEF";
        let strippedHex = switch (Text.stripStart(hex, #text "#")) {
            case (?h) h;
            case null hex;
        };

        for (char in Text.toIter(strippedHex)) {
            if (not Text.contains(hexChars, #char char)) {
                return false;
            };
        };

        return true;
    };

    public func nat64Percentage(amount : Nat64, percentage : Float) : Nat64 {
        return Int64.toNat64(Float.toInt64(Float.fromInt64(Int64.fromNat64(amount)) * percentage));
    };

    public func updateCanister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management) : async () {
        let cid = { canister_id = Principal.fromActor(a) };
        switch (backendCanisterController) {
            case (null) {};
            case (?controller) {
                await (
                    IC.update_settings({
                        canister_id = cid.canister_id;
                        settings = {
                            controllers = ?[controller];
                            compute_allocation = ?1;
                            memory_allocation = null;
                            freezing_threshold = ?2_592_000;
                            reserved_cycles_limit = null;
                        };
                        sender_canister_version = null;
                    })
                );
            };
        };
    };

    public func topup_canister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management, cycles : Nat) : async () {
        let cid = { canister_id = Principal.fromActor(a) };
        switch (backendCanisterController) {
            case (null) {};
            case (?_) {
                Cycles.add<system>(cycles);
                await (
                    IC.deposit_cycles({
                        canister_id = cid.canister_id;
                    })
                );
            };
        };
    };

    public func delete_canister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management) : async () {
        let cid = { canister_id = Principal.fromActor(a) };
        switch (backendCanisterController) {
            case (null) {};
            case (?_) {
                await (
                    IC.delete_canister({
                        canister_id = cid.canister_id;
                    })
                );
            };
        };
    };

    public func toLowercase(t : Text.Text) : Text.Text {
        func charToLower(c : Char) : Char {
            if (Char.isUppercase(c)) {
                Char.fromNat32(Char.toNat32(c) + 32);
            } else {
                c;
            };
        };
        Text.map(t, charToLower);
    };

    public func trimStartToLength(t : Text, length : Nat) : Text {
        let cs = Text.toIter(t);
        var result = "";
        var count = 0;

        label charLoop for (c in cs) {
            if (count < length) {
                result #= Text.fromChar(c);
                count += 1;
            } else {
                break charLoop;
            };
        };

        return result;
    };

};
