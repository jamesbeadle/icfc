import Base "mo:waterway-mops/BaseTypes";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
//import ckBTCLedger "canister:ckbtc_ledger";

module ICFCTypes {

  public type ClubId = Nat16;
  public type PlayerId = Nat16;
  public type PodcastChannelId = Nat;

  public type Profile = {
    principalId : Base.PrincipalId;
    username : Text;
    displayName : Text;
    membershipType : MembershipType;
    membershipClaims : [MembershipClaim];
    membershipExpiryTime : Int;
    createdOn : Int;
    profilePicture : ?Blob;
    profilePictureExtension : Text;
    termsAgreed : Bool;
    appPrincipalIds : [(SubApp, Base.PrincipalId)];
    podcastIds : [Base.PrincipalId];
  };

  public type PodcastChannel = {
    id : PodcastChannelId;
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
  };

  public type Club = {
    id : ClubId;
    name : Text;
  };

  public type ScoutedPlayer = {

  };

  public type Manager = {

  };

  /*
  public type DepositArgs = {
    spender_subaccount : ?Blob;
    token : Principal;
    from : ckBTCLedger.Account;
    amount : Nat;
    fee : ?Nat;
    memo : ?Blob;
    created_at_time : ?Nat64;
  };
  public type DepositError = {
    #TransferFromError : ckBTCLedger.TransferFromError;
  };
  */

  public type SaleParticipant = {
    user : Principal;
    amount : Nat;
    icfc_staked : Nat;
    time : Nat64;
  };
};
