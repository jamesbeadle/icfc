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
  import Header from "$lib/components/shared/header.svelte";
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;

  let isLoading = true;
  let showLinkAccounts = false;
  let isMenuOpen = false;
  let hasProfile = false;
  let hasSynced = false;

  let syncTimeout: NodeJS.Timeout | null = null;
  let lastSync = 0;
  let lastAuthSignedInState: boolean | null = null;

  const init = async () => {
    console.log("Layout worker initialised, calling initAuthWorker");
    worker = await initAuthWorker();
    console.log("initAuthWorker complete, calling syncAuthStore");
    await syncAuthStore(); 
  };

  const debounceSyncAuthStore = (retryCount = 0, maxRetries = 5) => {
    console.log("Debouncing auth store");
    if (syncTimeout) clearTimeout(syncTimeout);
    syncTimeout = setTimeout(() => syncAuthStore(retryCount, maxRetries), 500);
    console.log("Debouncing auth store complete");
  };

  const throttleWorkerSync = () => {
    console.log("Throttle worker sync");
    const now = Date.now();
    if (now - lastSync < 5000) return;
    lastSync = now;
    worker?.syncAuthIdle($authStore);
    console.log("Throttle worker sync complete");
  };

  const syncAuthStore = async (retryCount = 0, maxRetries = 5) => {
    console.log("sync auth store begin");
    if (!browser) return;
    
    try {
      isLoading = true;
      console.log("sync auth store sync");
      await authStore.sync();
      console.log("sync auth store sync complete");
      
      if (!$authSignedInStore) {
        hasProfile = false;
        hasSynced = true;
        isLoading = false;
        return;
      }

      console.log("get user profile");
      let profile = await userStore.getProfile();
      console.log("get user profile complete");
      hasProfile = !!profile;
      hasSynced = true;
    } catch (err: any) {
      console.error("Error syncing auth store:", err);
      toasts.addToast({ 
        message: "Unexpected issue while syncing the status of your authentication. Please check your network or server configuration.",
        type: "error" 
      });
      if (err.message.includes('CORS')) {
        isLoading = false;
        hasSynced = true;
        return;
      }
    } finally {
      isLoading = false;
    }
  };

  const handleStorageEvent = (event: StorageEvent) => {
    console.log("begin handle storage event");
    hasSynced = false;
    debounceSyncAuthStore();
    console.log("handle storage event complete");
  };

  onMount(async () => {
    console.log("on mount");
    await init();
    console.log("on mount complete");
  });

  $: if (browser && $authSignedInStore !== lastAuthSignedInState) {
    
    console.log("reactive auth state and browser check");
    lastAuthSignedInState = $authSignedInStore;
    console.log("lastAuthSignedInState");
    console.log(lastAuthSignedInState);
    console.log("hasSynced");
    console.log(hasSynced);
    if (!hasSynced) {
      console.log("begin debounce auth store");
      debounceSyncAuthStore();
    }
  }

  $: if (worker && $authStore) {
    console.log("reactive worker and auth store check");
    throttleWorkerSync();
    console.log("end reactive worker and auth store check");
  }

  $: if (browser && $authStore !== undefined) {
    console.log("browser clean up");
    document.querySelector("body > #app-spinner")?.remove();
  }

  let currentPathname = '';
  $: if (browser && page.url) {
    console.log("page url check");
    if (page.url.pathname !== currentPathname) {
      currentPathname = page.url.pathname;
      if (!hasSynced) {
        debounceSyncAuthStore(); // Ensure sync on path change
      }
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
      <Header />
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