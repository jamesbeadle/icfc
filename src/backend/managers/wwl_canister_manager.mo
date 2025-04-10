import Ids "mo:waterway-mops/Ids";
import BaseTypes "mo:waterway-mops/BaseTypes";
import Management "mo:waterway-mops/Management";
import CanisterUtilities "mo:waterway-mops/CanisterUtilities";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Result "mo:base/Result";
import WWLCanisterQueries "../queries/wwl_canister_queries";
import MopsCanisterIds "mo:waterway-mops/CanisterIds";
import Enums "mo:waterway-mops/Enums";

module WWLCanisterManager {

    public func getCanisterInfo(dto : WWLCanisterQueries.GetCanisterInfo) : async Result.Result<WWLCanisterQueries.CanisterInfo, Enums.Error> {

        let IC : Management.Management = actor (MopsCanisterIds.Default);
        let canister_actor = actor (dto.canisterId) : actor {};

        let canisterStatusResult = await CanisterUtilities.getCanisterStatus_(canister_actor, IC);
        switch (canisterStatusResult) {
            case (?canisterStatus) {

                let controllers_principal =

                canisterStatus.settings.controllers;
                var controllers : [Ids.PrincipalId] = [];
                for (controllerPrincipal in controllers_principal.vals()) {
                    let controller = Principal.toText(controllerPrincipal);
                    controllers := Array.append<Ids.PrincipalId>(controllers, [controller]);
                };

                return #ok({
                    app = #ICFC;
                    canisterId = dto.canisterId;
                    canisterName = dto.canisterName;
                    canisterType = dto.canisterType;
                    cycles = canisterStatus.cycles;
                    computeAllocation = canisterStatus.settings.compute_allocation;
                    controllers = controllers;
                    freezeThreshold = canisterStatus.settings.freezing_threshold;
                    memoryAllocation = canisterStatus.settings.memory_allocation;
                    memoryUsage = canisterStatus.memory_size;
                    status = canisterStatus.status;
                });

            };
            case (null) {
                return #err(#NotFound);
            };
        };
    };
};
