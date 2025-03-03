import Base "mo:waterway-mops/BaseTypes";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import ckBTCLedger "canister:ckbtc_ledger";

module ICFCTypes {

  public type ClubId = Nat16;
  public type PlayerId = Nat16;

  public type Profile = {
    principalId : Base.PrincipalId;
    username : Text;
    displayName : Text;
    membershipType : MembershipType;
    membershipClaims : [MembershipClaim];
    createdOn : Int;
    profilePicture : Blob;
    profilePictureExtension : Text;
    termsAgreed : Bool;
    appPrincipalIds : [(Text, Base.PrincipalId)];
  };

  public type MembershipType = {
    #Monthly;
    #Annual;
    #Lifetime;
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
  };

  public type Club = {
    id : ClubId;
    name : Text;
  };

  public type ScoutedPlayer = {

  };

  public type Manager = {

  };

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

};
