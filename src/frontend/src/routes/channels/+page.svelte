<script lang="ts">
    import LogoIconWhite from "$lib/icons/LogoIconWhite.svelte";
    import Layout from "../Layout.svelte";
</script>

<Layout>
    <div class="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-BrandGray to-BrandBlueComp px-4">
        <div class="h-16"></div>

        <div class="max-w-2xl text-center space-y-6">
            <h1 class="text-4xl md:text-5xl cta-text text-FootballGodFont drop-shadow-lg">
                Football Channels
            </h1>
            
            <p class="text-xl text-BrandGrayShade5 leading-relaxed">
                Get ready for the ultimate football content experience!
            </p>

            <div class="bg-ModalBackground/80 p-6 rounded-lg border border-ModalBorder">
                <p class="text-BrandGrayShade4 text-lg">
                    The ICFC platform is bringing you exclusive creator channels packed with:
                </p>
                
                <ul class="mt-4 space-y-2 text-BrandGrayShade5 text-left">
                    <li class="flex items-center">
                        <span class="w-2 h-2 bg-BrandRed rounded-full mr-2"></span>
                        Team-specific content drops
                    </li>
                    <li class="flex items-center">
                        <span class="w-2 h-2 bg-MembershipYellow rounded-full mr-2"></span>
                        Direct creator subscriptions
                    </li>
                    <li class="flex items-center">
                        <span class="w-2 h-2 bg-BrandSuccess rounded-full mr-2"></span>
                        Premium football insights
                    </li>
                </ul>
            </div>

            <p class="text-BrandGrayShade5 italic">
                Creators: Build your channel. Fans: Get closer to the action.
            </p>

            <div class="mt-8">
                <span class="inline-block px-6 py-3 bg-BrandRed text-FootballGodFont font-semibold rounded-md shadow-lg transform transition hover:scale-105">
                    Coming Soon
                </span>
            </div>
        </div>

        <div class="flex-grow"></div>
        <div class="h-16 text-BrandGrayShade4 text-sm">
            <span class="flex flex-col space-y-1">
                Powered by ICFC
                <LogoIconWhite className='w-5' />
            </span>
        </div>
    </div>
</Layout>