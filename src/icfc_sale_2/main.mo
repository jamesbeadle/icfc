import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Timer "mo:base/Timer";
import T "./sale_types";
import DTO "./dtos/dtos";
import Base "mo:waterway-mops/BaseTypes";
import SaleManager "manager/sale_manager";
import SaleCommands "commands/sale_commands";
import SaleQueries "queries/sale_queries";

actor class Self() = this {

    private let saleManager = SaleManager.SaleManager();

    private var appStatus : Base.AppStatus = {
        onHold = false;
        version = "0.0.2";
    };

    private stable var stable_icfcPacketsRemaining : Nat = 1000;

    private stable var stable_saleParticipants : [(Base.PrincipalId, [T.ClaimedRecord])] = [];
    private stable var stable_icfcDistributions : [T.ICFCDistribution] = [];

    public shared query func getAppStatus() : async Result.Result<DTO.AppStatusDTO, T.Error> {
        return #ok(appStatus);
    };

    public shared ({ caller }) func claimICFCPackets(command : SaleCommands.CalimICFCPackets) : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let dto : SaleCommands.ParticipateInSale = {
            principalId = Principal.toText(caller);
            packets = command.packets;
        };
        return await saleManager.claimICFCPackets(dto);
    };

    public shared ({ caller }) func getUserParticipation() : async Result.Result<DTO.UserParticipationDTO, T.Error> {
        assert not Principal.isAnonymous(caller);
        let dto : SaleQueries.GetUserParticipation = {
            principalId = Principal.toText(caller);
        };
        return await saleManager.getUserParticipation(dto);
    };

    public shared ({ caller }) func getUsersICFCDistributions() : async Result.Result<[T.ICFCDistribution], T.Error> {
        assert not Principal.isAnonymous(caller);
        let dto : SaleQueries.GetICFCDistributions = {
            principalId = Principal.toText(caller);
        };
        return await saleManager.getUsersICFCDistributions(dto);
    };

    public shared func getProgress() : async Result.Result<DTO.SaleProgressDTO, T.Error> {
        return await saleManager.getProgress();
    };

    // backup and restore stable storage
    system func preupgrade() {
        backUpStableData();
    };

    system func postupgrade() {
        restoreStableData();
        ignore Timer.setTimer<system>(
            #nanoseconds(1),
            func() : async () {
                await saleManager.restoreDistributionTimers();
            },
        );
    };

    private func backUpStableData() {
        stable_icfcPacketsRemaining := saleManager.getStableICFCPacketsRemaining();
        stable_saleParticipants := saleManager.getStableSaleParticipants();
        stable_icfcDistributions := saleManager.getStableICFCDistributions();
    };

    private func restoreStableData() {
        saleManager.setStableICFCPacketsRemaining(stable_icfcPacketsRemaining);
        saleManager.setStableSaleParticipants(stable_saleParticipants);
        saleManager.setStableICFCDistributions(stable_icfcDistributions);
    };

};
