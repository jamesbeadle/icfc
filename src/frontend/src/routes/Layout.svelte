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
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;
  let isLoading = true;
  let isLoggedIn = false;
  let showApps = false;
  let user: Profile | null = null;


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

  async function handleLogout() {
    await authStore.signOut();
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
        {#if isLoggedIn}
          <header class="fixed top h-16 flex items-center justify-between w-full px-4 bg-gray-900 text-white shadow-md">
              <div class="flex items-center">
                <LogoIcon className='w-8' />
              </div>
          
              <div class="flex items-center gap-4">
                <button on:click={() => showApps = true} class="px-4 py-2 text-sm font-medium bg-gray-800 hover:bg-gray-700 rounded-lg transition">
                    Apps
                </button>
                <button class="px-4 py-2 text-sm font-medium bg-blue-600 hover:bg-BrandBlue rounded-lg transition" on:click={handleLogout}>
                  Disconnect
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
    </div>
    <Toasts />
{/await}
