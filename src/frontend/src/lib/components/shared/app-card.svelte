<script lang="ts">
    import Card from './card.svelte';
    import InfoIcon from "$lib/icons/InfoIcon.svelte";
    import CloseIcon from "$lib/icons/CloseIcon.svelte";

    export let app: {
        id: string;
        name: string;
        background: any;
        logo: any;
        color: string;
        textColor: string;
        description: string;
        link: string;
        backgroundOpacity: string;
        backgroundSize: string;
        backgroundPosition: string;
    };

    export let isFlipped: boolean;
    export let onFlip: (id: string, e: MouseEvent | KeyboardEvent) => void;
    export let isModal: boolean = false;
    export let disableFlip: boolean = false;
</script>

<Card 
    {isFlipped} 
    {onFlip} 
    id={app.id} 
    {isModal} 
    {disableFlip}
    frontClasses="bg-{app.color} {app.textColor}"
    backClasses="bg-{app.color} {app.textColor}"
>
    <div slot="front" class="flex flex-col h-full">
        <div class="flex items-center justify-between">
            <div class="relative z-20 w-12 h-12">
                <svelte:component this={app.logo} className="w-full h-full" />
            </div>
            {#if !isModal}
                <button
                    on:click|stopPropagation={(e) => onFlip(app.id, e)}
                    class="z-30 flex items-center justify-center transition-transform duration-300 hover:scale-110"
                >
                    <InfoIcon className="w-7 h-7" fill="currentColor" />
                </button>
            {/if}
        </div>

        <div class="absolute transform {app.backgroundPosition} {app.backgroundOpacity}">
            <svelte:component this={app.background} className={app.backgroundSize} />
        </div>
        
        <div class="relative z-10 mt-auto">
            <p class="mb-1 text-lg opacity-75 xxs:text-xl cta-text">{app.id}</p>
            <h3 class="text-2xl font-[1000] xxs:text-4xl">{app.name}</h3>
        </div>
    </div>

    <div slot="back" class="flex flex-col h-full">
        <div class="flex items-center justify-between">
            <div class="relative z-20 w-12 h-12">
                <svelte:component this={app.logo} className="w-full h-full" />
            </div>
            <button
                on:click|stopPropagation={(e) => onFlip(app.id, e)}
                class="z-30 flex items-center justify-center transition-transform duration-300 hover:scale-110"
            >
                <CloseIcon className="w-8 h-8" fill="currentColor" />
            </button>
        </div>

        <div class="flex flex-col flex-1">
            <p class="pl-1 my-2 text-lg opacity-75 cta-text">{app.id}</p>
            <h3 class="mb-3 text-2xl font-[1000] xxs:text-4xl">{app.name}</h3>
            <div class="w-full h-[2px] bg-current mb-4"></div>
            <p class={`mb-4 ${
                isModal 
                    ? 'text-xs xxs:text-sm xs:text-base mini:text-xs md:text-sm base:text-xs lg:text-sm 2xl:text-xs 3xl:text-sm'
                    : 'text-sm xxs:text-base xs:text-lg mini:text-sm md:text-base base:text-sm lg:text-base 2xl:text-sm 3xl:text-base'
            }`}>{app.description}</p>
            <a 
                href={app.link}
                target="_blank"
                on:click|stopPropagation
                class={`px-6 py-3 mt-auto border text-center transition-colors duration-300 bg-transparent transform rounded-md shadow-md ${
                    app.textColor === 'text-white' 
                        ? 'border-BrandGrayShade6 hover:bg-BrandGrayShade6' 
                        : 'border-black hover:bg-black'
                } hover:shadow-lg hover:-translate-y-1 hover:text-${app.color}`}
            >
                Visit Website
            </a>
        </div>
    </div>
</Card>

<style>
    .perspective {
        perspective: 1000px;
    }
    
    .transform-style-3d {
        transform-style: preserve-3d;
    }
    
    .backface-hidden {
        backface-visibility: hidden;
    }
    
    .rotate-y-180 {
        transform: rotateY(180deg);
    }
</style> 