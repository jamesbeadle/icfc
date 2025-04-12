/* ----- Mops Packages ----- */
import Blob "mo:base/Blob";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";
import Debug "mo:base/Debug";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Enums "mo:waterway-mops/Enums";
import BaseTypes "mo:waterway-mops/BaseTypes";
import LeagueQueries "mo:waterway-mops/queries/football-queries/LeagueQueries";
import ClubQueries "mo:waterway-mops/queries/football-queries/ClubQueries";
import Ids "mo:waterway-mops/Ids";
import SNSToken "mo:waterway-mops/sns-wrappers/ledger";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Management "mo:waterway-mops/Management";
import BaseQueries "mo:waterway-mops/queries/BaseQueries";
import CanisterUtilities "mo:waterway-mops/CanisterUtilities";
import Account "mo:waterway-mops/Account";
import CanisterQueries "mo:waterway-mops/canister-management/CanisterQueries";
import CanisterManager "mo:waterway-mops/canister-management/CanisterManager";
import CanisterCommands "mo:waterway-mops/canister-management/CanisterCommands";

/* ----- Canister Definition Files ----- */

import ProfileCanister "canister_definitions/profile-canister";

/* ----- Queries ----- */
import AppQueries "queries/app_queries";
import ProfileQueries "queries/profile_queries";

/* ----- Commands ----- */
import ProfileCommands "commands/profile_commands";

/* ----- Managers ----- */

import ProfileManager "managers/profile_manager";
import FootballChannelManager "managers/football_channel_manager";
import SNSManager "managers/sns_manager";

/* ----- Environment ----- */
import Environment "environment";
import Utilities "utilities/utilities";

actor class Self() = this {

  private let profileManager = ProfileManager.ProfileManager();
  private let footballChannelManager = FootballChannelManager.FootballChannelManager();
  private let snsManager = SNSManager.SNSManager();
  private let canisterManager = CanisterManager.CanisterManager();

  private var appStatus : BaseTypes.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };

  public shared query func getAppStatus() : async Result.Result<AppQueries.AppStatus, Enums.Error> {
    return #ok(appStatus);
  };

  //Profile Queries

  public shared ({ caller }) func getProfile() : async Result.Result<ProfileQueries.ProfileDTO, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let dto : ProfileQueries.GetProfile = {
      principalId = Principal.toText(caller);
    };
    return await profileManager.getProfile(dto);
  };

  public shared query ({ caller }) func isUsernameValid(dto : ProfileQueries.IsUsernameValid) : async Bool {
    assert not Principal.isAnonymous(caller);
    let usernameValid = Utilities.isUsernameValid(dto.username);
    let usernameTaken = profileManager.isUsernameTaken(dto.username, Principal.toText(caller));
    return usernameValid and not usernameTaken;
  };

  public shared ({ caller }) func getUserNeurons() : async Result.Result<ProfileQueries.UserNeuronsDTO, Enums.Error> {
    assert not Principal.isAnonymous(caller);

    let neurons = await snsManager.getUsersNeurons(caller);
    let userEligibility : ProfileQueries.EligibleMembership = Utilities.getMembershipType(neurons);
    let isValidNeurons = profileManager.validNeurons(userEligibility.eligibleNeuronIds, Principal.toText(caller));

    if (not isValidNeurons) {
      let dto : ProfileQueries.UserNeuronsDTO = {
        userNeurons = [];
        totalMaxStaked = 0;
        userMembershipEligibility = {
          membershipType = #NotEligible;
          eligibleNeuronIds = [];
        };
      };
      return #ok(dto);
    };

    let totalMaxStaked = Utilities.getTotalMaxStaked(neurons);
    let result : ProfileQueries.UserNeuronsDTO = {
      userNeurons = neurons;
      totalMaxStaked;
      userMembershipEligibility = userEligibility;
    };
    return #ok(result);

  };

  //Profile Commands

  public shared ({ caller }) func createProfile(dto : ProfileCommands.CreateProfile) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);

    // let neurons = await snsManager.getUsersNeurons(caller);
    // let userEligibility : ProfileCommands.EligibleMembership = Utilities.getMembershipType(neurons);
    let userEligibility : ProfileQueries.EligibleMembership = {
      membershipType = #Lifetime;
      eligibleNeuronIds = [];
    };

    return await profileManager.createProfile(principalId, dto, userEligibility);
  };

  public shared ({ caller }) func claimMembership() : async Result.Result<(ProfileCommands.MembershipClaim), Enums.Error> {
    assert not Principal.isAnonymous(caller);

    let principalId = Principal.toText(caller);
    return await profileManager.claimMembership(principalId);
  };

  public shared ({ caller }) func addSubApp(dto : ProfileCommands.AddSubApp) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return await profileManager.addSubApp(Principal.toText(caller), dto);
  };

  public shared ({ caller }) func removeSubApp(subApp : ProfileCommands.SubApp) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return await profileManager.removeSubApp(Principal.toText(caller), subApp);
  };

  public shared ({ caller }) func verifySubApp(dto : ProfileCommands.VerifySubApp) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Utilities.isSubApp(Principal.toText(caller));
    return await profileManager.verifySubApp(dto);
  };

  public shared ({ caller }) func updateUsername(dto : ProfileCommands.UpdateUserName) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateUsername(principalId, dto);
  };

  public shared ({ caller }) func updateDisplayName(dto : ProfileCommands.UpdateDisplayName) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateDisplayName(principalId, dto);
  };

  public shared ({ caller }) func updateNationality(dto : ProfileCommands.UpdateNationality) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateNationality(principalId, dto);
  };

  public shared ({ caller }) func updateFavouriteClub(dto : ProfileCommands.UpdateFavouriteClub) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateFavouriteClub(principalId, dto);
  };

  public shared ({ caller }) func updateProfilePicture(dto : ProfileCommands.UpdateProfilePicture) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    return await profileManager.updateProfilePicture(principalId, dto);
  };

  public shared ({ caller }) func getTokenBalances() : async Result.Result<AppQueries.TokenBalances, Enums.Error> {
    assert not Principal.isAnonymous(caller);

    let icfc_ledger : SNSToken.Interface = actor (CanisterIds.ICFC_SNS_LEDGER_CANISTER_ID);
    let ckBTC_ledger : SNSToken.Interface = actor (Environment.CKBTC_LEDGER_CANISTER_ID);
    let icp_ledger : SNSToken.Interface = actor (CanisterIds.NNS_LEDGER_CANISTER_ID);

    let icfc_tokens = await icfc_ledger.icrc1_balance_of({
      owner = Principal.fromText(CanisterIds.ICFC_BACKEND_CANISTER_ID);
      subaccount = null;
    });
    let ckBTC_tokens = await ckBTC_ledger.icrc1_balance_of({
      owner = Principal.fromText(CanisterIds.ICFC_BACKEND_CANISTER_ID);
      subaccount = null;
    });
    let icp_tokens = await icp_ledger.icrc1_balance_of({
      owner = Principal.fromText(CanisterIds.ICFC_BACKEND_CANISTER_ID);
      subaccount = null;
    });

    return #ok({
      ckBTCBalance = ckBTC_tokens;
      icfcBalance = icfc_tokens;
      icpBalance = icp_tokens;
      icgcBalance = 0; // TODO after ICGC SNS
    });
  };

  public shared ({ caller }) func getICPBalance(user_principal : Ids.PrincipalId) : async Result.Result<Nat, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == Environment.ICFC_SALE_2_CANISTER_ID;

    let icp_ledger : SNSToken.Interface = actor (CanisterIds.NNS_LEDGER_CANISTER_ID);
    let icp_tokens = await icp_ledger.icrc1_balance_of({
      owner = Principal.fromText(CanisterIds.ICFC_BACKEND_CANISTER_ID);
      subaccount = ?Account.principalToSubaccount(Principal.fromText(user_principal));
    });

    return #ok(icp_tokens);
  };

  public shared ({ caller }) func completeICFCPackPurchase(user_principal : Ids.PrincipalId, amount : Nat) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == Environment.ICFC_SALE_2_CANISTER_ID;

    let icp_ledger : SNSToken.Interface = actor (CanisterIds.NNS_LEDGER_CANISTER_ID);

    let res = await icp_ledger.icrc1_transfer({
      to = {
        owner = Principal.fromText(CanisterIds.ICFC_BACKEND_CANISTER_ID);
        subaccount = null;
      };
      from_subaccount = ?Account.principalToSubaccount(Principal.fromText(user_principal));
      amount = amount - 10_000;
      fee = ?10_000;
      memo = ?"0";
      created_at_time = null;
    });

    switch (res) {
      case (#Ok(_)) {
        return #ok(());
      };
      case (#Err(_)) {
        return #err(#FailedInterCanisterCall);
      };
    };
  };

  public shared ({ caller }) func getICFCProfile(dto : ProfileCommands.GetICFCProfile) : async Result.Result<ProfileQueries.ProfileDTO, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Utilities.isSubApp(Principal.toText(caller));
    return await profileManager.getProfile(dto);
  };

  public shared ({ caller }) func getICFCProfileSummary(dto : ProfileCommands.GetICFCProfile) : async Result.Result<ProfileQueries.ICFCProfileSummary, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Utilities.isSubApp(Principal.toText(caller));
    return await profileManager.getICFCProfileSummary(dto);
  };

  /* ----- Calls to Data Canister ----- */

  public shared ({ caller }) func getCountries(dto : BaseQueries.GetCountries) : async Result.Result<BaseQueries.Countries, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // TODO: Check caller is a member

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getCountries : (dto : BaseQueries.GetCountries) -> async Result.Result<BaseQueries.Countries, Enums.Error>;
    };
    let result = await data_canister.getCountries(dto);
    return result;
  };

  public shared ({ caller }) func getLeagues(dto : LeagueQueries.GetLeagues) : async Result.Result<LeagueQueries.Leagues, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // TODO: Check caller is a member

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getLeagues : (dto : LeagueQueries.GetLeagues) -> async Result.Result<LeagueQueries.Leagues, Enums.Error>;
    };
    let result = await data_canister.getLeagues(dto);
    return result;
  };

  /* ----- Calls for Debug ----- */
  public shared ({ caller }) func getProfileCanisterIds() : async [Ids.CanisterId] {
    assert not Principal.isAnonymous(caller);
    return profileManager.getStableUniqueCanisterIds();
  };
  public shared ({ caller }) func getProfileCanisterIndex() : async [(Ids.PrincipalId, Ids.CanisterId)] {
    assert not Principal.isAnonymous(caller);
    return profileManager.getStableCanisterIndex();
  };

  public shared ({ caller }) func getClubs(dto : ClubQueries.GetClubs) : async Result.Result<ClubQueries.Clubs, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // TODO: Check caller is a member

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getClubs : (dto : ClubQueries.GetClubs) -> async Result.Result<ClubQueries.Clubs, Enums.Error>;
    };
    return await data_canister.getClubs(dto);
  };

  // public shared ({ caller }) func getCountries(dto : AppQueries.GetCountries) : async Result.Result<AppQueries.Countries, Enums.Error> {
  //   assert not Principal.isAnonymous(caller);
  //   // TODO: Check caller is a member

  //   let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
  //     getCountries : (dto : AppQueries.GetCountries) -> async Result.Result<AppQueries.Countries, Enums.Error>;
  //   };
  //   return await data_canister.getCountries(dto);
  // };

  // Stable Storage & System Functions:
  private stable var stable_profile_canister_index : [(Ids.PrincipalId, Ids.CanisterId)] = [];
  private stable var stable_active_profile_canister_id : Ids.CanisterId = "";
  private stable var stable_usernames : [(Ids.PrincipalId, Text)] = [];
  private stable var stable_unique_profile_canister_ids : [Ids.CanisterId] = [];
  private stable var stable_total_profile : Nat = 0;
  private stable var stable_neurons_used_for_membership : [(Blob, Ids.PrincipalId)] = [];

  private stable var stable_podcast_channel_canister_index : [(Ids.FootballChannelId, Ids.CanisterId)] = [];
  private stable var stable_active_podcast_channel_canister_id : Ids.CanisterId = "";
  private stable var stable_podcast_channel_names : [(Ids.FootballChannelId, Text)] = [];
  private stable var stable_unique_podcast_channel_canister_ids : [Ids.CanisterId] = [];
  private stable var stable_total_podcast_channels : Nat = 0;
  private stable var stable_next_podcast_channel_id : Nat = 0;

  private stable var stable_membership_timer_id : Nat = 0;

  //System Backup and Upgrade Functions:

  system func preupgrade() {
    backupProfileData();
    backupFootballChannelData();

    // stop membership timer
    if (stable_membership_timer_id != 0) {
      Timer.cancelTimer(stable_membership_timer_id);
    };
  };

  system func postupgrade() {
    setProfileData();
    setFootballChannelData();
    stable_membership_timer_id := Timer.recurringTimer<system>(#seconds(86_400), checkMembership);
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };

  public shared func getCanisterIds() : async [Ids.CanisterId] {
    return profileManager.getStableUniqueCanisterIds();
  };

  // public shared func deleteCanister() : async () {
  //   let IC : Management.Management = actor (CanisterIds.Default);
  //   let result1 = await IC.stop_canister({
  //     canister_id = Principal.fromText("a25ax-gaaaa-aaaal-qslsa-cai");
  //   });
  //   let result2 = await IC.delete_canister({
  //     canister_id = Principal.fromText("a25ax-gaaaa-aaaal-qslsa-cai");
  //   });

  //   Debug.print(debug_show result1);
  //   Debug.print(debug_show result2);
  // };

  private func postUpgradeCallback() : async () {
    // await updateProfileCanisterWasms();
    /*

    let result1 = await IC.stop_canister({
      canister_id = Principal.fromText("a25ax-gaaaa-aaaal-qslsa-cai");
    });
    let result2 = await IC.delete_canister({
      canister_id = Principal.fromText("a25ax-gaaaa-aaaal-qslsa-cai");
    });

    Debug.print(debug_show result1);
    Debug.print(debug_show result2);

    //

    // stable_unique_profile_canister_ids := Buffer.toArray(unique_Canister_ids);


    let manualProfileCanisterIds : [Ids.CanisterId] = [
      "drlwu-ayaaa-aaaal-qslyq-cai",
      "gnqmr-lqaaa-aaaal-qslha-cai",
      "dyi5i-wqaaa-aaaal-qslza-cai",
      "ai3xo-kqaaa-aaaal-qslra-cai",
      "bfvta-fyaaa-aaaal-qslwq-cai",
      "a25ax-gaaaa-aaaal-qslsa-cai",
    ];

    Debug.print("deleting canisters");
    Debug.print("deleting canisters1");
    await CanisterUtilities.deleteCanister_("ai3xo-kqaaa-aaaal-qslra-cai", IC);
    Debug.print("deleting canisters2");
    await CanisterUtilities.deleteCanister_("bfvta-fyaaa-aaaal-qslwq-cai", IC);
    Debug.print("deleting canisters3");
    await CanisterUtilities.deleteCanister_("drlwu-ayaaa-aaaal-qslyq-cai", IC);
    Debug.print("deleting canisters4");
    await CanisterUtilities.deleteCanister_("gnqmr-lqaaa-aaaal-qslha-cai", IC);
    */
  };

  private func backupProfileData() {
    stable_profile_canister_index := profileManager.getStableCanisterIndex();
    stable_active_profile_canister_id := profileManager.getStableActiveCanisterId();
    stable_usernames := profileManager.getStableUsernames();
    stable_unique_profile_canister_ids := profileManager.getStableUniqueCanisterIds();
    stable_total_profile := profileManager.getStableTotalProfiles();
    stable_neurons_used_for_membership := profileManager.getStableNeuronsUsedforMembership();

  };

  private func backupFootballChannelData() {
    stable_podcast_channel_canister_index := footballChannelManager.getStableCanisterIndex();
    stable_active_podcast_channel_canister_id := footballChannelManager.getStableActiveCanisterId();
    stable_podcast_channel_names := footballChannelManager.getStableFootballChannelNames();
    stable_unique_podcast_channel_canister_ids := footballChannelManager.getStableUniqueCanisterIds();
    stable_total_podcast_channels := footballChannelManager.getStableTotalFootballChannels();
    stable_next_podcast_channel_id := footballChannelManager.getStableNextFootballChannelId();

  };

  private func setProfileData() {
    profileManager.setStableCanisterIndex(stable_profile_canister_index);
    profileManager.setStableActiveCanisterId(stable_active_profile_canister_id);
    profileManager.setStableUsernames(stable_usernames);
    profileManager.setStableUniqueCanisterIds(stable_unique_profile_canister_ids);
    profileManager.setStableTotalProfiles(stable_total_profile);
    profileManager.setStableNeuronsUsedforMembership(stable_neurons_used_for_membership);
  };

  private func setFootballChannelData() {
    footballChannelManager.setStableCanisterIndex(stable_podcast_channel_canister_index);
    footballChannelManager.setStableActiveCanisterId(stable_active_podcast_channel_canister_id);
    footballChannelManager.setStableFootballChannelNames(stable_podcast_channel_names);
    footballChannelManager.setStableUniqueCanisterIds(stable_unique_podcast_channel_canister_ids);
    footballChannelManager.setStableTotalFootballChannels(stable_total_podcast_channels);
    footballChannelManager.setStableNextFootballChannelId(stable_next_podcast_channel_id);
  };

  private func updateProfileCanisterWasms() : async () {
    let profileCanisterIds = profileManager.getStableUniqueCanisterIds();
    let IC : Management.Management = actor (CanisterIds.Default);
    for (canisterId in Iter.fromArray(profileCanisterIds)) {
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId) });
      let oldCanister = actor (canisterId) : actor {};
      let _ = await (system ProfileCanister._ProfileCanister)(#upgrade oldCanister)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId) });
    };
  };

  private func reinstallProfileCanisterWasms() : async () {
    let profileCanisterIds = profileManager.getStableUniqueCanisterIds();
    let IC : Management.Management = actor (CanisterIds.Default);
    for (canisterId in Iter.fromArray(profileCanisterIds)) {
      await IC.stop_canister({ canister_id = Principal.fromText(canisterId) });
      let oldCanister = actor (canisterId) : actor {};
      let _ = await (system ProfileCanister._ProfileCanister)(#reinstall oldCanister)();
      await IC.start_canister({ canister_id = Principal.fromText(canisterId) });
    };
  };

  // call_backs for profile_canister
  public shared ({ caller }) func removeNeuronsforExpiredMembership(pofile_principal : Ids.PrincipalId) : async () {
    assert profileManager.isProfileCanister(Principal.toText(caller));
    await profileManager.removeNeuronsforExpiredMembership(pofile_principal);
  };

  private func checkMembership() : async () {
    await profileManager.checkMemberships();
  };

  //functions for WWL backend to communicate
  public shared ({ caller }) func getProjectCanisters() : async Result.Result<CanisterQueries.ProjectCanisters, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;

    var projectCanisters : [CanisterQueries.CanisterInfo] = [];

    // profile canisters
    let profileCanisterIds = profileManager.getStableUniqueCanisterIds();
    for (canisterId in Iter.fromArray(profileCanisterIds)) {
      let dto : CanisterQueries.GetCanisterInfo = {
        canisterId = canisterId;
        canisterType = #Dynamic;
        canisterName = "Profile Canister";
      };
      let result = await canisterManager.getCanisterInfo(dto, #ICFC);
      switch (result) {
        case (#ok(canisterInfo)) {
          projectCanisters := Array.append<CanisterQueries.CanisterInfo>(projectCanisters, [canisterInfo]);
        };
        case (#err(_)) {};
      };
    };

    // backend canister
    var backend_dto : CanisterQueries.GetCanisterInfo = {
      // canisterId = CanisterIds.ICFC_BACKEND_CANISTER_ID;
      canisterId = "bkyz2-fmaaa-aaaaa-qaaaq-cai";
      canisterType = #Static;
      canisterName = "ICFC Backend Canister";
    };
    let result = await canisterManager.getCanisterInfo(backend_dto, #ICFC);
    switch (result) {
      case (#ok(canisterInfo)) {
        projectCanisters := Array.append<CanisterQueries.CanisterInfo>(projectCanisters, [canisterInfo]);
      };
      case (#err(_)) {};
    };

    // frontend canister
    // let frontend_dto : WWLCanisterQueries.GetCanisterInfo = {
    //   canisterId = CanisterIds.ICFC_FRONTEND_CANISTER_ID;
    //   canisterType = #Static;
    //   canisterName = "ICFC Frontend Canister";
    // };
    // let result2 = await wwlCanisterManager.getCanisterInfo(frontend_dto);
    // switch (result2) {
    //   case (#ok(canisterInfo)) {
    //     projectCanisters := Array.append<WWLCanisterQueries.CanisterInfo>(projectCanisters, [canisterInfo]);
    //   };
    //   case (#err(_)) {};
    // };

    // sale canister
    let saleCanister = actor ("bd3sg-teaaa-aaaaa-qaaba-cai") : actor {
      getCanisterInfo : () -> async Result.Result<CanisterQueries.CanisterInfo, Enums.Error>;
    };
    let result3 = await saleCanister.getCanisterInfo();
    switch (result3) {
      case (#ok(canisterInfo)) {
        projectCanisters := Array.append<CanisterQueries.CanisterInfo>(projectCanisters, [canisterInfo]);
      };
      case (#err(_)) {};
    };

    let res : CanisterQueries.ProjectCanisters = {
      entries = projectCanisters;
    };
    return #ok(res);
  };

  public shared ({ caller }) func addController(dto : CanisterCommands.AddController) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.addController(dto);
    return result;
  };
  public shared ({ caller }) func removeController(dto : CanisterCommands.RemoveController) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.removeController(dto);
    return result;
  };

};
