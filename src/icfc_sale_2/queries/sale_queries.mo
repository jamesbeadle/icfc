import T "../sale_types";
import Ids "mo:waterway-mops/Ids";

module {
    public type ICFCMembershipDTO = {
        membershipType : T.MembershipType;
        membershipClaims : [T.MembershipClaim];
        membershipExpiryTime : Int;
    };

    public type GetICPBalance = {
        principalId : Ids.PrincipalId;
    };

    public type GetUserParticipation = {
        principalId : Ids.PrincipalId;
    };

    public type GetICFCDistributions = {
        principalId : Ids.PrincipalId;
    };

    public type UserParticipation = {
        participations : [T.PurchaseRecord];
    };

    public type SaleProgress = {
        totalPacks : Nat;
        remainingPacks : Nat;
        packCostinICP : Nat;
    };
};
