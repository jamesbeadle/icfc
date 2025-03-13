module DTOs {
    public type AppStatusDTO = {
        onHold : Bool;
        version : Text;
    };

    public type SaleCountDownDTO = {
        status : Text;
        timeRemaining : Nat64;
        stringTime : Text;
    };

    public type SaleGoalDTO = {
        minGoal : Nat;
        maxGoal : Nat;
        currentProgress : Nat;
    };

    public type ChargeMembershipDTO = {

    };
};
