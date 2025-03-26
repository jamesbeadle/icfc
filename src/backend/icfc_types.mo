import Base "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";
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
    termsAgreed : Bool;
    appPrincipalIds : [(SubApp, Base.PrincipalId)];
    podcastIds : [Base.PrincipalId];
    favouriteLeagueId : ?FootballTypes.LeagueId;
    favouriteClubId : ?FootballTypes.ClubId;
    nationalityId : ?Base.CountryId;
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
