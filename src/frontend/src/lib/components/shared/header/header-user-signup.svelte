<script lang="ts">
    import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import { signOut } from "$lib/services/auth.services";
    import { goto } from "$app/navigation";

    async function handleDisconnect(){
      await signOut();
      goto('/', { replaceState: true });
    }

</script>

<header class="fixed top-0 left-0 right-0 z-30 bg-BrandBlackShade1">
  <div class="flex items-center justify-between w-full h-20 px-6">
      <a 
          href="/" 
          class="flex items-center space-x-2 transition-transform hover:scale-105"
      >
          <LogoIcon className="w-10 h-10" />
          <span class="hidden text-xl text-white cta-text sm:block">ICFC</span>
      </a>
    <button 
        on:click={handleDisconnect}
        class="px-4 py-2 text-sm font-medium text-white transition-all duration-200 border-2 border-white rounded-lg sm:text-base hover:bg-white/10 hover:scale-105 active:scale-95"
    >
        Disconnect
    </button>
</header>