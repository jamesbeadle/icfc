import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import ICFCEnums "mo:waterway-mops/ICFCEnums";

module ProfileCommands {

    public type CreateProfile = {
        username : Text;
        profilePicture : ?Blob;
        displayName : Text;
        favouriteLeagueId : ?FootballIds.LeagueId;
        favouriteClubId : ?FootballIds.ClubId;
        nationalityId : ?Ids.CountryId;
    };

    public type UpdateUserName = {
        username : Text;
    };

    public type UpdateDisplayName = {
        displayName : Text;
    };

    public type UpdateFavouriteClub = {
        favouriteLeagueId : FootballIds.LeagueId;
        favouriteClubId : FootballIds.ClubId;
    };

    public type UpdateNationality = {
        nationalityId : Ids.CountryId;
    };

    public type UpdateProfilePicture = {
        profilePicture : ?Blob;
    };

    public type DeleteProfile = {
        confirm : Bool;
    };

    public type UpdateMembership = {
        membershipType : ICFCEnums.MembershipType;
    };

    public type AddSubApp = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
    };

    public type GetICFCProfile = {
        principalId : Ids.PrincipalId;
    };

    public type RemoveSubApp = {
        subApp : ICFCEnums.SubApp;
    };
    public type VerifySubApp = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
        icfcPrincipalId : Ids.PrincipalId;
    };

    public type NotifyAppofLink = {
        membershipType : ICFCEnums.MembershipType;
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
        icfcPrincipalId : Ids.PrincipalId;
    };
    public type NotifyAppofRemoveLink = {
        subApp : ICFCEnums.SubApp;
        icfcPrincipalId : Ids.PrincipalId;
    };
    public type UpdateICFCProfile = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
        membershipType : ICFCEnums.MembershipType;
    };

    public type MembershipClaim = {
        membershipType : ICFCEnums.MembershipType;
        purchasedOn : Int;
        expiresOn : ?Int;
    };
    public type SubApp = {
        #OpenFPL;
        #OpenWSL;
        #JeffBets;
        #TransferKings;
        #FootballGod;
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
