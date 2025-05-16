import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import Enums "mo:waterway-mops/Enums";

module PayoutCommands {
    public type PayoutLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        app : Enums.WaterwayLabsApp;
    };

    public type Leaderboard = {
        entries : LeaderboardEntry;
    };

    public type LeaderboardEntry = {
        amount : Nat64;
    };
};
