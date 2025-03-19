<script lang="ts">
    import { onMount } from "svelte";
    import { userStore } from "$lib/stores/user-store";
    import { membershipStore } from "$lib/stores/membership-store";
    import type { ProfileDTO, MembershipType } from "../../../../../declarations/backend/backend.did";
    import Modal from "../shared/modal.svelte";
    import LogoIconWhite from "$lib/icons/LogoIconWhite.svelte";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import { toasts } from "$lib/stores/toasts-store";

    export let onClose: () => void;
    export let userMembershipEligibility: MembershipType;
    export let totalStakedICFC: number = 0;

    let isLoading = true;
    let profile: ProfileDTO | undefined = undefined;
    let submittingClaim = false;

    const membershipLevels = [
        { type: "Monthly", tokensRequired: 1000, key: "Monthly" },
        { type: "Seasonal", tokensRequired: 10000, key: "Seasonal" },
        { type: "Lifetime", tokensRequired: 100000, key: "Lifetime" },
        { type: "Founding", tokensRequired: 1000000, key: "Founding" }
    ];

    $: currentLevelIndex = profile ? getCurrentLevelIndex(profile.membershipType) : 0;

    onMount(async () => {
        await loadProfile();
        isLoading = false;
    });

    async function loadProfile() {
        profile = await userStore.getProfile();
    }

    function getCurrentLevelIndex(membershipType: MembershipType): number {
        if ("Founding" in membershipType) return 3;
        if ("Lifetime" in membershipType) return 2;
        if ("Seasonal" in membershipType) return 1;
        if ("Monthly" in membershipType) return 0;
        return -1;
    }

    function getLevelStatus(levelIndex: number) {
        console.log(`Get level status ${levelIndex}`)
        const isClaimed = levelIndex <= currentLevelIndex;
        console.log(`isClaimed ${isClaimed}`)
        const level = membershipLevels[levelIndex];
        console.log(`level ${level}`)
        const hasEnoughTokens = totalStakedICFC >= level.tokensRequired;
        console.log(`hasEnoughTokens ${hasEnoughTokens}`)
        const isEligible = levelIndex <= membershipLevels.findIndex(l => l.key in userMembershipEligibility);
        console.log(`isEligible ${isEligible}`)

        if (isClaimed) return "Already Claimed";
        if (isEligible && hasEnoughTokens) return "Claim Membership";
        if (currentLevelIndex >= 0 && isEligible) return "Upgrade";
        return `Stake ${level.tokensRequired} ICFC`;
    }

    async function handleClaimMembership() {
        try {
            submittingClaim = true;
            const success = await membershipStore.claimMembership();
            if (success) {
                await loadProfile();
                toasts.addToast({ type: "success", message: "Successfully claimed membership." });
                submittingClaim = false;
            }
        } catch (error) {
            console.error("Error claiming membership:", error);
            toasts.addToast({ type: "error", message: "Failed to claim membership." });
        } finally {
            submittingClaim = false;
        }
    }
</script>

<Modal {onClose}>
    {#if isLoading}
        <LocalSpinner />
    {:else}
        <div class="flex flex-col space-y-4">
            <p>Total Max Staked ICFC: {totalStakedICFC.toLocaleString('en-US', { maximumFractionDigits: 0 })}</p>
            
            {#if submittingClaim}
                <LocalSpinner />
            {:else}
                <div class="grid gap-6 base:grid-cols-2 lg:grid-cols-4">
                    {#each membershipLevels as level, index}
                        {@const status = getLevelStatus(index)}
                        {@const isClaimed = status === "Already Claimed"}
                        {@const isEligible = index <= membershipLevels.findIndex(l => l.key in userMembershipEligibility)}
                        <div class={`flex flex-col p-4 space-y-2 ${isEligible ? "bg-BrandBlue text-white" : "bg-BrandGrayShade4 text-black"}`}>
                            <p class="w-full text-center text-xl">{level.type} Membership</p>
                            <div class="p-4 w-full text-center justify-center flex items-center">
                                <LogoIconWhite className="w-12" />
                            </div>
                            {#if isEligible && !isClaimed}
                                <button on:click={handleClaimMembership} class="w-full brand-button" disabled={isClaimed}>
                                    {status}
                                </button>
                            {:else if !isEligible}
                                <a href="https://nns.ic0.app/" target="_blank" class="brand-button-purple">
                                    <div class="flex flex-col text-center items-center justify-center">
                                        <p>{(level.tokensRequired - totalStakedICFC) > 0 ? (level.tokensRequired - totalStakedICFC).toLocaleString('en-US', { maximumFractionDigits: 0 }) : 0} ICFC Remaining</p>                                    <p>Stake in NNS</p>
                                    </div>
                                </a>
                            {:else}
                                <p>{status}</p>
                            {/if}
                        </div>
                    {/each}
                </div>
            {/if}
        </div>
    {/if}
</Modal>