import Base "mo:waterway-mops/BaseTypes";
import T "../icfc_types";

module AppQueries {
    public type ProfileDTO = {
        principalId: Base.PrincipalId;
        username: Text;
        displayName: Text;
        membershipType: T.MembershipType;
        membershipClaims: [T.MembershipClaim];
        createdOn: Int;
        profilePicture: Blob;
        termsAgreed: Bool;
        unconfirmedAppPrincipalIds: [(Text, Base.PrincipalId)];
        appPrincipalIds: [(Text, Base.PrincipalId)];
    };

    public type CountryDTO = {
        id : Base.CountryId;
        name : Text;
        code : Text;
    };

    public type TokenBalances = {
        icpBalance : Nat;
        icfcBalance : Nat;
        ckBTCBalance : Nat;
        icgcBalance : Nat;
    };

}

  