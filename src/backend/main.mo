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
import ckBTCLedger "canister:ckBTC_ledger";
import T "icfc_types";
import BaseCommands "commands/base_commands";

actor class Main(_startBlock : Nat) {

  private var latestTransactionIndex : Nat = 0;
  private var logData = Buffer.Buffer<Text>(0);

  private stable var ckBTCTransactions : Trie.Trie<Text, T.Profile> = Trie.empty();
  private stable var profiles : [T.Profile] = [];

  private var appStatus : Base.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };

  public shared query ({ caller }) func getProfile() : async Result.Result<T.Profile, T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);

    let foundProfile = Array.find(
      profiles,
      func(profile : T.Profile) : Bool {
        profile.principalId == principalId;
      },
    );
    switch (foundProfile) {
      case (?profile) {
        return #ok(profile);
      };
      case (null) {
        return #err(#NotFound);
      };
    };
  };

  public shared query func getAppStatus() : async Result.Result<BaseCommands.AppStatusDTO, T.Error> {
    return #ok(appStatus);
  };

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

  system func postupgrade() {
    latestTransactionIndex := _startBlock;
  };
};
