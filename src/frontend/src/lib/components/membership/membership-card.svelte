<script lang="ts">
    import Card from '../shared/card.svelte';
    import ICFCCoinIcon from '$lib/icons/ICFCCoinIcon.svelte';
    import LogoIcon from '$lib/icons/LogoIcon.svelte';
    import InfoIcon from '$lib/icons/InfoIcon.svelte';
    import CloseIcon from '$lib/icons/CloseIcon.svelte';
    import { membershipStore } from '$lib/stores/membership-store';
    import { toasts } from '$lib/stores/toasts-store';
    import type { MembershipType } from "../../../../../declarations/backend/backend.did";

    export let membership: { type: string; tokensRequired: number; key: string };
    export let levelIndex: number;
    export let currentLevelIndex: number;
    export let totalStakedICFC: number;

    let isFlipped = false;

    const backgroundProperties = {
        opacity: "opacity-[0.10]",
        size: "w-[130%] h-[130%]",
        frontPosition: "-bottom-1 -right-24",
        backPosition: "-bottom-1 -left-[12.5rem]"
    };

    $: status = getLevelStatus();
    $: canClaim = status === "Claim" || status === "Upgrade";
    $: needsMoreTokens = totalStakedICFC < membership.tokensRequired;

    function getLevelStatus() {
        if (levelIndex === currentLevelIndex) return "Already Claimed";
        if (levelIndex < currentLevelIndex) return "Auto-Claimed";
        if (totalStakedICFC >= membership.tokensRequired) {
            return currentLevelIndex >= 0 ? "Upgrade" : "Claim";
        }
        return `Need ${Math.max(membership.tokensRequired - totalStakedICFC, 0).toLocaleString()} more ICFC`;
    }

    async function handleClaimMembership() {
        if (!canClaim) return;
        
        try {
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
        }
    }

    function handleFlip() {
        isFlipped = !isFlipped;
    }
</script>

<Card 
    {isFlipped} 
    onFlip={handleFlip}
    id={membership.key}
    frontClasses="bg-BrandBlueComp text-white overflow-hidden"
    backClasses="bg-BrandBlueComp text-white overflow-hidden"
>
    <div slot="front" class="flex flex-col h-full">
        <div class="flex items-center justify-between">
            <ICFCCoinIcon className="w-12 h-12" />
            <button on:click|stopPropagation={handleFlip} class="z-30 hover:scale-110 transition-transform">
                <InfoIcon className="w-7 h-7" fill="currentColor" />
            </button>
        </div>

        <div class="absolute transform {backgroundProperties.frontPosition} {backgroundProperties.opacity}">
            <LogoIcon className={backgroundProperties.size} />
        </div>

        <div class="relative z-10 mt-auto space-y-2">
            <p class="text-lg opacity-75">{membership.type}</p>
            <h3 class="text-xl">{membership.tokensRequired.toLocaleString()} ICFC</h3>
            {#if status === "Already Claimed"}
                <div class="already-claimed-membership-badge">
                    {status}
                </div>
            {:else if status === "Auto-Claimed"}
                <div class="auto-claimed-membership-badge">
                    {status}
                </div>

            {:else if status === "Claim" || status === "Upgrade"}
            <button 
                    on:click={handleClaimMembership}
                    class="brand-button"
                >
                    {status}
                </button>
            {/if}
        </div>
    </div>

    <div slot="back" class="flex flex-col h-full">
        <div class="flex items-center justify-between mb-4">
            <ICFCCoinIcon className="w-12 h-12" />
            <button on:click|stopPropagation={handleFlip} class="z-30 hover:scale-110 transition-transform">
                <CloseIcon className="w-7 h-7" fill="currentColor" />
            </button>
        </div>

        <div class="absolute transform {backgroundProperties.backPosition} {backgroundProperties.opacity}">
            <LogoIcon className={backgroundProperties.size} />
        </div>

        <div class="relative flex-1 space-y-4">
            <div>
                <p class="text-lg">Membership: {membership.type}</p>
                <p>Required: {membership.tokensRequired.toLocaleString()} ICFC</p>
                <p>Current Stake: {totalStakedICFC.toLocaleString()} ICFC</p>
                <p>Status: {status}</p>
            </div>
        </div>
    </div>
</Card>