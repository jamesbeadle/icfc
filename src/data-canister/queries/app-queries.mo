import FootballIds "mo:waterway-mops/domain/football/ids";

module AppQueries {

    
    public type GetDataHashes = {
        leagueId: FootballIds.LeagueId;
    };

    public type GetDataTotals = {

    };

    public type DataTotals = {
        totalLeagues: Nat;
        totalClubs: Nat;
        totalPlayers: Nat;
        totalNeurons: Nat;
        totalProposals: Nat;
        totalGovernanceRewards: Nat;
    };
}