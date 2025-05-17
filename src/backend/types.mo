import Blob "mo:base/Blob";

import AppIds "./ids";
import Ids "mo:waterway-mops/base/ids";
import Enums "mo:waterway-mops/base/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import ICFCEnums "mo:waterway-mops/product/icfc/enums";
import OpenFPLEnums "mo:waterway-mops/product/openfpl/enums";
import Definitions "mo:waterway-mops/base/definitions";

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

  public type OpenFPLPayoutRequest = {
    app : ICFCEnums.App;
    rewardType: OpenFPLEnums.RewardType;
    detail: OpenFPLPayoutDetail;
    currency : Enums.Currency;
    status: Enums.PayoutStatus;
    totalEntries: Nat;
    totalPaid: Nat;
  };

  public type OpenFPLPayoutDetail = {
    #Weekly : WeeklyLeaderboardPayoutDetails;
    #Monthly : MonthlyLeaderboardPayoutDetails;
    #HighestScoringPlayer : HighestScoringPlayerPayoutDetails
  };

  public type WeeklyLeaderboardPayoutDetails = {
    seasonId : ?FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    leaderboard : [LeaderboardEntry];
  };

  public type MonthlyLeaderboardPayoutDetails = {
    detail: OpenFPLPayoutDetail;
    leaderboard : [LeaderboardEntry];
    month : Definitions.CalendarMonth;
    seasonId : FootballIds.SeasonId;
  };

  public type HighestScoringPlayerPayoutDetails = {
    detail: OpenFPLPayoutDetail;
    managers : [ManagerEntry];
    seasonId : ?FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    fixtureId : FootballIds.FixtureId;
  };

  public type LeaderboardEntry = {
    appPrincipalId : Ids.PrincipalId;
  };

  public type ManagerEntry = {
    appPrincipalId : Ids.PrincipalId;
  };

  public type LeaderboardPayout = {
    app : ICFCEnums.App;
    entriesPaid: [PaidLeaderboardEntry];
    gameweek : FootballDefinitions.GameweekNumber;
    seasonId : FootballIds.SeasonId;
    currency : Enums.Currency;
    status: Enums.PayoutStatus;
    totalEntries: Nat;
    totalPaid: Nat;
  };

  public type PaidLeaderboardEntry = {
    appPrincipalId : Ids.PrincipalId;
    rewardAmount : ?Nat64;
    payoutStatus : Enums.PayoutStatus;
    payoutDate : ?Int;
  };
};
