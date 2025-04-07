<script lang="ts">
    import FullScreenSpinner from '$lib/components/shared/full-screen-spinner.svelte';
    import {onMount, type  Snippet } from 'svelte';
    import { authStore } from '$lib/stores/auth-store';
    import { toasts } from '$lib/stores/toasts-store';
    import { displayAndCleanLogoutMsg } from '$lib/services/auth.services';
    import { get } from 'svelte/store';
    import { goto } from '$app/navigation';
    let isLoading = $state(false);
    let loadingMessage = $state("Loading");

    interface Props {
        children: Snippet;
    }
    let { children }: Props = $props();

    onMount(async () => {
        isLoading = true;
        try {
            if (typeof window !== 'undefined') {
                displayAndCleanLogoutMsg();
            }
            loadingMessage = 'Checking Authentication';
            await authStore.sync();
            const identity = get(authStore).identity;
            if (!identity) {
                throw new Error('No identity found');
            }
            loadingMessage = 'Loading';
        } catch (error) {
            goto('/', { replaceState: true });
        } finally {
            isLoading = false;
        }
    });
</script>

{#if isLoading}
    <FullScreenSpinner message={loadingMessage} />
{:else}
    {@render children()}
{/if}