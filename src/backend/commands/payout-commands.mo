import Enums "mo:waterway-mops/base/enums";
import ICFCEnums "mo:waterway-mops/product/icfc/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";

module PayoutCommands {
    public type PayoutLeaderboard = {
        seasonId : FootballIds.SeasonId;
        gameweek : FootballDefinitions.GameweekNumber;
        app : ICFCEnums.SubApp;
        currency: Enums.Currency;
    };

    public type Leaderboard = {
        entries : LeaderboardEntry;
    };

    public type LeaderboardEntry = {
        amount : Nat64;
    };
};
