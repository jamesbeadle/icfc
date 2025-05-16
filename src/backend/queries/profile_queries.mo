import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import IcfcEnums "mo:waterway-mops/ICFCEnums";
import T "../icfc_types";
import SNSGovernance "mo:waterway-mops/sns-wrappers/governance";

module ProfileQueries {
    public type GetProfile = {
        principalId : Ids.PrincipalId;
    };

    public type Profile = {
        principalId : Ids.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : IcfcEnums.MembershipType;
        membershipClaims : [T.MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        appPrincipalIds : [(T.SubApp, Ids.PrincipalId)];
        subscribedChannelIds : [Ids.FootballChannelId];
        membershipExpiryTime : Int;
        favouriteLeagueId : ?FootballIds.LeagueId;
        favouriteClubId : ?FootballIds.ClubId;
        nationalityId : ?Ids.CountryId;
    };

    public type ICFCProfileSummary = {
        principalId : Ids.PrincipalId;
        username : Text;
        displayName : Text;
        membershipType : T.MembershipType;
        membershipClaims : [T.MembershipClaim];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        membershipExpiryTime : Int;
        favouriteLeagueId : ?FootballIds.LeagueId;
        favouriteClubId : ?FootballIds.ClubId;
        nationalityId : ?Ids.CountryId;
    };

    public type ListProfiles = {
        searchTerm : Text;
        totalEntries : Nat;
        limit : Nat;
        offset : Nat;
    };

    public type GetClaimedMemberships = {
        principalId : Ids.PrincipalId;
        offset : Nat;
    };
    public type ProfilePictureDTO = {
        profilePicture : ?Blob;
    };

    public type Profiles = {
        profiles : [ProfileSummary];
    };

    public type ProfileSummary = {
        profilePrincipalId : Ids.PrincipalId;
        userName : Text;
        userPicture : ?Blob;
        userPictureExtension : Text;
    };

    public type IsUsernameAvailable = {
        username : Text;
        principalId : Ids.PrincipalId;
    };

    public type UserNeuronsDTO = {
        userNeurons : [SNSGovernance.Neuron];
        totalMaxStaked : Nat64;
        userMembershipEligibility : T.EligibleMembership;
    };

    public type ClaimedMembershipsDTO = {
        claimedMemberships : [T.MembershipClaim];
    };

    public type UsernameAvailable = Bool;

    public type IsUsernameValid = {
        username : Text;
    };

    public type MembershipType = {
        #Monthly;
        #Seasonal;
        #Lifetime;
        #Founding;
        #Expired;
        #NotClaimed;
        #NotEligible;
    };

    public type EligibleMembership = {
        membershipType : MembershipType;
        eligibleNeuronIds : [Blob];
    };

};
