<script lang="ts">
    import ParticipateModal from './participate-modal.svelte';
    import HowItWorksModal from './how-it-works-modal.svelte';
    
    export let packCost: bigint;
    export let remainingPacks: bigint;

    let showParticipateModal = false;
    let showHowItWorksModal = false;

    $: packCostInICP = Number(packCost)

    function openParticipateModal() {
        showParticipateModal = true;
    }

    function closeParticipateModal() {
        showParticipateModal = false;
    }

    function openHowItWorksModal() {
        showHowItWorksModal = true;
    }

    function closeHowItWorksModal() {
        showHowItWorksModal = false;
    }
</script>

<div class="p-5 space-y-3 border bg-white/5 backdrop-blur-sm rounded-xl border-white/10">
    <div class="flex flex-col gap-3 md:flex-row md:justify-between">
        <div class="p-4 text-center rounded-lg bg-white/10 md:w-1/2">
            <p class="text-xl text-white cta-text">{packCostInICP} ICP</p>
            <p class="text-sm text-white/80">Per 10,000 ICFC</p>
        </div>
        <div class="p-4 text-center rounded-lg bg-white/10 md:w-1/2">
            <p class="text-xl text-white cta-text">{remainingPacks.toLocaleString()}</p>
            <p class="text-sm text-white/80">Packs Remaining</p>
        </div>
    </div>
    <div class="flex flex-col gap-3">
        <button 
            class="flex-1 px-4 py-3 text-white transition border rounded-lg border-BrandGrayShade3 brand-button hover:bg-BrandBlack hover:border-BrandBlue/80"
            on:click={openParticipateModal}
            disabled={remainingPacks <= 0}
        >
            Buy ICFC Packs
        </button>
        <button 
            class="flex-1 px-4 py-3 text-white transition border rounded-lg border-BrandGrayShade3 brand-button hover:bg-BrandBlack hover:border-BrandBlue/80"
            on:click={openHowItWorksModal}
        >
            How It Works
        </button>
    </div>
</div>

{#if showHowItWorksModal}
    <HowItWorksModal 
        showModal={showHowItWorksModal}
        onClose={closeHowItWorksModal}
    />
{/if}
{#if showParticipateModal}
    <ParticipateModal 
        showModal={showParticipateModal}
        onClose={closeParticipateModal}
    /> 
{/if}