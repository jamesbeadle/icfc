<script lang="ts">
    import IcpLogo from "$lib/icons/ICPLogo.svelte";
    import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import { signIn } from "$lib/services/auth.services";
    import { isBusy } from '$lib/stores/busy-store';
</script>

<div class="relative flex flex-col items-center justify-center w-full md:min-h-screen">
    <div class="items-center w-full max-w-sm mx-4">
        <div class="flex flex-col items-center justify-center mb-5">
            <LogoIcon className="mx-auto mb-4 w-24 h-24" />
            <h2 class="text-2xl text-center cta-text">JOIN THE CLUB</h2>
        </div>
        <p class="mb-8 text-center text-BrandGrayShade6">
            Own the game. Shape the future. Join a global community where fans make the decisions.
        </p>
        <div class="flex flex-row items-center justify-center mx-2 mb-4 space-x-2 md:space-x-4">
            <div class="w-full border border-l border-BrandGrayShade1"></div>
            <p class="text-center text-xxs whitespace-nowrap">Connect Instantly</p>
            <div class="w-full border border-r border-BrandGrayShade1"></div>
        </div>
        <div class="mx-2 space-y-4">
            <button 
                class="flex items-center justify-center w-full py-2 rounded lg:mx-0 bg-BrandGrayShade1 hover:bg-BrandGrayShade3"
                onclick={async () => await signIn({})} disabled={$isBusy}
            >
                <span class="flex items-center justify-center mr-2"><IcpLogo/></span> 
                <span>Internet Identity</span>
            </button>
            <div class="mt-6 text-xs text-center">
                <p class="mt-6 text-sm text-center text-white">
                    Have questions? Read our <a href="/whitepaper" class="underline hover:text-BrandBlue">Whitepaper</a>
                </p>
                <p class="mt-2 text-sm text-center text-white">
                    Login to see our exclusive sale.
                </p>
            </div>
        </div>
    </div>
</div>