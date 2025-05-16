import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import ICFCEnums "mo:waterway-mops/product/icfc/enums";
import Ids "mo:waterway-mops/base/ids";
import LeaderboardPayoutCommands "mo:waterway-mops/product/icfc/inter-app-call-commands";

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
