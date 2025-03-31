<script lang="ts">
    import IcfcCoinIcon from "$lib/icons/ICFCCoinIcon.svelte";
    
    export let formatICFC: (amount: bigint) => string;
    export let maxStakedICFC: bigint;
</script>
<div class="flex flex-col items-center justify-center w-full p-4 space-y-2 text-center md:w-1/2">
    <p class="text-xl text-white">Total ICFC Staked:</p>
    <div class="flex flex-row items-center h-8 space-x-2">
        <IcfcCoinIcon className="w-7" />
        <p class="text-lg text-white">{formatICFC(maxStakedICFC / 100000000n)}</p>
    </div>
    <p class="text-base text-BrandGrayShade3">Non-dissolving neurons with a dissolve delay greater than 2 years.</p>
</div>