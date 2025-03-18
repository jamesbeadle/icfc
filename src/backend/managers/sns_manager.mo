import SNSGovernance "../sns-wrappers/governance";
import Environment "../environment";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";

module {
    public class SNSManager() {
        public func getUsersNeurons(userPrincipalId : Principal) : async [SNSGovernance.Neuron] {
            var allNeurons = await listNeurons(userPrincipalId);
            let userNeurons = Buffer.Buffer<SNSGovernance.Neuron>(0);
            for (neuron in allNeurons.vals()) {

                let permissions : [SNSGovernance.NeuronPermission] = neuron.permissions;

                for (permission in permissions.vals()) {
                    switch (permission.principal) {
                        case (null) {

                        };
                        case (?principalId) {
                            if (principalId == userPrincipalId) {
                                userNeurons.add(neuron);
                            };
                        };
                    };
                };

            };
            return Buffer.toArray(userNeurons);
        };
        private func listNeurons(userPrincipalId : Principal) : async [SNSGovernance.Neuron] {
            var governance = actor (Environment.SNS_GOVERNANCE_CANISTER_ID) : actor {
                list_neurons : shared query SNSGovernance.ListNeurons -> async SNSGovernance.ListNeuronsResponse;
            };

            let command : SNSGovernance.ListNeurons = {
                of_principal = ?userPrincipalId;
                limit = 100000;
                start_page_at = null;
            };
            var response : SNSGovernance.ListNeuronsResponse = await governance.list_neurons(command);
            return response.neurons;
        };
    };
};
