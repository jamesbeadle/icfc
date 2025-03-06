<script lang="ts">
  import { onMount } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";

  import { userStore } from "$lib/stores/user-store";
  import { appStore } from "$lib/stores/app-store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthSignInParams, type AuthStoreData } from "$lib/stores/auth-store";
  
  import "../app.css";
  import IcfcAppsModal from "$lib/components/shared/icfc-apps-modal.svelte";
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import LogoIcon from "$lib/icons/LogoIcon.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";
  import type { Profile } from "../../../declarations/backend/backend.did";
  import LandingPage from "$lib/components/homepage/landingPage/landing-page.svelte";
  import IcfcLinkAccountsModal from "$lib/components/shared/icfc-link-accounts-modal.svelte";
  import Sidebar from "$lib/components/shared/sidebar.svelte";
  import { page } from "$app/state";
    
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
      user = await userStore.getProfile(principalId);
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
    <div class="flex h-screen w-full">
      {#if isLoading}
        <FullScreenSpinner />
      {:else}
        {#if isLoggedIn || isWhitepaper || isSale}
          <Sidebar {isMenuOpen} {toggleMenu} />
           {#if isMenuOpen}
              <div 
                class="fixed inset-0 bg-black/40 z-30 sm:bg-black/20 pointer-events-none sm:pointer-events-auto"
                on:click={toggleMenu}
              ></div>
            {/if}
          
          <header class="fixed top h-16 flex items-center justify-between w-full px-4 bg-gray-900 text-white shadow-md">
              <div class="flex items-center">
                <LogoIcon className='w-8' />
              </div>
          
              <div class="flex items-center gap-4">
                <button
                  on:click={toggleMenu}
                  class="fixed top-4 right-4 z-50 p-2 rounded-md bg-blue-600 text-white hover:bg-blue-700 transition-colors"
                >
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                  </svg>
                </button>
              </div>
          </header>
          <div class="w-full flex mt-16 p-4">
            <slot></slot>
          </div>
        {:else}
          <LandingPage />
        {/if}    
      {/if}
      <IcfcAppsModal isOpen={showApps} on:close={() => showApps = false} />
      <IcfcLinkAccountsModal isOpen={showLinkAccounts} on:close={() => showLinkAccounts = false} />
    </div>
    <Toasts />
{/await}
