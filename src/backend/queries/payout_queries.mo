import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Enums "mo:waterway-mops/Enums";
import LeaderboardPayoutCommands "mo:waterway-mops/football/LeaderboardPayoutCommands";

module PayoutQueries {
    public type GetLeaderboardRequests = {
    };

    public type LeaderboardRequests = {
        requests : [PayoutRequest];
        totalEntries : Nat;
    };

    public type PayoutRequest = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        payoutStatus : Enums.PayoutStatus;
        payoutDate : ?Int;
        app : Enums.WaterwayLabsApp;
        entries : [LeaderboardPayoutCommands.LeaderboardEntry];
    };
};
