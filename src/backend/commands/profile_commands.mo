import Base "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";
import T "../icfc_types";

module ProfileCommands {

    public type CreateProfile = {
        username : Text;
        profilePicture : ?Blob;
        profilePictureExtension : ?Text;
        displayName : Text;
        appPrincipalIds : [(T.SubApp, Base.PrincipalId)];
    };

    public type UpdateUserName = {
        principalId : Base.PrincipalId;
        username : Text;
    };

    public type UpdateDisplayName = {
        principalId : Base.PrincipalId;
        displayName : Text;
    };

    public type UpdateFavouriteClub = {
        principalId : Base.PrincipalId;
        favouriteLeagueId : FootballTypes.LeagueId;
        favouriteClubId : FootballTypes.ClubId;
    };

    public type UpdateNationality = {
        principalId : Base.PrincipalId;
        countryId : Base.CountryId;
    };

    public type UpdateProfilePicture = {
        principalId : Base.PrincipalId;
        profilePicture : ?Blob;
        profilePictureExtension : Text;
    };

    public type DeleteProfile = {
        principalId : Base.PrincipalId;
        confirm : Bool;
    };


    public type UpdateMembership = {
        principalId : Base.PrincipalId;
        membershipType : T.MembershipType;
    };

    public type ClaimMembership = {
        principalId : Base.PrincipalId;
    };

    public type AddSubApp = {
        subAppUserPrincipalId : Base.PrincipalId;
        subApp : T.SubApp;
    };

    public type GetICFCMembership = {
        principalId : Base.PrincipalId;

    };

    public type RemoveSubApp = {
        subApp : T.SubApp;
        userPrincipalId : Base.PrincipalId;
    };
    public type VerifySubApp = {
        subAppUserPrincipalId : Base.PrincipalId;
        subApp : T.SubApp;
        icfcPrincipalId : Base.PrincipalId;
    };

    public type NotifyAppofLink = {
        subAppUserPrincipalId : Base.PrincipalId;
        subApp : T.SubApp;
        icfcPrincipalId : Base.PrincipalId;
    }
};
