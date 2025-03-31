import Ids "mo:waterway-mops/Ids";
import Nat "mo:base/Nat";
module = {
    public type GetICFCMembership = {
        principalId : Ids.PrincipalId;
    };

    public type ParticipateInSale = {
        principalId : Ids.PrincipalId;
        packets: Nat;
    };
    public type CalimICFCPackets = {
        packets: Nat;
    };

};
