<script lang="ts">

    interface Props {
        value: number;
        label: string;
    }
  
    let { value, label } : Props = $props();
    
    let previousValue = value;
    let isFlipping = $state(false);
    let digits: string[] = $state([]);
    let previousDigits: string[] = $state([]);
    
    function padNumber(num: number): string {
        return num.toString().padStart(2, '0');
    }

    $effect(() => {
        if (value !== previousValue) {
            isFlipping = true;
            setTimeout(() => {
                previousValue = value;
                isFlipping = false;
            }, 300);
            digits = padNumber(value).split('');
            previousDigits = padNumber(previousValue).split('');
        }
    });
</script>

<div class="flex flex-col items-center">
    <div class="flex gap-1">
        {#each digits as digit, i}
            <div class="relative w-8 h-12 rounded-lg md:w-12 md:h-16 lg:w-10 lg:h-14 xl:w-12 xl:h-16 bg-BrandBlue">
                <div class="absolute inset-0 flex items-center justify-center">
                    <span class="text-xl font-bold text-white md:text-2xl lg:text-xl xl:text-2xl">{digit}</span>
                </div>

                {#if isFlipping}
                    <div class="absolute inset-0 rounded-lg bg-BrandBlue">
                        <div class="flex items-center justify-center w-full h-full origin-center animate-flip">
                            <span class="text-xl font-bold text-white md:text-2xl lg:text-xl xl:text-2xl">{previousDigits[i]}</span>
                        </div>
                    </div>
                {/if}
            </div>
        {/each}
    </div>
    <span class="mt-1 text-xs text-BrandGrayShade2 md:mt-2 lg:mt-1 xl:mt-2">{label}</span>
</div>

<style>
    @keyframes flip {
        0% {
            transform: rotateX(0);
        }
        50% {
            transform: rotateX(90deg);
        }
        100% {
            transform: rotateX(0);
        }
    }

    .animate-flip {
        animation: flip 300ms ease-in-out;
        backface-visibility: hidden;
        transform-origin: center;
    }
</style> 