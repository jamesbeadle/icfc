
<script lang="ts">
    
    import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import { authStore } from "$lib/stores/auth-store";

    export let showApps: boolean;
    export let showLinkAccounts: boolean;

    async function handleLogout() {
        await authStore.signOut();
    }

    let isOpen = false;

    function toggleMenu() {
        isOpen = !isOpen;
    }
</script>

<nav class="p-4 flex justify-between items-center bg-BrandBlue text-white">
    <div class="flex items-center space-x-2">
        <LogoIcon className="w-10" />
    </div>

    <button 
        on:click={toggleMenu} 
        class="md:hidden p-2 focus:outline-none"
        aria-label="Toggle menu"
    >
        <svg 
            class="h-6 w-6" 
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24" 
            xmlns="http://www.w3.org/2000/svg"
        >
            <path 
                stroke-linecap="round" 
                stroke-linejoin="round" 
                stroke-width="2" 
                d="M4 6h16M4 12h16m-7 6h7" 
            />
        </svg>
    </button>

    <div class="hidden md:flex space-x-4">
        <button on:click={() => showApps = true} class="px-4 py-2 hover:bg-BrandGrayShade3 rounded">
            Apps
        </button>
        <button on:click={() => showLinkAccounts = true} class="px-4 py-2 hover:bg-BrandGrayShade3 rounded">
          Link Accounts
        </button>
        <button class="px-4 py-2 hover:bg-BrandGrayShade3 rounded" on:click={handleLogout}>
          Disconnect
        </button>
    </div>

    {#if isOpen}
        <div 
            class="fixed top-0 right-0 h-full w-64 bg-BrandGrayShade4 shadow-lg transform transition-transform duration-300 ease-in-out translate-x-0"
            on:click|self={toggleMenu}
        >
            <div class="p-4">
                <button 
                    on:click={toggleMenu} 
                    class="absolute top-4 right-4 p-2 focus:outline-none"
                    aria-label="Close menu"
                >
                    <svg 
                        class="h-6 w-6" 
                        fill="none" 
                        stroke="currentColor" 
                        viewBox="0 0 24 24" 
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path 
                            stroke-linecap="round" 
                            stroke-linejoin="round" 
                            stroke-width="2" 
                            d="M6 18L18 6M6 6l12 12" 
                        />
                    </svg>
                </button>
                <div class="mt-10 space-y-4">
                    <button on:click={() => showApps = true} class="px-4 py-2 hover:bg-gray-700 rounded">
                        Apps
                    </button>
                    <button on:click={() => showLinkAccounts = true} class="px-4 py-2 hover:bg-gray-700 rounded">
                    Link Accounts
                    </button>
                    <button class="px-4 py-2 hover:bg-gray-700 rounded" on:click={handleLogout}>
                    Disconnect
                    </button>
                </div>
            </div>
        </div>
    {/if}
</nav>

<style>
    nav {
        position: relative;
        z-index: 10;
    }
</style>