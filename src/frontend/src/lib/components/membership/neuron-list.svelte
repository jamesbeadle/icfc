<script lang="ts">
    import { onMount } from "svelte";
    import { formatSecondsUnixDateToReadable, formatUnixNanoToDuration } from "$lib/utils/helpers";
    import { membershipStore } from "$lib/stores/membership-store";
    import { busy } from "$lib/stores/busy-store";
    import type { MembershipType, Neuron, UserNeuronsDTO } from "../../../../../declarations/backend/backend.did";

    import NeuronCard from './neuron-card.svelte';
    import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
    import type { NeuronSummary } from "$lib/types/neuron-types";
    import { Principal } from "@dfinity/principal";
    import { toasts } from "$lib/stores/toasts-store";
    import ClaimMembershipModal from "./claim-membership-modal.svelte";
    import HowToClaimModal from "./how-to-claim-modal.svelte";
    import { appStore } from "$lib/stores/app-store";
    import { authStore } from "$lib/stores/auth-store";
    import CopyIcon from "$lib/icons/CopyIcon.svelte";

    interface Props {
        neurons: Neuron[];
    }

    let { neurons } : Props = $props();

    let isLoading: boolean = true;
    let showHowToClaimModal = false;
    let showClaimMembershipModal = false;
    function formatICFC(amount: number): string {
        return Math.round(amount).toLocaleString();
    }

    function formatNeuronForCard(neuron: Neuron) : NeuronSummary {

        let emptySummary: NeuronSummary = {
            id: '',
            stakedAmount: '',
            lockPeriod: '',
            status: 'locked',
            age: '',
            displayId: ''
        };

        const neuronId = neuron.id[0];  
        if(!neuronId) { 
            return emptySummary;
        }

        let id = Principal.fromUint8Array(new Uint8Array(neuronId.id)).toHex();
        const displayId = `${id.slice(0, 4)}...${id.slice(-5)}`;

        const stakedAmount = formatICFC(Number(neuron.cached_neuron_stake_e8s) / 100000000);
        
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


    function sortByHighestNeuron(a: Neuron, b: Neuron): number {
        return Number(b.cached_neuron_stake_e8s) - Number(a.cached_neuron_stake_e8s);
    }

    function calculateTotalStakedICFC(neurons: Neuron[]): number {
        if (!neurons || neurons.length === 0) return 0;
        const totalE8s = neurons.reduce((sum, neuron) => sum + Number(neuron.cached_neuron_stake_e8s), 0);
        return totalE8s / 100000000;
    }

</script>

{#if isLoading}
    <LocalSpinner />
{:else}
    <div class="flex flex-col space-y-6">
        <div class="flex flex-col gap-4 mini:flex-row mini:justify-between mini:gap-0">
            <h1 class="text-2xl lg:text-3xl cta-text">Your Neurons</h1>

            <div class="flex flex-col items-center w-full gap-2 mini:w-auto">
                {#if neurons.length === 0}
                    <button 
                        class="w-full brand-button"
                        on:click={() => showHowToClaimModal = true}
                    >
                        How To Claim Membership
                    </button>
                {:else}
                    <button 
                        class="w-full brand-button"
                        on:click={() => showClaimMembershipModal = true}
                    >
                        Claim Membership
                    </button>
                {/if}
            </div>
        </div>
        {#if neurons.length === 0}
            <div class="flex flex-col items-center justify-center w-full p-8 text-center rounded-lg bg-BrandBlueComp/10">
                <p class="text-xl text-white">No Neurons Found</p>
                
                <div class="flex w-full flex-col gap-2">
                    <p class="text-xs">Add this hotkey to any neurons staked for 2 years that you would like to claim membership for.</p>
                    <div class="relative bg-BrandGrayShade4 rounded-lg p-4">
                        <button 
                            on:click={() => { appStore.copyTextAndShowToast($authStore.identity?.getPrincipal().toString() ?? "") }}
                            class="absolute top-2 right-2 text-BrandGrayShade2 hover:text-white"
                        >
                            <CopyIcon className="w-5 h-5" fill='#FFFFFF' />
                        </button>
                        <p class="text-BrandGrayShade2 font-mono text-sm break-all px-4">
                            {$authStore.identity?.getPrincipal().toString() ?? ""}
                        </p>
                        <h3 class="text-xxs text-white font-semibold">Your Principal ID</h3>
                    </div>
                </div>
            </div>
        {:else}
            <div class="grid gap-6 base:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5">
                {#each neurons as neuron}
                    <NeuronCard neuron={formatNeuronForCard(neuron)} {copyToClipboard} />
                {/each}
            </div>
        {/if}
    </div>
{/if}

{#if showHowToClaimModal}
    <HowToClaimModal onClose={() => showHowToClaimModal = false }  />
{/if}