<script lang="ts">
    import MonthlyMembershipIcon from "$lib/icons/MonthlyMembershipIcon.svelte";
    import SeasonalMembershipIcon from "$lib/icons/SeasonalMembershipIcon.svelte";
    import LifetimeMembershipIcon from "$lib/icons/LifetimeMembershipIcon.svelte";
    import FoundingMembershipIcon from "$lib/icons/FoundingMembershipIcon.svelte";
    import type { MembershipType } from "../../../../../../declarations/backend/backend.did";

    export let availableMembership: MembershipType;
</script>


<div class="flex flex-col items-center justify-center w-full p-4 space-y-2 text-lg text-center md:w-1/2">
    <p class="text-xl text-white">Membership Level:</p>
    <div class="flex items-center h-8">
        {#if Object.keys(availableMembership)[0].toLowerCase() === 'monthly'}
            <div class="flex flex-row items-center space-x-2">
                <MonthlyMembershipIcon className="w-7" />
                <p class="text-lg text-white">Monthly</p>
            </div>
        {:else if Object.keys(availableMembership)[0].toLowerCase() === 'seasonal'}
            <div class="flex flex-row items-center space-x-2">
                <SeasonalMembershipIcon className="w-7" />
                <p class="text-lg text-white">Seasonal</p>
            </div>
        {:else if Object.keys(availableMembership)[0].toLowerCase() === 'lifetime'}
            <div class="flex flex-row items-center space-x-2">
                <LifetimeMembershipIcon className="w-7" />
                <p class="text-lg text-white">Lifetime</p>
            </div>
        {:else if Object.keys(availableMembership)[0].toLowerCase() === 'founding'}
            <div class="flex flex-row items-center space-x-2">
                <FoundingMembershipIcon className="w-7" />
                <p class="text-lg text-white">Founding</p>
            </div>
        {:else}
            <p class="text-BrandGrayShade1">Not Eligible</p>
        {/if}
    </div>
    {#if Object.keys(availableMembership)[0].toLowerCase() === 'founding'}
        <p class="text-base text-BrandGrayShade3">Congratulations! You are a Founding Member.</p>
    {:else}
        <p class="text-base text-BrandGrayShade3">You can upgrade your membership level at any time.</p>
    {/if}
</div>