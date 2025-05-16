import Enums "mo:waterway-mops/product/icfc/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";

module PayoutCommands {
    public type PayoutLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        app : Enums.SubApp;
    };

    public type Leaderboard = {
        entries : LeaderboardEntry;
    };

    public type LeaderboardEntry = {
        amount : Nat64;
    };
};
