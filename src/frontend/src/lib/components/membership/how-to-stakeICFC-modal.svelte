<script lang="ts">
    import StepPanel from "./step-panel.svelte";
    import Modal from "../shared/modal.svelte";
    import CloseIcon from '$lib/icons/CloseIcon.svelte';

    export let showModal: boolean;
    export let onClose: () => void;

    let steps = [
        {
            step: 1,
            title: "Log into NNS",
            description: "Go to https://nns.ic0.app/ and log in with your internet identity."
        },
        {
            step: 2,
            title: "Stake ICFC",
            description: "Click on 'Neuron Staking' in the left sidebar, then find and click on ICFC in the list of nervous systems. Now click the 'Stake ICFC' button. Enter the amount of ICFC you want to stake and set the max dissolve delay to qualify for a ICFC membership."
        },
        {
            step: 3,
            title: "Add Hot Key",
            description: "Once your have staked ICFC, you will see that a neuron is created. Click on your neuron and scroll down to the 'Hot Key' section. Click on the 'Add Hot Key' button and enter your principal ID from the ICFC profile page. Then click 'Confirm' to add your hot key."
        },
        {
            step: 4,
            title: "Refresh Page",
            description: "Once your hot key is added, refresh the page to see your newly added ICFC neuron in the list of neurons."
        },
        {
            step: 5,
            title: "Claim Membership",
            description: "Once your ICFC neuron is created and has a minimum staked amount of 1000 ICP with the max dissolve delay, you can claim membership by clicking the 'Claim Membership' button."
        }
    ]
</script>

{#if showModal}
    <Modal onClose={onClose}>
        <div class="flex flex-col w-full h-full max-w-2xl mx-auto">
            <div class="relative flex flex-col flex-1 w-full bg-ModalBackground rounded-xl">
                <div class="p-6 border-b border-white/10">
                    <div class="flex items-center justify-between">
                        <h3 class="text-2xl text-white cta-text md:text-3xl">How to Stake ICFC</h3>
                        <button 
                            on:click={onClose}
                            class="p-2 transition-colors duration-300 rounded-lg hover:bg-white/10"
                        >
                            <CloseIcon className="w-6 h-6" fill="white" />
                        </button>
                    </div>
                    <p class="mt-1 text-sm text-white/60 md:text-base">Follow these steps to stake your ICFC tokens</p>
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