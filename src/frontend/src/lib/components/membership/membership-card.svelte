<script lang="ts">
    import Card from '../shared/card.svelte';
    import LogoIcon from '$lib/icons/LogoIcon.svelte';
    import MonthlyMembershipIcon from '$lib/icons/MonthlyMembershipIcon.svelte';
    import SeasonalMembershipIcon from '$lib/icons/SeasonalMembershipIcon.svelte';
    import LifetimeMembershipIcon from '$lib/icons/LifetimeMembershipIcon.svelte';
    import FoundingMembershipIcon from '$lib/icons/FoundingMembershipIcon.svelte';
    import IcfcCoinIcon from '$lib/icons/ICFCCoinIcon.svelte';


    interface Props {
        membership: { type: string; tokensRequired: number; key: string };
        levelIndex: number;
        currentLevelIndex: number;
        totalStakedICFC: number;
        handleClaimMembership: () => void;
    }

    let { membership, levelIndex, currentLevelIndex, totalStakedICFC, handleClaimMembership  } : Props = $props();
  
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


    let status = getLevelStatus();
    let canClaim = status === "Claim" || status === "Upgrade";
    let needsMoreTokens = status.startsWith("Need");

    let cardClass = (() => {
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


    let buttonClass = (() => {
        const baseClasses = {
            'monthly': 'bg-MonthlyPrimary border-MonthlySecondary',
            'seasonal': 'bg-SeasonalPrimary border-SeasonalSecondary',
            'lifetime': 'bg-LifetimePrimary border-LifetimeSecondary',
            'founding': 'bg-FoundingPrimary border-white text-black',
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
<!--
<Card 
    isFlipped={false} 
    onFlip={()=>('')} 
    id={membership.key} 
    disableFlip={true}
    frontClasses={`${cardClass} relative overflow-hidden`}
    backClasses={cardClass}
>
</Card>
 -->   

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