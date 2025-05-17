import Blob "mo:base/Blob";

import AppIds "./ids";
import Ids "mo:waterway-mops/base/ids";
import Enums "mo:waterway-mops/base/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import ICFCEnums "mo:waterway-mops/product/icfc/enums";

module ICFCTypes {

  public type Profile = {
    principalId : Ids.PrincipalId;
    username : Text;
    displayName : Text;
    subscriptionType : ICFCEnums.SubscriptionType;
    subscriptions : [Subscription];
    subscriptionExpiryTime : Int;
    createdOn : Int;
    profilePicture : ?Blob;
    termsAgreed : Bool;
    appPrincipalIds : [(ICFCEnums.SubApp, Ids.PrincipalId)];
    subscribedChannelIds : [AppIds.FootballChannelId];
    favouriteLeagueId : ?FootballIds.LeagueId;
    favouriteClubId : ?FootballIds.ClubId;
    nationalityId : ?Ids.CountryId;
  };

  public type FootballChannel = {
    id : AppIds.FootballChannelId;
    name : Text;
    createdBy : Ids.PrincipalId;
    createdOn : Int;
    channelImage : ?Blob;
    channelImageExtension : Text;
    channelBanner : ?Blob;
    channelBannerExtension : Text;
  };

  public type Subscription = {
    subscriptionType : ICFCEnums.SubscriptionType;
    purchasedOn : Int;
    expiresOn : ?Int;
  };

  public type Club = {
    id : FootballIds.ClubId;
    name : Text;
  };

  public type PayoutRequest = {
    app : ICFCEnums.App;
    leaderboard : [LeaderboardEntry];
    gameweek : FootballDefinitions.GameweekNumber;
    seasonId : FootballIds.SeasonId;
    currency : Enums.Currency;
    status: Enums.PayoutStatus;
    totalEntries: Nat;
    totalPaid: Nat;
  };

  public type LeaderboardEntry = {
        appPrincipalId : Ids.PrincipalId;
        rewardAmount : ?Nat64;
        payoutStatus : Enums.PayoutStatus;
        payoutDate : ?Int;
  };
};
