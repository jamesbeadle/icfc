<script lang="ts">
	import type { ICFCDistribution, UserParticipation, ClaimedRecord } from '../../../../../../declarations/icfc_sale_2/icfc_sale_2.did.js';
	import { saleStore } from '$lib/stores/sale-store';
    import { onMount } from 'svelte';
    import { authStore } from '$lib/stores/auth-store';
    import { toasts } from '$lib/stores/toasts-store';
    import { formatUnixDateToReadable } from '$lib/utils/helpers';
    import LocalSpinner from '$lib/components/shared/local-spinner.svelte';

    let participation: UserParticipation | undefined = $state(undefined);
    let distributions: ICFCDistribution[] | undefined = $state(undefined);
    let loading = $state(true);

    onMount(async () => {
       await refreshData();
    });

    async function refreshData() {
        try {
             loading = true;
            [participation, distributions] = await Promise.all([
                saleStore.getUserParticipation(),
                saleStore.getUsersICFCDistributions()
            ]);
        } catch (err) {
            console.error('Failed to load claims:', err);
            toasts.addToast({
                message: 'Failed to load claims',
                type: 'error',
                duration: 3000
            });
        } finally {
            loading = false;
        }
    }
</script>
<div class="p-8 mx-auto">
    <h1 class="mb-8 text-4xl font-bold text-white cta-text">Your ICFC Claims</h1>
    
    {#if loading}
        <div class="flex justify-center p-8">
            <LocalSpinner message="Loading your claim data..." />
        </div>
    {:else}
        <div class="grid grid-cols-1 gap-4 mb-8 sm:grid-cols-3">
        <div class="p-4 rounded-lg bg-white/5">
            <h3 class="brand-sub-title">Total Claims</h3>
            <p class="text-2xl font-bold text-white">
            {participation?.participations.length ?? 0}
            </p>
        </div>
        <div class="p-4 rounded-lg bg-white/5">
            <h3 class="brand-sub-title">Total Packets</h3>
            <p class="text-2xl font-bold text-white">
            {participation?.participations.reduce((sum, p) => sum + p.packetsClaimed, BigInt(0)).toString()}
            </p>
        </div>
        <div class="p-4 rounded-lg bg-white/5">
            <h3 class="brand-sub-title">Pending Distributions</h3>
            <p class="text-2xl font-bold text-white">
            {distributions?.filter(d => 'Pending' in d.distributionStatus).length ?? 0}
            </p>
        </div>
        </div>

        <div class="p-6 mb-8 rounded-lg bg-white/5">
        <h2 class="mb-4 text-3xl cta-text text-BrandSuccess">Participation History</h2>
        {#if participation?.participations?.length}
            <div class="overflow-x-auto scrollbar-thin">
            <table class="w-full">
                <thead>
                <tr class="text-left border-b border-BrandGrayShade3">
                    <th class="p-3 small-header">Claim ID</th>
                    <th class="p-3 small-header">Date Claimed</th>
                    <th class="p-3 small-header">Packets Claimed</th>
                </tr>
                </thead>
                <tbody>
                {#if participation.participations.length}
                    {#each participation.participations as claim (claim.claimId)}
                    <tr class="transition-colors border-b border-BrandGrayShade3 hover:bg-white/5">
                        <td class="p-3 text-BrandGrayShade5">{claim.claimId}</td>
                        <td class="p-3 text-BrandGrayShade5">{formatUnixDateToReadable(Number(claim.claimedOn))}</td>
                        <td class="p-3 text-BrandGrayShade5">{claim.packetsClaimed}</td>
                    </tr>
                    {/each}
                {:else}
                    <tr>
                    <td colspan="3" class="p-3 text-BrandGrayShade5">No participation records found</td>
                    </tr>
                {/if}
                </tbody>
            </table>
            </div>
        {:else}
            <p class="text-BrandGrayShade3">No participation records found</p>
        {/if}
        </div>

        <div class="p-6 rounded-lg bg-white/5">
        <h2 class="mb-4 section-title">Distribution Schedule</h2>
        {#if distributions?.length}
            <div class="overflow-x-auto scrollbar-thin">
            <table class="w-full">
                <thead>
                <tr class="text-left border-b border-BrandGrayShade3">
                    <th class="p-3 small-header">Installment</th>
                    <th class="p-3 small-header">Distribution Date</th>
                    <th class="p-3 small-header">Amount</th>
                    <th class="p-3 small-header">Status</th>
                </tr>
                </thead>
                <tbody>
                {#each distributions as dist (dist.claimId)}
                    <tr class="transition-colors border-b border-BrandGrayShade3 hover:bg-white/5">
                    <td class="p-3 text-BrandGrayShade5">{dist.installment.toString()}</td>
                    <td class="p-3 text-BrandGrayShade5">{formatUnixDateToReadable(Number(dist.time))}</td>
                    <td class="p-3 text-BrandGrayShade5">{(dist.amount)} ICFC</td>
                    <td class="p-3">
                        <span class:status={'Completed' in dist.distributionStatus}
                            class:auto-claimed-membership-badge={'Completed' in dist.distributionStatus}
                            class:already-claimed-membership-badge={'Pending' in dist.distributionStatus}>
                        {'Completed' in dist.distributionStatus ? 'Completed' : 'Pending'}
                        </span>
                    </td>
                    </tr>
                {/each}
                </tbody>
            </table>
            </div>
        {:else}
            <p class="text-BrandGrayShade3">No distributions scheduled yet</p>
        {/if}
        
        </div>
        <div class="flex justify-center mt-8">
            <button 
                class="px-4 py-2 text-white transition border rounded-lg brand-button hover:bg-BrandBlack/50 hover:border-BrandSuccess"
                onclick={refreshData}
            >
                Refresh
            </button>
        </div>
    {/if}
</div>