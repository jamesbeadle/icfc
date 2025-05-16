import FootballIds "mo:waterway-mops/domain/football/Ids";

module AppQueries {

    
    public type GetDataHashes = {
        leagueId: FootballIds.LeagueId;
    };

    public type DataHashes = {
        dataHashes: [DataHash];
    };

    public type DataHash = {
        category : Text;
        hash : Text;
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