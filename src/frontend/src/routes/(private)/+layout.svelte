<script lang="ts">
    import FullScreenSpinner from '$lib/components/shared/full-screen-spinner.svelte';
    import type { Snippet } from 'svelte';
    
    const { children } = $props<{
        children: Snippet;  
    }>();

    let loading = $state(false);
    let loadingMessage = $state("Loading");
</script>

{#if loading}
    <FullScreenSpinner message={loadingMessage} />
{:else}
    {@render children()}
{/if}