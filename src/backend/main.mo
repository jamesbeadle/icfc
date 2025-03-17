import Base "mo:waterway-mops/BaseTypes";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Option "mo:base/Option";
import Text "mo:base/Text";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Timer "mo:base/Timer";
import T "icfc_types";
import Environment "environment";
import DTOs "./dtos/dtos";
import ProfileManager "managers/profile_manager";
import ProfileCommands "commands/profile_commands";
import PodcastManager "managers/podcast_manager";
import ProfileQueries "queries/profile_queries";
import SNSManager "managers/sns_manager";
import SNSGovernance "./sns-wrappers/governance";

actor class Self() = this {

  private let profileManager = ProfileManager.ProfileManager();
  private let podcastChannelManager = PodcastManager.PodcastManager();
  private let snsManager = SNSManager.SNSManager();

  private var appStatus : Base.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };

  public shared query func get_app_status() : async Result.Result<DTOs.AppStatusDTO, T.Error> {
    return #ok(appStatus);
  };

  //Profile Queries

  public shared ({ caller }) func getProfile() : async Result.Result<ProfileQueries.Profile, T.Error> {
    assert not Principal.isAnonymous(caller);
    let dto : ProfileQueries.GetProfile = {
      principalId = Principal.toText(caller);
    };
    return await profileManager.getProfile(dto);
  };

  public shared ({ caller }) func getUserNeurons() : async Result.Result<[SNSGovernance.Neuron], T.Error> {
    assert not Principal.isAnonymous(caller);

    let dto : ProfileQueries.GetProfile = {
      principalId = Principal.toText(caller);
    };
    let profile = await profileManager.getProfile(dto);
    switch (profile) {
      case (#err(e)) return #err(e);
      case (#ok(_)) {};
    };

    let neurons = await snsManager.getUsersNeurons(caller);
    return #ok(neurons);
  };

  //Profile Commands
  public shared ({ caller }) func createProfile(dto : ProfileCommands.CreateProfile) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.createProfile(principalId, dto);
  };

  public shared ({ caller }) func claimMembership() : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    let dto : ProfileCommands.ClaimMembership = {
      principalId = Principal.toText(caller);
    };
    return await profileManager.claimMembership(dto);
  };

  public shared ({ caller }) func updateUsername(dto : ProfileCommands.UpdateUserName) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert dto.principalId == Principal.toText(caller);
    return await profileManager.updateUsername(dto);
  };

  public shared ({ caller }) func updateDisplayName(dto : ProfileCommands.UpdateDisplayName) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert dto.principalId == Principal.toText(caller);
    return await profileManager.updateDisplayName(dto);
  };

  public shared ({ caller }) func updateProfilePicture(dto : ProfileCommands.UpdateProfilePicture) : async Result.Result<(), T.Error> {
    assert not Principal.isAnonymous(caller);
    assert dto.principalId == Principal.toText(caller);
    return await profileManager.updateProfilePicture(dto);
  };

  // Stable Storage & System Functions:
  private stable var stable_profile_canister_index : [(Base.PrincipalId, Base.CanisterId)] = [];
  private stable var stable_active_profile_canister_id : Base.CanisterId = "";
  private stable var stable_usernames : [(Base.PrincipalId, Text)] = [];
  private stable var stable_unique_profile_canister_ids : [Base.CanisterId] = [];
  private stable var stable_total_profile : Nat = 0;

  private stable var stable_podcast_channel_canister_index : [(T.PodcastChannelId, Base.CanisterId)] = [];
  private stable var stable_active_podcast_channel_canister_id : Base.CanisterId = "";
  private stable var stable_podcast_channel_names : [(T.PodcastChannelId, Text)] = [];
  private stable var stable_unique_podcast_channel_canister_ids : [Base.CanisterId] = [];
  private stable var stable_total_podcast_channels : Nat = 0;
  private stable var stable_next_podcast_channel_id : Nat = 0;

  //System Backup and Upgrade Functions:

  system func preupgrade() {
    backupProfileData();
    backupPodcastChannelData();
  };

  system func postupgrade() {
    setProfileData();
    setPodcastChannelData();
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  private func postUpgradeCallback() : async () {
    await profileManager.createMembershipExpiredTimers();
  };

  private func backupProfileData() {
    stable_profile_canister_index := profileManager.getStableCanisterIndex();
    stable_active_profile_canister_id := profileManager.getStableActiveCanisterId();
    stable_usernames := profileManager.getStableUsernames();
    stable_unique_profile_canister_ids := profileManager.getStableUniqueCanisterIds();
    stable_total_profile := profileManager.getStableTotalProfiles();
  };

  private func backupPodcastChannelData() {
    stable_podcast_channel_canister_index := podcastChannelManager.getStableCanisterIndex();
    stable_active_podcast_channel_canister_id := podcastChannelManager.getStableActiveCanisterId();
    stable_podcast_channel_names := podcastChannelManager.getStablePodcastChannelNames();
    stable_unique_podcast_channel_canister_ids := podcastChannelManager.getStableUniqueCanisterIds();
    stable_total_podcast_channels := podcastChannelManager.getStableTotalPodcastChannels();
    stable_next_podcast_channel_id := podcastChannelManager.getStableNextPodcastChannelId();

  };

  private func setProfileData() {
    profileManager.setStableCanisterIndex(stable_profile_canister_index);
    profileManager.setStableActiveCanisterId(stable_active_profile_canister_id);
    profileManager.setStableUsernames(stable_usernames);
    profileManager.setStableUniqueCanisterIds(stable_unique_profile_canister_ids);
    profileManager.setStableTotalProfiles(stable_total_profile);
  };

  private func setPodcastChannelData() {
    podcastChannelManager.setStableCanisterIndex(stable_podcast_channel_canister_index);
    podcastChannelManager.setStableActiveCanisterId(stable_active_podcast_channel_canister_id);
    podcastChannelManager.setStablePodcastChannelNames(stable_podcast_channel_names);
    podcastChannelManager.setStableUniqueCanisterIds(stable_unique_podcast_channel_canister_ids);
    podcastChannelManager.setStableTotalPodcastChannels(stable_total_podcast_channels);
    podcastChannelManager.setStableNextPodcastChannelId(stable_next_podcast_channel_id);
  };

  /* Below is code related to a second sale */

  // private let podcast

  private var saleStartTime : Nat64 = Environment.SALE_START;
  private var saleEndTime : Nat64 = Environment.SALE_END;

  private stable var saleParticipants : [T.SaleParticipant] = [];

  private var min_goal : Nat = Environment.CKBTC_MIN_GOAL * Nat.pow(10, Nat8.toNat(8));
  private var max_goal : Nat = Environment.CKBTC_MAX_GOAL * Nat.pow(10, Nat8.toNat(8));
  private var isSaleActive : Bool = (Nat64.fromNat(Int.abs(Time.now())) >= saleStartTime and Nat64.fromNat(Int.abs(Time.now())) < saleEndTime);
  private stable var ckBTCRaised : Nat = 0;

  private type Subaccount = Blob;
  private var icfcExchange : Nat = 400; //400 ckSatoshis per ICFC

  private func caller_allowed(caller : Principal) : Bool {
    let foundCaller = Array.find<Base.PrincipalId>(
      Environment.ADMIN_PRINCIPALS,
      func(canisterId : Base.CanisterId) : Bool {
        Principal.toText(caller) == canisterId;
      },
    );
    return Option.isSome(foundCaller);
  };

  // SNS Sale ckBTC Functions
  /*
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
    let saleProgress = ckBTCRaised;
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

  public query func get_goal() : async Result.Result<DTOs.SaleGoalDTO, Text> {
    let result : DTOs.SaleGoalDTO = {
      minGoal = min_goal;
      maxGoal = max_goal;
      currentProgress = ckBTCRaised;
    };
    return #ok(result);
  };

  public shared ({ caller }) func get_user_ckBTC_balance() : async Nat {
    assert not Principal.isAnonymous(caller);
    await ckBTCLedger.icrc1_balance_of({
      owner = Principal.fromActor(this);
      subaccount = ?Account.principalToSubaccount(caller);
    });
  };

  public shared ({ caller }) func get_user_sale_contribution() : async [T.SaleParticipant] {
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
  */

  // private func renew_membership(user : Principal, membership : T.MembershipType) : async Result.Result<(T.MembershipClaim), Text> {
  //   let fee = switch membership {
  //     case (#Monthly) { Environment.ICFC_MONTHLY_MEMBERSHIP_FEE };
  //     case (#Annual) { Environment.ICFC_ANNUAL_MEMBERSHIP_FEE };
  //     case (#Lifetime) { Environment.ICFC_LIFETIME_MEMBERSHIP_FEE };
  //     case (_) { return #err("Invalid membership type") };
  //   };

  //   // TODO: Check ICFC stacked by user
  //   let eligibleUser = true;

  //   let userProfile = Array.find(
  //     profiles,
  //     func(profile : T.Profile) : Bool {
  //       profile.principalId == Principal.toText(user);
  //     },
  //   );

  //   let now = Time.now();

  //   let claim : T.MembershipClaim = if (eligibleUser) {
  //     {
  //       membershipType = membership;
  //       claimedOn = now;
  //       expiresOn = switch membership {
  //         case (#Monthly) {
  //           ?(now + 30 * 24 * 60 * 60);
  //         };
  //         case (#Annual) {
  //           ?(now + 365 * 24 * 60 * 60);
  //         };
  //         case (#Lifetime) { null };
  //         case (_) { null };
  //       };
  //     };
  //   } else {
  //     {
  //       membershipType = #Expired;
  //       claimedOn = now;
  //       expiresOn = null;
  //     };
  //   };

  //   switch (userProfile) {
  //     case (?profile) {
  //       switch (profile.membershipTimerId) {
  //         case (?id) { Timer.cancelTimer(id) };
  //         case (null) {};
  //       };

  //       let membershipBuffer = Buffer.fromArray<T.MembershipClaim>(profile.membershipClaims);
  //       membershipBuffer.add(claim);
  //       let updatedProfile = {
  //         profile with
  //         membershipClaims = Buffer.toArray(membershipBuffer);
  //         membershipType = if (eligibleUser) membership else #Expired;
  //         membershipTimerId = null;
  //       };

  //       let updatedProfiles = Array.map<T.Profile, T.Profile>(
  //         profiles,
  //         func(p : T.Profile) : T.Profile {
  //           if (p.principalId == Principal.toText(user)) updatedProfile else p;
  //         },
  //       );
  //       profiles := updatedProfiles;

  //       switch (claim.expiresOn) {
  //         case (?exp) {
  //           if (exp > now) {
  //             let delay = (exp - now) / 1_000_000_000;
  //             let timerId = Timer.setTimer<system>(
  //               #seconds(Int.abs(delay)),
  //               func() : async () {
  //                 let _ = await renew_membership(user, membership);
  //               },
  //             );

  //             let updatedUserProfile = Array.find<T.Profile>(
  //               profiles,
  //               func(p) { p.principalId == Principal.toText(user) },
  //             );
  //             switch (updatedUserProfile) {
  //               case (?up) {
  //                 let updatedProfiles = Array.map<T.Profile, T.Profile>(
  //                   profiles,
  //                   func(p : T.Profile) : T.Profile {
  //                     if (p.principalId == Principal.toText(user)) {
  //                       { up with membershipTimerId = ?timerId };
  //                     } else {
  //                       p;
  //                     };
  //                   },
  //                 );
  //                 profiles := updatedProfiles;
  //               };
  //               case (null) {};
  //             };
  //           };
  //         };
  //         case (null) { /* No timer for lifetime or expired memberships */ };
  //       };

  //       #ok(claim);
  //     };
  //     case (null) {
  //       #err("User profile not found");
  //     };
  //   };
  // };

  // public shared ({caller}) func create_podcast_group()
};
