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
import Debug "mo:base/Debug";
import T "icfc_types";
import ckBTCLedger "canister:ckbtc_ledger";
import Account "lib/Account";
import Environment "environment";
import Utils "utils/utils";
import DTOs "./dtos/dtos";
// import icpLedger "canister:icp_ledger";

actor class Self() = this {
  private var saleStartTime : Nat64 = Environment.SALE_START;
  private var saleEndTime : Nat64 = Environment.SALE_END;

  private stable var profiles : [T.Profile] = [];
  private stable var podcasts : [T.Podcast] = [];

  private stable var saleParticipants : [T.SaleParticipant] = [];

  private stable var min_goal : Nat = Environment.CKBTC_MIN_GOAL * Nat.pow(10, Nat8.toNat(8));
  private stable var max_goal : Nat = Environment.CKBTC_MAX_GOAL * Nat.pow(10, Nat8.toNat(8));
  private stable var isSaleActive : Bool = (Nat64.fromNat(Int.abs(Time.now())) >= saleStartTime and Nat64.fromNat(Int.abs(Time.now())) < saleEndTime);
  private stable var ckBTCRaised : Nat = 0;

  private type Subaccount = Blob;
  private var icfcExchange : Nat = 400; //400 ckSatoshis per ICFC

  public shared ({ caller }) func get_goal_progress() : async Nat {
    assert not Principal.isAnonymous(caller);

    return ckBTCRaised;
  };

  private func return_participants_ckBTC() : async Result.Result<Nat, Text> {
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

  private func end_sale() : async () {
    let saleProgress = await get_goal_progress();
    let decimal = await ckBTCLedger.icrc1_decimals();

    let totalRaised = saleProgress / Nat.pow(10, Nat8.toNat(decimal));

    if (totalRaised < 50) {
      // min goal not reached
      let _ = await return_participants_ckBTC();
      return;
    };
  };

  if (Nat64.fromNat(Int.abs(Time.now())) < saleStartTime) {
    let duration : Nat64 = saleStartTime - Nat64.fromNat(Int.abs(Time.now()));
    ignore Timer.setTimer<system>(
      #nanoseconds(Nat64.toNat(duration)),
      func() : async () {
        isSaleActive := true;
      },
    );
  };

  if (Nat64.fromNat(Int.abs(Time.now())) < saleEndTime) {
    let duration : Nat64 = saleEndTime - Nat64.fromNat(Int.abs(Time.now()));
    ignore Timer.setTimer<system>(
      #nanoseconds(Nat64.toNat(duration)),
      func() : async () {
        await end_sale();
        isSaleActive := false;
      },
    );
  };

  private var appStatus : Base.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };

  private func caller_allowed(caller : Principal) : Bool {
    let foundCaller = Array.find<Base.PrincipalId>(
      Environment.ADMIN_PRINCIPALS,
      func(canisterId : Base.CanisterId) : Bool {
        Principal.toText(caller) == canisterId;
      },
    );
    return Option.isSome(foundCaller);
  };

  public shared query ({ caller }) func get_profile() : async Result.Result<T.Profile, T.Error> {
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

  public shared query func get_app_status() : async Result.Result<DTOs.AppStatusDTO, T.Error> {
    return #ok(appStatus);
  };

  // amount is in ckSatoshi
  public shared ({ caller }) func participate(amount : Nat) : async Result.Result<(), Text> {
    assert not Principal.isAnonymous(caller);

    let now = Nat64.fromNat(Int.abs(Time.now()));
    if (now < saleStartTime or now >= saleEndTime) {
      return #err("Sale is not active");
    };

    let current_balance = await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = null;
    });

    if (current_balance >= max_goal) {
      return #err("Goal already reached");
    };

    if (current_balance + amount > max_goal) {
      return #err("Contribution would exceed the goal");
    };

    let fee = await ckBTCLedger.icrc1_fee();

    if (amount < fee) {
      return #err("Amount is less than fee");
    };

    let transfer_result = await ckBTCLedger.icrc1_transfer({
      from_subaccount = ?Account.principalToSubaccount(caller);
      to = {
        owner = Principal.fromActor(this);
        subaccount = ?Account.defaultSubaccount();
      };
      amount = amount - fee;
      fee = ?fee;
      memo = null;
      created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
    });

    let icfc_staked = amount / icfcExchange;

    switch (transfer_result) {
      case (#Ok(_)) {
        ckBTCRaised += amount;
        let particapantsBuffer = Buffer.fromArray<T.SaleParticipant>(saleParticipants);
        particapantsBuffer.add({
          user = caller;
          amount = amount;
          icfc_staked = icfc_staked;
          time = Nat64.fromNat(Int.abs(Time.now()));
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

  public shared ({ caller }) func get_goal() : async Result.Result<DTOs.SaleGoalDTO, Text> {
    assert not Principal.isAnonymous(caller);
    let current_balance = await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = null;
    });

    let result : DTOs.SaleGoalDTO = {
      minGoal = min_goal;
      maxGoal = max_goal;
      currentProgress = current_balance;
    };
    return #ok(result);
  };

  public shared ({ caller }) func get_user_balance() : async Nat {
    assert not Principal.isAnonymous(caller);
    await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = ?Account.principalToSubaccount(caller);
    });
  };

  public shared ({ caller }) func get_user_contribution() : async [T.SaleParticipant] {
    assert not Principal.isAnonymous(caller);

    let foundParticipants = Array.filter(
      saleParticipants,
      func(participant : T.SaleParticipant) : Bool {
        participant.user == caller;
      },
    );
    return foundParticipants;

  };

  public shared ({ caller }) func get_sale_participants() : async [T.SaleParticipant] {
    assert caller_allowed(caller);
    return saleParticipants;
  };

  public shared func get_sale_countdown() : async Result.Result<DTOs.SaleCountDownDTO, Text> {
    let now = Nat64.fromNat(Int.abs(Time.now()));
    if (now < saleStartTime) {
      let timeRemaining = saleStartTime - now;
      let (days, hours, minutes, seconds) = await Utils.convertNanoToTime(timeRemaining);

      let result : DTOs.SaleCountDownDTO = {
        status = "upcoming";
        timeRemaining = timeRemaining;
        stringTime = Nat.toText(days) # " days, " # Nat.toText(hours) # " hours, " # Nat.toText(minutes) # " minutes, " # Nat.toText(seconds) # " seconds";
      };
      return #ok(result);

    } else if (now < saleEndTime) {
      let timeRemaining = saleEndTime - now;
      let (days, hours, minutes, seconds) = await Utils.convertNanoToTime(timeRemaining);

      let result : DTOs.SaleCountDownDTO = {
        status = "active";
        timeRemaining = timeRemaining;
        stringTime = Nat.toText(days) # " days, " # Nat.toText(hours) # " hours, " # Nat.toText(minutes) # " minutes, " # Nat.toText(seconds) # " seconds";
      };
      return #ok(result);

    } else {
      let result : DTOs.SaleCountDownDTO = {
        status = "ended";
        timeRemaining = 0;
        stringTime = "Sale has ended";
      };
      return #ok(result);
    };

  };

  // public shared ({caller}) func create_podcast_group()
};
