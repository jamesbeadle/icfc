import Base "mo:waterway-mops/BaseTypes";
module ICFCTypes {

  public type ClubId = Nat16;
  public type PlayerId = Nat16;

  public type Profile = {
    principalId: Base.PrincipalId;
    username: Text;
    displayName: Text;
    membershipType: MembershipType;
    membershipClaims: [MembershipClaim];
    createdOn: Int;
    profilePicture: Blob;
    profilePictureExtension: Text;
    termsAgreed: Bool;
    appPrincipalIds: [(Text, Base.PrincipalId)];
  };

  public type MembershipType = {
    #Monthly;
    #Annual;
    #Lifetime;
  };

  public type MembershipClaim = {
    membershipType: MembershipType;
    claimedOn: Int;
    expiresOn: ?Int;
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
};
