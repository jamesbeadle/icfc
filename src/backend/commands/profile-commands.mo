import FootballIds "mo:waterway-mops/domain/football/ids";
import ICFCEnums "mo:waterway-mops/product/icfc/enums";
import Ids "mo:waterway-mops/base/ids";

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

    public type AddSubApp = {
        subAppUserPrincipalId : Ids.PrincipalId;
        subApp : ICFCEnums.SubApp;
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
        subscriptionType : ICFCEnums.SubscriptionType;
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
        subscriptionType : ICFCEnums.SubscriptionType;
    };

    public type Subscribe = {
        subscriptionType : ICFCEnums.SubscriptionType;
    };

};
