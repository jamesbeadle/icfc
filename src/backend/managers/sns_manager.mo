import SNSGovernance "../sns-wrappers/governance";
import Principal "mo:base/Principal";
import CanisterIds "mo:waterway-mops/CanisterIds";

module {
    public class SNSManager() {
        public func getUsersNeurons(userPrincipalId : Principal) : async [SNSGovernance.Neuron] {
              var governance = actor (CanisterIds.ICFC_SNS_GOVERNANCE_CANISTER_ID) : actor {
                list_neurons : shared query SNSGovernance.ListNeurons -> async SNSGovernance.ListNeuronsResponse;
            };

            let command : SNSGovernance.ListNeurons = {
                of_principal = ?userPrincipalId;
                limit = 1000;
                start_page_at = null;
            };
            var response : SNSGovernance.ListNeuronsResponse = await governance.list_neurons(command);
            return response.neurons;
        };
    };
};
