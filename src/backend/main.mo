import Base "mo:waterway-mops/BaseTypes";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Error "mo:base/Error";
import Option "mo:base/Option";
import Text "mo:base/Text";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Timer "mo:base/Timer";
import T "icfc_types";
import BaseCommands "commands/base_commands";
import ckBTCLedger "canister:ckbtc_ledger";
import Account "lib/Account";
import Environment "environment";
// import icpLedger "canister:icp_ledger";

actor class Self() = this {
  private stable var profiles : [T.Profile] = [];
  private stable var podcasts : [T.Podcast] = [];

  private stable var saleParticipants : [T.SaleParticipant] = [];

  private stable var goal : Nat = 0; // Goal in ckBTC (100ckBTC = 10^8 units)
  private stable var isSaleActive : Bool = false;
  

  private type Subaccount = Blob;
  private var icfcCexchange: Nat = 400; //400 ckSatoshis per ICFC

  private var appStatus : Base.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };

  public shared ({ caller }) func startSale() : async Result.Result<Text, Text> {
    if (not callerAllowed(caller)) {
      throw Error.reject("Only the admin can start the sale");
    };

    if (not isSaleActive) {
      let secondsInDay = 86_400;
      let nanosecondsInSecond = 1_000_000_000;
      let thirtyDaysInSeconds = 30 * secondsInDay;
      let thirtyDaysInNanoseconds = thirtyDaysInSeconds * nanosecondsInSecond;

      let callback = func() : async () {
        await endSale();
        isSaleActive := false;
      };

      ignore Timer.setTimer<system>(#nanoseconds(thirtyDaysInNanoseconds), callback);
      isSaleActive := true;

      return #ok("Sale started");
    } else {
      return #err("Sale is already active");
    };

  };

  private func endSale() : async () {
    let saleProgress = await get_goal_progress();
    let decimal = await ckBTCLedger.icrc1_decimals();

    let totalRaised = saleProgress / Nat.pow(10, Nat8.toNat(decimal));

    if (totalRaised < 50) {
      // min goal not reached
      let _ = await returnParticipantsckBTC();
      return;
    };
  };

  private func callerAllowed(caller : Principal) : Bool {
    let foundCaller = Array.find<Base.PrincipalId>(
      Environment.ADMIN_PRINCIPALS,
      func(canisterId : Base.CanisterId) : Bool {
        Principal.toText(caller) == canisterId;
      },
    );
    return Option.isSome(foundCaller);
  };

  public shared ({ caller }) func set_goal(new_goal : Nat) : async () {
    if (not callerAllowed(caller)) {
      throw Error.reject("Only the owner can update the goal");
    };

    let decimal = await ckBTCLedger.icrc1_decimals();

    goal := new_goal * Nat.pow(10, Nat8.toNat(decimal)); // sets goal in ckSatoshi
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

  // amount is in ckSatoshi
  public shared ({ caller }) func participate(amount : Nat) : async Result.Result<(), Text> {

    let current_balance = await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = null;
    });

    if (current_balance >= goal) {
      return #err("Goal already reached");
    };

    if (current_balance + amount > goal) {
      return #err("Contribution would exceed the goal");
    };

    let fee = await ckBTCLedger.icrc1_fee();

    let transfer_result = await ckBTCLedger.icrc1_transfer({
      from_subaccount = ?Account.principalToSubaccount(caller);
      to = {
        owner = Principal.fromActor(this);
        subaccount = null;
      };
      amount = amount - fee;
      fee = ?fee;
      memo = null;
      created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
    });

    let icfc_staked = amount / icfcCexchange;

    switch (transfer_result) {
      case (#Ok(_)) {
        let particapantsBuffer = Buffer.fromArray<T.SaleParticipant>(saleParticipants);
        particapantsBuffer.add({
          user = caller;
          amount = amount;
          icfc_staked = icfc_staked;
        });
        saleParticipants := Buffer.toArray(particapantsBuffer);
        return #ok(());
      };
      case (#Err(err)) {
        return #err("Transfer failed: " # debug_show (err));
      };
    };
  };

  public shared ({ caller }) func get_principal() : async Principal {
    return caller;
  };

  private func returnParticipantsckBTC() : async Result.Result<Nat, Text> {
    let participants = saleParticipants;
    saleParticipants := [];
    let fee = await ckBTCLedger.icrc1_fee();
    var total = 0;
    for (participant in Array.vals(participants)) {
      let transfer_result = await ckBTCLedger.icrc1_transfer({
        from_subaccount = ?Account.defaultSubaccount();
        to = {
          owner = Principal.fromActor(this);
          subaccount = ?Account.principalToSubaccount(participant.user);
        };
        amount = participant.amount - fee;
        fee = ?fee;
        memo = null;
        created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
      });

      switch (transfer_result) {
        case (#Ok(_)) {
          total += participant.amount;
        };
        case (#Err(err)) {
          return #err("Transfer failed: " # debug_show (err));
        };
      };
    };
    return #ok(total);
  };

  public query func get_goal() : async Nat {
    return goal;
  };

  public shared func get_goal_progress() : async Nat {
    let current_balance = await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = null;
    });

    return current_balance;
  };

  public shared ({ caller }) func get_user_balance() : async Nat {
    // returns in ckSatoshi
    await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = ?Account.principalToSubaccount(caller);
    });
  };

  // public shared ({caller}) func create_podcast_group()
};
