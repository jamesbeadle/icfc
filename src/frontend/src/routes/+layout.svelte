<script lang="ts">
  import { onMount, type Snippet } from "svelte";
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { get } from "svelte/store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { displayAndCleanLogoutMsg } from "$lib/services/auth.services";
  import { authStore, type AuthStoreData } from "$lib/stores/auth-store";
  import { initUserProfile } from "$lib/services/user-profile-service";

  import "../app.css";
  
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";
  import PortalHost from 'svelte-portal';
  import HeaderController from "$lib/components/shared/header/header-controller.svelte";

  interface Props { children: Snippet }
  let { children }: Props = $props();
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;
  let isLoading = $state(true);

  const init = async () => {
    console.log('init called')
    if (!browser) return;
    console.log('auth store sync called')
    await authStore.sync();
    console.log('auth store sync complete')
    displayAndCleanLogoutMsg();
    console.log('end init')
  };

  onMount(async () => {
    console.log('mounting')
    if (browser) {
      document.querySelector('#app-spinner')?.remove();
    }
    console.log('init')
    await init();
    console.log('init end')
    const identity = get(authStore).identity;
    if (identity) {
      try {
        console.log('init user profile')
        await initUserProfile({ identity });
        console.log('init user profile end')
      } catch (err) {
        console.error('initUserProfile error:', err);
      }
    }
    worker = await initAuthWorker();
    isLoading = false;
  });
</script>

<svelte:window on:storage={authStore.sync} />

{#if browser && isLoading}
  <div in:fade>
    <FullScreenSpinner />
  </div>
{:else}
  <HeaderController>
    {@render children()}
  </HeaderController>
  <Toasts />
  <PortalHost />
{/if}