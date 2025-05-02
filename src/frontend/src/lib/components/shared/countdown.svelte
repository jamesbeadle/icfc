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
    let timeLeft = saleTimeRemaining;

    function decrementTime() {
        if (timeLeft.days === 0 && timeLeft.hours === 0 && 
            timeLeft.minutes === 0 && timeLeft.seconds === 0) {
            clearInterval(intervalId);
            return;
        }

        if (timeLeft.seconds > 0) {
            timeLeft.seconds--;
        } else {
            timeLeft.seconds = 59;
            if (timeLeft.minutes > 0) {
                timeLeft.minutes--;
            } else {
                timeLeft.minutes = 59;
                if (timeLeft.hours > 0) {
                    timeLeft.hours--;
                } else {
                    timeLeft.hours = 23;
                    if (timeLeft.days > 0) {
                        timeLeft.days--;
                    }
                }
            }
        }
        timeLeft = { ...timeLeft };
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
            <FlipNumber value={timeLeft.days} label="Days" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={timeLeft.hours} label="Hours" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={timeLeft.minutes} label="Minutes" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={timeLeft.seconds} label="Seconds" />
        </div>
        -->
    {:else if saleStatus === "active"}
        <p class="text-lg font-semibold lg:text-base">Sale ends in:</p>
        <div class="flex flex-col items-center gap-4 md:flex-row lg:gap-2 xl:gap-4">
            <FlipNumber value={timeLeft.days} label="Days" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={timeLeft.hours} label="Hours" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={timeLeft.minutes} label="Minutes" />
            <span class="hidden mb-6 text-xl font-bold text-BrandGrayShade2 md:block lg:mb-4">:</span>
            <FlipNumber value={timeLeft.seconds} label="Seconds" />
        </div>
    {/if}
</div> 