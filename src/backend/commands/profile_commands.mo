import FootballTypes "mo:waterway-mops/FootballTypes";
import Ids "mo:waterway-mops/Ids";
import T "../icfc_types";

module ProfileCommands {
    public type GetProfile = {
        principalId : Ids.PrincipalId;
    };

    public type CreateProfile = {
        username : Text;
        profilePicture : ?Blob;
        displayName : Text;
        appPrincipalIds : [(T.SubApp, Ids.PrincipalId)];
        favouriteLeagueId : ?FootballTypes.LeagueId;
        favouriteClubId : ?FootballTypes.ClubId;
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
        favouriteLeagueId : FootballTypes.LeagueId;
        favouriteClubId : FootballTypes.ClubId;
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
        membershipType : T.MembershipType;
    };

    public type ClaimMembership = {
        principalId : Ids.PrincipalId;
    };

    public type AddSubApp = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : T.SubApp;
    };

    public type GetICFCProfile = {
        principalId : Ids.PrincipalId;
    };

    public type RemoveSubApp = {
        subApp : T.SubApp;
        userPrincipalId : Ids.PrincipalId;
    };
    public type VerifySubApp = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : T.SubApp;
        icfcPrincipalId : Ids.PrincipalId;
    };

    public type NotifyAppofLink = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : T.SubApp;
        icfcPrincipalId : Ids.PrincipalId;
    };
    public type UpdateICFCProfile = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : T.SubApp;
        membershipType : T.MembershipType;
    };
};
