<script lang="ts">
    import StepPanel from "./step-panel.svelte";
    import Modal from "../shared/modal.svelte";
    
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
        <h2 class="text-2xl text-white cta-text">How To Add ICFC</h2>
        <div class="flex flex-col w-full h-full max-w-2xl mx-auto">
            <div class="relative flex flex-col flex-1 w-full bg-ModalBackground rounded-xl">

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