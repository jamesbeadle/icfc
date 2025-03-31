<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";
    import { onMount } from "svelte";
    import type { EligibleMembership, Neuron, ProfileDTO } from "../../../../../declarations/backend/backend.did";
    import { sortByHighestNeuron } from "$lib/utils/helpers";
    import { membershipStore } from "$lib/stores/membership-store";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import AvailableMembership from "../membership/available-membership.svelte";
    import ProfileMembershipStatus from "./profile-membership-status.svelte";
    import TabContainer from "../shared/tab-container.svelte";
    
    const { profile } = $props<{ profile: ProfileDTO }>();
    
    let isLoading = $state(true);
    let neurons: Neuron[] = $state([]);
    let userMembershipEligibility: EligibleMembership | null = $state(null);
    let maxStakedICFC = $state(0n);

    const tabs = [
        { id: "neurons", label: "Neurons" },
        { id: "membership", label: "Status" },
    ];
    let activeTab = $state("neurons");

    function setActiveTab(tab: string): void {
        activeTab = tab;
    }

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

    function getMembershipStatus(): string {
        const membershipType = userMembershipEligibility?.membershipType;
        if (!membershipType) return "None";
        
        if ("Monthly" in membershipType) return "Monthly";
        if ("Seasonal" in membershipType) return "Seasonal";
        if ("Lifetime" in membershipType) return "Lifetime";
        if ("Founding" in membershipType) return "Founding";
        
        return "None";
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
</script>

<div class="flex flex-col p-4 space-y-6">
    <div class="flex items-center space-x-4">
        <p class="text-2xl text-white cta-text">Your ICFC Membership</p>
        <span class="status">{getMembershipStatus()}</span>
    </div>
    <p class="text-BrandGrayShade5">
      Please see information below related to your neuron based membership.
    </p>

    {#if isLoading}
      <LocalSpinner />
    {:else}
      {#if neurons.length >= 0}
        <div class="flex flex-col p-5 rounded-lg">
            <TabContainer {tabs} {activeTab} {setActiveTab} />
            {#if activeTab == "neurons"}
                <AvailableMembership {neurons} {refreshNeurons} availableMembership={userMembershipEligibility?.membershipType!} {maxStakedICFC} isProfile={true} />
            {:else if activeTab == "membership"}
                <ProfileMembershipStatus {profile} {maxStakedICFC} {refreshNeurons}/>
            {/if}
        </div>
      {/if}
    {/if}
</div>



