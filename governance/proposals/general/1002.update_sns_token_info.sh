

#!/bin/bash

# Set current directory to the directory this script is in
SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")
cd $SCRIPT_DIR

PROPOSAL="(record {
        title = \"Update ICFC Lefger Token Name \";
        url = \"https://github.com/jamesbeadle/icfc\";
        summary = \"Update ICFC Lefger Token Name \";
        action = opt variant {
            ManageLedgerParameters  = record {
                token_name = opt \"ICFC\";
                token_symbol = null;
                token_logo = null;
                transfer_fee = null;
            }
        }
 })"

../../utils/submit_proposal.sh "$PROPOSAL"