import FootballIds "mo:waterway-mops/domain/football/Ids";
import FootballDefinitions "mo:waterway-mops/domain/football/Definitions";
import Enums "mo:waterway-mops/product/icfc/Enums";

module PayoutCommands {
    public type PayoutLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        app : Enums.App;
    };

    public type Leaderboard = {
        entries : LeaderboardEntry;
    };

    public type LeaderboardEntry = {
        amount : Nat64;
    };
};
