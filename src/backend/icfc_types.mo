import Base "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";
import Blob "mo:base/Blob";
//import ckBTCLedger "canister:ckbtc_ledger"; // TODO Use for ckBTC sale Q3 2025

module ICFCTypes {

  public type ClubId = Nat16;
  public type PlayerId = Nat16;
  public type FootballChannelId = Nat;

  public type Profile = {
    principalId : Base.PrincipalId;
    username : Text;
    displayName : Text;
    membershipType : MembershipType;
    membershipClaims : [MembershipClaim];
    membershipExpiryTime : Int;
    createdOn : Int;
    profilePicture : ?Blob;
    termsAgreed : Bool;
    appPrincipalIds : [(SubApp, Base.PrincipalId)];
    podcastIds : [Base.PrincipalId];
    favouriteLeagueId : ?FootballTypes.LeagueId;
    favouriteClubId : ?FootballTypes.ClubId;
    nationalityId : ?Base.CountryId;
  };

  public type FootballChannel = {
    id : FootballChannelId;
    name : Text;
    createdBy : Base.PrincipalId;
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

  public type MembershipClaim = {
    membershipType : MembershipType;
    claimedOn : Int;
    expiresOn : ?Int;
  };

  public type EligibleMembership = {
    membershipType : MembershipType;
    eligibleNeuronIds : [Blob];
  };

  public type Error = {
    #NotFound;
    #AlreadyExists;
    #NotAuthorized;
    #NotAllowed;
    #DecodeError;
    #InvalidData;
    #CanisterFull;
    #OutOfRange;
    #TooLong;
    #TooShort;
    #NotEnoughFunds;
    #PaymentError;
    #InvalidProfilePicture;
    #CreateGameError;
    #UpdateFailed;
    #AlreadyClaimed;
    #InEligible;
    #NeuronAlreadyUsed;
    #AlreadyLinked;
    #FailedInterCanisterCall;
  };

  public type Club = {
    id : ClubId;
    name : Text;
  };

  public type ScoutedPlayer = {

  };

  public type Manager = {

  };
};
