import FootballIds "mo:waterway-mops/domain/football/ids";
import IcfcEnums "mo:waterway-mops/product/icfc/enums";
import Ids "mo:waterway-mops/base/ids";

import AppIds "../ids";
import T "../types";

module ProfileQueries {
    public type GetProfile = {
        principalId : Ids.PrincipalId;
    };

    public type Profile = {
        principalId : Ids.PrincipalId;
        username : Text;
        displayName : Text;
        subscriptionType : IcfcEnums.SubscriptionType;
        subscriptions : [T.Subscription];
        createdOn : Int;
        profilePicture : ?Blob;
        termsAgreed : Bool;
        appPrincipalIds : [(IcfcEnums.SubApp, Ids.PrincipalId)];
        subscribedChannelIds : [AppIds.FootballChannelId];
        subscriptionExpiryTime : Int;
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

    public type GetSubscriptions = {
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

    public type UsernameAvailable = Bool;

    public type IsUsernameValid = {
        username : Text;
    };

};
