<script lang="ts">
    import IcpLogo from "$lib/icons/ICPLogo.svelte";


    import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import { authStore, type AuthSignInParams } from "$lib/stores/auth-store";


    async function handleLogin() {
        let params: AuthSignInParams = {
            domain: import.meta.env.VITE_AUTH_PROVIDER_URL,
        };
        await authStore.signIn(params);
    }

</script>
<div class="flex flex-col md:flex-row min-h-screen w-full bg-BrandGray">
    <div class="w-full md:w-1/2 bg-cover bg-center" style="background-image: url('background.jpg')">
      <div class="h-full flex items-end p-4 bg-gradient-to-t from-black/70 to-transparent">
        <h1 class="text-white text-2xl font-bold text-center py-32 md:py-0">
          Be Part of the World's First Fully Decentralised Football Club
        </h1>
      </div>
    </div>
  
    <div class="w-full md:w-1/2 flex flex-col items-center justify-center p-4 bg-BrandGray text-white">
      <div class="w-full max-w-sm">
        <LogoIcon className="mx-auto mb-4 w-24 h-24" />
        <h2 class="text-2xl cta-text text-center mb-4">JOIN THE CLUB</h2>
        <p class="text-center mb-6 text-BrandGrayShade6">
          Own the game. Shape the future. Join a global community where fans make the decisions.
        </p>
        <div class="space-y-4">
          <button 
            on:click={handleLogin}          
            class="w-full bg-BrandGrayShade1 hover:bg-BrandGrayShade3 text-white py-2 rounded flex items-center justify-center">
            <span class="mr-2"><IcpLogo /></span> Internet Identity
          </button>
        </div>
        <p class="text-center mt-6 text-white text-sm">
          Have questions? Read our Whitepaper
        </p>
      </div>
    </div>
  </div>