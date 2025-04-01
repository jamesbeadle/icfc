import Ids "mo:waterway-mops/Ids";
import T "../icfc_types";

module AppQueries {

    public type AppStatus = {
        onHold : Bool;
        version : Text;
    };

    public type Profile = {
        principalId: Ids.PrincipalId;
        username: Text;
        displayName: Text;
        membershipType: T.MembershipType;
        membershipClaims: [T.MembershipClaim];
        createdOn: Int;
        profilePicture: Blob;
        termsAgreed: Bool;
        unconfirmedAppPrincipalIds: [(Text, Ids.PrincipalId)];
        appPrincipalIds: [(Text, Ids.PrincipalId)];
    };

    public type Country = {
        id : Ids.CountryId;
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

  