<script lang="ts">
    import Modal from "../shared/modal.svelte";
    import StepPanel from "./step-panel.svelte";
    import TabContainer from "../shared/tab-container.svelte";

    export let onClose: () => void;

    let getICPSteps = [
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

    let stakeICFCSteps = [
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
            description: "Once your have staked ICFC, you will see that a neuron is created. Click on your neuron and scroll down to the 'Hot Key' section. Click on the 'Add Hot Key' button and enter your principal ID that was listed above this button. Then click 'Confirm' to add your hot key."
        },
        {
            step: 4,
            title: "Refresh",
            description: "Once your hot key is added, click the 'Refresh' button to see your newly added ICFC neuron in the list of neurons."
        },
        {
            step: 5,
            title: "Claim Membership",
            description: "Once your ICFC neuron is created and has a minimum staked amount of 1000 ICP with the max dissolve delay, you can claim membership by completing the 'Create User' form or later on the profile page. On the profile page navigate to the 'Membership' tab and click on 'Status' and if you are eligible you will see a button to 'Claim Membership'."
        }
    ]

    let activeTab: string = "stakeICFC";

    const tabs = [
        { id: "stakeICFC", label: "Stake ICFC" },
        { id: "getICP", label: "Get ICP" },
    ];
    function setActiveTab(tab: string): void {
        activeTab = tab;
    }
</script>


<Modal {onClose} title="How To Claim Membership">
   <div class="flex flex-col h-full">
        <div class="flex-none">
            <TabContainer {tabs} {activeTab} {setActiveTab} />
        </div>
        <div class="flex-1 mt-4">
            {#if activeTab === "stakeICFC"}
                {#each stakeICFCSteps as step}
                    <StepPanel {...step} />
                {/each}
            {:else if activeTab === "getICP"}
                {#each getICPSteps as step}
                    <StepPanel {...step} />
                {/each}
            {/if}
        </div>
   </div>
</Modal>