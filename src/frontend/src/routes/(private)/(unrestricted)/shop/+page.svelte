<script lang="ts">
    import LogoIconWhite from "$lib/icons/LogoIconWhite.svelte";
    import { fade, scale } from 'svelte/transition';
</script>

<div class="flex flex-col items-center justify-center min-h-screen px-4 bg-gradient-to-br from-BrandGray to-BrandBlueComp">
    <div class="h-16"></div>

    <div 
        class="max-w-2xl space-y-6 text-center"
        in:fade={{ duration: 300 }}
    >
        <h1 class="text-4xl md:text-5xl cta-text text-FootballGodFont drop-shadow-lg">
            The ICFC Shop
        </h1>
        
        <p class="text-xl leading-relaxed text-BrandGrayShade5">
            Premium merchandise for the true football enthusiast
        </p>

        <div 
            class="p-6 border rounded-lg bg-ModalBackground/80 border-ModalBorder"
            in:scale={{ duration: 400, delay: 200, start: 0.95 }}
        >
            <p class="text-lg text-BrandGrayShade4">
                We have designed our ecosystem around high quality branding, featuring:
            </p>
            
            <ul class="mt-4 space-y-2 text-left text-BrandGrayShade5">
                <li class="flex items-center">
                    <span class="w-2 h-2 mr-2 rounded-full bg-BrandRed animate-pulse"></span>
                    Limited edition apparel
                </li>
                <li class="flex items-center">
                    <span class="w-2 h-2 mr-2 rounded-full bg-MembershipYellow animate-pulse"></span>
                    Exclusive merchandise drops
                </li>
                <li class="flex items-center">
                    <span class="w-2 h-2 mr-2 rounded-full bg-BrandSuccess animate-pulse"></span>
                    Premium collectibles
                </li>
            </ul>
        </div>

        <p class="italic text-BrandGrayShade5">
            More information about our product launches will be available soon.
        </p>

        <div class="mt-8">
            <span 
                class="inline-block px-6 py-3 font-semibold transition transform rounded-md shadow-lg bg-BrandRed text-FootballGodFont hover:scale-105"
                in:scale={{ duration: 400, delay: 400, start: 0.9 }}
            >
                Coming Soon
            </span>
        </div>
    </div>

    <div class="flex-grow"></div>
    <div class="h-16 text-sm text-BrandGrayShade4">
        <span class="flex flex-col space-y-1">
            Powered by ICFC
            <LogoIconWhite className='w-5' />
        </span>
    </div>
</div>