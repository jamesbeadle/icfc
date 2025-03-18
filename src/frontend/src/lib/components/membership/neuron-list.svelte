<script lang="ts">
    import { onMount } from "svelte";
    import { formatSecondsUnixDateToReadable, formatUnixNanoToDuration } from "$lib/utils/helpers";
    import { membershipStore } from "$lib/stores/membership-store";
    import { busy } from "$lib/stores/busy-store";
    import type { Neuron, MembershipType, UserNeuronsDTO } from "../../../../../declarations/backend/backend.did";

    import NeuronCard from './neuron-card.svelte';
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import ClaimMembershipButton from './claim-membership-button.svelte';
    import type { NeuronSummary } from "$lib/types/neuron-types";
    import { Principal } from "@dfinity/principal";
    import { toasts } from "$lib/stores/toasts-store";

    let isLoading: boolean = true;
    let neurons: Neuron[] = [];
    
    let userMembershipEligibility: MembershipType = { NotEligible: null };
    let userNeurons: UserNeuronsDTO | undefined;

    onMount(async () => {
        try {
            await getNeurons();
        } catch (error) {
            console.error("Error fetching funding data:", error);
        } finally {
            isLoading = false;
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

</script>

{#if isLoading}
    <LocalSpinner />
{:else}
    <div class="flex flex-col space-y-6">
        <div class="flex flex-col gap-4 mini:flex-row mini:justify-between mini:gap-0 mini:px-4">
            <h1 class="text-2xl lg:text-3xl cta-text">Your Neurons</h1>
            <ClaimMembershipButton {userMembershipEligibility} />
        </div>
        {#if neurons.length === 0}
            <div class="flex flex-col items-center justify-center w-full p-8 text-center rounded-lg bg-BrandBlueComp/10">
                <p class="text-xl text-white">No Neurons Found</p>
                <p class="mt-2 text-sm text-BrandGrayShade4">
                    Stake ICFC tokens to create neurons and unlock membership benefits
                </p>
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