import T "../sale_types";

module {
    public type ICFCMembershipDTO = {
        membershipType : T.MembershipType;
        membershipClaims : [T.MembershipClaim];
        membershipExpiryTime : Int;
    };
};
