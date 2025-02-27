import Base "mo:waterway-mops/BaseTypes";
import Result "mo:base/Result";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Trie "mo:base/Trie";
import Nat64 "mo:base/Nat64";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import BaseCommands "queries/base_commands";
import ckBTCLedger "canister:ckBTC_ledger";
import ICFCTypes "icfc_types";

actor class Main(_startBlock : Nat) {

  private var latestTransactionIndex : Nat = 0;
  private var logData = Buffer.Buffer<Text>(0);
  private stable var ckBTCTransactions : Trie.Trie<Text, ICFCTypes.User> = Trie.empty();

  private var appStatus : Base.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };

  public shared query func getAppStatus() : async Result.Result<BaseCommands.AppStatusDTO, ICFCTypes.Error> {
    return #ok(appStatus);
  };

  // TODO: Implement Get and Set Profiles

  public query func getLogs() : async [Text] {
    Buffer.toArray(logData);
  };


  private func log(text : Text) {
    Debug.print(text);
    logData.reserve(logData.size() + 1);
    logData.insert(0, text);

    // cap the log at 100 entries
    if (logData.size() == 100) {
      let _ = logData.removeLast();
    };
    return;
  };

  private func userKey(x : Text) : Trie.Key<Text> {
    return { hash = Text.hash(x); key = x };
  };

  system func timer(setGlobalTimer : Nat64 -> ()) : async () {
    let next = Nat64.fromIntWrap(Time.now()) + 20_000_000_000; // 20 seconds
    setGlobalTimer(next);
    await notify();
  };

  private func notify() : async () {
    var start : Nat = _startBlock;
    if (latestTransactionIndex > 0) {
      start := latestTransactionIndex + 1;
    };

    var response = await ckBTCLedger.get_transactions({
      start = start;
      length = 1;
    });

    if (Array.size(response.transactions) > 0) {
      latestTransactionIndex := start;
      if (response.transactions[0].kind == "transfer") {
        let t = response.transactions[0];
        switch (t.transfer) {
          case (?transfer) {
            let to = transfer.to.owner;
            switch (Trie.get(ckBTCTransactions, userKey(Principal.toText(to)), Text.equal)) {
              case (?user) {
                // TODO: Send notification to user
              };
              case null {

              };
            };
          };
          case null {

          };
        };
      };
    };
  };

  system func postupgrade(){
    latestTransactionIndex := _startBlock;
  }
};
