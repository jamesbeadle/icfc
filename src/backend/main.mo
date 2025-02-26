import Base "mo:waterway-mops/BaseTypes";
import Result "mo:base/Result";
import BaseCommands "queries/base_commands";
import T "icfc_types";


actor Self {

  
  
  private var appStatus: Base.AppStatus = { 
    onHold = false;
    version = "0.0.1";
  };  
  
  public shared query func getAppStatus() : async Result.Result<BaseCommands.AppStatusDTO, T.Error> {
    return #ok(appStatus);
  };
    
};
