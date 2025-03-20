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
  import LogoIcon from "$lib/icons/LogoIcon.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";
  import LandingPage from "$lib/components/homepage/landingPage/landing-page.svelte";
  import IcfcLinkAccountsModal from "$lib/components/shared/icfc-link-accounts-modal.svelte";
  import Sidebar from "$lib/components/shared/sidebar.svelte";
  import PortalHost from 'svelte-portal'
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { toasts } from "$lib/stores/toasts-store";
  import CreateUser from "$lib/components/profile/create-user.svelte";
  import { writable } from "svelte/store";
    import LoggedInHeader from "$lib/components/shared/logged-in-header.svelte";
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;

  let isLoading = writable(true);
  let showLinkAccounts = false;
  let isMenuOpen = false;
  let hasProfile = false;

  const init = async () => {
    await Promise.all([syncAuthStore()]);
    worker = await initAuthWorker();
  };

  const syncAuthStore = async () => {
    if (!browser) { return; }

    try {
      await authStore.sync();
    } catch (err: unknown) {
      toasts.addToast( { message: "Unexpected issue while syncing the status of your authentication.",
      type: "error" });
    }
  };

  onMount(async () => {
    worker = await initAuthWorker();
    if(!$authSignedInStore){
      hasProfile = false;
      $isLoading = false;
      return;
    }
    let profile = await userStore.getProfile();
    hasProfile = profile != undefined;
    $isLoading = false;
  });

  $: worker, $authStore, (() => worker?.syncAuthIdle($authStore))();

  $: (() => {
    if (!browser) {
      return;
    }

    if ($authStore === undefined) {
      return;
    }

    const spinner = document.querySelector("body > #app-spinner");
    spinner?.remove();
  })();

  $: isWhitepaper = browser && page.url.pathname === "/whitepaper";
  $: isSale = browser && page.url.pathname === "/sale";

  function toggleMenu() {
    isMenuOpen = !isMenuOpen;
  }

</script>

<svelte:window on:storage={syncAuthStore} />

{#await init()}
  <div in:fade>
    <FullScreenSpinner />
  </div>
{:then _}
    <div class="flex w-full h-screen">
      {#if $isLoading}
        <FullScreenSpinner />
      {:else}
        {#if hasProfile || isWhitepaper || isSale}
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
              <IcfcLinkAccountsModal isOpen={showLinkAccounts} on:close={() => showLinkAccounts = false} />  
            {/if}
        {:else}
          {#if $authSignedInStore}
              <CreateUser />
          {:else}  
            <LandingPage />
          {/if}
        {/if}    
      {/if}
    </div>
    <Toasts />
    <PortalHost />
{/await}
