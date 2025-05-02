<script lang="ts">
    import Modal from "../shared/global/modal.svelte";
    import StepPanel from "../membership/step-panel.svelte";
    import TabContainer from "../shared/tab-container.svelte";

    interface Props {
        onClose: () => void;
    }

    let { onClose } : Props = $props();
    
    let depositICP = [
        {
            step: 1,
            title: "Purchase ICP",
            description: "Purchase ICP from a reputable exchange."
        },
        {
            step: 2,
            title: "Transfer ICP to Your Principal ID",
            description: "Transfer the ICP to your principal ID. You can find your principal ID after you click on 'Buy ICFC Packs'."
        },
        {
            step: 3,
            title: "Check Your ICP Balance",
            description: "You should be able to see your ICP balance in the Purchase ICFC Packs section. If you don't see it, please wait for a few minutes and refresh the page."
        }
    ]

    let purchaseICFCPack = [
        {
            step: 1,
            title: "Go to Buy ICFC Packs",
            description: "Click on the 'Buy ICFC Packs' button in the center."
        },
        {
            step: 2,
            title: "Enter the number of ICFC Packs",
            description: "Enter the number of ICFC Packs you want to buy."
        },
        {
            step: 3,
            title: "Confirm Purchase",
            description: "Click the 'Purchase ICFC Packs' button to confirm your purchase. You will be prompted to confirm the purchase."
        },
        {
            step: 4,
            title: "Check your Balance",
            description: "You balance should be updated if the purchase was successful. If you don't see the updated balance, please wait for a few minutes and refresh the page."
        },
        {
            step: 5,
            title: "Check your ICFC Purchases",
            description: "In the Navigation bar, click on the 'Sale Schedule' tab to see your ICFC purchases. and the Schedule of your ICFC distributions."
        },
        {
            step: 6,
            title: "Note",
            description: "Each pack is 10,000 ICFC. You can buy any number of packs, but the minimum is 1 pack. The Distribution of ICFC will be done to your Principal ID, in 6 installments. The first distribution of 1/6 of your total packs will be done in 3 months, and the rest will be done in 6 month intervals. Check the Sale Schedule for more details."
        }
    ]

    let activeTab: string = "depositICP";

    const tabs = [
        { id: "depositICP", label: "Deposit ICP" },
        { id: "purchaseICFCPack", label: "Purchase ICFC Packs" },
    ];
    function setActiveTab(tab: string): void {
        activeTab = tab;
    }
</script>

<Modal {onClose} title="How To Purhcase ICFC Packs">
   <div class="flex flex-col h-full">
        <div class="flex-none">
            <TabContainer {tabs} {activeTab} {setActiveTab} />
        </div>
        <div class="flex-1 mt-4">
            {#if activeTab === "depositICP"}
                {#each depositICP as step}
                    <StepPanel {...step} />
                {/each}
            {:else if activeTab === "purchaseICFCPack"}
                {#each purchaseICFCPack as step}
                    <StepPanel {...step} />
                {/each}
            {/if}
        </div>
   </div>
</Modal>