<script lang="ts">
    import { onMount } from "svelte";
    import { formatSecondsUnixDateToReadable } from "$lib/utils/helpers";
    import { membershipStore } from "$lib/stores/membership-store";
    import { busy } from "$lib/stores/busy-store";
    import type { Neuron, ICFCMembershipType } from "../../../../../declarations/backend/backend.did";

    import NeuronCard from './neuron-card.svelte';
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import ClaimMembershipButton from './claim-membership-button.svelte';

    export let isLoading: boolean = false;
    export let neurons: Neuron[] = [];
    
    let userMembershipEligibility: ICFCMembershipType = { NotEligibe: null };

    onMount(async () => {
        try {
            busy.start();
            await getNeurons();
        } catch (error) {
            console.error("Error fetching funding data:", error);
        } finally {
            isLoading = false;
            busy.stop();
        }
    });

    async function getNeurons() {
        try {
            busy.start();
            const userNeurons = await membershipStore.getUserNeurons();
            neurons = userNeurons.neurons.sort(sortByHighestNeuron);
            userMembershipEligibility = userNeurons.membershipEligibility;
        } catch (error) {
            console.error(error);
        } finally {
            busy.stop();
        }
    }

    function formatICFC(amount: number): string {
        return Math.round(amount).toLocaleString();
    }

    function formatNeuronForCard(neuron: Neuron) {
        const id = neuron.id
            ? Array.from(neuron.id.id)
                .map((b: unknown) => (b as number).toString(16).padStart(2, '0'))
                .join('')
            : 'unknown';
        
        const stakedAmount = formatICFC(Number(neuron.cached_neuron_stake_e8s) / 100000000);
        
        const dissolveState = neuron.dissolve_state ?? { DissolveDelaySeconds: BigInt(0) };
        let status: 'active' | 'dissolving' = 'active';
        let lockPeriod = '';
        
        if ('DissolveDelaySeconds' in dissolveState) {
            status = 'active';
            lockPeriod = convertBigIntSeconds(dissolveState.DissolveDelaySeconds);
        } else {
            status = 'dissolving';
        }

        const age = formatSecondsUnixDateToReadable(Number(neuron.created_timestamp_seconds));

        return { id, stakedAmount, lockPeriod, age, status };
    }

    function convertBigIntSeconds(value: bigint): string {
        const secondsInYear = 31536000n; // 365 days
        const secondsInDay = 86400n;

        const years = value / secondsInYear;
        const remainingSeconds = value % secondsInYear;
        const days = remainingSeconds / secondsInDay;

        return `${years} years ${days} days`;
    }

    const mockNeurons: Neuron[] = [
        {
            aging_since_timestamp_seconds: BigInt(0),
            cached_neuron_stake_e8s: BigInt(150000 * 100000000), // 150k ICFC
            created_timestamp_seconds: BigInt(Date.now()),
            disburse_maturity_in_progress: [],
            dissolve_state: { DissolveDelaySeconds: BigInt(31536000 * 4) }, // 4 years
            followees: [],
            id: { id: new Uint8Array([1, 2, 3, 4]) },
            maturity_e8s_equivalent: BigInt(0),
            neuron_fees_e8s: BigInt(0),
            permissions: [],
            voting_power_percentage_multiplier: BigInt(0)
        },
        {
            aging_since_timestamp_seconds: BigInt(0),
            cached_neuron_stake_e8s: BigInt(20000 * 100000000), // 20k ICFC
            created_timestamp_seconds: BigInt(Date.now()),
            disburse_maturity_in_progress: [],
            dissolve_state: { DissolveDelaySeconds: BigInt(31536000 * 2) }, // 2 years
            followees: [],
            id: { id: new Uint8Array([5, 6, 7, 8]) },
            maturity_e8s_equivalent: BigInt(0),
            neuron_fees_e8s: BigInt(0),
            permissions: [],
            voting_power_percentage_multiplier: BigInt(0)
        },
        {
            aging_since_timestamp_seconds: BigInt(0),
            cached_neuron_stake_e8s: BigInt(5000 * 100000000), // 5k ICFC
            created_timestamp_seconds: BigInt(Date.now()),
            disburse_maturity_in_progress: [],
            dissolve_state: { DissolveDelaySeconds: BigInt(31536000) }, // 1 year
            followees: [],
            id: { id: new Uint8Array([9, 10, 11, 12]) },
            maturity_e8s_equivalent: BigInt(0),
            neuron_fees_e8s: BigInt(0),
            permissions: [],
            voting_power_percentage_multiplier: BigInt(0)
        },
        {
            aging_since_timestamp_seconds: BigInt(0),
            cached_neuron_stake_e8s: BigInt(500 * 100000000), // 500 ICFC
            created_timestamp_seconds: BigInt(Date.now()),
            disburse_maturity_in_progress: [],
            dissolve_state: { DissolveDelaySeconds: BigInt(15768000) }, // 6 months
            followees: [],
            id: { id: new Uint8Array([13, 14, 15, 16]) },
            maturity_e8s_equivalent: BigInt(0),
            neuron_fees_e8s: BigInt(0),
            permissions: [],
            voting_power_percentage_multiplier: BigInt(0)
        }
    ];

    function sortByHighestNeuron(a: Neuron, b: Neuron): number {
        return Number(b.cached_neuron_stake_e8s) - Number(a.cached_neuron_stake_e8s);
    }

</script>

<div class="flex flex-col space-y-6">
    <div class="flex flex-col gap-4 mini:flex-row mini:justify-between mini:gap-0 mini:px-4">
        <h1 class="text-2xl lg:text-3xl cta-text">User's Neurons</h1>
        <ClaimMembershipButton {userMembershipEligibility} />
    </div>
    {#if isLoading}
        <div class="flex items-center justify-center w-full h-48">
            <LocalSpinner />
        </div>
    {:else if neurons.length === 0}
        <div class="flex flex-col items-center justify-center w-full p-8 text-center rounded-lg bg-BrandBlueComp/10">
            <p class="text-xl text-white">No Neurons Found</p>
            <p class="mt-2 text-sm text-BrandGrayShade4">
                Stake ICFC tokens to create neurons and unlock membership benefits
            </p>
        </div>
    {:else}
        <div class="grid gap-6 lg:px-4 mini:grid-cols-2 base:grid-cols-3 xl:grid-cols-4">
            {#each neurons as neuron}
                <NeuronCard neuron={formatNeuronForCard(neuron)} />
            {/each}
        </div>
    {/if}
</div> 