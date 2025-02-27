module ICFCTypes {

  public type ClubId = Nat16;
  public type PlayerId = Nat16;

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

  public type User = {
    name:Text;
    // TODO: Add more fields eg email and ph. no. for sending notifications
  }
};
