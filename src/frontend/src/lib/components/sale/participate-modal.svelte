<script lang="ts">
    import Modal from '../shared/modal.svelte';
    import LocalSpinner from '../shared/local-spinner.svelte';

    import { onMount } from 'svelte';
    import { toasts } from '$lib/stores/toasts-store';
    import { saleStore } from '$lib/stores/sale-store';
    import { isError } from '$lib/utils/helpers';
    import type { SaleProgress } from '../../../../../declarations/icfc_sale_2/icfc_sale_2.did';
    import CopyPrincipal from '../profile/copy-principal.svelte';
    
    export let showModal: boolean;
    export let onClose: () => void;

    let userBalance: bigint = BigInt(0);
    let contributionAmount: bigint = BigInt(0);
    let maxContributionAmount: bigint = BigInt(20);
    let packetCost: bigint = BigInt(0);
    let packetsToBuy: number = 0;
    let packetsRemaining: bigint = BigInt(0);
    let showConfirm: boolean = false;
    let isLoading: boolean = false;
    let loadingMessage: string = "Loading";

    $: contributionAmount = packetCost * BigInt(packetsToBuy);

    function validateContribution(): { isValid: boolean; error?: string } {
        if (packetsToBuy <= 0) {
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
                error: "You can't purchase more packets than the amount of packets remaining."
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
        loadingMessage = "Submitting Contribution";
        try {
            isLoading = true;
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
        } finally {
            isLoading = false;
        }
    }

    function resetModalState() {
        contributionAmount = BigInt(0);
        packetsToBuy = 0;
        showConfirm = false;
    }

    function handleClose() {
        resetModalState();
        onClose();
    }

    onMount(async () => {
        try {
            isLoading = true;
            resetModalState();
            loadingMessage = "Getting Sale Progress";
            let saleGoal = await saleStore.getProgress();
            if(saleGoal){
                packetCost = saleGoal.packetCostinICP;
                maxContributionAmount = saleGoal.remainingPackets * saleGoal.packetCostinICP;
                loadingMessage = "Getting User Balance";
                userBalance = await saleStore.getUserBalance() ?? 0n;
            }
        } catch (error) {
            console.error("Error fetching sale goal", error);
        } finally {
            isLoading = false;
        }
    });
</script>

{#if showModal}
    <Modal onClose={handleClose} title="Buy ICFC Packets">
        {#if isLoading}
            <LocalSpinner message={loadingMessage} />
        {:else}
            <div class="w-full max-w-2xl mx-auto space-y-4">
                <h3 class="text-xl text-white cta-text">Purchase Details</h3>
                <div class="space-y-2">
                    <label for="packets" class="block text-sm text-BrandGrayShade2">
                        Number of Packets (10,000 ICFC each)
                    </label>
                    <input
                        id="packets"
                        type="number"
                        bind:value={packetsToBuy}
                        class="w-full px-4 py-3 text-white border rounded-lg border-BrandGrayShade3 bg-white/5 focus:outline-none focus:border-BrandBlue"
                        max={Number(packetsRemaining)}
                        placeholder="Enter number of packets"
                    />
                </div>
                <label for="principal" class="block text-sm text-BrandGrayShade2">
                    ICFC Principal ID
                </label>
                <CopyPrincipal bgColor="bg-white/5" borderColor="border-BrandGrayShade3" />

                <div class="p-4 space-y-3 rounded-lg bg-white/5">
                    <div class="flex justify-between">
                        <span class="text-BrandGrayShade2">Packets Remaining:</span>
                        <span class="font-medium text-white">{packetsRemaining}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-BrandGrayShade2">Cost per packet:</span>
                        <span class="font-medium text-white">{packetCost} ICP</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-BrandGrayShade2">Packets to buy:</span>
                        <span class="font-medium text-white">{packetsToBuy}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-BrandGrayShade2">Total cost:</span>
                        <span class="font-medium text-white">{contributionAmount} ICP</span>
                    </div>
                    <div class="flex justify-between pt-2 border-t border-BrandGrayShade3">
                        <span class="text-BrandGrayShade2">Your ICP balance:</span>
                        <span class="font-medium text-white">{userBalance} ICP</span>
                    </div>
                </div>

                <div class="flex gap-4 pt-4">
                    <button
                        onclick={handleClose}
                        class="flex-1 px-4 py-3 text-white transition border rounded-lg border-BrandGrayShade3 hover:bg-BrandBlack/50 hover:border-BrandError/80"
                        disabled={isLoading}
                    >
                        Cancel
                    </button>
                    <button
                        onclick={showConfirmation}
                        class="flex-1 px-4 py-3 text-white transition border rounded-lg brand-button hover:bg-BrandBlack/50 hover:border-BrandBlue/80"
                        disabled={isLoading}
                    >
                        Donate
                    </button>
                </div>

                {#if showConfirm}
                    <div class="flex items-center">
                        <button
                            class="w-full px-4 py-3 text-white transition border rounded-lg brand-button hover:bg-BrandBlack/50 hover:border-BrandBlue/80"
                            onclick={handleSubmit}
                        >
                            Confirm Contribution
                        </button>
                    </div>
                {/if}
            </div>
        {/if}
    </Modal>
{/if}
  