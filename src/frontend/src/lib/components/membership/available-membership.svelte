<script lang="ts">
    import { formatSecondsUnixDateToReadable, formatUnixNanoToDuration } from "$lib/utils/helpers";
    import type { MembershipType, Neuron } from "../../../../../declarations/backend/backend.did";

    import NeuronCard from './neuron-card.svelte';
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import type { NeuronSummary } from "$lib/types/neuron-types";
    import { Principal } from "@dfinity/principal";
    import { toasts } from "$lib/stores/toasts-store";
    import HowToClaimModal from "./how-to-claim-modal.svelte";
    import { appStore } from "$lib/stores/app-store";
    import { authStore } from "$lib/stores/auth-store";
    import CopyIcon from "$lib/icons/CopyIcon.svelte";
    import IcfcCoinIcon from "$lib/icons/ICFCCoinIcon.svelte";
    import MonthlyMembershipIcon from "$lib/icons/MonthlyMembershipIcon.svelte";
    import SeasonalMembershipIcon from "$lib/icons/SeasonalMembershipIcon.svelte";
    import LifetimeMembershipIcon from "$lib/icons/LifetimeMembershipIcon.svelte";
    import FoundingMembershipIcon from "$lib/icons/FoundingMembershipIcon.svelte";

    export let neurons: Neuron[];
    export let refreshNeurons: () => void;
    export let availableMembership: MembershipType;
    export let maxStakedICFC: bigint;

    let isLoading: boolean = false;
    let showHowToClaimModal = false;

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

{#if isLoading}
    <LocalSpinner />
{:else}
    <div class="flex flex-col space-y-6 mt-4">
        <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
            <h1 class="text-2xl lg:text-3xl cta-text text-white">Your Neurons</h1>
            {#if neurons.length === 0}
                <button 
                    class="brand-button bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition w-full sm:w-auto"
                    on:click={() => showHowToClaimModal = true}
                >
                    How To Claim Membership
                </button>
            {/if}
        </div>

        {#if neurons.length === 0}
            <div class="flex flex-col items-center justify-center w-full p-6 text-center rounded-lg bg-blue-500/10">
                <p class="text-xl text-white mb-4">No Neurons Found</p>
                <div class="flex flex-col gap-3 w-full max-w-md">
                    <p class="text-sm text-gray-300">Add this hotkey to any neurons staked for 2 years that you would like to claim membership for.</p>
                    <div class="relative bg-gray-800 rounded-lg p-4">
                        <button 
                            on:click={() => { appStore.copyTextAndShowToast($authStore.identity?.getPrincipal().toString() ?? "") }}
                            class="absolute top-2 right-2 text-gray-400 hover:text-white"
                        >
                            <CopyIcon className="w-5 h-5" fill='#FFFFFF' />
                        </button>
                        <p class="text-gray-300 font-mono text-sm break-all px-4 mb-2">
                            {$authStore.identity?.getPrincipal().toString() ?? ""}
                        </p>
                        <h3 class="text-xs text-white font-semibold">Your Principal ID</h3>
                    </div>
                </div>
            </div>
        {:else}
            <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                {#each neurons as neuron}
                    <NeuronCard neuron={formatNeuronForCard(neuron)} {copyToClipboard} />
                {/each}
            </div>
        {/if}

        <div class="flex flex-col md:flex-row border-t border-gray-600 pt-4">
            <div class="w-full md:w-1/2 flex flex-col items-center justify-center text-center p-4 space-y-2">
                <p class="text-gray-300">Total ICFC Staked:</p>
                <div class="flex flex-row items-center">
                    <IcfcCoinIcon className="w-6 mr-2" />
                    <p class="text-white">{formatICFC(maxStakedICFC / 100000000n)}</p>
                </div>
            </div>
            <div class="w-full md:w-1/2 flex flex-col items-center justify-center text-center p-4 space-y-2">
                <p class="text-gray-300">Membership Level:</p>
                {#if Object.keys(availableMembership)[0].toLowerCase() === 'monthly'}
                    <div class="flex flex-row items-center">
                        <MonthlyMembershipIcon className="w-6 mr-2" />
                        <p class="text-white">Monthly</p>
                    </div>
                {:else if Object.keys(availableMembership)[0].toLowerCase() === 'seasonal'}
                    <div class="flex flex-row items-center">
                        <SeasonalMembershipIcon className="w-6 mr-2" />
                        <p class="text-white">Seasonal</p>
                    </div>
                {:else if Object.keys(availableMembership)[0].toLowerCase() === 'lifetime'}
                    <div class="flex flex-row items-center">
                        <LifetimeMembershipIcon className="w-6 mr-2" />
                        <p class="text-white">Lifetime</p>
                    </div>
                {:else if Object.keys(availableMembership)[0].toLowerCase() === 'founding'}
                    <div class="flex flex-row items-center">
                        <FoundingMembershipIcon className="w-6 mr-2" />
                        <p class="text-white">Founding</p>
                    </div>
                {:else}
                    <p class="text-white">Not Eligible</p>
                {/if}
                <p class="text-sm text-gray-400">You can upgrade your membership level at any time.</p>
            </div>
        </div>

        <!-- Refresh Button -->
        <div class="flex w-full justify-center">
            <button 
                class="brand-button bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition"
                on:click={refreshNeurons}
            >
                Refresh
            </button>
        </div>
    </div>
{/if}

{#if showHowToClaimModal}
    <HowToClaimModal onClose={() => showHowToClaimModal = false} />
{/if}