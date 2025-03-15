import Base "mo:waterway-mops/BaseTypes";
import Timer "mo:base/Timer";
import T "../icfc_types";

module ProfileQueries {
    public type GetProfile = {
        principalId : Base.PrincipalId;
    };

    public type Profile = {
        principalId : Base.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : T.MembershipType;
        membershipClaims : [T.MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        profilePictureExtension : Text;
        termsAgreed : Bool;
        appPrincipalIds : [(Text, Base.PrincipalId)];
        podcastIds : [Base.PrincipalId];
        membershipTimerId : ?Timer.TimerId;
    };

    public type ListProfiles = {
        searchTerm : Text;
        totalEntries : Nat;
        limit : Nat;
        offset : Nat;
    };

    public type Profiles = {
        profiles : [ProfileSummary];
    };

    public type ProfileSummary = {
        profilePrincipalId : Base.PrincipalId;
        userName : Text;
        userPicture : ?Blob;
        userPictureExtension : Text;
    };

    public type IsUsernameAvailable = {
        username : Text;
        principalId : Base.PrincipalId;
    };

    public type UsernameAvailable = Bool;

};
