<script lang="ts">
    import Card from '../shared/card.svelte';
    import ICFCCoinIcon from '$lib/icons/ICFCCoinIcon.svelte';
    import LogoIcon from '$lib/icons/LogoIcon.svelte';
    import InfoIcon from '$lib/icons/InfoIcon.svelte';
    import CloseIcon from '$lib/icons/CloseIcon.svelte';
    import type { NeuronSummary } from '$lib/types/neuron-types';
    
    export let neuron: NeuronSummary;

    export let copyToClipboard: (id: string) => void;

    const backgroundProperties = {
        opacity: "opacity-[0.10]",
        size: "w-[110%] h-[110%]",
        frontPosition: "-bottom-1 -right-32",
        backPosition: "-bottom-1 -left-[10rem]"
    };

    let isFlipped = false;

    function handleFlip(id: string) {
        isFlipped = !isFlipped;
    }
    
</script>

<Card 
    {isFlipped} 
    onFlip={handleFlip} 
    id={neuron.id}
    frontClasses="bg-BrandBlueComp text-white overflow-hidden border border-BrandGrayShade3/50"
    backClasses="bg-BrandBlueComp text-white overflow-hidden border border-BrandGrayShade3/50"
>
    <div slot="front" class="flex flex-col h-full">
        <div class="flex items-center justify-between">
            <ICFCCoinIcon className="w-12 h-12" />
            <button
                on:click|stopPropagation={() => handleFlip(neuron.id)}
                class="z-30 flex items-center justify-center transition-transform duration-300 hover:scale-110"
            >
                <InfoIcon className="w-7 h-7" fill="currentColor" />
            </button>
        </div>

        <div class="absolute transform {backgroundProperties.frontPosition} {backgroundProperties.opacity}">
            <LogoIcon className={backgroundProperties.size} />
        </div>

        <div class="relative z-10 mt-auto">
            <div class="flex items-center gap-2">
                <p class="mb-1 text-lg opacity-75 xxs:text-xl cta-text">Neuron</p>
                <button on:click={() => copyToClipboard(neuron.id)} class="text-sm text-BrandGrayShade4">#{neuron.displayId}</button>
            </div>
            <h3 class="text-base mini:text-lg md:text-xl lg:text-2xl">{neuron.stakedAmount} ICFC</h3>
        </div>
    </div>

    <div slot="back" class="flex flex-col h-full">
        <div class="flex items-center justify-between mb-4">
            <ICFCCoinIcon className="w-12 h-12" />
            <button
                on:click|stopPropagation={() => handleFlip(neuron.id)}
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
                
                <p class="pl-1 my-2 text-base md:text-lg cta-text">#{neuron.displayId}</p>
                <h3 class="mb-3 brand-title">Neuron Details</h3>
                
                <div class="w-full h-[1px] mini:h-[2px] bg-current mb-4"></div>

                <div class="space-y-4">
                    <div>
                        <p class="text-BrandGrayShade4">Staked Amount</p>
                        <p class="text-xl font-semibold">{neuron.stakedAmount} ICFC</p>
                    </div>
                    <div>
                        <p class="text-BrandGrayShade4">Status</p>
                        <p class="text-xl font-semibold capitalize">{neuron.status}</p>
                    </div>
                    <div>
                        <p class="text-BrandGrayShade4">Lock Period</p>
                        <p class="text-xl font-semibold">{neuron.lockPeriod}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</Card> 