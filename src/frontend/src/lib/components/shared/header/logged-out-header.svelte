<script lang="ts">
    import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import { page } from "$app/state";
    import { signIn } from "$lib/services/auth.services";
    import { isBusy } from '$lib/stores/busy-store';

    async function handleLoginClick() {
        await signIn({});
    }

    const navLinks = [
        { href: '/whitepaper/', label: 'Whitepaper' },
        { href: '/sale/', label: 'Membership Sale' }
    ];
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

        <div class="flex items-center space-x-4">
            <nav class="flex items-center">
                <ul class="flex space-x-8">
                    {#each navLinks as link}
                        {#if page.url.pathname !== link.href}
                            <li>
                                <a 
                                    href={link.href}
                                    class="text-sm font-medium text-white transition-all duration-200 sm:text-base hover:text-gray-200 hover:underline underline-offset-4"
                                >
                                    {link.label}
                                </a>
                            </li>
                        {/if}
                    {/each}
                </ul>
            </nav>
            <button 
                onclick={handleLoginClick} disabled={$isBusy}
                class="px-4 py-2 text-sm font-medium text-white transition-all duration-200 border-2 border-white rounded-lg sm:text-base hover:bg-white/10 hover:scale-105 active:scale-95"
            >
                Sign In
            </button>
        </div>
    </div>
</header>
