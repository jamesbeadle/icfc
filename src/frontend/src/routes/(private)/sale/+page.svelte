<script lang="ts">
    import { onMount } from "svelte";
    import { saleStore } from "$lib/stores/sale-store";
    import { getCountdownTime } from "$lib/utils/helpers";

    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import ICFCCoinIcon from "$lib/icons/ICFCCoinIcon.svelte";
    import FundingProgress from "$lib/components/sale/funding-progress.svelte";

    let isLoading = true;
    let totalICFC = 0;
    let raisedCkBTC = 0;
    let minTarget = 50;
    let maxTarget = 100;
    
    //TODO: Change Sale Status to ""
    let saleStatus = "upcoming";
    let saleTimeRemaining = { days: 20, hours: 10, minutes: 0, seconds: 0 };
  
    onMount(async () => {
        try {
            //await getSaleData();
        } catch (error) {
            console.error("Error fetching funding data:", error);
        } finally {
            isLoading = false;
        }
    });

    async function getSaleData() {
        const goal = await saleStore.getGoal();
        const countdown = await saleStore.getSaleCountdown();

        raisedCkBTC = goal.currentProgress;
        totalICFC = goal.maxGoal;
        minTarget = goal.minGoal;
        maxTarget = goal.maxGoal;

        saleStatus = countdown.status;
        const timeRemaining = countdown.timeRemaining;
        saleTimeRemaining = getCountdownTime(Number(timeRemaining));
    }
</script>

    <div class="relative min-h-screen">
        <div class="absolute inset-0 z-0">
            <img 
                src="/background.jpg" 
                alt="Background" 
                class="object-cover w-full h-full"
            />
            <div class="absolute inset-0 bg-black/50 backdrop-blur-sm"></div>
        </div>

        <div class="relative z-10">
            <div class="container flex items-center justify-center min-h-screen px-4 mx-auto lg:justify-normal">
                <div class="grid items-center grid-cols-1 gap-12 lg:gap-6 xl:gap-12 2xl:gap-36 3xl:gap-64 lg:grid-cols-2">
                    <div class="max-w-2xl px-2 3xl:px-8">
                        <div class="flex items-center justify-center gap-2 mt-4 mb-6 lg:mt-0">
                            <ICFCCoinIcon className="w-12 h-12 2xl:w-16 2xl:h-16" />
                            <h1 class="text-4xl text-white 2xl:text-5xl cta-text">ICFC</h1>
                        </div>
                        <h2 class="mb-4 text-3xl font-bold text-center text-white 2xl:text-4xl xxs:text-5xl">Football Ownership Unleashed</h2>
                        <p class="text-xl text-center text-BrandGrayShade2 2xl:text-2xl">
                            The world's first decentralised football club is coming to the Internet Computer.
                        </p>
                    </div>
                    {#if !isLoading}
                        <div class="w-full max-w-xl mx-auto lg:mx-0">
                            <FundingProgress 
                                {raisedCkBTC}
                                {totalICFC}
                                {minTarget}
                                {maxTarget}
                                {saleStatus}
                                {saleTimeRemaining}
                            />
                        </div>
                    {:else}
                        <div class="flex items-center justify-center p-12">
                            <LocalSpinner />
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>