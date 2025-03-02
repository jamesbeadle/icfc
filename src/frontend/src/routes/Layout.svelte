<script lang="ts">
  import { onMount } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";

  import { userStore } from "$lib/stores/user-store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthSignInParams, type AuthStoreData } from "$lib/stores/auth-store";
  import "../app.css";
  
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";
  import IcfcAppsModal from "$lib/components/shared/icfc-apps-modal.svelte";
  import { appStore } from "$lib/stores/app-store";
  import Header from "$lib/components/shared/header.svelte";
  import Footer from "$lib/components/shared/footer.svelte";
    import { writable } from "svelte/store";
    import Landing from "$lib/components/landing/landing.svelte";

  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;

  let isLoading = true;
  let isLoggedIn = false;
  let showApps = writable(false);

  const init = async () => {
    await Promise.all([syncAuthStore()]);
    worker = await initAuthWorker();
  };

  async function syncAuthStore() {
    if (!browser) return;
    try {
      await authStore.sync();
    } catch (err: unknown) {
      console.error(err);
    } finally {
    }
  }

  onMount(async () => {
    try{
      authStore.subscribe((store) => {
          isLoggedIn = store.identity !== null && store.identity !== undefined;
          userStore.sync();
      });
      await appStore.checkServerVersion();
    } catch {

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

  async function onLogin() {
    let params: AuthSignInParams = {
        domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
    };
    await authStore.signIn(params);
  }

  async function onLogout() {
    await authStore.signOut();
  }

</script>

<svelte:window on:storage={syncAuthStore} />

{#await init()}
  <div in:fade>
    <FullScreenSpinner />
  </div>
{:then _}
  <div class="flex flex-col justify-between h-screen default-text">
    {#if isLoading}
      <FullScreenSpinner />
    {:else}

      {#if isLoggedIn}
        <Header {onLogout} {showApps} />
        <main class="page-wrapper">
          <slot />
        </main>
        <Footer />
      {:else}

        <Landing />

      {/if}
      <IcfcAppsModal {showApps} on:close={() => $showApps = false} />
      <Toasts />
    {/if}
  </div>

{/await}
