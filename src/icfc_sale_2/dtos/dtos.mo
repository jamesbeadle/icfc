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
        goal : Nat;
        currentProgress : Nat;
    };

    public type ChargeMembershipDTO = {

    };
};
