import FootballIds "mo:waterway-mops/football/FootballIds";
import Enums "mo:waterway-mops/Enums";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";

module PayoutCommands {
    public type PayoutLeaderboard = {
        seasonId: FootballIds.SeasonId;
        gameweek: FootballDefinitions.GameweekNumber;
        app: Enums.WaterwayLabsApp;
    };

    public type Leaderboard = {
        entries: LeaderboardEntry;
    };

    public type LeaderboardEntry = {
        amount: Nat64;
    };
}

  