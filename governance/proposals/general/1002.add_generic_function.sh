

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(
    record {
        title = \"Create Promote Club Callback Function\";          
        url = \"https://github.com/jamesbeadle/football_god/blob/master/src/data_canister/main.mo\";        
        summary = \"Proposal to create the endpoint for adding the callback function to promote a club within the data canister.\";
        action = opt variant {
            AddGenericNervousSystemFunction = record {
                id = 63000 : nat64;
                name = \"Promote Club\";
                description = opt \"Function to promote a club.\";
                function_type = opt variant { 
                    GenericNervousSystemFunction = record { 
                        topic = opt variant { ApplicationBusinessLogic };
                        validator_canister_id = opt principal \"52fzd-2aaaa-aaaal-qmzsa-cai\"; 
                        target_canister_id = opt principal \"52fzd-2aaaa-aaaal-qmzsa-cai\"; 
                        validator_method_name = opt \"validatePromoteClub\";                         
                        target_method_name = opt \"promoteClub\";
                    } 
                };
            }
        };
    }
)"

../../utils/submit_proposal.sh "$PROPOSAL"
