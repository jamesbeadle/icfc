<script lang="ts">
    import ProgressCircle from "./progress-circle.svelte";
    import Countdown from '$lib/components/shared/countdown.svelte';
    import ParticipateModal from './participate-modal.svelte';
    
    export let raisedCkBTC: number;
    export let totalICFC: number;
    export let minTarget: number;
    export let maxTarget: number;
    export let saleStatus: string;
    export let saleTimeRemaining: { days: number, hours: number, minutes: number, seconds: number };

    let showParticipateModal = false;

    $: minProgressPercentage = Math.min((raisedCkBTC / minTarget) * 100, 200);
    $: maxProgressPercentage = (raisedCkBTC / maxTarget) * 100;
    $: isSaleComplete = raisedCkBTC >= maxTarget;

    function openParticipateModal() {
        showParticipateModal = true;
    }

    function closeParticipateModal() {
        showParticipateModal = false;
    }
</script>

<div class="p-5 space-y-3 border bg-white/5 backdrop-blur-sm rounded-xl border-white/10">
    <div class="p-4 text-center bg-white/10 rounded-xl">
        <Countdown 
            {saleStatus}
            {saleTimeRemaining}
            {isSaleComplete}
        />
    </div>

    <div class="flex flex-col items-center justify-between p-4 md:flex-row bg-white/10 rounded-xl">
        <div class="flex flex-col items-center mb-4 md:space-y-8 md:pt-14 lg:space-y-4 lg:pt-9 xl:space-y-8 xl:pt-14 md:mb-0 md:w-1/3">
            <h3 class="text-xl text-center text-white md:text-2xl cta-text">
                {raisedCkBTC.toLocaleString()} ckBTC
            </h3>
            <span class="text-xs text-BrandGrayShade2 md:text-sm">Amount Raised</span>
        </div>

        <div class="flex items-center gap-6 lg:gap-3 xl:gap-6 md:w-2/3">
            <div class="flex flex-col items-center flex-1">
                <ProgressCircle percentage={minProgressPercentage} />
                <span class="text-xs text-BrandGrayShade2 md:text-sm">Minimum Goal</span>
            </div>

            <div class="flex flex-col items-center flex-1">
                <ProgressCircle percentage={maxProgressPercentage} />
                <span class="text-xs text-BrandGrayShade2 md:text-sm">Maximum Goal</span>
            </div>
        </div>
    </div>

    <div class="flex flex-col gap-3 md:flex-row md:justify-between">
        <div class="p-4 text-center rounded-lg bg-white/10 md:w-1/3">
            <p class="text-lg text-white cta-text">{totalICFC.toLocaleString()}</p>
            <p class="text-xs text-BrandGrayShade2 lg:text-xxs xl:text-xs">ICFC to be swapped</p>
        </div>
        <div class="p-4 text-center rounded-lg bg-white/10 md:w-1/3">
            <p class="text-lg text-white cta-text">{minTarget} ckBTC</p>
            <p class="text-xs text-BrandGrayShade2 lg:text-xxs xl:text-xs">Min Target</p>
        </div>
        <div class="p-4 text-center rounded-lg bg-white/10 md:w-1/3">
            <p class="text-lg text-white cta-text">{maxTarget} ckBTC</p>
            <p class="text-xs text-BrandGrayShade2 lg:text-xxs xl:text-xs">Max Target</p>
        </div>
    </div>

    <div class="flex flex-col gap-3 md:flex-row md:justify-between">
        <button class="py-3 text-base font-bold text-white transition-all duration-300 rounded-lg bg-BrandBlue hover:bg-opacity-90 md:flex-1">
            How to Participate
        </button>
        <button 
            class="py-3 text-base font-bold text-white transition-all duration-300 rounded-lg bg-BrandBlue hover:bg-opacity-90 disabled:opacity-50 disabled:cursor-not-allowed md:flex-1"
            disabled={isSaleComplete}
            on:click={openParticipateModal}
        >
            {isSaleComplete ? 'Sale Completed' : 'Participate Now'}
        </button>
    </div>
</div>

<ParticipateModal 
    showModal={showParticipateModal}
    onClose={closeParticipateModal}
/> 