<script lang="ts">
  import { onMount } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";

  import { userStore } from "$lib/stores/user-store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthSignInParams, type AuthStoreData } from "$lib/stores/auth-store";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";

  import "../app.css";
  import { goto } from "$app/navigation";
  import IcfcAppsModal from "$lib/components/shared/icfc-apps-modal.svelte";
  import { appStore } from "$lib/stores/app-store";
    import Toasts from "$lib/components/toasts/toasts.svelte";
    import LogoIcon from "$lib/icons/LogoIcon.svelte";

    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;
  let isLoggedIn: Boolean;
  let showApps = false;

  async function syncAuthStore() {
    if (!browser) return;
    try {
      await authStore.sync();
    } catch (err: unknown) {
      console.error(err);
    }
  }

  const init = async () => {
    await Promise.all([syncAuthStore()]);
    worker = await initAuthWorker();
  };

  onMount(async () => {
    await userStore.sync();
    await appStore.checkServerVersion();
    checkUser();
  });

  $: worker, $authStore, (() => worker?.syncAuthIdle($authStore))();

  $: (() => {
    if (!browser || $authStore === undefined) return;
    const spinner = document.querySelector("body > #app-spinner");
    spinner?.remove();
  })();

  async function handleLogin() {
    let params: AuthSignInParams = {
        domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
    };
    await authStore.signIn(params);
    checkUser();
  }

  async function checkUser(){
    console.log("checking")
    authStore.subscribe((store) => {
      console.log(store.identity)
      isLoggedIn = store.identity !== null && store.identity !== undefined;
    });
  }
</script>

<svelte:window on:storage={syncAuthStore} />

{#await init()}
  <div in:fade>
    <FullScreenSpinner />
  </div>
{:then _}
    <div class="flex h-screen w-full">
      {#if isLoggedIn}
        <header class="fixed top h-16 flex items-center justify-between w-full px-4 bg-gray-900 text-white shadow-md">
            <div class="flex items-center">
              <LogoIcon className='w-8' />
            </div>
        
            <div class="flex items-center gap-4">
            <button on:click={() => showApps = true} class="px-4 py-2 text-sm font-medium bg-gray-800 hover:bg-gray-700 rounded-lg transition">
                Apps
            </button>

            {#if !isLoggedIn}
                <button class="px-4 py-2 text-sm font-medium bg-blue-600 hover:bg-BrandBlue rounded-lg transition" on:click={handleLogin}>
                    Connect
                </button>
            {/if}
            </div>
        </header>
        <div class="w-full flex mt-16 p-4">
          <slot></slot>
        </div>
      {:else}
        <slot></slot>
      {/if}
    </div>
    <IcfcAppsModal isOpen={showApps} on:close={() => showApps = false} />
    <Toasts />
{/await}
