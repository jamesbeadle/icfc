<script lang="ts">
    import { onMount } from "svelte";
    import { busy } from "$lib/stores/busy-store";
    import { userStore } from "$lib/stores/user-store";
    import { membershipStore } from "$lib/stores/membership-store";
    import type { ProfileDTO, MembershipType } from "../../../../../declarations/backend/backend.did";

    export let userMembershipEligibility: MembershipType;

    let canClaimMembership = false;
    let profile: ProfileDTO | undefined = undefined;

    onMount(async () => {
        try{
            profile = await userStore.getProfile();
            console.log(profile)
        } catch {

        } finally {

        }
    });

    async function handleClaimMembership() {
        try {
            busy.start();
            const success = await membershipStore.claimMembership();
            if (success) {
                await userStore.getProfile();
            }
        } catch (error) {
            console.error("Error claiming membership:", error);
        } finally {
            busy.stop();
        }
    }
</script>

{#if profile}
    
    <div class="flex flex-col items-center w-full gap-2 mini:w-auto">
        {#if 'NotClaimed' in (profile?.membershipType ?? {})}
            <button 
                class="w-full p-3 text-base font-bold text-white transition-all duration-300 rounded-lg mini:w-auto bg-BrandBlue hover:bg-opacity-90 disabled:opacity-50 disabled:cursor-not-allowed"
                on:click={handleClaimMembership}
                disabled={'NotEligible' in userMembershipEligibility}
            >
                Claim Membership
            </button>
            <p class="text-sm text-center {'NotEligible' in userMembershipEligibility ? 'text-BrandError' : 'text-BrandSuccess'}">
                {#if 'NotEligible' in userMembershipEligibility}
                    Not Eligible for Membership
                {:else if 'Monthly' in userMembershipEligibility}
                    Eligible for Monthly Membership
                {:else if 'Seasonal' in userMembershipEligibility}
                    Eligible for Seasonal Membership
                {:else if 'Lifetime' in userMembershipEligibility}
                    Eligible for Lifetime Membership
                {:else if 'Founding' in userMembershipEligibility}
                    Eligible for Founding Membership
                {/if}
            </p>
        {:else}
            <p class="w-full p-3 text-lg text-center text-white rounded-lg mini:w-auto cta-text bg-BrandBlueComp">
                Membership Active
            </p>
        {/if}
    </div> 

{/if}