<script lang="ts">
    import type { ProfileDTO } from '../../../../../declarations/backend/backend.did';
    import { onMount } from 'svelte';
    import { userStore } from '$lib/stores/user-store';
    import { toasts } from '$lib/stores/toasts-store';
    import { goto } from '$app/navigation';
    import LocalSpinner from '$lib/components/shared/local-spinner.svelte';
    import ProfileMembership from '$lib/components/profile/profile-membership.svelte';

    let profile = $state<ProfileDTO | null>(null);
    let isLoading = $state(true);

    onMount(async () => {
        try {
            const profileResult = await userStore.getProfile();
            if (!profileResult) {
                goto('/', { replaceState: true });
                return;
            }
            
            profile = profileResult;
        } catch (error) {
            console.error('Profile fetch error:', error);
        } finally {
            isLoading = false;
        }
    });
</script>

{#if isLoading && !profile}
    <LocalSpinner />
{:else}
    <div class="flex flex-col w-full p-2">
        <ProfileMembership profile={profile!} />
    </div>
{/if}