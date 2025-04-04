<script lang="ts">
    import type { EligibleMembership, Neuron, ProfileDTO } from "../../../../../declarations/backend/backend.did";
    import { membershipStore } from "$lib/stores/membership-store";
    import { toasts } from "$lib/stores/toasts-store";
    import { getCurrentLevelIndex } from "$lib/utils/helpers";
    import { userStore } from "$lib/stores/user-store";
    import MembershipCard from "../membership/membership-card.svelte";
    import LocalSpinner from "../shared/local-spinner.svelte";
    
    let {profile, maxStakedICFC, refreshNeurons} = 
        $props<{ 
            profile: ProfileDTO; 
            maxStakedICFC: bigint;
            refreshNeurons: () => void;
        }>();

    let submittingClaim = $state(false);
    let isLoading = $state(false);
    let loadingMessage = $state("");

    const membershipLevels = [
        { type: "Monthly", tokensRequired: 1000, key: "Monthly" },
        { type: "Seasonal", tokensRequired: 10000, key: "Seasonal" },
        { type: "Lifetime", tokensRequired: 100000, key: "Lifetime" },
        { type: "Founding", tokensRequired: 1000000, key: "Founding" }
    ];
    const currentLevelIndex = $derived(profile ? getCurrentLevelIndex(profile.membershipType) : -1);

    async function handleClaimMembership() {
        toasts.addToast({ 
            type: "info", 
            message: "Claiming membership...",
            duration: 3000
        });
        try {
            loadingMessage = "Claiming membership";
            submittingClaim = true;
            await membershipStore.claimMembership();
            await userStore.cacheProfile();
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
            submittingClaim = false;
        }
    }
</script>
<div class="flex flex-col p-5 mt-4 space-y-6 border rounded-lg border-BrandGrayShade3/50">
    <p class="px-2 text-2xl text-white cta-text">Membership Status</p>
    <div class="border-t horizontal-divider border-BrandGrayShade3"></div>
    {#if isLoading || submittingClaim}
      <LocalSpinner message={loadingMessage} />
    {:else}
        <div class="grid grid-cols-1 gap-4 sm:gap-6 sm:grid-cols-2 lg:grid-cols-4">
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
    {/if}
    <div class="border-t horizontal-divider border-BrandGrayShade3"></div>
    <div class="flex justify-center w-full mt-8">
        <button 
            class="px-4 py-2 text-white transition border rounded-lg brand-button hover:bg-BrandBlack/50 hover:border-BrandBlue/80"
            onclick={refreshNeurons}
        >
            Refresh
        </button>
    </div>
    <div class="border-t horizontal-divider border-BrandGrayShade3"></div>
</div>