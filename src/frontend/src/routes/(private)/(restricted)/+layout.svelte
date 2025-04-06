<script lang="ts">
    import { restrictedSaleStore } from '$lib/stores/user-control-store';
    import { get } from 'svelte/store';
    import { onMount, type Snippet } from 'svelte';

    import FullScreenSpinner from '$lib/components/shared/full-screen-spinner.svelte';

    const { children } = $props<{
      children: Snippet;
    }>();
  
    
    let loading = $state(false);
    let syncError = $state<string | null>(null);

    onMount(async () => {
      try {
      loading = true;
      //TODO JUST UNCOMMENT THIS
      //await syncSaleProfile();
      
      // if (get(!restrictedSaleStore).data) {
      //   throw new Error('No sale profile found');
      // }
    } catch (err) {
      syncError = err instanceof Error ? err.message : 'Sync failed';
    } finally {
      loading = false;
    }
  });
  
   
  </script>
  {#if syncError}
    <div class="error-message">
      Failed to verify access: {syncError}
    </div>
  {:else if loading}
    <FullScreenSpinner message="Verifying Sale Profile" />
  {:else}
    {@render children()}
  {/if}