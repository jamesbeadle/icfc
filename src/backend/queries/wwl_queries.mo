import Ids "mo:waterway-mops/Ids";
import T "../icfc_types";

module {
    public type CanisterInfo = {
        total_num_changes : Nat64;
        recent_changes : [change];
        module_hash : ?Blob;
        controllers : [Principal];
    };
    public type change = {
        timestamp_nanos : Nat64;
        canister_version : Nat64;
        origin : change_origin;
        details : change_details;
    };

    public type CanisterStatus = {
        status : { #running; #stopping; #stopped };
        settings : definite_canister_settings;
        module_hash : ?Blob;
        memory_size : Nat;
        cycles : Nat;
        reserved_cycles : Nat;
        idle_cycles_burned_per_day : Nat;
    };
    public type definite_canister_settings = {
        controllers : [Principal];
        compute_allocation : Nat;
        memory_allocation : Nat;
        freezing_threshold : Nat;
        reserved_cycles_limit : Nat;
    };
    public type change_details = {
        #creation : {
            controllers : [Principal];
        };
        #code_uninstall;
        #code_deployment : {
            mode : { #install; #reinstall; #upgrade };
            module_hash : Blob;
        };
        #controllers_change : {
            controllers : [Principal];
        };
    };

    public type change_origin = {
        #from_user : {
            user_id : Principal;
        };
        #from_canister : {
            canister_id : Principal;
            canister_version : ?Nat64;
        };
    };
    public type CanisterDetails = {
        canister_id : Ids.PrincipalId;
        canister_name : Text;
        canister_type : T.CanisterType;
        canister_info : CanisterInfo;
        canister_status : CanisterStatus;
    };
};
