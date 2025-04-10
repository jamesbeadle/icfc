<script lang="ts">
    import { onMount } from 'svelte';
    import { toasts } from '$lib/stores/toasts-store';
    import { saleStore } from '$lib/stores/sale-store';
    import { formatTokenBalance, isError } from '$lib/utils/helpers';
    import Modal from '../shared/modal.svelte';
    import CopyPrincipal from '../profile/copy-principal.svelte';
    import IcfcCoinIcon from "$lib/icons/ICFCCoinIcon.svelte";
    import LocalSpinner from '../shared/local-spinner.svelte';
    
    export let showModal: boolean;
    export let onClose: () => void;

    let userBalance = 0n;
    let contributionAmount = 0n;
    let maxContributionAmount = 0n;
    let packCost = 0n;
    let packsToBuy: number | null = null;
    let packsRemaining = 0n;
    let showConfirm: boolean = false;
    let isLoading: boolean = false;
    let loadingMessage: string = "Loading";

    $: contributionAmount = packCost * BigInt(packsToBuy ?? 0);

    $: totalICFC = packsToBuy ? packsToBuy * 10000 : 0;
    $: amountPerInstallment = totalICFC / 6;
    $: now = new Date();
    $: installments = Array.from({ length: 6 }, (_, i) => {
        const nowInNanoseconds = BigInt(now.getTime()) * 1_000_000n;
        const threeMonthsInNanoseconds = BigInt(3 * 30 * 24 * 60 * 60 * 1_000_000_000); 
        const sixMonthsInNanoseconds = BigInt(6 * 30 * 24 * 60 * 60 * 1_000_000_000);
        const installmentTimeInNanoseconds = nowInNanoseconds + threeMonthsInNanoseconds + BigInt(i) * sixMonthsInNanoseconds;
        const installmentDate = new Date(Number(installmentTimeInNanoseconds / 1_000_000n));
        return installmentDate;
    });

    onMount(async () => {
        try {
            isLoading = true;
            resetModalState();
            loadingMessage = "Getting Sale Progress";
            let saleGoal = await saleStore.getProgress();
            if (saleGoal) {
                let packCostE8s = (saleGoal.packCostinICP * 100_000_000n);
                packsRemaining = BigInt(saleGoal.remainingPacks);
                packCost = packCostE8s;
                maxContributionAmount = saleGoal.remainingPacks * packCostE8s;
                loadingMessage = "Getting User Balance";
                userBalance = (await saleStore.getUserBalance()) ?? 0n; 
                
            }
        } catch (error) {
            console.error("Error fetching sale goal", error);
        } finally {
            isLoading = false;
        }
    });

    function validateContribution(): { isValid: boolean; error?: string } {
        if (!packsToBuy || packsToBuy <= 0) {
            return {
                isValid: false,
                error: "Please enter a valid amount."
            };
        }
        if (contributionAmount > userBalance) {
            return {
                isValid: false,
                error: "You don't have enough balance to buy this amount of packs."
            };
        }
        if (contributionAmount > maxContributionAmount) {
            return {
                isValid: false,
                error: "You can't purchase more packs than the amount of packs remaining."
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

    function handleInput(event: Event & { currentTarget: EventTarget & HTMLInputElement }) {
        const input = event.currentTarget.value;
        
        if (input === '' || input === '.') {
            packsToBuy = null;
            contributionAmount = BigInt(0);
            return;
        } 
        else if (/^\d+$/.test(input)) {
            packsToBuy = Number(input);
            contributionAmount = packCost * BigInt(packsToBuy);
        } 
        else if (input.includes('.')) {
            const cleanedInput = input.split('.')[0]; 
            if (/^\d+$/.test(cleanedInput)) {
                packsToBuy = Number(cleanedInput);
                contributionAmount = packCost * BigInt(packsToBuy);
            } else {
                packsToBuy = null;
                contributionAmount = BigInt(0);
            }
        } 
        else if (input.includes(',')) {
            const cleanedInput = input.split(',')[0]; 
            if (/^\d+$/.test(cleanedInput)) {
                packsToBuy = Number(cleanedInput);
                contributionAmount = packCost * BigInt(packsToBuy);
            } else {
                packsToBuy = null;
                contributionAmount = BigInt(0);
            }
        }
        else {
            packsToBuy = null;
            contributionAmount = BigInt(0);
        }
    }

    async function handleSubmit() {
        loadingMessage = "Submitting Purchase";
        try {
            isLoading = true;
            const result = await saleStore.participateInSale(contributionAmount);
            if (isError(result)) {
                console.error("Error purchasing ICFC Packs", result);
                toasts.addToast({
                    message: "Error purchasing ICFC Packs",
                    type: "error",
                });
                return;
            }
            toasts.addToast({
                message: "You purchased your ICFC Packs successfully",
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
        packsToBuy = null;
        showConfirm = false;
    }

    function handleClose() {
        resetModalState();
        onClose();
    }
    function addNumberCommas(num: string | number): string {
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
</script>

{#if showModal}
    <Modal onClose={handleClose} title="Buy ICFC Packs">
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
                    <label for="packs" class="block text-sm text-BrandGrayShade2">
                        1 Pack = {formatTokenBalance(packCost)} ICP = 10,000 ICFC
                    </label>
                    <input
                        id="packs"
                        min={1}
                        max={Number(packsRemaining)}
                        oninput={handleInput} 
                        step="1"
                        type="number"
                        bind:value={packsToBuy}
                        class="w-full px-4 py-3 text-white border rounded-lg border-BrandGrayShade3 bg-white/5 focus:outline-none focus:border-BrandBlue"
                        placeholder="Enter number of packs"
                    />
                </div>
                <label for="principal" class="block text-sm text-BrandGrayShade2">
                    ICFC Principal ID
                </label>
                <CopyPrincipal bgColor="bg-white/5" borderColor="border-BrandGrayShade3" />

                <div class="p-4 space-y-3 rounded-lg bg-white/5">
                    <div class="flex justify-between">
                        <span class="text-BrandGrayShade2">Packs Remaining:</span>
                        <span class="font-medium text-white">{packsRemaining}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-BrandGrayShade2">Cost per Packs:</span>
                        <span class="font-medium text-white">{formatTokenBalance(packCost)} ICP</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-BrandGrayShade2">Packs to buy:</span>
                        <span class="font-medium text-white">{packsToBuy}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-BrandGrayShade2">Total cost:</span>
                        <span class="font-medium text-white">{formatTokenBalance(contributionAmount)} ICP</span>
                    </div>
                    <div class="flex justify-between pt-2 border-t border-BrandGrayShade3">
                        <span class="text-BrandGrayShade2">Your ICP balance:</span>
                        <span class="font-medium text-white">{formatTokenBalance(userBalance)} ICP</span>
                    </div>
                </div>

                {#if packsToBuy && packsToBuy > 0}
                    <div class="mt-4">
                        <h4 class="text-lg text-white">Distribution Schedule</h4>
                        <p class="text-sm text-BrandGrayShade2">
                            The ICFC tokens will be distributed in 6 equal installments starting 3 months from now, with subsequent installments every 6 months.
                        </p>
                        <div class="flex flex-col items-center justify-center w-full pt-2 space-y-2">
                            {#each installments as installment, index}
                                <div class="lg:flex lg:flex-row justify-between lg:w-[90%] w-full text-sm items-center text-white pb-2">                               
                                    <div class="flex-row lg:text-sm text-[10px]">   
                                        <div>{installment.toLocaleDateString('en-US', { day: 'numeric',month: 'short', year: 'numeric' })}</div>
                                        <div>ICFC Membership Sale (Disbursement {index + 1}/6)</div>
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
                        Buy ICFC Packs
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