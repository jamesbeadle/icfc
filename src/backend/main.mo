
/* ----- Mops Packages ----- */

import Blob "mo:base/Blob";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Timer "mo:base/Timer";
import Array "mo:base/Array";


/* ----- WWL Mops Packages ----- */

import Account "mo:waterway-mops/base/def/account";
import BaseQueries "mo:waterway-mops/base/queries";
import BaseTypes "mo:waterway-mops/base/types";
import CanisterIds "mo:waterway-mops/product/wwl/canister-ids";
import CanisterCommands "mo:waterway-mops/product/wwl/canister-management/commands";
import CanisterManager "mo:waterway-mops/product/wwl/canister-management/manager";
import CanisterQueries "mo:waterway-mops/product/wwl/canister-management/queries";
import Countries "mo:waterway-mops/base/countries";
import Enums "mo:waterway-mops/base/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import Ids "mo:waterway-mops/base/ids";
import InterAppCallCommands "mo:waterway-mops/product/icfc/inter-app-call-commands";
import ICFCQueries "mo:waterway-mops/product/icfc/queries";
import Management "mo:waterway-mops/base/def/management";
import SNSToken "mo:waterway-mops/base/def/sns-wrappers/ledger";


/* ----- Data Canister Queries ----- */

import SeasonQueries "mo:waterway-mops/product/icfc/data-canister-queries/season-queries";
import ClubQueries "mo:waterway-mops/product/icfc/data-canister-queries/club-queries";
import FixtureQueries "mo:waterway-mops/product/icfc/data-canister-queries/fixture-queries";
import LeagueQueries "mo:waterway-mops/product/icfc/data-canister-queries/league-queries";
import PlayerQueries "mo:waterway-mops/product/icfc/data-canister-queries/player-queries";


/* ----- Canister Definition Files ----- */

import ProfileCanister "canister-definitions/profile-canister";


/* ----- Queries ----- */
import ProfileQueries "queries/profile-queries";
import PayoutQueries "queries/payout-queries";


/* ----- Commands ----- */

import ProfileCommands "commands/profile-commands";
import PayoutCommands "commands/payout-commands";


/* ----- Managers ----- */

import LeaderboardPayoutManager "managers/leaderboard-payout-manager";
import ProfileManager "managers/profile-manager";
import FootballChannelManager "managers/football-channel-manager";


/* ----- Local Types, Environment and Utilities ----- */

import AppTypes "./types";
import AppIds "./ids";
import Environment "environment";
import Utilities "utilities/utilities";
import PrizePoolQueries "queries/prize-pool-queries";


actor class Self() = this {

  /* ----- Stable Canister Variables ----- */

  private stable var stable_profile_canister_index : [(Ids.PrincipalId, Ids.CanisterId)] = [];
  private stable var stable_active_profile_canister_id : Ids.CanisterId = "";
  private stable var stable_usernames : [(Ids.PrincipalId, Text)] = [];
  private stable var stable_unique_profile_canister_ids : [Ids.CanisterId] = [];
  private stable var stable_total_profile : Nat = 0;
  
  private stable var stable_channel_canister_index : [(AppIds.FootballChannelId, Ids.CanisterId)] = [];
  private stable var stable_active_channel_canister_id : Ids.CanisterId = "";
  private stable var stable_channel_names : [(AppIds.FootballChannelId, Text)] = [];
  private stable var stable_unique_channel_canister_ids : [Ids.CanisterId] = [];
  private stable var stable_total_channels : Nat = 0;
  private stable var stable_next_channel_id : Nat = 0;

  private stable var stable_leaderboard_payout_requests : [AppTypes.PayoutRequest] = [];

  private stable var stable_subscription_timer_id : Nat = 0;


    //is this not renew subscription? make it just add a year to the time and can be at any point
    //provided subscription time is < 3 months


  /* ----- Domain Object Managers ----- */

  private let profileManager = ProfileManager.ProfileManager();
  private let footballChannelManager = FootballChannelManager.FootballChannelManager();
  private let canisterManager = CanisterManager.CanisterManager();
  private let leaderboardPayoutManager = LeaderboardPayoutManager.LeaderboardPayoutManager();

  private var appStatus : BaseTypes.AppStatus = {
    onHold = false;
    version = "0.0.1";
  };


  /* ----- App Queries ----- */

  public shared query func getAppStatus() : async Result.Result<BaseQueries.AppStatus, Enums.Error> {
    return #ok(appStatus);
  };


  /* ----- Profile Queries ----- */

  public shared ({ caller }) func getProfile() : async Result.Result<ProfileQueries.Profile, Enums.Error> {
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


  /* ----- Profile Commands ----- */

  public shared ({ caller }) func createProfile(dto : ProfileCommands.CreateProfile) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);


        return #err(#NotAllowed);

/* TODO
    let subscription = await subscriptionManager.getUserSubscription(principalId);
    switch(subscription){
      case (?foundSubscription){
        return await profileManager.createProfile(principalId, dto, foundSubscription);
      };
      case (null){
        return #err(#NotAllowed);
      }
    };
    */
  };





  public shared ({ caller }) func addSubApp(dto : ProfileCommands.AddSubApp) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return await profileManager.addSubApp(Principal.toText(caller), dto);
  };

  public shared ({ caller }) func removeSubApp(dto : ProfileCommands.RemoveSubApp) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return await profileManager.removeSubApp(Principal.toText(caller), dto.subApp);
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







  public shared ({ caller }) func getPrizePool(dto: PrizePoolQueries.GetPrizePool) : async Result.Result<PrizePoolQueries.PrizePool, Enums.Error> {
    assert not Principal.isAnonymous(caller);

    let ckBTC_ledger : SNSToken.Interface = actor (Environment.CKBTC_LEDGER_CANISTER_ID);

    let ckBTC_tokens = await ckBTC_ledger.icrc1_balance_of({
      owner = Principal.fromText(CanisterIds.ICFC_BACKEND_CANISTER_ID);
      subaccount = null;
    });

    return #ok({
      ckBTCTokens = ckBTC_tokens;
    });
  };






  public shared ({ caller }) func getICFCProfile(dto : ProfileQueries.GetProfile) : async Result.Result<ProfileQueries.Profile, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Utilities.isSubApp(Principal.toText(caller));
    return await profileManager.getProfile(dto);
  };

  /* ----- Calls to Data Canister ----- */

  public shared ({ caller }) func getCountries(_ : BaseQueries.GetCountries) : async Result.Result<BaseQueries.Countries, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return #ok({
      countries = Countries.countries;
    });
  };

  public shared ({ caller }) func getLeagues(dto : LeagueQueries.GetLeagues) : async Result.Result<LeagueQueries.Leagues, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // TODO: Check caller has subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getLeagues : (dto : LeagueQueries.GetLeagues) -> async Result.Result<LeagueQueries.Leagues, Enums.Error>;
    };
    let result = await data_canister.getLeagues(dto);
    return result;
  };

  /* ----- Calls from Applications requesting leaderboard payout ----- */

  public shared ({ caller }) func requestLeaderboardPayout(dto : InterAppCallCommands.LeaderboardPayoutRequest) : async Result.Result<(), Enums.Error> {

    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert Utilities.isValidCanisterId(principalId);

    let res = await leaderboardPayoutManager.addLeaderboardPayoutRequest(dto);
    return res;

  };

  public shared ({ caller }) func getLeaderboardRequests(_ : PayoutQueries.GetPayoutRequests) : async Result.Result<PayoutQueries.PayoutRequests, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await Utilities.callerIsAdmin(principalId);
    let result = leaderboardPayoutManager.getLeaderboardPayoutRequests();
    return #ok({
      requests = result;
      totalRequest = Array.size(result);
    });

  };

  public shared ({ caller }) func payoutLeaderboard(dto : PayoutCommands.PayoutLeaderboard) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert await Utilities.callerIsAdmin(principalId);

    let ?appCanisterId = BaseUtilities.getAppCanisterId(dto.app) else {
      return #err(#NotFound);
    };

    let res = await leaderboardPayoutManager.payoutLeaderboard(dto);
    switch (res) {
      case (#ok(paidResult)) {
        var callbackCanister = actor (appCanisterId) : actor {
          leaderboardPaid : (dto : LeaderboardPayoutCommands.CompleteLeaderboardPayout) -> async Result.Result<(), Enums.Error>;
        };
        await callbackCanister.leaderboardPaid({
          seasonId = paidResult.seasonId;
          gameweek = paidResult.gameweek;
          leaderboard = paidResult.leaderboard;
        });
      };
      case (#err(err)) {
        return #err(err);
      };

    };

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


  //System Backup and Upgrade Functions:

  system func preupgrade() {
    backupProfileData();
    backupFootballChannelData();
    backupLeaderboardPayoutRequests();

    // stop subscription timer
    if (stable_subscription_timer_id != 0) {
      Timer.cancelTimer(stable_subscription_timer_id);
    };
  };

  system func postupgrade() {
    setProfileData();
    setFootballChannelData();
    setLeaderboardPayoutRequests();
    stable_subscription_timer_id := Timer.recurringTimer<system>(#seconds(86_400), checkSubscriptions);
    ignore Timer.setTimer<system>(#nanoseconds(Int.abs(1)), postUpgradeCallback);
  };








  public shared func getCanisterIds() : async [Ids.CanisterId] {
    return profileManager.getStableUniqueCanisterIds();
  };

  private func postUpgradeCallback() : async () {
    // await updateProfileCanisterWasms();

    // let currentProfileCanisterIds = ["cjcdx-oyaaa-aaaal-qsl4q-cai"];
    // stable_unique_profile_canister_ids := currentProfileCanisterIds;
    // profileManager.setStableUniqueCanisterIds(stable_unique_profile_canister_ids);

  };

  private func backupLeaderboardPayoutRequests() {
    stable_leaderboard_payout_requests := leaderboardPayoutManager.getStableLeaderboardPayoutRequests();
  };
  private func setLeaderboardPayoutRequests() {
    leaderboardPayoutManager.setStableLeaderboardPayoutRequests(stable_leaderboard_payout_requests);
  };

  private func backupProfileData() {
    stable_profile_canister_index := profileManager.getStableCanisterIndex();
    stable_active_profile_canister_id := profileManager.getStableActiveCanisterId();
    stable_usernames := profileManager.getStableUsernames();
    stable_unique_profile_canister_ids := profileManager.getStableUniqueCanisterIds();
    stable_total_profile := profileManager.getStableTotalProfiles();
  };

  private func backupFootballChannelData() {
    stable_channel_canister_index := footballChannelManager.getStableCanisterIndex();
    stable_active_channel_canister_id := footballChannelManager.getStableActiveCanisterId();
    stable_channel_names := footballChannelManager.getStableFootballChannelNames();
    stable_unique_channel_canister_ids := footballChannelManager.getStableUniqueCanisterIds();
    stable_total_channels := footballChannelManager.getStableTotalFootballChannels();
    stable_next_channel_id := footballChannelManager.getStableNextFootballChannelId();

  };

  private func setProfileData() {
    profileManager.setStableCanisterIndex(stable_profile_canister_index);
    profileManager.setStableActiveCanisterId(stable_active_profile_canister_id);
    profileManager.setStableUsernames(stable_usernames);
    profileManager.setStableUniqueCanisterIds(stable_unique_profile_canister_ids);
    profileManager.setStableTotalProfiles(stable_total_profile);
  };

  private func setFootballChannelData() {
    footballChannelManager.setStableCanisterIndex(stable_channel_canister_index);
    footballChannelManager.setStableActiveCanisterId(stable_active_channel_canister_id);
    footballChannelManager.setStableFootballChannelNames(stable_channel_names);
    footballChannelManager.setStableUniqueCanisterIds(stable_unique_channel_canister_ids);
    footballChannelManager.setStableTotalFootballChannels(stable_total_channels);
    footballChannelManager.setStableNextFootballChannelId(stable_next_channel_id);
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

  // callbacks for profile_canister
 
  private func checkSubscriptions() : async () {
    await profileManager.checkSubscriptions();
  };








  //functions for WWL backend to communicate
  public shared ({ caller }) func getProjectCanisters() : async Result.Result<CanisterQueries.ProjectCanisters, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;

    var projectCanisters : [CanisterQueries.Canister] = [];

    // profile canisters
    let profileCanisterIds = profileManager.getStableUniqueCanisterIds();
    for (canisterId in Iter.fromArray(profileCanisterIds)) {
      let dto : CanisterQueries.Canister = {
        app = #ICFC;
        canisterId = canisterId;
        canisterType = #Dynamic;
        canisterName = "Profile Canister";
      };
      projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [dto]);

    };

    var backend_dto : CanisterQueries.Canister = {
      canisterId = CanisterIds.ICFC_BACKEND_CANISTER_ID;
      canisterType = #Static;
      canisterName = "ICFC Backend Canister";
      app = #ICFC;
    };
    projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [backend_dto]);

    let frontend_dto : CanisterQueries.Canister = {
      canisterId = Environment.ICFC_FRONTEND_CANISTER_ID;
      canisterType = #Static;
      canisterName = "ICFC Frontend Canister";
      app = #ICFC;
    };

    projectCanisters := Array.append<CanisterQueries.Canister>(projectCanisters, [frontend_dto]);

    let res : CanisterQueries.ProjectCanisters = {
      entries = projectCanisters;
    };
    return #ok(res);
  };

  public shared ({ caller }) func addController(dto : CanisterCommands.AddController) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.addController(dto);
    return result;
  };
  public shared ({ caller }) func removeController(dto : CanisterCommands.RemoveController) : async Result.Result<(), Enums.Error> {
    assert not Principal.isAnonymous(caller);
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.removeController(dto);
    return result;
  };

  public shared ({ caller }) func transferCycles(dto : CanisterCommands.TopupCanister) : async Result.Result<(), Enums.Error> {
    assert Principal.toText(caller) == CanisterIds.WATERWAY_LABS_BACKEND_CANISTER_ID;
    let result = await canisterManager.topupCanister(dto);
    switch (result) {
      case (#ok()) {
        return #ok(());
      };
      case (#err(err)) {
        return #err(err);
      };
    };
  };


  /* ----- Data Canister Calls -----  */

  public shared ({ caller }) func getDataHashes(dto : ICFCQueries.GetDataHashes) : async Result.Result<BaseQueries.DataHashes, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getDataHashes : (dto : ICFCQueries.GetDataHashes) -> async Result.Result<BaseQueries.DataHashes, Enums.Error>;
    };
    return await data_canister.getDataHashes(dto);
  };

  public shared ({ caller }) func getClubs(dto : ClubQueries.GetClubs) : async Result.Result<ClubQueries.Clubs, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getClubs : (dto : ClubQueries.GetClubs) -> async Result.Result<ClubQueries.Clubs, Enums.Error>;
    };
    return await data_canister.getClubs(dto);
  };

  /*
  public shared ({ caller }) func getCountries(dto : BaseQueries.GetCountries) : async Result.Result<BaseQueries.Countries, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    return #ok({
      countries = Countries.countries;
    });
  };
  */

  public shared ({ caller }) func getSeasons(dto : SeasonQueries.GetSeasons) : async Result.Result<SeasonQueries.Seasons, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getSeasons : (dto : SeasonQueries.GetSeasons) -> async Result.Result<SeasonQueries.Seasons, Enums.Error>;
    };
    return await data_canister.getSeasons(dto);
  };

  public shared ({ caller }) func getLoanedPlayers(dto : PlayerQueries.GetLoanedPlayers) : async Result.Result<PlayerQueries.LoanedPlayers, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getLoanedPlayers : (dto : PlayerQueries.GetLoanedPlayers) -> async Result.Result<PlayerQueries.LoanedPlayers, Enums.Error>;
    };
    return await data_canister.getLoanedPlayers(dto);
  };

  public shared ({ caller }) func getPlayers(dto : PlayerQueries.GetPlayers) : async Result.Result<PlayerQueries.Players, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getPlayers : (dto : PlayerQueries.GetPlayers) -> async Result.Result<PlayerQueries.Players, Enums.Error>;
    };
    return await data_canister.getPlayers(dto);
  };

  /*
  public shared ({ caller }) func getLeagues(dto : LeagueQueries.GetLeagues) : async Result.Result<LeagueQueries.Leagues, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getLeagues : (dto : LeagueQueries.GetLeagues) -> async Result.Result<LeagueQueries.Leagues, Enums.Error>;
    };
    let result = await data_canister.getLeagues(dto);
    return result;
  };
  */

  public shared ({ caller }) func getLeagueStatus(dto : LeagueQueries.GetLeagueStatus) : async Result.Result<LeagueQueries.LeagueStatus, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getLeagueStatus : (dto : LeagueQueries.GetLeagueStatus) -> async Result.Result<LeagueQueries.LeagueStatus, Enums.Error>;
    };
    return await data_canister.getLeagueStatus(dto);
  };

  public shared ({ caller }) func getFixtures(dto : FixtureQueries.GetFixtures) : async Result.Result<FixtureQueries.Fixtures, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getFixtures : (dto : FixtureQueries.GetFixtures) -> async Result.Result<FixtureQueries.Fixtures, Enums.Error>;
    };
    return await data_canister.getFixtures(dto);
  };

  public shared ({ caller }) func getPostponedFixtures(dto : FixtureQueries.GetPostponedFixtures) : async Result.Result<FixtureQueries.PostponedFixtures, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getPostponedFixtures : (dto : FixtureQueries.GetPostponedFixtures) -> async Result.Result<FixtureQueries.PostponedFixtures, Enums.Error>;
    };
    return await data_canister.getPostponedFixtures(dto);
  };

  public shared ({ caller }) func getClubValueLeaderboard(dto : ClubQueries.GetClubValueLeaderboard) : async Result.Result<ClubQueries.ClubValueLeaderboard, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getClubValueLeaderboard : (dto : ClubQueries.GetClubValueLeaderboard) -> async Result.Result<ClubQueries.ClubValueLeaderboard, Enums.Error>;
    };
    return await data_canister.getClubValueLeaderboard(dto);
  };

  public shared ({ caller }) func getPlayerValueLeaderboard(dto : PlayerQueries.GetPlayerValueLeaderboard) : async Result.Result<PlayerQueries.PlayerValueLeaderboard, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getPlayerValueLeaderboard : (dto : PlayerQueries.GetPlayerValueLeaderboard) -> async Result.Result<PlayerQueries.PlayerValueLeaderboard, Enums.Error>;
    };
    return await data_canister.getPlayerValueLeaderboard(dto);
  };

  public shared ({ caller }) func getDataTotals(dto : ICFCQueries.GetDataTotals) : async Result.Result<ICFCQueries.DataTotals, Enums.Error> {
    assert not Principal.isAnonymous(caller);
    // DevOps 480: Check caller has valid subscription

    let data_canister = actor (CanisterIds.ICFC_DATA_CANISTER_ID) : actor {
      getDataTotals : (dto : ICFCQueries.GetDataTotals) -> async Result.Result<ICFCQueries.DataTotals, Enums.Error>;
    };
    return await data_canister.getDataTotals(dto);
  };



  private func callerIsAdmin(principalId: Text) : Bool {
    return false; // TODO
  };

};
