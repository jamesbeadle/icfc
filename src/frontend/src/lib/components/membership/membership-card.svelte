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
        opacity: "opacity-[0.10]",
        size: "w-[110%] h-[110%]",
        frontPosition: "-bottom-1 -right-32",
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
    frontClasses="bg-BrandBlueComp text-white border border-BrandGrayShade3/50"
    backClasses="bg-BrandBlueComp text-white border border-white"
>
        
    <div slot="front" class="flex flex-col h-full ">
        <div class="flex items-center justify-between">
            <div class="flex items-center justify-center ">
                {#if membership.type == "Monthly"}
                    <MonthlyMembershipIcon className="w-11" fill="white" />
                {/if}
    
                {#if membership.type == "Seasonal"}
                    <SeasonalMembershipIcon className="w-11" fill="white" />
                {/if}
    
                {#if membership.type == "Lifetime"}
                    <LifetimeMembershipIcon className="w-11" fill="white" />
                {/if}
    
                {#if membership.type == "Founding"}
                    <FoundingMembershipIcon className="w-11" fill="white" />
                {/if}
            </div>
            <ICFCCoinIcon className="w-10 h-10" />
        </div>

        <div class="absolute transform {backgroundProperties.frontPosition} {backgroundProperties.opacity}">
            <LogoIcon className={backgroundProperties.size} />
        </div>

        <div class="relative z-10 mt-auto space-y-2">
            <p class="text-lg opacity-75 cta-text">{membership.type}</p>
            <h3 class="text-xl">{membership.tokensRequired.toLocaleString()} ICFC</h3>
            {#if status === "Already Claimed"}
                <div class="w-full already-claimed-membership-badge">
                    {status}
                </div>
            {:else if status === "Auto-Claimed"}
                <div class="w-full auto-claimed-membership-badge">
                    {status}
                </div>
            {:else if status === "Claim" || status === "Upgrade"}
                <button 
                    on:click={claimMembership}
                    class="w-full small-brand-button"
                >
                    {status}
                </button>
            {:else if needsMoreTokens}
                <button 
                    on:click={loadNNS}
                    class="w-full nns-button"
                >
                    Stake {(membership.tokensRequired - totalStakedICFC).toLocaleString()} ICFC via NNS
                </button>
            {/if}
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