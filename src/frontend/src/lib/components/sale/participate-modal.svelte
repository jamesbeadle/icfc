<script lang="ts">
    import Modal from '../shared/modal.svelte';
    import CloseIcon from '$lib/icons/CloseIcon.svelte';

    import { onMount } from 'svelte';
    import { toasts } from '$lib/stores/toasts-store';
    import { saleStore } from '$lib/stores/sale-store';
    import { isError } from '$lib/utils/helpers';
    import type { SaleProgress } from '../../../../../declarations/icfc_sale_2/icfc_sale_2.did';
    export let showModal: boolean;
    export let onClose: () => void;

    let userBalance: bigint = BigInt(0);
    let contributionAmount: bigint = BigInt(0);
    let maxContributionAmount: bigint = BigInt(20);
    let showConfirm: boolean = false;

    let saleGoal: SaleProgress = {
        packetCostinICP: BigInt(60),
        remainingPackets: BigInt(1000),
        totalPackets: BigInt(1000)
    };

    function validateContribution(): { isValid: boolean; error?: string } {
        if (contributionAmount <= 0) {
            return {
                isValid: false,
                error: "Please enter a valid amount."
            };
        }
        if (contributionAmount > userBalance) {
            return {
                isValid: false,
                error: "You don't have enough balance to donate that amount."
            };
        }
        if (contributionAmount > maxContributionAmount) {
            return {
                isValid: false,
                error: "You can't donate more than the maximum contribution amount."
            };
        }
        return { isValid: true };
    }

    function showConfirmation() {
        const validation = validateContribution();
        if (!validation.isValid) {
            toasts.addToast({
                message: validation.error!,
                type: "error",
                duration: 5000
            });
            return;
        }
        showConfirm = true;
    }

    async function handleSubmit() {
        try {
            const result = await saleStore.participateInSale(Number(maxContributionAmount));
            if (isError(result)) {
                toasts.addToast({
                    message: "Error submitting contribution",
                    type: "error",
                });
                console.error("Error submitting contribution", result);
                return;
            }
            toasts.addToast({
                message: "Your contribution has been successfully submitted.",
                type: "success",
                duration: 3000
            });
            onClose();
        } catch (error) {
            toasts.addToast({
                message: "Error submitting contribition",
                type: "error",
            });
            console.error("Error submitting contribution", error);
        }
    }

    function resetModalState() {
        contributionAmount = BigInt(0);
        showConfirm = false;
    }

    function handleClose() {
        resetModalState();
        onClose();
    }

    onMount(async () => {
        try {
            resetModalState();
            let saleGoalResult = await saleStore.getProgress();
            if(saleGoalResult){
                saleGoal = saleGoalResult;
                maxContributionAmount = saleGoal.remainingPackets * saleGoal.packetCostinICP;
                userBalance = await saleStore.getUserBalance() ?? 0n;
            }
        } catch (error) {
            console.error("Error fetching sale goal", error);
        }
    });
</script>

{#if showModal}
    <Modal onClose={handleClose}>
        <div class="w-full max-w-2xl mx-auto">
            <h2 class="text-2xl text-white cta-text">Participate In Sale</h2>
            <div class="p-8 space-y-6">
                <div class="flex items-center justify-between pb-4 border-b border-BrandGrayShade3">
                    <h3 class="text-xl text-white cta-text">Contribute</h3>
                    <button 
                        onclick={onClose}
                        class="p-2 transition-colors duration-300 rounded-lg hover:bg-white/10"
                    >
                        <CloseIcon className="w-8 h-8" fill="white" />
                    </button>
                </div>

                <div class="p-8 rounded-lg bg-white/5">
                    <div class="flex flex-col px-2 space-y-6">
                        <div class="flex items-center justify-between gap-8">
                            <span class="text-BrandGrayShade2">Your Balance:</span>
                            <span class="text-white cta-text">{Number(userBalance).toFixed(4)} ckBTC</span>
                        </div>
                        <div class="flex items-center justify-between gap-8 pt-4 border-t border-BrandGrayShade3">
                            <span class="text-BrandGrayShade2">Maximum Contribution Allowed:</span>
                            <span class="text-white cta-text">{Number(maxContributionAmount).toFixed(4)} ckBTC</span>
                        </div>
                    </div>
                </div>

                <div class="space-y-2">
                    <label for="contribution" class="block text-sm text-BrandGrayShade2">
                        Amount to Contribute
                    </label>
                    <input
                        id="contribution"
                        type="number"
                        bind:value={contributionAmount}
                        class="w-full px-4 py-3 text-white border border-BrandGrayShade3 rounded-lg bg-white/5 focus:outline-none focus:border-BrandBlue"
                        max={Number(maxContributionAmount)}
                        placeholder="Enter contribution amount"
                    />
                </div>

                <div class="flex gap-4 pt-4">
                    <button
                        onclick={handleClose}
                        class="flex-1 px-4 py-3 text-white transition-colors duration-200 border border-BrandGrayShade3 rounded-lg hover:bg-white/5"
                    >
                        Cancel
                    </button>
                    <button
                        onclick={showConfirmation}
                        class="flex-1 px-4 py-3 text-white transition-colors duration-200 rounded-lg bg-BrandBlue hover:bg-BrandBlue/90"
                    >
                        Donate
                    </button>
                </div>

                {#if showConfirm}
                    <div class="flex items-center">
                        <button
                            class="w-full px-4 py-3 text-white transition-colors duration-200 rounded-lg bg-BrandBlue hover:bg-BrandBlue/90"
                            onclick={handleSubmit}
                        >
                            Confirm Contribution
                        </button>
                    </div>
                {/if}
            </div>
        </div>
    </Modal>
{/if}
  