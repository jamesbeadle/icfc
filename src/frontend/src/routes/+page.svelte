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
  

  let isLoggedIn: Boolean;
  let termsAgreed: Boolean;
  let isLoading = true;
  let user: any = undefined;
  let identity: OptionIdentity;
  let loadingNeurons = true;
  let neurons: Neuron[] = [];
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
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4 p-4">
        {#each neurons as neuron, index}
          <div class="relative h-[400px] w-full max-w-[260px] mx-auto overflow-hidden rounded-2xl bg-BrandInfo shadow-lg">
            <div class="absolute inset-0 opacity-40 overflow-hidden flex items-center">
              <LogoIcon 
                className="h-[450px] w-auto m-4" 
              />
            </div>

            <div class="absolute top-0 w-full p-4">
              <h2 class="text-xs">ICFC NEURON:</h2>
              <p class="text-xs text-wrap">{Principal.fromUint8Array(new Uint8Array(neuron.id[0]?.id!)).toHex()}</p>
              <div class="w-full h-px bg-white/50 my-2"></div>
            </div>

            <div class="absolute bottom-0 w-full p-4">
              <div class="w-full h-px bg-white/50 mb-2"></div> 
              <p class="text-xs uppercase text-white/70">Dissolve Delay: {convertBigIntSeconds(Object.values(neuron.dissolve_state[0]!)[0])}</p>
              <span class="font-bold text-white text-lg block">
                {formatICFC(Number(neuron.cached_neuron_stake_e8s) / 100_000_000)} ICFC
              </span>
              <p class="text-xs text-white/70">Created: {formatSecondsUnixDateToReadable(Number(neuron.created_timestamp_seconds))}</p>
            </div>
          </div>
        {/each}
      </div>
    {/if}
  </div>
</Layout>

<style>
  /* Ensure the SVG is positioned correctly and stays faint */
  .absolute {
    position: absolute;
  }
</style>