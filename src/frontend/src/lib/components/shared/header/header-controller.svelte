<script lang="ts">
    import type { Snippet } from 'svelte';
	import { authSignedInStore } from '$lib/derived/auth.derived';
    import { userIdCreatedStore, restrictedSaleStore } from '$lib/stores/user-control-store';
    import { page } from '$app/state';
    import { busy } from '$lib/stores/busy-store';
    import { authStore } from '$lib/stores/auth-store';
    import { goto } from '$app/navigation';
    import { toasts } from '$lib/stores/toasts-store';

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
    let saleSignupProcessing = $state(false);

    const SIGN_UP_CHOICE_KEY = 'user_signup_choice';

    let signupChoice = $state<'full' | 'sale' | null>(
        typeof localStorage !== 'undefined' 
            ? localStorage.getItem(SIGN_UP_CHOICE_KEY) as 'full' | 'sale' | null
            : null
    );

    function toggleMenu() {
        isMenuOpen = !isMenuOpen;
    }

    function handleFullSignup() {
        signupChoice = 'full';
        if (typeof localStorage !== 'undefined') {
            localStorage.setItem(SIGN_UP_CHOICE_KEY, 'full');
        }
        
    }

    async function handleSaleSignup() {
        signupChoice = 'sale';
        saleSignupProcessing = true;
        try {
            const principal = $authStore.identity?.getPrincipal();
            if (!principal) throw new Error('No principal found');
            restrictedSaleStore.set({
                data: principal.toString(),
                certified: true,
            });
            if (typeof localStorage !== 'undefined') {
                localStorage.setItem(SIGN_UP_CHOICE_KEY, 'sale');
            }
            await goto('/sale', { replaceState: true });
            toasts.addToast({
                message: 'Sale signup successful',
                type: 'success',
                duration: 3000
            });
        } catch (error) {
            console.error('Sale signup failed:', error);
            toasts.addToast({
                message: 'Sale signup failed',
                type: 'error',
                duration: 3000
            });
        } finally {
            saleSignupProcessing = false;
        }
    }

    $effect(() => {
        console.log('restrictedSaleStore', $restrictedSaleStore);
    });

    const isSaleOnly = $derived(!$userIdCreatedStore?.data && !!$restrictedSaleStore?.data);
</script>

{#if $busy}
    <FullScreenSpinner message="Checking for Existing Profile" />
{:else}
    {#if $authSignedInStore}
        {#if signupChoice === null}
            <div class="relative flex flex-col w-full min-h-screen bg-BrandBlack">
                <div class="fixed top-0 left-0 right-0 z-50">
                    <HeaderUserSignup />
                </div>
                <div>
                    <SignupChoice
                        onFull={handleFullSignup}
                        onSale={handleSaleSignup}
                        processing={saleSignupProcessing}
                    />
                </div>
            </div>
        {:else if signupChoice === 'full'}
            {#if $userIdCreatedStore?.data}
                <div class="relative flex flex-col w-full min-h-screen">
                    <LoggedInHeader {toggleMenu} />
                    <main class="flex-1 w-full mt-16 overflow-x-hidden">
                    {@render children()}
                    </main>
                </div>
                <Sidebar {isMenuOpen} {toggleMenu} isSaleOnly={false} />
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
        {:else if signupChoice === 'sale'}
            <div class="relative flex flex-col w-full min-h-screen">
                <LoggedInHeader {toggleMenu} />
                <main class="flex-1 w-full mt-16 overflow-x-hidden">
                {@render children()}
                </main>
            </div>
            <Sidebar {isMenuOpen} {toggleMenu} {isSaleOnly} />
            {#if isMenuOpen}
                <button 
                class="fixed inset-0 z-30 pointer-events-none bg-black/40 sm:bg-black/20 sm:pointer-events-auto"
                onclick={toggleMenu}
                onkeydown={(e) => e.key === 'Enter' && toggleMenu()}
                aria-label="Close menu overlay"
                ></button>
            {/if}
        {:else if saleSignupProcessing}
            <FullScreenSpinner message="Signing up for Sale" />
        {:else}
        <HeaderUserSignup />
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
