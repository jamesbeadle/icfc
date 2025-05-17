import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import LeaderboardPayoutCommands "mo:waterway-mops/product/icfc/inter-app-call-commands";

module PayoutQueries {
    public type GetPayoutRequests = {};

    public type PayoutRequests = {
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

};
