import T "../sale_types";
import Base "mo:waterway-mops/BaseTypes";

module {
    public type ICFCMembershipDTO = {
        membershipType : T.MembershipType;
        membershipClaims : [T.MembershipClaim];
        membershipExpiryTime : Int;
    };

    public type GetICPBalance = {
        principalId : Base.PrincipalId;
    };

    public type GetUserParticipation = {
        principalId : Base.PrincipalId;
    };

    public type GetICFCDistributions = {
        principalId : Base.PrincipalId;
    };
};
