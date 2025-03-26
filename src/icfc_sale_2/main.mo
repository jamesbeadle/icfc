import Result "mo:base/Result";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Timer "mo:base/Timer";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import T "./sale_types";
import DTO "./dtos/dtos";
import Base "mo:waterway-mops/BaseTypes";
import Account "lib/Account";
import Utils "../backend/utils/utils";
import SaleManager "manager/sale_manager";


actor class Self() = this {

    private let saleManager = SaleManager.SaleManager();

    private var appStatus : Base.AppStatus = {
        onHold = false;
        version = "0.0.2";
    };


    private stable var stable_saleComplete : Bool = false;

    private stable var stable_saleParticipants : [T.SaleParticipant] = [];

    private stable var stable_icpRaised : Nat = 0;



    public shared query func getAppStatus() : async Result.Result<DTO.AppStatusDTO, T.Error> {
        return #ok(appStatus);
    };

    // SNS Sale icp Functions

    public shared ({caller}) func getPrinciapl() : async Result.Result<(Base.PrincipalId), Text> {
        assert not Principal.isAnonymous(caller);
        return #ok(Principal.toText(caller));
    };



    // private func end_sale() : async () {
    //     let saleProgress = icpRaised;
    //     let decimal = await icpLedger.icrc1_decimals();

    //     let totalRaised = saleProgress / Nat.pow(10, Nat8.toNat(decimal));

    //     if (totalRaised < 50) {
    //         // min goal not reached
    //         let _ = await return_participants_ICP();
    //         return;
    //     };
    // };

    // public shared ({ caller }) func participate(amount : Nat) : async Result.Result<(), Text> {
    //     assert not Principal.isAnonymous(caller);

    //     let now = Nat64.fromNat(Int.abs(Time.now()));
    //     if (now < saleStartTime or now >= saleEndTime) {
    //         return #err("Sale is not active");
    //     };

    //     let current_balance = await icpLedger.icrc1_balance_of({
    //         owner = Principal.fromActor(this);
    //         subaccount = null;
    //     });

    //     if (current_balance >= goal) {
    //         return #err("Goal already reached");
    //     };

    //     if (current_balance + amount > goal) {
    //         return #err("Contribution would exceed the goal");
    //     };

    //     let fee = await icpLedger.icrc1_fee();

    //     if (amount < fee) {
    //         return #err("Amount is less than fee");
    //     };

    //     let transfer_result = await icpLedger.icrc1_transfer({
    //         from_subaccount = ?Account.principalToSubaccount(caller);
    //         to = {
    //             owner = Principal.fromActor(this);
    //             subaccount = ?Account.defaultSubaccount();
    //         };
    //         amount = amount - fee;
    //         fee = ?fee;
    //         memo = null;
    //         created_at_time = ?Nat64.fromNat(Int.abs(Time.now()));
    //     });

    //     let icfc_staked = Float.fromInt(amount) / icpExchange;

    //     switch (transfer_result) {
    //         case (#Ok(_)) {
    //             icpRaised += amount;
    //             let particapantsBuffer = Buffer.fromArray<T.SaleParticipant>(saleParticipants);
    //             particapantsBuffer.add({
    //                 user = caller;
    //                 amount = amount;
    //                 icfc_staked = icfc_staked;
    //                 time = Nat64.fromNat(Int.abs(Time.now()));
    //             });
    //             saleParticipants := Buffer.toArray(particapantsBuffer);
    //             return #ok(());
    //         };
    //         case (#Err(err)) {
    //             return #err("Transfer failed: " # debug_show (err));
    //         };
    //     };
    // };

    // public query func get_goal() : async Result.Result<DTO.SaleGoalDTO, Text> {
    //     let result : DTO.SaleGoalDTO = {
    //         goal = goal;
    //         currentProgress = icpRaised;
    //     };
    //     return #ok(result);
    // };

    // public shared ({ caller }) func get_user_ckBTC_balance() : async Nat {
    //     assert not Principal.isAnonymous(caller);
    //     await icpLedger.icrc1_balance_of({
    //         owner = Principal.fromActor(this);
    //         subaccount = ?Account.principalToSubaccount(caller);
    //     });
    // };

    // public shared ({ caller }) func get_user_sale_contribution() : async [T.SaleParticipant] {
    //     assert not Principal.isAnonymous(caller);

    //     let foundParticipants = Array.filter(
    //         saleParticipants,
    //         func(participant : T.SaleParticipant) : Bool {
    //             participant.user == caller;
    //         },
    //     );
    //     return foundParticipants;

    // };

    // public shared func get_sale_participants() : async [T.SaleParticipant] {
    //     return saleParticipants;
    // };

    // public shared func get_sale_countdown() : async Result.Result<DTO.SaleCountDownDTO, Text> {
    //     let now = Nat64.fromNat(Int.abs(Time.now()));
    //     if (now < saleStartTime) {
    //         let timeRemaining = saleStartTime - now;
    //         let (days, hours, minutes, seconds) = await Utils.convertNanoToTime(timeRemaining);

    //         let result : DTO.SaleCountDownDTO = {
    //             status = "upcoming";
    //             timeRemaining = timeRemaining;
    //             stringTime = Nat.toText(days) # " days, " # Nat.toText(hours) # " hours, " # Nat.toText(minutes) # " minutes, " # Nat.toText(seconds) # " seconds";
    //         };
    //         return #ok(result);

    //     } else if (now < saleEndTime) {
    //         let timeRemaining = saleEndTime - now;
    //         let (days, hours, minutes, seconds) = await Utils.convertNanoToTime(timeRemaining);

    //         let result : DTO.SaleCountDownDTO = {
    //             status = "active";
    //             timeRemaining = timeRemaining;
    //             stringTime = Nat.toText(days) # " days, " # Nat.toText(hours) # " hours, " # Nat.toText(minutes) # " minutes, " # Nat.toText(seconds) # " seconds";
    //         };
    //         return #ok(result);

    //     } else {
    //         let result : DTO.SaleCountDownDTO = {
    //             status = "ended";
    //             timeRemaining = 0;
    //             stringTime = "Sale has ended";
    //         };
    //         return #ok(result);
    //     };

    // };

    // private func setSaleStatus() : async () {
    //     if (Nat64.fromNat(Int.abs(Time.now())) < saleStartTime) {
    //         let duration : Nat64 = saleStartTime - Nat64.fromNat(Int.abs(Time.now()));
    //         ignore Timer.setTimer<system>(
    //             #nanoseconds(Nat64.toNat(duration)),
    //             func() : async () {
    //                 isSaleActive := true;
    //             },
    //         );
    //     };

    //     if (Nat64.fromNat(Int.abs(Time.now())) < saleEndTime) {
    //         let duration : Nat64 = saleEndTime - Nat64.fromNat(Int.abs(Time.now()));
    //         ignore Timer.setTimer<system>(
    //             #nanoseconds(Nat64.toNat(duration)),
    //             func() : async () {
    //                 if (not saleCompleted) {
    //                     await end_sale();
    //                 };

    //                 isSaleActive := false;
    //             },
    //         );
    //     };
    // };

    // system func postupgrade() {
    //     let _ = await setSaleStatus();
    // };

};
