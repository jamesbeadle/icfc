import T "../sale_types";

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

    public type SaleProgressDTO = {
        totalPackets : Nat;
        remainingPackets : Nat;
    };

    public type UserParticipationDTO = {
        participations : [T.SaleParticipant];
    };
};
