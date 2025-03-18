import Timer "mo:base/Timer";
import Int "mo:base/Int";
import Principal "mo:base/Principal";
import Management "../backend/utils/management";
import Utils "../backend/utils/utils";
import Environment "../backend/environment";

actor Self {

  system func postupgrade() {
    
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {

    let canister = actor ("mmony-taaaa-aaaal-qsk4a-cai") : actor {};
    let IC : Management.Management = actor (Environment.Default);
    let principal = ?Principal.fromText(Environment.BACKEND_CANISTER_ID);
    let _ = await Utils.updateCanister_(canister, principal, IC);
  };

};
