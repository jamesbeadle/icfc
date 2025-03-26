<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";
    import { onMount } from "svelte";
    import type { EligibleMembership, Neuron, ProfileDTO } from "../../../../../declarations/backend/backend.did";
    import CopyPrincipal from "./copy-principal.svelte";
    import { membershipStore } from "$lib/stores/membership-store";
    import { getCurrentLevelIndex, sortByHighestNeuron } from "$lib/utils/helpers";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import AvailableMembership from "../membership/available-membership.svelte";
    import MembershipCard from "../membership/membership-card.svelte";
    
    export let profile: ProfileDTO;
    let isLoading = true;
    let neurons: Neuron[] = [];
    let userMembershipEligibility: EligibleMembership | null = null;
    let maxStakedICFC = 0n;
    let submittingClaim = false;

    const membershipLevels = [
        { type: "Monthly", tokensRequired: 1000, key: "Monthly" },
        { type: "Seasonal", tokensRequired: 10000, key: "Seasonal" },
        { type: "Lifetime", tokensRequired: 100000, key: "Lifetime" },
        { type: "Founding", tokensRequired: 1000000, key: "Founding" }
    ];

    $: currentLevelIndex = profile ? getCurrentLevelIndex(profile.membershipType) : -1;

    onMount(async () => {
        try{
            await loadData();
        } catch {
            toasts.addToast({type: 'error', message: 'Failed to load data.'});
        } finally {
            isLoading = false;
        }
    });

    async function loadData(){
        try {
            await getNeurons();
        } catch (error) {
            console.error("No neurons found:", error);
        } finally {
            isLoading = false;
        }
    }

    async function getNeurons() {
        let neuronsResult = await membershipStore.getUserNeurons();
        if (neuronsResult) {
            neurons = neuronsResult.userNeurons.sort(sortByHighestNeuron);
            userMembershipEligibility = neuronsResult.userMembershipEligibility;
            maxStakedICFC = neuronsResult.totalMaxStaked;
        }
    }
    
    async function refreshNeurons() {
        try{
            isLoading = true;
            await loadData();
        } catch {
            toasts.addToast({ type: 'error', message: 'Failed to refresh neurons' })
        } finally {
            isLoading = false;
        }
    }
    
    async function handleClaimMembership() {
        
        try {
            isLoading = true;
            await membershipStore.claimMembership();
            toasts.addToast({ 
                type: "success", 
                message: `Successfully claimed membership.` 
            });
        } catch (error) {
            console.error("Error claiming membership:", error);
            toasts.addToast({ 
                type: "error", 
                message: "Failed to claim membership." 
            });
        } finally {
            isLoading = false;
        }
    }
</script>

<div class="flex flex-col space-y-4">
    <p class="cta-text text-lg text-white">Your ICFC Membership</p>
    <p class="text-BrandGrayShade5">
      Please see information below related to your neuron based membership.
    </p>

    <CopyPrincipal />


    {#if isLoading || submittingClaim}
      <LocalSpinner />
    {:else}
      {#if neurons.length > 0}
        <div class="flex flex-col space-y-4">

          <AvailableMembership {neurons} {refreshNeurons} availableMembership={userMembershipEligibility?.membershipType!} {maxStakedICFC} />

            <div class="grid gap-4 sm:gap-6 grid-cols-1 sm:grid-cols-2 lg:grid-cols-4">
                {#each membershipLevels as level, index}
                    <div class="w-full">
                        <MembershipCard 
                            membership={level} 
                            levelIndex={index}
                            {currentLevelIndex} 
                            totalStakedICFC={Number(maxStakedICFC)}
                            on:claim={() => submittingClaim = true}
                            {handleClaimMembership}
                        />
                    </div>
                {/each}
            </div>

        </div>
      {/if}
    {/if}
    <div class="h-6"></div>
</div>



