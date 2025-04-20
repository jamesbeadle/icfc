import FootballEnums "mo:waterway-mops/football/FootballEnums";

module PayoutCommands {
    public type RequestLeadboardPayout = {
        leaderboard: Leaderboard;
        app: FootballEnums.App;
    };

    public type Leaderboard = {
        entries: LeaderboardEntry;
    };

    public type LeaderboardEntry = {
        amount: Nat64;
    };
}

  