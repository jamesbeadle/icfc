import Base "mo:waterway-mops/BaseTypes";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import T "icfc_types";
import BaseCommands "commands/base_commands";


actor Self {

  private stable var profiles: [T.Profile] = [];
  
  private var appStatus: Base.AppStatus = { 
    onHold = false;
    version = "0.0.1";
  };  

  public shared query ({ caller }) func getProfile() : async Result.Result<T.Profile, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
   
    let foundProfile = Array.find(profiles, func(profile: T.Profile) : Bool {
      profile.principalId == principalId
    });
    switch(foundProfile){
      case (?profile){
        return #ok(profile);
      };
      case (null){
        return #err(#NotFound);
      }
    }
  };
  
  public shared query func getAppStatus() : async Result.Result<BaseCommands.AppStatusDTO, T.Error> {
    return #ok(appStatus);
  };
    
};