<script lang="ts">
    import { onMount } from "svelte";
    import { appStore } from "$lib/stores/app-store";
    import { toasts } from "$lib/stores/toasts-store";
    import type { TokenBalances } from "../../../../../declarations/backend/backend.did";
    import IcfcCoinIcon from "$lib/icons/ICFCCoinIcon.svelte";
    import { formatTokenBalance } from "$lib/utils/helpers";
    import IcpCoinIcon from "$lib/icons/ICPCoinIcon.svelte";
    import CkbtcCoinIcon from "$lib/icons/CKBTCCoinIcon.svelte";
    import IcgcCoinIcon from "$lib/icons/ICGCCoinIcon.svelte";
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";

    let isLoading = true;
    let tokenBalances: TokenBalances | null = null;

    onMount(async() => {
        try{
            let balances = await appStore.getTokenBalances();
            if(balances){
                tokenBalances = balances;
            }
        } catch{
            toasts.addToast({ type: 'error', message: 'Error loading token balances'});
        } finally {
            isLoading = false;
        }
    });

</script>
    {#if isLoading}
        <LocalSpinner />
    {:else}
    <div class="min-h-screen bg-BrandBlackShade1">
        <div class="p-4 mx-auto">
            <div class="p-2">
                <h1 class="text-3xl cta-text">Token Balances</h1>
            </div>

            <div class="flex flex-col space-y-4">
                <p class="text-xl cta-text"></p>
                <p class="flex flex-row items-center">
                    <IcfcCoinIcon className="w-6 mx-2" /> {formatTokenBalance(tokenBalances?.icfcBalance ?? 0n)} ICFC
                </p>
                <p class="flex flex-row items-center">
                    <IcpCoinIcon className="w-6 mx-2" /> {formatTokenBalance(tokenBalances?.icpBalance ?? 0n)} ICP
                </p>
                <p class="flex flex-row items-center">
                    <CkbtcCoinIcon className="w-6 mx-2" /> {formatTokenBalance(tokenBalances?.ckBTCBalance ?? 0n)} ckBTC
                </p>
                <p class="flex flex-row items-center">
                    <IcgcCoinIcon className="w-6 mx-2" /> {formatTokenBalance(tokenBalances?.icgcBalance ?? 0n)} ICGC
                </p>
            </div>
        </div>
    </div>



    {/if}
