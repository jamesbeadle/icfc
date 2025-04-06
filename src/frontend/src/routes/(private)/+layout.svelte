<script lang="ts">
    import FullScreenSpinner from '$lib/components/shared/full-screen-spinner.svelte';
    import type { ProfileDTO } from '../../../../declarations/backend/backend.did';
    import type { OptionIdentity } from '$lib/types/identity';
    import type { Snippet } from 'svelte';
    
    const { profile, identity, children } = $props<{
        profile: ProfileDTO;
        identity?: OptionIdentity;
        children: (data: { 
            profile: ProfileDTO; 
            identity?: OptionIdentity 
        }) => Snippet;
    }>();

    let loading = $state(false);
    let loadingMessage = $state("");
</script>

{#if loading}
    <FullScreenSpinner message={loadingMessage} />
{:else}
    {@render children({ profile, identity })}
{/if}