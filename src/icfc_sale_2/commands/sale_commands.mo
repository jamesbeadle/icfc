import Base "mo:waterway-mops/BaseTypes";
import Nat "mo:base/Nat";
module = {
    public type GetICFCMembership = {
        principalId : Base.PrincipalId;
    };

    public type ParticipateInSale = {
        principalId : Base.PrincipalId;
        packets: Nat;
    };
    public type CalimICFCPackets = {
        packets: Nat;
    };

};
