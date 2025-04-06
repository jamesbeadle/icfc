<script lang="ts">
  import { userStore } from '$lib/stores/user-store';
  import { userIdCreatedStore, restrictedSaleStore } from '$lib/stores/user-control-store';
  import { onMount, type Snippet } from 'svelte';
  import { get } from 'svelte/store';
  import { goto } from '$app/navigation';
  import { toasts } from '$lib/stores/toasts-store';

  import FullScreenSpinner from '$lib/components/shared/full-screen-spinner.svelte';

  const { children } = $props<{
    children: Snippet;
  }>();

  let loading = $state(false);
  let syncError = $state<string | null>(null);

  onMount(async () => {
    try {
      loading = true;
      userStore.sync();
      
      if (get(restrictedSaleStore)?.data) {
        toasts.addToast({
          message: 'Unauthorized access - redirecting to sale portal',
          type: 'error',
          duration: 3000
        });
        await new Promise(resolve => setTimeout(resolve, 1500));
        await goto('/sale');
        return;
      }
      if (!get(userIdCreatedStore)?.data) {
        throw new Error('No user profile found');
      }
    } catch (err) {
        syncError = err instanceof Error ? err.message : 'Sync failed';
        goto('/', { replaceState: true });
    } finally {
      loading = false;
    }
  });
  
   
</script>
{#if syncError}
  <div class="flex flex-col items-center justify-center min-h-screen bg-gray-900 error-container">
      <p class="mb-4 text-xl text-red-500">Failed to load user profile</p>
      <p class="text-gray-400">Please try refreshing the page</p>
      <button 
          class="px-4 py-2 mt-4 text-white rounded bg-BrandGreen hover:bg-BrandGreen/80"
          onclick={() => window.location.reload()}
      >
          Refresh Page
      </button>
  </div>
{:else if loading}
  <FullScreenSpinner message="Verifying User Profile" />
{:else}
  {@render children()}
{/if}