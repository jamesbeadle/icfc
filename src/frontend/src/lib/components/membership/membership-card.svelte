<script lang="ts">
    import Card from '../shared/card.svelte';
    import ICFCCoinIcon from '$lib/icons/ICFCCoinIcon.svelte';
    import LogoIcon from '$lib/icons/LogoIcon.svelte';
    import MonthlyMembershipIcon from '$lib/icons/MonthlyMembershipIcon.svelte';
    import SeasonalMembershipIcon from '$lib/icons/SeasonalMembershipIcon.svelte';
    import LifetimeMembershipIcon from '$lib/icons/LifetimeMembershipIcon.svelte';
    import FoundingMembershipIcon from '$lib/icons/FoundingMembershipIcon.svelte';
  
    export let membership: { type: string; tokensRequired: number; key: string };
    export let levelIndex: number;
    export let currentLevelIndex: number;
    export let totalStakedICFC: number;
    export let handleClaimMembership: () => void;

    const backgroundProperties = {
        size: "w-[110%] h-[110%]",
        frontPosition: "-bottom-1 -right-[10rem]",
        backPosition: "-bottom-1 -left-[12.5rem]"
    };
    
    function formatStakeAmount(amount: number): string {
        if (amount >= 1000) {
            return `${(amount / 1000)}K`;
        }
        return amount.toLocaleString();
    }

    $: status = getLevelStatus();
    $: canClaim = status === "Claim" || status === "Upgrade";
    $: needsMoreTokens = status.startsWith("Need");

    $: cardClass = (() => {
        switch (membership.type.toLowerCase()) {
            case 'monthly':
                return 'border-MonthlyPrimary bg-MonthlyTertiary text-MonthlySecondary border-2 ';
            case 'seasonal':
                return 'border-SeasonalPrimary bg-SeasonalTertiary text-SeasonalSecondary border-2 ';
            case 'lifetime':
                return 'border-LifetimePrimary bg-LifetimeTertiary text-LifetimeSecondary border-2 ';
            case 'founding':
                return 'border-FoundingPrimary bg-FoundingTertiary text-FoundingSecondary border-2 ';
            default:
                return 'border-BrandGrayShade3';
        }
    })();


    $: buttonClass = (() => {
        const baseClasses = {
            'monthly': 'bg-MonthlyPrimary border-MonthlySecondary',
            'seasonal': 'bg-SeasonalPrimary border-SeasonalSecondary',
            'lifetime': 'bg-LifetimePrimary border-LifetimeSecondary',
            'founding': 'bg-FoundingPrimary border-white',
        }[membership.type.toLowerCase()] || 'bg-BrandGrayShade3';
        
        const hoverClasses = status === "Already Claimed" || status === "Auto-Claimed" 
            ? ''
            : 'hover:bg-opacity-80 hover:border-opacity-80';

        return `${baseClasses} border ${hoverClasses}`;
    })();

    function getLevelStatus() {
        if (levelIndex === currentLevelIndex) return "Already Claimed";
        if (levelIndex < currentLevelIndex) return "Auto-Claimed";
        if (totalStakedICFC >= membership.tokensRequired) {
            return currentLevelIndex >= 0 ? "Upgrade" : "Claim";
        }
        const tokensNeeded = Math.max(membership.tokensRequired - totalStakedICFC, 0);
        return `Need ${formatStakeAmount(tokensNeeded)} more ICFC`;
    }

    function loadNNS(){
        window.open("https://nns.ic0.app/neurons/?u=gyito-zyaaa-aaaaq-aacpq-cai/", "_blank");
    }

    function claimMembership(){
        if(!canClaim) {return}
        handleClaimMembership();
    }

</script>

<Card 
    isFlipped={false} 
    onFlip={()=>('')} 
    id={membership.key} 
    isModal={false} 
    disableFlip={true}
    frontClasses="{cardClass} relative overflow-hidden"
    backClasses="{cardClass}"
>
    <div slot="front" class="relative flex flex-col h-full">
        <div class="absolute inset-0 pointer-events-none">
            <div class="absolute transform {backgroundProperties.frontPosition} opacity-20">
                <LogoIcon className={backgroundProperties.size} />
            </div>
        </div>

        <div class="relative flex flex-col h-full">
            <div class="flex items-center justify-between">
                <div class="flex items-center justify-center">
                    {#if membership.type == "Monthly"}
                        <MonthlyMembershipIcon className="w-11" />
                    {/if}
                    {#if membership.type == "Seasonal"}
                        <SeasonalMembershipIcon className="w-11" />
                    {/if}
                    {#if membership.type == "Lifetime"}
                        <LifetimeMembershipIcon className="w-11" />
                    {/if}
                    {#if membership.type == "Founding"}
                        <FoundingMembershipIcon className="w-11" />
                    {/if}
                </div>
                <ICFCCoinIcon className="w-10 h-10" />
            </div>

            <div class="mt-auto space-y-2">
                <p class="text-lg tracking-wider uppercase cta-text">{membership.type}</p>
                <div class="flex flex-row items-baseline gap-2">
                    <h3 class="text-2xl font-bold">{membership.tokensRequired.toLocaleString()}</h3>
                    <span class="text-sm">ICFC Required</span>
                </div>
                {#if status === "Already Claimed"}
                    <div class="w-full font-medium already-claimed-membership-badge {buttonClass} cursor-default">
                        {status}
                    </div>
                {:else if status === "Auto-Claimed"}
                    <div class="w-full font-medium auto-claimed-membership-badge {buttonClass} cursor-default">
                        {status}
                    </div>
                {:else if status === "Claim" || status === "Upgrade"}
                    <button 
                        on:click={claimMembership}
                        class="w-full font-medium transition-colors small-brand-button {buttonClass}"
                    >
                        {status}
                    </button>
                {:else if needsMoreTokens}
                    <button 
                        on:click={loadNNS}
                        class="w-full font-medium transition-colors nns-button {buttonClass}"
                    >
                        <span class="block text-sm">Stake</span>
                        <span class="block font-bold">{(membership.tokensRequired - totalStakedICFC).toLocaleString()} ICFC</span>
                    </button>
                {/if}
            </div>
        </div>
    </div>
</Card>

<style>
    .perspective {
        perspective: 1000px;
    }
    
    .transform-style-3d {
        transform-style: preserve-3d;
    }
    
    .backface-hidden {
        backface-visibility: hidden;
    }
    
    .rotate-y-180 {
        transform: rotateY(180deg);
    }
</style> 