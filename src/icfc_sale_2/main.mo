import Result "mo:base/Result";
import Principal "mo:base/Principal";
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

    private stable var stable_saleParticipants : [T.SaleParticipant] = [];

    public shared query func getAppStatus() : async Result.Result<DTO.AppStatusDTO, T.Error> {
        return #ok(appStatus);
    };

    public shared ({ caller }) func claimICFCPackets() : async Result.Result<(), T.Error> {
        assert not Principal.isAnonymous(caller);
        let dto : SaleCommands.ParticipateInSale = {
            principalId = Principal.toText(caller);
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

    public shared func get_progress() : async Result.Result<DTO.SaleProgressDTO, T.Error> {
        return await saleManager.get_progress();
    };

    // backup and restore stable storage
    system func preupgrade() {
        backUpStableData();
    };

    system func postupgrade() {
        restoreStableData();

    };

    private func backUpStableData() {
        stable_icfcPacketsRemaining := saleManager.getStableICFCPacketsRemaining();
        stable_saleParticipants := saleManager.getStableSaleParticipants();
    };

    private func restoreStableData() {
        saleManager.setStableICFCPacketsRemaining(stable_icfcPacketsRemaining);
        saleManager.setStableSaleParticipants(stable_saleParticipants);
    };

};
