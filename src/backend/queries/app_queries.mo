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
        profilePictureExtension: Text;
        termsAgreed: Bool;
        unconfirmedAppPrincipalIds: [(Text, Base.PrincipalId)];
        appPrincipalIds: [(Text, Base.PrincipalId)];
    };
}

  