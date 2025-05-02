<script lang="ts">
    import Card from '../shared/card.svelte';
    import ICFCCoinIcon from '$lib/icons/ICFCCoinIcon.svelte';
    import LogoIcon from '$lib/icons/LogoIcon.svelte';
    import InfoIcon from '$lib/icons/InfoIcon.svelte';
    import CloseIcon from '$lib/icons/CloseIcon.svelte';
    import BulletPointIcon from '$lib/icons/BulletPointIcon.svelte';

    interface Props {
        tier: {
            name: string;
            stakingRequirement: string;
            stakingPeriod: string;
            freeBets: number;
            freeBetsFrequency: string;
            benefits: string[];
        };
    }

    let { tier  } : Props = $props();
    
    const backgroundProperties = {
        opacity: "opacity-[0.10]",
        size: "w-[100%] h-[100%]",
        frontPosition: "-bottom-1 -right-36",
        backPosition: "-bottom-1 -left-36"
    };

    let isFlipped = false;

    function handleFlip(id: string) {
        isFlipped = !isFlipped;
    }
</script>

<Card 
    {isFlipped} 
    onFlip={handleFlip} 
    id={tier.name}
    frontClasses="bg-BrandBlueComp text-white overflow-hidden"
    backClasses="bg-BrandBlueComp text-white overflow-hidden"
>
    <div slot="front" class="flex flex-col h-full">
        <div class="flex items-center justify-between">
            <ICFCCoinIcon className="w-12 h-12" />
            <button
                onclick={() => handleFlip(tier.name)}
                class="z-30 flex items-center justify-center transition-transform duration-300 hover:scale-110"
            >
                <InfoIcon className="w-7 h-7" fill="currentColor" />
            </button>
        </div>

        <div class="absolute transform {backgroundProperties.frontPosition} {backgroundProperties.opacity}">
            <LogoIcon className={backgroundProperties.size} />
        </div>

        <div class="relative z-10 mt-auto">
            <h2 class="text-3xl font-[1000] cta-text">{tier.name}</h2>
            <p class="text-2xl font-semibold">{tier.stakingRequirement}</p>
            <p class="text-base text-BrandGrayShade4">Staked for {tier.stakingPeriod}</p>
        </div>
    </div>

    <div slot="back" class="flex flex-col h-full">
        <div class="flex items-center justify-between mb-4">
            <ICFCCoinIcon className="w-12 h-12" />
            <button
                onclick={() => handleFlip(tier.name)}
                class="z-30 flex items-center justify-center transition-transform duration-300 hover:scale-110"
            >
                <CloseIcon className="w-7 h-7" fill="currentColor" />
            </button>
        </div>

        <div class="absolute transform {backgroundProperties.backPosition} {backgroundProperties.opacity}">
            <LogoIcon className={backgroundProperties.size} />
        </div>

        <div class="relative flex-1 overflow-y-auto">
            <div class="py-4">
                <p class="pl-1 my-2 text-base mini:text-lg md:text-base cta-text">{tier.stakingRequirement}</p>
                <h3 class="mb-3 text-2xl font-[1000] xxs:text-3xl mini:text-4xl md:text-2xl 2xl:text-4xl">{tier.name}</h3>
                <div class="w-full h-[1px] mini:h-[2px] bg-current mb-4"></div>

                <ul class="space-y-4 mini:space-y-6 md:space-y-4 lg:space-y-6">
                    {#each tier.benefits as benefit}
                        <li class="flex items-start gap-1">
                            <BulletPointIcon className="w-4 h-4 mt-[0.4rem] flex-shrink-0" color="#E8E8E8" />
                            <span class="text-sm leading-normal break-words whitespace-normal">{benefit}</span>
                        </li>
                    {/each}
                </ul>
            </div>
        </div>
    </div>
</Card> 