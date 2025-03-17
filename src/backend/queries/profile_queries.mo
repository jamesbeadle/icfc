import Base "mo:waterway-mops/BaseTypes";
import T "../icfc_types";
import SNSGovernance "../sns-wrappers/governance";

module ProfileQueries {
    public type GetProfile = {
        principalId : Base.PrincipalId;
    };

    public type ProfileDTO = {
        principalId : Base.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : T.MembershipType;
        membershipClaims : [T.MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        profilePictureExtension : Text;
        termsAgreed : Bool;
        appPrincipalIds : [(T.SubApp, Base.PrincipalId)];
        podcastIds : [Base.PrincipalId];
        membershipExpiryTime : Int;
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

    public type UserNeurons = {
        userNeurons : [SNSGovernance.Neuron];
        userMembershipEligibility : T.MembershipType;
    };

    public type UsernameAvailable = Bool;

};
