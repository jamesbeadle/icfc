<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "./Layout.svelte";
  import { appStore } from "$lib/stores/app-store";
  import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import { authStore } from "$lib/stores/auth-store";

  let isLoading = true;

  onMount(async () => {
    try {
      await appStore.checkServerVersion();
    } catch (error) {
      console.error("Error fetching funding data:", error);
    } finally {
      isLoading = false;
    }
  });

  function handleLogout() {
    console.log("here")
    authStore.signOut();
  }
</script>

<Layout>
  <div class="min-h-screen w-full flex flex-col justify-center items-center p-4 bg-BrandGray">
    <div class="hidden md:flex w-full max-w-6xl mx-auto items-center">
      <div class="flex-shrink-0 mx-24">
        <LogoIcon className="w-64" />
      </div>
      <button on:click={handleLogout} class="brand-button">
        Disconnect
      </button>
    </div>
  </div>
</Layout>