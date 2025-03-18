<script lang="ts">
    import StepPanel from "./step-panel.svelte";
    import Modal from "../shared/modal.svelte";
    import CloseIcon from '$lib/icons/CloseIcon.svelte';

    export let showModal: boolean;
    export let onClose: () => void;

    let steps = [
        {
            step: 1,
            title: "Purchase ICP and Swap for ICFC",
            description: "Purchase ICP from a reputable exchange. Then swap your ICP for ICFC on a reputable exchange."
        },
        {
            step: 2,
            title: "Transfer ICFC to NNS",
            description: "Transfer the ICFC you purchased or won to the NNS: https://nns.ic0.app"
        }
    ]
</script>

{#if showModal}
    <Modal onClose={onClose}>
        <div class="flex flex-col w-full h-full max-w-2xl mx-auto">
            <div class="relative flex flex-col flex-1 w-full bg-ModalBackground rounded-xl">
                <div class="p-6 border-b border-white/10">
                    <div class="flex items-center justify-between">
                        <h3 class="text-2xl text-white cta-text md:text-3xl">How to Get ICFC</h3>
                        <button 
                            on:click={onClose}
                            class="p-2 transition-colors duration-300 rounded-lg hover:bg-white/10"
                        >
                            <CloseIcon className="w-6 h-6" fill="white" />
                        </button>
                    </div>
                    <p class="mt-1 text-sm text-white/60 md:text-base">Follow these steps to get ICFC tokens</p>
                </div>

                <div class="flex-1 p-6 overflow-y-auto">
                    <div class="flex flex-col space-y-4">
                        {#each steps as step}
                            <StepPanel {...step} />
                        {/each}
                    </div>
                </div>
            </div>
        </div>
    </Modal>
{/if}