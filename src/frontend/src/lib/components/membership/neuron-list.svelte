<script lang="ts">
    import { onMount } from "svelte";
    import { formatSecondsUnixDateToReadable } from "$lib/utils/helpers";
    import { membershipStore } from "$lib/stores/membership-store";
    import { busy } from "$lib/stores/busy-store";
    import type { Neuron, MembershipType, UserNeuronsDTO } from "../../../../../declarations/backend/backend.did";

    import NeuronCard from './neuron-card.svelte';
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import ClaimMembershipButton from './claim-membership-button.svelte';

    export let isLoading: boolean = false;
    export let neurons: Neuron[] = [];
    
    let userMembershipEligibility: MembershipType = { NotEligible: null };
    let userNeurons: UserNeuronsDTO | undefined;

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
            userNeurons = await membershipStore.getUserNeurons();
            if (userNeurons) {
                neurons = userNeurons.userNeurons.sort(sortByHighestNeuron);
                userMembershipEligibility = userNeurons.userMembershipEligibility;
            }
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
            ? Array.from(neuron.id)
                .map((b: unknown) => (b as number).toString(16).padStart(2, '0'))
                .join('')
            : 'unknown';
        
        const stakedAmount = formatICFC(Number(neuron.cached_neuron_stake_e8s) / 100000000);
        
        const dissolveState = neuron.dissolve_state ?? { DissolveDelaySeconds: BigInt(0) };
        let status: 'active' | 'dissolving' = 'active';
        let lockPeriod = '';
        
        if ('DissolveDelaySeconds' in dissolveState) {
            status = 'active';
            //lockPeriod = convertBigIntSeconds(dissolveState.DissolveDelaySeconds);
        } else {
            status = 'dissolving';
        }

        const age = formatSecondsUnixDateToReadable(Number(neuron.created_timestamp_seconds));

        return { id, stakedAmount, lockPeriod, age, status };
    }

    function convertBigIntSeconds(value: bigint): string {
        const secondsInYear = 31536000n;
        const secondsInDay = 86400n;

        const years = value / secondsInYear;
        const remainingSeconds = value % secondsInYear;
        const days = remainingSeconds / secondsInDay;

        return `${years} years ${days} days`;
    }

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