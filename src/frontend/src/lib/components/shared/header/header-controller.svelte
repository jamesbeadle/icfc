<script lang="ts">
	import { authSignedInStore } from '$lib/derived/auth.derived';
    import { userIdCreatedStore } from '$lib/stores/user-control-store';
    import { page } from '$app/state';
    import type { Snippet } from 'svelte';

    import HeaderUserSignup from './header-user-signup.svelte';
    import LoggedInHeader from './logged-in-header.svelte';
    import LoggedOutHeader from './logged-out-header.svelte';
    import Sidebar from './sidebar.svelte';
    import CreateUser from '$lib/components/profile/create-user/create-user.svelte';
    import { busy } from '$lib/stores/busy-store';
    import FullScreenSpinner from '../full-screen-spinner.svelte';
    
    interface Props {
        children: Snippet;
    }
    let { children }: Props = $props();

    let isMenuOpen = $state(false);

    function toggleMenu() {
        isMenuOpen = !isMenuOpen;
    }
</script>

{#if $busy}
    <FullScreenSpinner message="Checking for Existing Profile" />
{:else}

    {#if $authSignedInStore}
        {#if $userIdCreatedStore?.data}
            <div class="relative flex flex-col w-full min-h-screen">
                <LoggedInHeader {toggleMenu} />
                <main class="flex-1 w-full mt-16 overflow-x-hidden">
                {@render children()}
                </main>
            </div>
            <Sidebar {isMenuOpen} {toggleMenu} />
            {#if isMenuOpen}
                <button 
                class="fixed inset-0 z-30 pointer-events-none bg-black/40 sm:bg-black/20 sm:pointer-events-auto"
                onclick={toggleMenu}
                onkeydown={(e) => e.key === 'Enter' && toggleMenu()}
                aria-label="Close menu overlay"
                ></button>
            {/if}
        {:else}
            <div class="relative flex flex-col w-full min-h-screen bg-BrandBlack">
                <div class="fixed top-0 left-0 right-0 z-50">
                    <HeaderUserSignup />
                </div>
                <div class="mt-12">
                    <CreateUser />
                </div>
            </div>
        {/if}
    {:else}
        {#if page.route.id === '/'}
            {@render children()}
        {:else}
            <div class="relative flex flex-col w-full min-h-screen">
                <LoggedOutHeader />
                <main class="flex-1 w-full mt-16 overflow-x-hidden">
                    {@render children()}
                </main>
            </div>
        {/if}
    {/if}
{/if}