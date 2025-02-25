<script lang="ts">
  import { onMount } from "svelte";
  import { appStore } from "$lib/stores/app-store";
  import LogoIcon from "$lib/icons/LogoIcon.svelte";
  import { authStore, type AuthSignInParams } from "$lib/stores/auth-store";

  let isLoading = true;
  const title = "Join The Club";
  const description = "Join the world's first fully decentralised football club today.";

  onMount(async () => {
    try {
      await appStore.checkServerVersion();
    } catch (error) {
      console.error("Error checking frontend version:", error);
    } finally {
      isLoading = false;
    }
  });

  
  function handleLogin() {
    let params: AuthSignInParams = {
      domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
    };
    authStore.signIn(params);
  }
</script>
  
<div class="min-h-screen w-full flex flex-col justify-center items-center p-4 bg-BrandGray">
  <div class="hidden md:flex w-full max-w-6xl mx-auto items-center">
    <div class="flex-shrink-0 mx-24">
      <LogoIcon className="w-64" />
    </div>
    <div class="flex-grow">
      <h1 class="text-5xl font-bold mb-4 cta-text">{title}</h1>
      <p class="text-xl mb-8">{description}</p>
      <button on:click={handleLogin} class="brand-button">
        Connect
      </button>
    </div>
  </div>

  <div class="md:hidden w-full flex flex-col justify-center items-center text-center">
    <div class="mb-8">
      <LogoIcon className="w-48 mx-auto" /> 
    </div>
    <div class="max-w-md"> 
      <h1 class="text-4xl font-bold mb-4">{title}</h1>
      <p class="text-lg mb-8">{description}</p>
      <button on:click={handleLogin} class="brand-button">
        Connect
      </button>
    </div>
  </div>
</div>