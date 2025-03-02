<script lang="ts">
    import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import type { Writable } from "svelte/store";
    export let showApps: Writable<Boolean>;
    export let onLogout: () => void;
</script>

<header class="fixed top h-16 flex items-center justify-between w-full px-4 bg-gray-900 text-white shadow-md">
    <div class="flex items-center">
        <LogoIcon className='w-8' />
    </div>

    <div class="flex items-center gap-4">
        <button on:click={() => $showApps = true} class="px-4 py-2 text-sm font-medium bg-gray-800 hover:bg-gray-700 rounded-lg transition">
            Apps
        </button>
        <button class="px-4 py-2 text-sm font-medium bg-blue-600 hover:bg-BrandBlue rounded-lg transition" on:click={onLogout}>
            Disconnect
        </button>
    </div>
</header>