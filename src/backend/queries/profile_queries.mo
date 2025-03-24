import Base "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";
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
        favouriteLeagueId: ?FootballTypes.LeagueId;
        favouriteClubId: ?FootballTypes.ClubId;
        nationalityId: ?Base.CountryId;
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

    public type UserNeuronsDTO = {
        userNeurons : [SNSGovernance.Neuron];
        totalMaxStaked: Nat64;
        userMembershipEligibility : T.MembershipType;
    };

    public type ICFCMembershipDTO = {
        membershipType : T.MembershipType;
        membershipClaims : [T.MembershipClaim];
        membershipExpiryTime : Int;
    };

    public type UsernameAvailable = Bool;



    public type IsUsernameValid = {
        username : Text;
    };

};
