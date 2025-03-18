export type NeuronId = { 
    id: Uint8Array 
};

export type DissolveState = 
    | { DissolveDelaySeconds: bigint }
    | { WhenDissolvedTimestampSeconds: bigint };

export type NeuronPermission = {
    permission_type: number[];
    principal?: string;
};

export type DisburseMaturityInProgress = {
    account_to_disburse_to?: string;
    amount_e8s: bigint;
    finalize_disbursement_timestamp_seconds?: bigint;
    timestamp_of_disbursement_seconds: bigint;
};

export type Neuron = {
    aging_since_timestamp_seconds: bigint;
    auto_stake_maturity?: boolean;
    cached_neuron_stake_e8s: bigint;
    created_timestamp_seconds: bigint;
    disburse_maturity_in_progress: DisburseMaturityInProgress[];
    dissolve_state?: DissolveState;
    followees: [bigint, { followees: NeuronId[] }][];
    id?: NeuronId;
    maturity_e8s_equivalent: bigint;
    neuron_fees_e8s: bigint;
    permissions: NeuronPermission[];
    source_nns_neuron_id?: bigint;
    staked_maturity_e8s_equivalent?: bigint;
    vesting_period_seconds?: bigint;
    voting_power_percentage_multiplier: bigint;  
}; 