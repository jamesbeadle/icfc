<script lang="ts">
    import HowToModalAddICFC from '$lib/components/membership/how-to-addICFC-modal.svelte';
    import HowToModalStakeICFC from '$lib/components/membership/how-to-stakeICFC-modal.svelte';
    import type { ProfileDTO } from '../../../../../declarations/backend/backend.did';
    import { onMount } from 'svelte';
    import { userStore } from '$lib/stores/user-store';
    import { toasts } from '$lib/stores/toasts-store';
    import LocalSpinner from '$lib/components/shared/local-spinner.svelte';
    import ProfileMembership from '$lib/components/profile/profile-membership.svelte';

    let showMembershipDetailsModal = false;
    let showHowToStakeICFCModal = false;
    let showHowToAddICFCModal = false;
    let profile = $state<ProfileDTO | null>(null);
    let isLoading = $state(true);



    onMount(async () => {
        try {
            const profileResult = await userStore.getProfile();
            if (!profileResult) {
                toasts.addToast({ type: 'error', message: 'No profile found.' });
                return;
            }
            
            profile = profileResult;
        } catch (error) {
            toasts.addToast({ type: 'error', message: 'Error fetching user profile.' });
            console.error('Profile fetch error:', error);
        } finally {
            isLoading = false;
        }
    });

    function openHowToStakeICFCModal() {
        showHowToStakeICFCModal = true;
    }

    function closeHowToStakeICFCModal() {
        showHowToStakeICFCModal = false;
    }

    function openHowToAddICFCModal() {
        showHowToAddICFCModal = true;
    }

    function closeHowToAddICFCModal() {
        showHowToAddICFCModal = false;
    }
</script>

{#if isLoading && !profile}
    <LocalSpinner />
{:else}

    <div class="flex flex-col w-full p-8 space-y-4">
        <h1 class="flex w-full brand-title">ICFC Membership</h1>
        <p class="brand-sub-title">
            Stake ICFC tokens for max time to unlock exclusive membership benefits
        </p>

        <ProfileMembership profile={profile!} />
    </div>

    {#if showHowToStakeICFCModal}
        <HowToModalStakeICFC
            showModal={showHowToStakeICFCModal}
            onClose={closeHowToStakeICFCModal}
        />
    {/if}

    {#if showHowToAddICFCModal}
        <HowToModalAddICFC
            showModal={showHowToAddICFCModal}
            onClose={closeHowToAddICFCModal}
        />
    {/if}
{/if}