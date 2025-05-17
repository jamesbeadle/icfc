import Blob "mo:base/Blob";

import AppIds "./ids";
import Ids "mo:waterway-mops/base/ids";
import Enums "mo:waterway-mops/base/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import ICFCEnums "mo:waterway-mops/product/icfc/enums";
//import ckBTCLedger "canister:ckbtc_ledger"; // TODO Use for ckBTC subscription

module ICFCTypes {

  public type Profile = {
    principalId : Ids.PrincipalId;
    username : Text;
    displayName : Text;
    membershipType : MembershipType;
    membershipClaims : [MembershipClaim];
    membershipExpiryTime : Int;
    createdOn : Int;
    profilePicture : ?Blob;
    termsAgreed : Bool;
    appPrincipalIds : [(SubApp, Ids.PrincipalId)];
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

  public type MembershipType = {
    #Monthly;
    #Seasonal;
    #Lifetime;
    #Founding;
    #Expired;
    #NotClaimed;
    #NotEligible;
  };

  public type SubApp = {
    #OpenFPL;
    #OpenWSL;
    #JeffBets;
    #TransferKings;
    #FootballGod;
  };

  public type CanisterType = {
    #Static;
    #Dynamic;
  };

  public type MembershipClaim = {
    membershipType : MembershipType;
    purchasedOn : Int;
    expiresOn : ?Int;
  };

  public type EligibleMembership = {
    membershipType : MembershipType;
    eligibleNeuronIds : [Blob];
  };

  public type Club = {
    id : FootballIds.ClubId;
    name : Text;
  };

  public type ScoutedPlayer = {

  };

  public type Manager = {

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
