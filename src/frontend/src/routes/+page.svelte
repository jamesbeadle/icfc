<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "./Layout.svelte";
  import { appStore } from "$lib/stores/app-store";
  import { authStore, type AuthSignInParams } from "$lib/stores/auth-store";
  import { userStore } from "$lib/stores/user-store";
  import LandingPage from "$lib/components/homepage/landingPage/landing-page.svelte";
    import type { OptionIdentity } from "$lib/types/identity";
    import { createAgent } from "@dfinity/utils";
    import { SnsGovernanceCanister } from "@dfinity/sns";
    import { Principal } from "@dfinity/principal";
    import type { Neuron } from "@dfinity/sns/dist/candid/sns_governance";
    import { formatSecondsUnixDateToReadable } from "$lib/utils/helpers";

  let isLoggedIn: Boolean;
  let termsAgreed: Boolean;
  let isLoading = true;
  let user: any = undefined;
  let identity: OptionIdentity
  let neurons: Neuron[] = [];
  let principalId = '';

  let cardStyles = [
    'bg-footballgod-card',
    'bg-openfpl-card',
    'bg-transferkings-card',
    'bg-openwsl-card',
    'bg-jeffbets-card'
  ];


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

  async function getNeurons(){
    try {
      console.log("getting neurons")
      authStore.subscribe((auth) => (identity = auth.identity));
      if (!identity) return;
      const agent = await createAgent({
        identity,
        host: import.meta.env.VITE_AUTH_PROVIDER_URL,
        fetchRootKey: process.env.DFX_NETWORK === "local",
      });

      console.log("create governance canister")
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

      neurons = userNeurons.sort(sortByHightestNeuron);
    } catch (error) {
      console.error(error);
    }
  }

  function sortByHightestNeuron(a: Neuron, b: Neuron): number {
    return Number(b.cached_neuron_stake_e8s) - Number(a.cached_neuron_stake_e8s);
  }

  async function checkUser(){
      authStore.subscribe((store) => {
          isLoggedIn = store.identity !== null && store.identity !== undefined;
      });
      userStore.subscribe((store) => {
          if(store == null){
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
</script>

<Layout>
  {#if !isLoggedIn}
    <LandingPage />
    {:else}

      <div class="w-full flex flex-col p-4 space-y-2">
        <p>Principal Id: {principalId}</p>
        <p>Welcome to ICFC, your linked neurons are below:</p>
        {#if neurons.length == 0}
          <div>
            <p>You have no neurons</p>
          </div>
        {/if}
        {#each neurons as neuron, index}
        <div class={`flex flex-col overflow-hidden shadow-lg ${cardStyles[index % cardStyles.length]}`}>
              <div class="flex justify-between items-center">
                <div>
                  <h2 class="text-xl font-bold">Neuron: {Principal.fromUint8Array(new Uint8Array(neuron.id[0]?.id!)).toHex()}</h2>
                  <p class="text-sm">Dissolve Delay: {Object.keys(neuron.dissolve_state)[1]}</p>
                </div>
                <span class="text-3xl font-bold">
                  { (Number(neuron.cached_neuron_stake_e8s) / 100_000_000).toFixed(0)}
                </span>
              </div>
              <div class="mt-4">
                <p class="text-base">
                  Neuron created: { formatSecondsUnixDateToReadable(Number(neuron.created_timestamp_seconds))}
                </p>
              </div>
          </div>
        {/each}
      </div>
  {/if}
</Layout>
