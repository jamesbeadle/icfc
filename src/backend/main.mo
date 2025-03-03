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
import T "icfc_types";
import BaseCommands "commands/base_commands";
import ckBTCLedger "canister:ckbtc_ledger";

actor class Self() = this {
  private stable var profiles : [T.Profile] = [];

  stable var goal : Nat = 0; // Goal in ckBTC (100ckBTC = 10^8 units)
  stable var initialized : Bool = false;
  stable var owner : ?Principal = null;

  private type Subaccount = Blob;

  private var appStatus : Base.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };

  public shared ({ caller }) func initialize(initial_goal : Nat) : async () {
    if (initialized) {
      throw Error.reject("Canister already initialized");
    };
    owner := ?caller;
    goal := initial_goal;
    initialized := true;
  };

  private func is_owner(caller : Principal) : Bool {
    switch (owner) {
      case (?owner) {
        return caller == owner;
      };
      case (null) {
        return false;
      };
    };
  };

  public shared ({ caller }) func set_goal(new_goal : Nat) : async () {
    if (Option.isNull(owner) or is_owner(caller)) {
      throw Error.reject("Only the owner can update the goal");
    };
    goal := new_goal;
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
  private func defaultSubaccount() : Subaccount {
    Blob.fromArrayMut(Array.init(32, 0 : Nat8));
  };

  public func approve_funds(amount : Nat) : async Result.Result<(), ckBTCLedger.ApproveError> {
    let fee = await ckBTCLedger.icrc1_fee();
    let decimals = Nat8.toNat(await ckBTCLedger.icrc1_decimals());
    let adjusted_amount = amount * Nat.pow(10, 8 - decimals);
    let adjusted_fee = fee * Nat.pow(10, 8 - decimals);

    let approve_result = await ckBTCLedger.icrc2_approve({
      from_subaccount = ?defaultSubaccount(); // need to fix this 
      spender = {
        owner = Principal.fromActor(this);
        subaccount = null;
      };
      to = {
        owner = Principal.fromActor(this);
        subaccount = null;
      };
      amount = adjusted_amount;
      fee = ?adjusted_fee;
      expected_allowance = null;
      expires_at = null;
      memo = null;
      created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
    });

    switch (approve_result) {
      case (#Ok(_)) {
        return #ok(());
      };
      case (#Err(err)) {
        return #err(err);
      };
    };
  };

  public shared ({ caller }) func contribute(amount : Nat) : async Result.Result<(), Text> {
    if (not initialized) {
      return #err("The canister is not initialized");
    };

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
    let decimals = Nat8.toNat(await ckBTCLedger.icrc1_decimals());
    let adjusted_amount = amount * Nat.pow(10, 8 - decimals);
    let adjusted_fee = fee * Nat.pow(10, 8 - decimals);

    let transfer_result = await ckBTCLedger.icrc2_transfer_from({
      spender_subaccount = ?defaultSubaccount();
      from = {
        owner = caller;
        subaccount = null;
      };
      to = {
        owner = Principal.fromActor(this);
        subaccount = null;
      };
      amount = adjusted_amount;
      fee = ?adjusted_fee;
      memo = null;
      created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
    });

    switch (transfer_result) {
      case (#Ok(_)) {
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

  public shared ({ caller }) func withdraw() : async Result.Result<(), Text> {
    if (not initialized) {
      return #err("The canister is not initialized");
    };

    if (Option.isNull(owner) or not is_owner(caller)) {
      return #err("Only the owner can withdraw");
    };

    let balance = await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = null;
    });
    let fee = await ckBTCLedger.icrc1_fee();
    // Transfer the balance to the owner
    let transfer_result = await ckBTCLedger.icrc1_transfer({
      to = {
        owner = switch (owner) {
          case (?principal) principal;
          case (null) throw Error.reject("Owner is not set");
        };
        subaccount = null;
      };
      amount = balance - fee;
      fee = ?fee;
      memo = null;
      created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
      from_subaccount = ?defaultSubaccount();
    });

    switch (transfer_result) {
      case (#Ok(_)) {
        return #ok(());
      };
      case (#Err(err)) {
        return #err("Transfer failed: " # debug_show (err));
      };
    };
  };

  public query func get_goal() : async Nat {
    return goal;
  };

  public shared func get_goal_progress() : async Nat {
    if (not initialized) {
      throw Error.reject("The canister is not initialized");
    };

    let current_balance = await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = null;
    });

    return current_balance;
  };

  public shared func get_current_balance() : async Nat {
    if (not initialized) {
      throw Error.reject("The canister is not initialized");
    };
    await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = null;
    });
  };

  public shared ({ caller }) func get_user_balance() : async Nat {
    await ckBTCLedger.icrc1_balance_of({
      owner = caller;
      subaccount = null;
    });
  };

};
