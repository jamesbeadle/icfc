import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Timer "mo:base/Timer";
import T "./sale_types";
import Base "mo:waterway-mops/BaseTypes";
import Ids "mo:waterway-mops/Ids";
import Enums "mo:waterway-mops/Enums";
import BaseTypes "mo:waterway-mops/BaseTypes";
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

    private stable var stable_saleParticipants : [(Ids.PrincipalId, [T.ClaimedRecord])] = [];
    private stable var stable_icfcDistributions : [T.ICFCDistribution] = [];

    public shared query func getAppStatus() : async Result.Result<BaseTypes.AppStatus, Enums.Error> {
        return #ok(appStatus);
    };

    public shared ({ caller }) func claimICFCPackets(command : SaleCommands.CalimICFCPackets) : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let dto : SaleCommands.ParticipateInSale = {
            principalId = Principal.toText(caller);
            packets = command.packets;
        };
        return await saleManager.claimICFCPackets(dto);
    };

    public shared ({ caller }) func getUserParticipation() : async Result.Result<SaleQueries.UserParticipation, Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let dto : SaleQueries.GetUserParticipation = {
            principalId = Principal.toText(caller);
        };
        return await saleManager.getUserParticipation(dto);
    };

    public shared ({ caller }) func refreshParticipant() : async Result.Result<(), Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let dto : SaleCommands.RefreshParticipant = {
            principalId = Principal.toText(caller);
        };
        return await saleManager.refreshParticipant(dto);
    };

    public shared ({ caller }) func getUsersICFCDistributions() : async Result.Result<[T.ICFCDistribution], Enums.Error> {
        assert not Principal.isAnonymous(caller);
        let dto : SaleQueries.GetICFCDistributions = {
            principalId = Principal.toText(caller);
        };
        return await saleManager.getUsersICFCDistributions(dto);
    };

    public shared func getProgress() : async Result.Result<SaleQueries.SaleProgress, Enums.Error> {
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
