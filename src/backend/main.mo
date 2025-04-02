/* ----- Mops Packages ----- */
import Blob "mo:base/Blob";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";
import Enums "mo:waterway-mops/Enums";
import BaseTypes "mo:waterway-mops/BaseTypes";
import LeagueQueries "mo:waterway-mops/queries/football-queries/LeagueQueries";
import ClubQueries "mo:waterway-mops/queries/football-queries/ClubQueries";
import Ids "mo:waterway-mops/Ids";
import SNSToken "mo:waterway-mops/sns-wrappers/ledger";
import CanisterIds "mo:waterway-mops/CanisterIds";
import Management "mo:waterway-mops/Management";
import BaseQueries "mo:waterway-mops/queries/BaseQueries";
import Account "mo:waterway-mops/Account";

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
    let dto : ProfileCommands.GetProfile = {
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

    let neurons = await snsManager.getUsersNeurons(caller);
    let userEligibility : ProfileCommands.EligibleMembership = Utilities.getMembershipType(neurons);

    return await profileManager.createProfile(principalId, dto, userEligibility);
  };

  public shared ({ caller }) func claimMembership() : async Result.Result<(ProfileCommands.MembershipClaim), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let dto : ProfileCommands.ClaimMembership = {
      principalId = Principal.toText(caller);
    };
    return await profileManager.claimMembership(dto);
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
    assert dto.principalId == Principal.toText(caller);
    return await profileManager.updateUsername(dto);
  };

  public shared ({ caller }) func updateDisplayName(dto : ProfileCommands.UpdateDisplayName) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert dto.principalId == Principal.toText(caller);
    return await profileManager.updateDisplayName(dto);
  };

  public shared ({ caller }) func updateNationality(dto : ProfileCommands.UpdateNationality) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert dto.principalId == Principal.toText(caller);
    return await profileManager.updateNationality(dto);
  };

  public shared ({ caller }) func updateFavouriteClub(dto : ProfileCommands.UpdateFavouriteClub) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert dto.principalId == Principal.toText(caller);
    return await profileManager.updateFavouriteClub(dto);
  };

  public shared ({ caller }) func updateProfilePicture(dto : ProfileCommands.UpdateProfilePicture) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert dto.principalId == Principal.toText(caller);
    return await profileManager.updateProfilePicture(dto);
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
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
    /*
    setProfileData();
    setFootballChannelData();
    stable_membership_timer_id := Timer.recurringTimer<system>(#seconds(86_400), checkMembership);
    */
  };

  private func postUpgradeCallback() : async () {
    await updateProfileCanisterWasms();
    /*
    profileManager.setStableCanisterIndex([]);
    profileManager.setStableUsernames([]);
    profileManager.setStableTotalProfiles(0);
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

  // call_backs for profile_canister
  public shared ({ caller }) func removeNeuronsforExpiredMembership(pofile_principal : Ids.PrincipalId) : async () {
    assert profileManager.isProfileCanister(Principal.toText(caller));
    await profileManager.removeNeuronsforExpiredMembership(pofile_principal);
  };

  private func checkMembership() : async () {
    await profileManager.checkMemberships();
  };

  //functions for WWL backend to communicate
  // public shared ({ caller }) getCanistersInfo() : async Result.Result<ProfileQueries.CanisterInfo, Enums.Error> {
  /* assert not Principal.isAnonymous(caller); */
  /* let canisterId = Principal.toText(caller); */
  /* let canisterInfo = profileManager.getCanisterInfo(canisterId); */
  /* return #ok(canisterInfo); */
  // };

};
