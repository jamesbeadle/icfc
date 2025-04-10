import Enums "mo:waterway-mops/Enums";
import MopsIds "mo:waterway-mops/Ids";
import MopsEnums "mo:waterway-mops/Enums";
module WWLCanisterQueries {
    public type CanisterInfo = {
        app : Enums.WaterwayLabsApp;
        canisterName : Text;
        canisterId : MopsIds.CanisterId;
        cycles : Nat;
        computeAllocation : Nat;
        freezeThreshold : Nat;
        memoryAllocation : Nat;
        controllers : [MopsIds.PrincipalId];
        memoryUsage : Nat;
        canisterType : MopsEnums.CanisterType;
    };
    public type GetCanisterInfo = {
        canisterId : MopsIds.CanisterId;
        canisterType : MopsEnums.CanisterType;
        canisterName : Text;
    };
};
