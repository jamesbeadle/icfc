<script lang="ts">
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
</script>

<div 
    class="relative w-full min-h-[400px] min-w-[260px] xs:min-h-[320px] xs:min-w-[208px] mini:min-h-[400px] mini:min-w-[260px] aspect-[1/1.54] group perspective hover:scale-[1.02] transition-transform duration-300 cursor-pointer"
    on:click={(e) => {
        if (!(e.target as HTMLElement).closest('a')) {
            onFlip(app.id, e);
        }
    }}
    on:keydown={(e) => e.key === 'Enter' && onFlip(app.id, e)}
    tabindex="0"
    role="button"
    aria-label={`${isFlipped ? 'Hide' : 'Show'} details for ${app.name}`}
>
    <div class={`relative w-full h-full transition-all duration-500 transform-style-3d ${isFlipped ? 'rotate-y-180' : ''}`}>
        <div 
            class="absolute w-full h-full min-h-[400px] min-w-[260px] p-8 text-left rounded-2xl backface-hidden bg-{app.color} {app.textColor} transform transition-all duration-200 hover:-translate-y-1 hover:shadow-xl overflow-hidden flex flex-col"
            role="button"
            tabindex="0"
            aria-label="Front of card"
        >
            <div class="flex items-center justify-between">
                <div class="relative z-20 w-12 h-12">
                    <svelte:component this={app.logo} className="w-full h-full" />
                </div>

                <button
                    on:click|stopPropagation={(e) => onFlip(app.id, e)}
                    aria-label="Show card details"
                    class="z-30 flex items-center justify-center transition-transform duration-300 hover:scale-110"
                >
                    <InfoIcon className="w-7 h-7" fill="currentColor" />
                </button>
            </div>

            <div class="absolute transform {app.backgroundPosition} {app.backgroundOpacity}">
                <svelte:component this={app.background} className={app.backgroundSize} />
            </div>
            
            <div class="relative z-10 mt-auto">
                <p class="mb-1 text-lg opacity-75 xxs:text-xl cta-text sm:text-lg md:text-xl base:text-lg">{app.id}</p>
                <h3 class="text-2xl font-[1000] xxs:text-4xl xs:text-5xl mini:text-3xl md:text-4xl base:text-3xl 4xl:text-4xl">{app.name}</h3>
            </div>
        </div>

        <div 
            class="absolute w-full h-full min-h-[400px] min-w-[260px] p-8 text-left rounded-2xl backface-hidden rotate-y-180 bg-{app.color} {app.textColor} flex flex-col"
            role="button"
            tabindex="0"
            aria-label="Back of card"
        >
            <div class="flex items-center justify-between">
                <div class="relative z-20 w-12 h-12">
                    <svelte:component this={app.logo} className="w-full h-full" />
                </div>

                <button
                    on:click|stopPropagation={(e) => onFlip(app.id, e)}
                    aria-label="Hide card details"
                    class="z-30 flex items-center justify-center transition-transform duration-300 hover:scale-120"
                >
                    <CloseIcon className="w-8 h-8" fill="currentColor" />
                </button>
            </div>

            <div class="flex flex-col h-full pt-4">
                <p class="pl-1 my-2 text-lg opacity-75 cta-text">{app.id}</p>
                <h3 class="mb-3 text-2xl font-[1000] xxs:text-4xl xs:text-5xl mini:text-2xl md:text-3xl base:text-2xl lg:text-3xl 2xl:text-2xl 4xl:text-3xl">{app.name}</h3>
                <div class="w-full h-[2px] bg-current mb-4"></div>
                <p class="mb-4 text-sm xxs:text-base xs:text-lg mini:text-sm md:text-base base:text-sm lg:text-base 2xl:text-sm 3xl:text-base">{app.description}</p>
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
    </div>
</div>

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
    
    @keyframes custom-pulse {
        0%, 100% {
            opacity: 1;
            transform: scale(1);
        }
        50% {
            opacity: 0.5;
            transform: scale(1.1);
        }
    }
    
    .group:hover .custom-pulse {
        animation: custom-pulse 1s ease-in-out infinite;
    }
</style> 