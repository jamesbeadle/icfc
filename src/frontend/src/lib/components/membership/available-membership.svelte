<script lang="ts">
    import { formatSecondsUnixDateToReadable, formatUnixNanoToDuration } from "$lib/utils/helpers";
    import type { MembershipType, Neuron } from "../../../../../declarations/backend/backend.did";
    import type { NeuronSummary } from "$lib/types/neuron-types";
    import { Principal } from "@dfinity/principal";
    import { toasts } from "$lib/stores/toasts-store";
    import NeuronCard from './neuron-card.svelte';
    import HowToClaimModal from "./how-to-claim-modal.svelte";
    import IcfcInfoContainer from "$lib/components/profile/create-user/icfc-info-container.svelte";

    interface Props {
        neurons: Neuron[];
        refreshNeurons: () => void;
        availableMembership: MembershipType;
        maxStakedICFC: bigint;
    }

    let { neurons, refreshNeurons, availableMembership, maxStakedICFC } : Props = $props();

    let showHowToClaimModal = $state(false);

    function formatICFC(amount: bigint): string {
        return Number(amount).toLocaleString('en-US', { maximumFractionDigits: 0 });
    }

    function formatNeuronForCard(neuron: Neuron): NeuronSummary {
        let emptySummary: NeuronSummary = {
            id: '',
            stakedAmount: '',
            lockPeriod: '',
            status: 'locked',
            age: '',
            displayId: ''
        };

        const neuronId = neuron.id[0];  
        if (!neuronId) { 
            return emptySummary;
        }

        let id = Principal.fromUint8Array(new Uint8Array(neuronId.id)).toHex();
        const displayId = `${id.slice(0, 4)}...${id.slice(-5)}`;

        const stakedAmount = formatICFC(neuron.cached_neuron_stake_e8s / 100000000n);
        
        let status: 'locked' | 'dissolving' = 'locked';
        let state = neuron.dissolve_state?.[0]; 
        let lockPeriod = '';
        
        if (state) {
            if ('DissolveDelaySeconds' in state) {
                status = 'locked';
                lockPeriod = formatUnixNanoToDuration(state.DissolveDelaySeconds);
            } else if ('WhenDissolvedTimestampSeconds' in state) {
                status = 'dissolving';
                lockPeriod = formatUnixNanoToDuration(state.WhenDissolvedTimestampSeconds - BigInt(Date.now()));
            }
        }
        
        const age = formatSecondsUnixDateToReadable(Number(neuron.created_timestamp_seconds));

        return { id, stakedAmount, lockPeriod, age, status, displayId };
    }
    
    function copyToClipboard(fullId: string) {
        navigator.clipboard.writeText(fullId).then(() => {
            toasts.addToast({
                message: 'Copied to clipboard',
                type: 'success',
                duration: 3000
            });
        }).catch(err => {
            console.error('Failed to copy: ', err);
        });
    }
</script>


<div class="flex flex-col p-4 mt-4 space-y-6">
    <div class="flex flex-col gap-4 sm:flex-row sm:justify-between sm:items-center">
        <h1 class="text-2xl text-white cta-text lg:text-3xl">Your Neurons</h1>
        <button 
            class="w-full sm:w-auto border-BrandGrayShade3 border brand-button"
            onclick={() => showHowToClaimModal = true}
        >
            How To Claim Membership
        </button>
    </div>
    {#if neurons.length === 0}
        <div class="flex flex-col items-center justify-center w-full p-6 text-center border rounded-lg bg-BrandGray border-BrandGrayShade3">
            <p class="mb-1 text-xl text-white">No Neurons Found</p>
            <p class="mb-2 text-lg text-BrandGrayShade2">Click how to claim membership to learn more.</p>
        </div>
    {:else}
        <div class="border-t horizontal-divider border-BrandGrayShade3"></div>
        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4 xl:grid-cols-5">
            {#each neurons as neuron}
                <NeuronCard neuron={formatNeuronForCard(neuron)} {copyToClipboard} />
            {/each}
        </div>
    {/if}
    
    <IcfcInfoContainer {availableMembership} {maxStakedICFC} {formatICFC} />
    
    <div class="border-t horizontal-divider border-BrandGrayShade3"></div>
    <div class="flex justify-center w-full">
        <button 
            class="px-4 py-2 text-white transition border rounded-lg brand-button hover:bg-BrandBlack/50 hover:border-BrandBlue/80"
            onclick={refreshNeurons}
        >
            Refresh
        </button>
    </div>
</div>

{#if showHowToClaimModal}
    <HowToClaimModal onClose={() => showHowToClaimModal = false} />
{/if}