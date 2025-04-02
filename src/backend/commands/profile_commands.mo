import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import ICFCEnums "mo:waterway-mops/ICFCEnums";

module ProfileCommands {
    public type GetProfile = {
        principalId : Ids.PrincipalId;
    };

    public type CreateProfile = {
        username : Text;
        profilePicture : ?Blob;
        displayName : Text;
        favouriteLeagueId : ?FootballIds.LeagueId;
        favouriteClubId : ?FootballIds.ClubId;
        nationalityId : ?Ids.CountryId;
    };

    public type UpdateUserName = {
        principalId : Ids.PrincipalId;
        username : Text;
    };

    public type UpdateDisplayName = {
        principalId : Ids.PrincipalId;
        displayName : Text;
    };

    public type UpdateFavouriteClub = {
        principalId : Ids.PrincipalId;
        favouriteLeagueId : FootballIds.LeagueId;
        favouriteClubId : FootballIds.ClubId;
    };

    public type UpdateNationality = {
        principalId : Ids.PrincipalId;
        nationalityId : Ids.CountryId;
    };

    public type UpdateProfilePicture = {
        principalId : Ids.PrincipalId;
        profilePicture : ?Blob;
    };

    public type DeleteProfile = {
        principalId : Ids.PrincipalId;
        confirm : Bool;
    };

    public type UpdateMembership = {
        principalId : Ids.PrincipalId;
        membershipType : ICFCEnums.MembershipType;
    };

    public type ClaimMembership = {
        principalId : Ids.PrincipalId;
    };

    public type AddSubApp = {
        principalId : Ids.PrincipalId;
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
    };

    public type GetICFCProfile = {
        principalId : Ids.PrincipalId;
    };

    public type RemoveSubApp = {
        subApp : ICFCEnums.SubApp;
        userPrincipalId : Ids.PrincipalId;
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
        claimedOn : Int;
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
