<script lang="ts">
    import type { Snippet } from 'svelte';
	import { authSignedInStore } from '$lib/derived/auth.derived';
    import { userIdCreatedStore, restrictedSaleStore } from '$lib/stores/user-control-store';
    import { page } from '$app/state';
    import { busy } from '$lib/stores/busy-store';
    import { authStore } from '$lib/stores/auth-store';

    import HeaderUserSignup from './header-user-signup.svelte';
    import LoggedInHeader from './logged-in-header.svelte';
    import LoggedOutHeader from './logged-out-header.svelte';
    import Sidebar from './sidebar.svelte';
    import CreateUser from '$lib/components/profile/create-user/create-user.svelte';
    import FullScreenSpinner from '../full-screen-spinner.svelte';
    import SignupChoice from '../signup-choice.svelte';
    
    interface Props {
        children: Snippet;
    }
    let { children }: Props = $props();

    let isMenuOpen = $state(false);
    let signupChoice = $state<'full' | 'sale' | null>(null);
    let saleSignupProcessing = $state(false);

    function toggleMenu() {
        isMenuOpen = !isMenuOpen;
    }

    function handleFullSignup() {
        signupChoice = 'full';
    }

    async function handleSaleSignup() {
        saleSignupProcessing = true;
        try {
            const principal = $authStore.identity?.getPrincipal();
            if (!principal) throw new Error('No principal found');
            
            restrictedSaleStore.set({
                data: principal.toString(),
                certified: true,
            });
        } catch (error) {
            console.error('Sale signup failed:', error);
        } finally {
            saleSignupProcessing = false;
        }
    }

    $effect(() => {
        console.log('restrictedSaleStore', $restrictedSaleStore);
    });

</script>

{#if $busy}
    <FullScreenSpinner message="Checking for Existing Profile" />
{:else}

    {#if $authSignedInStore}
        {#if $userIdCreatedStore?.data || $restrictedSaleStore?.data}
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
            {#if signupChoice === null}
                <SignupChoice
                    onFull={handleFullSignup}
                    onSale={handleSaleSignup}
                    processing={saleSignupProcessing}
                />
            {:else if signupChoice === 'full'}
                <div class="relative flex flex-col w-full min-h-screen bg-BrandBlack">
                    <div class="fixed top-0 left-0 right-0 z-50">
                        <HeaderUserSignup />
                    </div>
                    <div class="mt-12">
                        <CreateUser />
                    </div>
                </div>
            {/if}
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