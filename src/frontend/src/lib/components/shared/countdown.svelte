<script lang="ts">
    import { onMount, onDestroy } from 'svelte';
    import FlipNumber from './flip-number.svelte';

    interface Props {
        saleStatus: string;
        saleTimeRemaining: { days: number, hours: number, minutes: number, seconds: number };
        isSaleComplete: boolean;
    }

    let { saleStatus, saleTimeRemaining, isSaleComplete } : Props = $props();
    
    let intervalId: ReturnType<typeof setInterval>;

    function decrementTime() {
        if (saleTimeRemaining.days === 0 && saleTimeRemaining.hours === 0 && 
            saleTimeRemaining.minutes === 0 && saleTimeRemaining.seconds === 0) {
            clearInterval(intervalId);
            return;
        }

        if (saleTimeRemaining.seconds > 0) {
            saleTimeRemaining.seconds--;
        } else {
            saleTimeRemaining.seconds = 59;
            if (saleTimeRemaining.minutes > 0) {
                saleTimeRemaining.minutes--;
            } else {
                saleTimeRemaining.minutes = 59;
                if (saleTimeRemaining.hours > 0) {
                    saleTimeRemaining.hours--;
                } else {
                    saleTimeRemaining.hours = 23;
                    if (saleTimeRemaining.days > 0) {
                        saleTimeRemaining.days--;
                    }
                }
            }
        }
        saleTimeRemaining = { ...saleTimeRemaining };
    }

    onMount(() => {
        if (saleStatus === 'active' || saleStatus === 'upcoming') {
            intervalId = setInterval(decrementTime, 1000);
        }
    });

    onDestroy(() => {
        if (intervalId) clearInterval(intervalId);
    });
</script>

<div class="flex flex-col items-center space-y-8 lg:space-y-4">
    {#if isSaleComplete}
        <p class="text-lg cta-text lg:text-2xl">Sale Completed</p>
    {:else if saleStatus === "ended"}
        <p class="text-lg lg:text-2xl cta-text">Sale has ended</p>
    {:else if saleStatus === "upcoming"}
        <p class="text-lg lg:text-base cta-text">Sale date TBC:</p>
        <!--
        <div class="flex flex-col items-center gap-4 md:flex-row lg:gap-2 xl:gap-4">
            <FlipNumber value={saleTimeRemaining.days} label="Days" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={saleTimeRemaining.hours} label="Hours" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={saleTimeRemaining.minutes} label="Minutes" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={saleTimeRemaining.seconds} label="Seconds" />
        </div>
        -->
    {:else if saleStatus === "active"}
        <p class="text-lg font-semibold lg:text-base">Sale ends in:</p>
        <div class="flex flex-col items-center gap-4 md:flex-row lg:gap-2 xl:gap-4">
            <FlipNumber value={saleTimeRemaining.days} label="Days" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={saleTimeRemaining.hours} label="Hours" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={saleTimeRemaining.minutes} label="Minutes" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={saleTimeRemaining.seconds} label="Seconds" />
        </div>
    {/if}
</div> 