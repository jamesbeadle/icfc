<script lang="ts">

    import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import { authStore } from "$lib/stores/auth-store";

    function handleDisconnect(){
      authStore.signOut();
    }

</script>

<header class="fixed top-0 left-0 right-0 z-30 flex items-center justify-between h-16 px-4 text-white bg-BrandBlue shadow-md">
    <a href="/" class="flex items-center">
      <LogoIcon className='w-8' />
    </a>
    <button 
        on:click={handleDisconnect}
        class="px-4 py-2 bg-white text-BrandBlue rounded hover:bg-gray-200 transition-colors"
    >
        Disconnect
    </button>
</header>