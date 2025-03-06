<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "./Layout.svelte";
  import { appStore } from "$lib/stores/app-store";
  import { authStore, type AuthSignInParams } from "$lib/stores/auth-store";
  import { userStore } from "$lib/stores/user-store";
  import type { OptionIdentity } from "$lib/types/identity";
  import { createAgent } from "@dfinity/utils";
  import { SnsGovernanceCanister } from "@dfinity/sns";
  import { Principal } from "@dfinity/principal";
  import type { Neuron } from "@dfinity/sns/dist/candid/sns_governance";
  import { formatSecondsUnixDateToReadable } from "$lib/utils/helpers";
    import LogoIcon from "$lib/icons/LogoIcon.svelte";
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import LogoIconWhite from "$lib/icons/LogoIconWhite.svelte";
  

  let isLoggedIn: Boolean;
  let termsAgreed: Boolean;
  let isLoading = true;
  let user: any = undefined;
  let identity: OptionIdentity;
  let loadingNeurons = true;
  let neurons: Neuron[] = [
  ];
  let principalId = '';

  onMount(async () => {
    try {
      await appStore.checkServerVersion();
      await getNeurons();
      await checkUser();
    } catch (error) {
      console.error("Error fetching funding data:", error);
    } finally {
      isLoading = false;
    }
  });

  async function getNeurons() {
    try {
      console.log("getting neurons");
      authStore.subscribe((auth) => (identity = auth.identity));
      if (!identity) return;
      const agent = await createAgent({
        identity,
        host: import.meta.env.VITE_AUTH_PROVIDER_URL,
        fetchRootKey: process.env.DFX_NETWORK === "local",
      });

      console.log("create governance canister");
      const { listNeurons } = SnsGovernanceCanister.create({
        canisterId: Principal.fromText(
          process.env.SNS_GOVERNANCE_CANISTER_ID ?? "",
        ),
        agent,
      });

      principalId = identity.getPrincipal().toString();

      const userNeurons = await listNeurons({
        principal: identity.getPrincipal(),
        limit: 100,
        beforeNeuronId: { id: [] },
      });

      console.log(userNeurons);

      neurons = userNeurons.sort(sortByHighestNeuron);
    } catch (error) {
      console.error(error);
    } finally {
      loadingNeurons = false;
    }
  }

  function sortByHighestNeuron(a: Neuron, b: Neuron): number {
    return Number(b.cached_neuron_stake_e8s) - Number(a.cached_neuron_stake_e8s);
  }

  async function checkUser() {
    authStore.subscribe((store) => {
      isLoggedIn = store.identity !== null && store.identity !== undefined;
    });
    userStore.subscribe((store) => {
      if (store == null) {
        return;
      }
      user = store;
      termsAgreed = store == null 
        ? false 
        : store.termsAcceptedDate == undefined 
          ? false 
          : store.termsAcceptedDate > 0;
    });
  }

  function convertBigIntSeconds(value: bigint): string {
    const secondsInMinute = 60n;
    const secondsInHour = 60n * secondsInMinute;
    const secondsInDay = 24n * secondsInHour;
    const secondsInYear = 365n * secondsInDay;

    let remainingSeconds = value;

    const years = remainingSeconds / secondsInYear;
    remainingSeconds = remainingSeconds % secondsInYear;

    const days = remainingSeconds / secondsInDay;

    return `${years} years ${days} days`;
  }

  // Function to round ICFC amount to whole number
  function formatICFC(amount: number): string {
    return Math.round(amount).toLocaleString();
  }
</script>

<Layout>
  <div class="w-full flex flex-col p-4 space-y-2">
    <p>Principal Id: {principalId}</p>
    <p>Welcome to ICFC, your linked neurons are below:</p>
    {#if neurons.length === 0}
      <div>
        <p>You have no neurons</p>
      </div>
    {/if}
    {#if loadingNeurons}
      <LocalSpinner />
    {:else}
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 p-4">
        {#each neurons as neuron, index}
          <div class="relative h-[420px] w-full max-w-[280px] mx-auto overflow-hidden rounded-xl gb-BrandGray shadow-xl hover:shadow-2xl transition-shadow duration-300">
            <div class="absolute inset-0 opacity-20 flex items-center justify-center">
              <LogoIconWhite className="h-[400px] mx-auto w-auto opacity-20" />
            </div>
            <div class="p-6 flex flex-col h-full justify-between">
              <div class="space-y-2">
                <h2 class="text-2xl font-bold text-white">ICFC NEURON</h2>
                <p class="text-sm text-BrandGrayShade5 truncate">{Principal.fromUint8Array(new Uint8Array(neuron.id[0]?.id!)).toHex()}</p>
              </div>
              <div class="flex justify-center my-4">
                <img class="w-20" src="star.png" alt="Golden Star" />
              </div>
              <div class="space-y-2">
                <p class="text-sm text-BrandGrayShade5">Dissolve Delay: {convertBigIntSeconds(Object.values(neuron.dissolve_state[0]!)[0])}</p>
                <p class="text-xl font-semibold text-white cta-text my-2">
                  {formatICFC(Number(neuron.cached_neuron_stake_e8s) / 100_000_000)} ICFC
                </p>
                <p class="text-sm text-BrandGrayShade5">Created: {formatSecondsUnixDateToReadable(Number(neuron.created_timestamp_seconds))}</p>
              </div>
              <div class="mt-4">
                {#if Number(neuron.cached_neuron_stake_e8s) / 100_000_000 >= 100_000}
                  <button class="brand-button w-full bg-yellow-500 hover:bg-yellow-600 text-gray-900 font-bold py-2 rounded-lg transition-colors duration-300">
                    Claim Lifetime Membership
                  </button>
                {:else if Number(neuron.cached_neuron_stake_e8s) / 100_000_000 >= 10_000}
                  <button class="brand-button w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 rounded-lg transition-colors duration-300">
                    Claim Season Membership
                  </button>
                {:else if Number(neuron.cached_neuron_stake_e8s) / 100_000_000 >= 1_000}
                  <button class="brand-button w-full bg-green-500 hover:bg-green-600 text-white font-bold py-2 rounded-lg transition-colors duration-300">
                    Claim Monthly Membership
                  </button>
                {:else}
                  <button class="brand-button w-full bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 rounded-lg transition-colors duration-300">
                    Stake 1,000 ICFC for Rewards
                  </button>
                {/if}
              </div>
            </div>
          </div>
        {/each}
      </div>
    {/if}
  </div>
</Layout>

<style>
  .absolute {
    position: absolute;
  }
</style>