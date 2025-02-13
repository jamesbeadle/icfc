<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "./Layout.svelte";
    import { appStore } from "$lib/stores/app-store";

  let isLoading = true;
  let totalICFC = 25_000_000;
  let targetCkBTC = 50;
  let raisedCkBTC = 29.71;
  let icfcPerPoint1CkBTC = 84146.7519354;
  let minTarget = 50;
  let maxTarget = 100;

  let progressPercentage = (raisedCkBTC / targetCkBTC) * 100;
  

  onMount(async () => {
    try {
      await appStore.checkServerVersion();
    } catch (error) {
      console.error("Error fetching funding data:", error);
    } finally {
      isLoading = false;
    }
  });
</script>

<Layout>
  {#if true}
    <p>Coming soon</p>
  {:else}
  <div class="max-w-4xl mx-auto p-6 space-y-2 bg-gray-800 shadow-lg rounded-lg">
    <h1 class="text-2xl font-bold text-center">ICFC</h1>
    <h1 class="text-xl font-bold text-center">Football Ownership Unleashed</h1>
    <p class="text-center text-gray-200 text-sm">
      The world's first decentralised football club is coming to the Internet Computer.
    </p>

    <div class="bg-gray-100 p-4 rounded-lg text-sm">
      <p class="text-sm font-semibold text-gray-700">Own your part of our football club here:</p>
      <p class="text-xs text-gray-500 break-all">
        ckBTC Address: agy5w-dlcen-pkrgo-pgfrz-3eqf2-xfwvr-qcvwn-nlhyu-77fsb-wgc37-nqe
      </p>
    </div>

    <div class="bg-gray-300 p-4 rounded-lg space-y-2">
      <p class="text-lg font-semibold text-black">Funding Progress</p>

      <div class="relative w-full bg-gray-200 rounded-full h-6">
        <div 
          class="bg-blue-500 h-6 rounded-full text-white text-xs flex items-center justify-center transition-all duration-500"
          style="width: {Math.min(progressPercentage, 100)}%;">
          {progressPercentage.toFixed(2)}%
        </div>
      </div>

      <p class="text-sm text-gray-700">
        <span class="font-semibold">{raisedCkBTC.toLocaleString()}</span> ckBTC raised out of <span class="font-semibold">{targetCkBTC.toLocaleString()} ckBTC</span>
      </p>
      <p class="text-sm text-gray-700">
        ICFC to be sold: <span class="font-semibold">{totalICFC.toLocaleString()}</span> ICFC
      </p>
      <p class="text-sm text-gray-700">
        Minimum Target: <span class="font-semibold">{minTarget.toLocaleString()}</span> ckBTC
      </p>
    </div>

    <div class="text-center">
      <p class="text-gray-200 text-sm my-4">ICFC per 0.1 ckBTC: <span class="font-semibold">{icfcPerPoint1CkBTC.toLocaleString()}</span></p>
      <button class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg shadow-lg transition duration-300">
        Buy ICFC
      </button>
    </div>

    <div class="flex w-full text-center items-center">
      <a href="/whitepaper" class="text-xs my-2 text-center w-full">Whitepaper</a>
    </div>
  </div>
  {/if}
</Layout>
