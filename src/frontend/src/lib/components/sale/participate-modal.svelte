<script lang="ts">
    import Modal from '../shared/modal.svelte';
    import LocalSpinner from '../shared/local-spinner.svelte';
    import { onMount } from 'svelte';
    import { toasts } from '$lib/stores/toasts-store';
    import { saleStore } from '$lib/stores/sale-store';
    import { isError } from '$lib/utils/helpers';
    import type { SaleProgress } from '../../../../../declarations/icfc_sale_2/icfc_sale_2.did';
    import CopyPrincipal from '../profile/copy-principal.svelte';
    import IcfcCoinIcon from "$lib/icons/ICFCCoinIcon.svelte";
    
    export let showModal: boolean;
    export let onClose: () => void;

    let userBalance: bigint = BigInt(0);
    let contributionAmount: bigint = BigInt(0);
    let maxContributionAmount: bigint = BigInt(20);
    let packetCost: bigint = BigInt(0);
    let packetsToBuy: number | null = null;
    let packetsRemaining: bigint = BigInt(0);
    let showConfirm: boolean = false;
    let isLoading: boolean = false;
    let loadingMessage: string = "Loading";

    $: contributionAmount = packetCost * BigInt(packetsToBuy ?? 0);

    $: totalICFC = packetsToBuy ? packetsToBuy * 10000 : 0;
    $: amountPerInstallment = totalICFC / 6;
    $: now = new Date();
    $: installments = Array.from({ length: 6 }, (_, i) => {
        let date = new Date(now);
        date.setMonth(date.getMonth() + 3 + i * 6);
        return date;
    });

    function validateContribution(): { isValid: boolean; error?: string } {
        if (!packetsToBuy || packetsToBuy <= 0) {
            return {
                isValid: false,
                error: "Please enter a valid amount."
            };
        }
        if (contributionAmount > userBalance) {
            return {
                isValid: false,
                error: "You don't have enough balance to buy this amount of packets."
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

    function handleInput(event) {
        const input = event.target.value;
        
        if (input === '' || input === '.') {
            packetsToBuy = null;
            contributionAmount = BigInt(0);
            return;
        } 
        else if (/^\d+$/.test(input)) {
            packetsToBuy = Number(input);
            contributionAmount = packetCost * BigInt(packetsToBuy);
        } 
        else if (input.includes('.')) {
            const cleanedInput = input.split('.')[0]; 
            if (/^\d+$/.test(cleanedInput)) {
                packetsToBuy = Number(cleanedInput);
                contributionAmount = packetCost * BigInt(packetsToBuy);
            } else {
                packetsToBuy = null;
                contributionAmount = BigInt(0);
            }
        } 
        else if (input.includes(',')) {
            const cleanedInput = input.split(',')[0]; 
            if (/^\d+$/.test(cleanedInput)) {
                packetsToBuy = Number(cleanedInput);
                contributionAmount = packetCost * BigInt(packetsToBuy);
            } else {
                packetsToBuy = null;
                contributionAmount = BigInt(0);
            }
        }
        else {
            packetsToBuy = null;
            contributionAmount = BigInt(0);
        }
    }

    async function handleSubmit() {
        loadingMessage = "Submitting Purchase";
        try {
            isLoading = true;
            const result = await saleStore.participateInSale(Number(contributionAmount));
            if (isError(result)) {
                console.error("Error purchasing ICFC Packets", result);
                toasts.addToast({
                    message: "Error purchasing ICFC Packets",
                    type: "error",
                });
                return;
            }
            toasts.addToast({
                message: "You purchased your ICFC Packets successfully",
                type: "success",
                duration: 3000
            });
            onClose();
        } catch (error) {
            toasts.addToast({
                message: "Error submitting purchase",
                type: "error",
            });
            console.error("Error submitting purchase", error);
        } finally {
            isLoading = false;
            showConfirm = false;
        }
    }

    function resetModalState() {
        contributionAmount = BigInt(0);
        packetsToBuy = null;
        showConfirm = false;
    }

    function handleClose() {
        resetModalState();
        onClose();
    }
    function addNumberCommas(num: number): string {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    async function refreshUserBalance() {
        try {
            loadingMessage = "Refreshing User Balance";
            isLoading = true;
            userBalance = (await saleStore.getUserBalance()) ?? 0n;
        } catch (error) {
            console.error("Error fetching user balance", error);
            toasts.addToast({
                message: "Error fetching user balance",
                type: "error",
                duration: 5000
            });
        } finally {
            isLoading = false;
        }
    }

    onMount(async () => {
        try {
            isLoading = true;
            resetModalState();
            loadingMessage = "Getting Sale Progress";
            let saleGoal = await saleStore.getProgress();
            if (saleGoal) {
                packetsRemaining = BigInt(saleGoal.remainingPackets);
                packetCost = saleGoal.packetCostinICP;
                maxContributionAmount = saleGoal.remainingPackets * saleGoal.packetCostinICP;
                loadingMessage = "Getting User Balance";
                userBalance = (await saleStore.getUserBalance()) ?? 0n;
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
                <div class="flex items-center justify-between">
                    <h3 class="text-xl text-white cta-text">Purchase Details</h3>
                    <button
                        onclick={refreshUserBalance}
                        class="px-4 py-1 text-white transition border rounded-lg bg-BrandBlueComp hover:bg-BrandBlack/50 hover:border-BrandBlue/80"
                        disabled={isLoading}
                    >
                        Refresh Balance
                    </button>
                </div>
                <div class="space-y-2">
                    <label for="packets" class="block text-sm text-BrandGrayShade2">
                        1 Packet = {packetCost} ICP = 10,000 ICFC
                    </label>
                    <input
                        id="packets"
                        min={1}
                        max={Number(packetsRemaining)}
                        oninput={handleInput} 
                        step="1"
                        type="number"
                        bind:value={packetsToBuy}
                        class="w-full px-4 py-3 text-white border rounded-lg border-BrandGrayShade3 bg-white/5 focus:outline-none focus:border-BrandBlue"
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

                {#if packetsToBuy > 0}
                    <div class="mt-4">
                        <h4 class="text-lg text-white">Distribution Schedule</h4>
                        <p class="text-sm text-BrandGrayShade2">
                            The ICFC tokens will be distributed in 6 equal installments starting 3 months from now, with subsequent installments every 6 months.
                        </p>
                        <div class="space-y-2 flex flex-col items-center justify-center w-full pt-2">
                            {#each installments as installment, index}
                                <div class="lg:flex lg:flex-row justify-between lg:w-[90%] w-full text-sm items-center text-white pb-2">                               
                                    <div class="flex-row lg:text-sm text-[10px]">   
                                        <div>{installment.toLocaleDateString('en-US', { day: 'numeric',month: 'short', year: 'numeric' })}</div>
                                        <div>ICFC Memmbership Sale (Disbursement {index + 1}/6)</div>
                                    </div>
                                    <div class="flex pt-1 lg:pt-0">  
                                        <IcfcCoinIcon className="w-6 mr-2" /> 
                                        <div><p class="text-[16px] font-200">{addNumberCommas(amountPerInstallment.toFixed(2))} ICFC</p></div>
                                    </div> 
                                </div>
                            {/each}
                        </div>
                    </div>
                {/if}

                <div class="flex gap-4 pt-4">
                    <button
                        onclick={handleClose}
                        class="flex-1 px-4 py-3 text-white transition border rounded-lg bg-BrandError/50 border-BrandGrayShade3 cta-text hover:bg-BrandBlack/50 hover:border-BrandError/80"
                        disabled={isLoading}
                    >
                        Cancel
                    </button>
                    <button
                        onclick={showConfirmation}
                        class="flex-1 px-4 py-3 text-white transition border rounded-lg brand-button hover:bg-BrandBlack/50 hover:border-BrandBlue/80"
                        disabled={isLoading}
                    >
                        Buy ICFC Packets
                    </button>
                </div>

                {#if showConfirm}
                    <div class="flex items-center">
                        <button
                            class="w-full px-4 py-3 text-white transition border rounded-lg brand-button hover:bg-BrandBlack/50 hover:border-BrandBlue/80"
                            onclick={handleSubmit}
                        >
                            Confirm Purchase
                        </button>
                    </div>
                {/if}
            </div>
        {/if}
    </Modal>
{/if}