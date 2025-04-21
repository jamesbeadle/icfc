import Ids "mo:waterway-mops/Ids";
import FootballIds "mo:waterway-mops/football/FootballIds";
import Blob "mo:base/Blob";
//import ckBTCLedger "canister:ckbtc_ledger"; // TODO Use for ckBTC sale Q3 2025

module ICFCTypes {

  public type FootballChannelId = Nat;
  type Subaccount = Blob;
  type Tokens = Nat;
  type Timestamp = Nat64;
  type BlockIndex = Nat;

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
    podcastIds : [Ids.PrincipalId];
    favouriteLeagueId : ?FootballIds.LeagueId;
    favouriteClubId : ?FootballIds.ClubId;
    nationalityId : ?Ids.CountryId;
  };

  public type FootballChannel = {
    id : FootballChannelId;
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

  public type TransferError = {
    #BadFee : { expected_fee : Tokens };
    #BadBurn : { min_burn_amount : Tokens };
    #InsufficientFunds : { balance : Tokens };
    #TooOld;
    #CreatedInFuture : { ledger_time : Timestamp };
    #TemporarilyUnavailable;
    #Duplicate : { duplicate_of : BlockIndex };
    #GenericError : { error_code : Nat; message : Text };
  };

  public type TransferResult = {
    #Ok : BlockIndex;
    #Err : TransferError;
  };

  public type TransferArg = {
    from_subaccount : ?Subaccount;
    to : Account;
    amount : Tokens;
    fee : ?Tokens;
    memo : ?Blob;
    created_at_time : ?Timestamp;
  };

  public type Account = {
    owner : Principal;
    subaccount : ?Subaccount;
  };
};
