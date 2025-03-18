<script lang="ts">
  import { onMount } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { page } from "$app/state";

  import { userStore } from "$lib/stores/user-store";
  import { appStore } from "$lib/stores/app-store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthSignInParams, type AuthStoreData } from "$lib/stores/auth-store";
  import type { Profile } from "../../../declarations/backend/backend.did";
  
  import "../app.css";
  import IcfcAppsModal from "$lib/components/shared/icfc-apps-modal.svelte";
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import LogoIcon from "$lib/icons/LogoIcon.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";
  import LandingPage from "$lib/components/homepage/landingPage/landing-page.svelte";
  import IcfcLinkAccountsModal from "$lib/components/shared/icfc-link-accounts-modal.svelte";
  import Sidebar from "$lib/components/shared/sidebar.svelte";
  import PortalHost from 'svelte-portal'
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;
  let isLoading = true;
  let isLoggedIn = false;
  let showApps = false;
  let showLinkAccounts = false;
  let user: Profile | null = null;
  let isMenuOpen = false;


  const init = async () => {
    await Promise.all([syncAuthStore()]);
    worker = await initAuthWorker();
    await Promise.all([syncUser()]);
  };

  async function syncUser(){
    let principalId = $authStore.identity?.getPrincipal().toString();
    if(principalId){
      user = await userStore.getProfile();
    }
  }

  async function syncAuthStore() {
    if (!browser) return;
    try {
      await authStore.sync();
      isLoggedIn = $authStore.identity !== null && $authStore.identity !== undefined;
    } catch (err: unknown) {
      console.error(err);
    }
  }

  
  onMount(async () => {
    try{
      await appStore.checkServerVersion();
    } catch {
      console.error("error syncing version");
    } finally {
      isLoading = false;
    }
  });

  $: worker, $authStore, (() => worker?.syncAuthIdle($authStore))();

  $: (() => {
    if (!browser || $authStore === undefined) return;
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
      {#if isLoading}
        <FullScreenSpinner />
      {:else}
        {#if isLoggedIn || isWhitepaper || isSale}
          <div class="relative flex flex-col w-full min-h-screen">
            <header class="fixed top-0 left-0 right-0 z-30 flex items-center justify-between h-16 px-4 text-white bg-gray-900 shadow-md">
              <a href="/" class="flex items-center">
                <LogoIcon className='w-8' />
              </a>

              <div class="flex items-center gap-4">
                <button
                  on:click={toggleMenu}
                  class="fixed z-50 p-2 text-white transition-colors bg-blue-600 rounded-md top-4 right-4 hover:bg-blue-700"
                  aria-label="Toggle menu"
                >
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                  </svg>
                </button>
              </div>
            </header>

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
        {:else}
          <LandingPage />
        {/if}    
      {/if}
      <IcfcAppsModal isOpen={showApps} onClose={() => showApps = false} />
      <IcfcLinkAccountsModal isOpen={showLinkAccounts} on:close={() => showLinkAccounts = false} />
    </div>
    <Toasts />
    <PortalHost />
{/await}
