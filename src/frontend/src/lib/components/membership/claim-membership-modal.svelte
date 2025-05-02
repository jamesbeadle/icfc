<script lang="ts">
    import { onMount } from "svelte";
    import { userStore } from "$lib/stores/user-store";
    import type { ProfileDTO } from "../../../../../declarations/backend/backend.did";
    import Modal from "../shared/global/modal.svelte";
    import LocalSpinner from "../shared/global/local-spinner.svelte";
    import MembershipCard from "./membership-card.svelte";
    import { getCurrentLevelIndex } from "$lib/utils/helpers";
    import IcfcCoinIcon from "$lib/icons/ICFCCoinIcon.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import { membershipStore } from "$lib/stores/membership-store";
    import CopyPrincipal from "../profile/copy-principal.svelte";

    interface Props {
        closeClaimMembership: (reload: boolean) => void;
        totalStakedICFC: number;
    }

    let { closeClaimMembership, totalStakedICFC } : Props = $props();

    let isLoading = true;
    let profile: ProfileDTO | undefined = undefined;
    let submittingClaim = false;

    const membershipLevels = [
        { type: "Monthly", tokensRequired: 1000, key: "Monthly" },
        { type: "Seasonal", tokensRequired: 10000, key: "Seasonal" },
        { type: "Lifetime", tokensRequired: 100000, key: "Lifetime" },
        { type: "Founding", tokensRequired: 1000000, key: "Founding" }
    ];

    $: currentLevelIndex = profile ? getCurrentLevelIndex(profile.membershipType) : -1;

    onMount(async () => {
        await loadProfile();
        isLoading = false;
    });

    async function loadProfile() {
        profile = await userStore.getProfile();
    }

    async function handleRefresh() {
        isLoading = true;
        await loadProfile();
        isLoading = false;
    }

    async function copyTextAndShowToast(text: string) {
        try {
            await navigator.clipboard.writeText(text);
            toasts.addToast({
            type: "success",
            message: "Copied to clipboard.",
            duration: 2000,
            });
        } catch (err) {
            console.error("Failed to copy:", err);
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
            closeClaimMembership(true);
            isLoading = false;
        }
    }

    function onClose(){
        closeClaimMembership(false);
    }
</script>

<Modal {onClose}>
    {#if isLoading}
        <LocalSpinner />
    {:else}
        <div class="flex flex-col space-y-6">
            <h2 class="text-2xl text-white cta-text">Claim Membership</h2>
            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
                <div class="flex flex-row items-center gap-2">
                    <IcfcCoinIcon className="w-5 h-5" />
                    <p class="text-lg sm:text-xl font-semibold">
                        Total Max Staked ICFC: {totalStakedICFC.toLocaleString('en-US', { maximumFractionDigits: 0 })}
                    </p>
                </div>
                <button 
                    on:click={handleRefresh}
                    class="brand-button"
                >
                    Refresh
                </button>
            </div>
            <div class="flex w-full">
                <div class="flex flex-col gap-2">
                    <h3 class="text-lg text-white font-semibold">Your Principal ID</h3>
                    <p class="text-xs">Add this hotkey to any neurons staked for 2 years that you would like to claim membership for.</p>
                   <CopyPrincipal />
                </div>
            </div>

            {#if submittingClaim}
                <LocalSpinner />
            {:else}
                <div class="grid gap-4 sm:gap-6 grid-cols-1 sm:grid-cols-2 lg:grid-cols-4">
                    {#each membershipLevels as level, index}
                        <div class="w-full">
                            <MembershipCard 
                                membership={level} 
                                levelIndex={index}
                                {currentLevelIndex} 
                                {totalStakedICFC}
                                on:claim={() => submittingClaim = true}
                                {handleClaimMembership}
                            />
                        </div>
                    {/each}
                </div>
            {/if}
        </div>
    {/if}
</Modal>