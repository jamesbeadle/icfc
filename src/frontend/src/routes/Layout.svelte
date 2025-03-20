<script lang="ts">
  import { onMount } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { page } from "$app/state";

  import { userStore } from "$lib/stores/user-store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthStoreData } from "$lib/stores/auth-store";
  
  import "../app.css";
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";
  import LandingPage from "$lib/components/landing/landing-page.svelte";
  import IcfcLinkAccountsModal from "$lib/components/shared/icfc-link-accounts-modal.svelte";
  import Sidebar from "$lib/components/shared/sidebar.svelte";
  import PortalHost from 'svelte-portal';
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { toasts } from "$lib/stores/toasts-store";
  import CreateUser from "$lib/components/profile/create-user.svelte";
  import LoggedInHeader from "$lib/components/shared/logged-in-header.svelte";
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;

  let isLoading = true;
  let showLinkAccounts = false;
  let isMenuOpen = false;
  let hasProfile = false;

  const init = async () => {
    await syncAuthStore();
    worker = await initAuthWorker();
  };

  const syncAuthStore = async (retryCount = 0, maxRetries = 5) => {
    if (!browser) return;

    try {
      isLoading = true;
      await authStore.sync();
      
      if (!$authSignedInStore) {
        hasProfile = false;
        isLoading = false;
        return;
      }

      let profile = await userStore.getProfile();

      if (!profile && retryCount < maxRetries) {
        await new Promise(resolve => setTimeout(resolve, 2000));
        return syncAuthStore(retryCount + 1, maxRetries);
      }

      hasProfile = !!profile;
      isLoading = false;
    } catch (err: unknown) {
      console.error("Error syncing auth store:", err);
      toasts.addToast({ 
        message: "Unexpected issue while syncing the status of your authentication.",
        type: "error" 
      });
      isLoading = false;
    }
  };

  const handleStorageEvent = (event: StorageEvent) => {
    syncAuthStore();
  };

  onMount(async () => {
    await init();
  });

  $: if (browser && $authSignedInStore) {
    syncAuthStore();
  }

  $: if (worker && $authStore) {
    worker.syncAuthIdle($authStore);
  }

  $: if (browser && $authStore !== undefined) {
    document.querySelector("body > #app-spinner")?.remove();
  }

  let currentPathname = '';
  $: if (browser && page.url) {
    if (page.url.pathname !== currentPathname) {
      currentPathname = page.url.pathname;
      syncAuthStore();
    }
  }

  $: isWhitepaper = browser && page.url.pathname === "/whitepaper";
  $: isSale = browser && page.url.pathname === "/sale";

  function toggleMenu() {
    isMenuOpen = !isMenuOpen;
  }

  function handleProfileCreated() {
    hasProfile = true;
    isLoading = false;
  }
</script>

<svelte:window on:storage={handleStorageEvent} />

{#await init()}
  <div in:fade>
    <FullScreenSpinner />
  </div>
{:then _}
  <div class="flex w-full h-screen">
    {#if isLoading}
      <FullScreenSpinner />
    {:else if $authSignedInStore && !hasProfile && !isWhitepaper && !isSale}
      <CreateUser on:profileCreated={handleProfileCreated} />
    {:else if !$authSignedInStore && !isWhitepaper && !isSale}
      <LandingPage />
    {:else}
      <div class="relative flex flex-col w-full min-h-screen">
        <LoggedInHeader {toggleMenu} />
        <main class="flex-1 w-full mt-16 overflow-x-hidden">
          <slot></slot>
        </main>
      </div>
      <Sidebar {isMenuOpen} {toggleMenu} />
      {#if isMenuOpen}
        <button 
          class="fixed inset-0 z-30 pointer-events-none bg-black/40 sm:bg-black/20 sm:pointer-events-auto"
          on:click={toggleMenu}
          on:keydown={(e) => e.key === 'Enter' && toggleMenu()}
          aria-label="Close menu overlay"
        ></button>
      {/if}
      {#if showLinkAccounts}
        <IcfcLinkAccountsModal 
          isOpen={showLinkAccounts} 
          on:close={() => showLinkAccounts = false} 
        />  
      {/if}
    {/if}
    <Toasts />
    <PortalHost />
  </div>
{/await}