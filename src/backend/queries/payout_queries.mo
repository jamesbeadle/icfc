import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Enums "mo:waterway-mops/Enums";
import ICFCEnums "mo:waterway-mops/ICFCEnums";
import LeaderboardPayoutCommands "mo:waterway-mops/football/LeaderboardPayoutCommands";
import Ids "mo:waterway-mops/Ids";

module PayoutQueries {
    public type GetLeaderboardRequests = {};

    public type LeaderboardRequests = {
        requests : [PayoutRequest];
        totalRequest : Nat;
    };

    public type PayoutRequest = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        app : Text;
        leaderboard : [LeaderboardPayoutCommands.LeaderboardEntry];
        token : Text;
        totalEntries : Nat;
        totalEntriesPaid : Nat;
    };

    public type GetICFCLinks = {};

    public type ICFCLinks = {
        icfcPrincipalId : Ids.PrincipalId;
        subAppUserPrincipalId : Ids.PrincipalId;
        membershipType : ICFCEnums.MembershipType;
        subApp : ICFCEnums.SubApp;
    };

};
