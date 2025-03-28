<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { countryStore } from "$lib/stores/country-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { membershipStore } from "$lib/stores/membership-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { getFileExtensionFromFile, isPrincipalValid, sortByHighestNeuron } from "$lib/utils/helpers";
  
  import type { CreateProfile, EligibleMembership, Neuron, PrincipalId, SubApp } from "../../../../../../declarations/backend/backend.did";
  import type { LeagueId, ClubId, CountryId, ClubDTO, CountryDTO, FootballLeagueDTO } from "../../../../../../external_declarations/data_canister/data_canister.did";
  
  import LocalSpinner from "../../shared/local-spinner.svelte";
  import AvailableMembership from "../../membership/available-membership.svelte";
  import CopyPrincipal from "../copy-principal.svelte";
  import CreateUserHeader from "./create-user-header.svelte";
  import UserDetailsLayout from "./user-details/user-details-layout.svelte";

  let isLoading = true;
  let isSubmitDisabled = true;
  
  let usernameAvailable = false;
  let username = "";
  let displayName = "";
  
  let openFplPrincipalId = '';
  let footballGodPrincipalId = '';
  let transferKingsPrincipalId = '';
  let jeffBetsPrincipalId = '';
  let openWslPrincipalId = '';
  
  let loadingNeurons = false;
  let neurons: Neuron[] = [];
  let maxStakedICFC = 0n;

  let clubs: ClubDTO[] = [];
  let countries: CountryDTO[] = [];
  let leagues: FootballLeagueDTO[] = [];
  let favouriteLeagueId: LeagueId | null = null;
  let favouriteClubId: ClubId | null = null;
  let nationalityId: CountryId | null = null;

  let file: File | null = null;
  
  let userMembershipEligibility: EligibleMembership | null = null;
  $: isSubmitDisabled = !username || !usernameAvailable;

  onMount(async () => {
    try{
      countries = await countryStore.getCountries();
      leagues = await leagueStore.getLeagues();
      await loadData();
    } catch {
      toasts.addToast({type: 'error', message: 'Failed to load data.'});
    } finally {
      isLoading = false;
    }
  });

  async function loadData(){
      try {
          await getNeurons();
      } catch (error) {
          console.error("No neurons found:", error);
      } finally {
          isLoading = false;
      }
  }

  async function getNeurons() {
    console.log("Getting neurons for create user");
    let neuronsResult = await membershipStore.getUserNeurons();
    console.log("neuronsResult: ", neuronsResult);
    if (neuronsResult) {
        neurons = neuronsResult.userNeurons.sort(sortByHighestNeuron);
        console.log("Sorted neurons: ", neurons);
        userMembershipEligibility = neuronsResult.userMembershipEligibility;
        console.log("userMembershipEligibility: ", userMembershipEligibility);
        maxStakedICFC = neuronsResult.totalMaxStaked;
        console.log("maxStakedICFC: ", maxStakedICFC);
    }
  }

  async function createProfile() {
    isLoading = true;
    try {
      let appPrincipalIds: Array<[SubApp, PrincipalId]> = [];

      if(openFplPrincipalId.length > 0 && isPrincipalValid(openFplPrincipalId)){
        appPrincipalIds.push([{ OpenFPL: null }, openFplPrincipalId]);
      }

      if(openWslPrincipalId.length > 0 && isPrincipalValid(openWslPrincipalId)){
        appPrincipalIds.push([{ OpenWSL: null }, openWslPrincipalId]);
      }

      if(transferKingsPrincipalId.length > 0 && isPrincipalValid(transferKingsPrincipalId)){
        appPrincipalIds.push([{ TransferKings: null }, transferKingsPrincipalId]);
      }

      if(footballGodPrincipalId.length > 0 && isPrincipalValid(footballGodPrincipalId)){
        appPrincipalIds.push([{ FootballGod: null }, footballGodPrincipalId]);
      }

      if(jeffBetsPrincipalId.length > 0 && isPrincipalValid(jeffBetsPrincipalId)){
        appPrincipalIds.push([{ JeffBets: null }, jeffBetsPrincipalId]);
      }

      if (file) {
        const extension = getFileExtensionFromFile(file);
        const reader = new FileReader();
        
        const profilePictureData = new Promise<Uint8Array>((resolve, reject) => {
          reader.onloadend = () => {
            const arrayBuffer = reader.result as ArrayBuffer;
            const uint8Array = new Uint8Array(arrayBuffer);
            resolve(uint8Array);
          };
          reader!.onerror = reject;
          reader.readAsArrayBuffer(file!);
        });

        const profilePicture = await profilePictureData;

        const dto: CreateProfile = {
          displayName,
          profilePicture: [profilePicture],
          username,
          appPrincipalIds,
          favouriteLeagueId: favouriteLeagueId != null ? [favouriteLeagueId] : [],
          favouriteClubId: favouriteClubId != null ? [favouriteClubId!] : [],
          nationalityId: nationalityId != null ? [nationalityId!] : []
        };

        await userStore.createProfile(dto);
      } else {
        const dto: CreateProfile = {
          displayName,
          profilePicture: [],
          username,
          appPrincipalIds,
          favouriteLeagueId: favouriteLeagueId != null ? [favouriteLeagueId] : [],
          favouriteClubId: favouriteClubId != null ? [favouriteClubId!] : [],
          nationalityId: nationalityId != null ? [nationalityId!] : []
        };

        await userStore.createProfile(dto);
      }

      await userStore.sync();
      toasts.addToast({type: 'success', message: 'Profile successfully created'});
      window.location.href = "/";
    } catch (error) {
      console.error("Error creating profile:", error);
      toasts.addToast({type: 'error', message: 'Failed to create profile'});
    } finally {
      isLoading = false;
    }
  }


  async function refreshNeurons() {
    try{
      loadingNeurons = true;
      await loadData();
    } catch {
      toasts.addToast({ type: 'error', message: 'Failed to refresh neurons' })
    } finally {
      loadingNeurons = false;
    }
  }

  $: if (!isLoading && favouriteLeagueId && favouriteLeagueId > 0) {
    getClubs();
  }

  async function getClubs() {
    let clubsResult = await clubStore.getClubs(favouriteLeagueId!);
    if(!clubsResult){ return }
    clubs = clubsResult;
  }
</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="px-4 py-6 mx-auto page-wrapper max-w-7xl">
    <div class="flex flex-col space-y-6">

      <CreateUserHeader />

      <UserDetailsLayout bind:file {countries} {leagues} {clubs} bind:nationalityId bind:favouriteLeagueId bind:favouriteClubId bind:username bind:usernameAvailable bind:displayName store={userStore} />

      <div class="flex flex-col space-y-4">
        <p class="text-lg text-white cta-text">Neuron Based Membership</p>
        <p class="text-BrandGrayShade5">
          To join the ICFC you need to have a non-dissolving NNS neuron with at least 1,000 ICFC staked, max staked for 2 years. Add your ICFC Principal as a hotkey to any ICFC NNS neuron over 1,000 ICFC to continue:
        </p>
        <CopyPrincipal />
        {#if loadingNeurons}
          <LocalSpinner />
        {:else}
          {#if neurons.length > 0}
            <div class="flex flex-col space-y-4">

              <AvailableMembership {neurons} {refreshNeurons} availableMembership={userMembershipEligibility?.membershipType!} {maxStakedICFC} />

              <div class="border-t horizontal-divider border-BrandGrayShade3"></div>

              <div class="flex flex-col space-y-4">
                <p class="text-lg text-white cta-text">Sub-App Principal IDs</p>
                <p class="text-BrandGrayShade2">
                  Enter your Principal IDs for ICFC sub-applications (optional)
                </p>
                
                <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                  <div class="flex flex-col space-y-4">
                    <div class="flex flex-col space-y-1">
                      <p class="form-title">OpenFPL Principal ID</p>
                      <p class="form-hint">A valid principal ID</p>
                      <input
                        type="text"
                        bind:value={openFplPrincipalId}
                        class="brand-input"
                        placeholder="Enter OpenFPL Principal ID"
                      />
                      {#if openFplPrincipalId.length > 0}
                        <div class="mt-1 text-sm">
                          {#if !isPrincipalValid(openFplPrincipalId)}
                            <p class="mt-1 text-BrandRed">Invalid Principal ID</p>
                          {:else}
                            <p class="mt-1 text-BrandSuccess">Valid Principal ID</p>
                          {/if}
                        </div>
                      {/if}
                    </div>

                    <div class="flex flex-col space-y-1">
                      <p class="form-title">Football God Principal ID</p>
                      <p class="form-hint">A valid principal ID</p>
                      <input
                        type="text"
                        bind:value={footballGodPrincipalId}
                        class="brand-input"
                        placeholder="Enter Football God Principal ID"
                      />
                      {#if footballGodPrincipalId.length > 0}
                        <div class="mt-1 text-sm">
                          {#if !isPrincipalValid(footballGodPrincipalId)}
                            <p class="text-BrandRed">Invalid Principal ID</p>
                          {:else}
                            <p class="text-BrandGreed">Valid Principal ID</p>
                          {/if}
                        </div>
                      {/if}
                    </div>

                    <div class="flex flex-col space-y-1">
                      <p class="form-title">Transfer Kings Principal ID</p>
                      <p class="form-hint">A valid principal ID</p>
                      <input
                        type="text"
                        bind:value={transferKingsPrincipalId}
                        class="brand-input"
                        placeholder="Enter Transfer Kings Principal ID"
                      />
                      {#if transferKingsPrincipalId.length > 0}
                        <div class="mt-1 text-sm">
                          {#if !isPrincipalValid(transferKingsPrincipalId)}
                            <p class="mt-1 text-BrandRed">Invalid Principal ID</p>
                          {:else}
                            <p class="mt-1 text-BrandSuccess">Valid Principal ID</p>
                          {/if}
                        </div>
                      {/if}
                    </div>
                  </div>

                  <div class="flex flex-col space-y-4">
                    <div class="flex flex-col space-y-1">
                      <p class="form-title">Jeff Bets Principal ID</p>
                      <p class="form-hint">A valid principal ID</p>
                      <input
                        type="text"
                        bind:value={jeffBetsPrincipalId}
                        class="brand-input"
                        placeholder="Enter Jeff Bets Principal ID"
                      />
                      {#if jeffBetsPrincipalId.length > 0}
                        <div class="mt-1 text-sm">
                          {#if !isPrincipalValid(jeffBetsPrincipalId)}
                            <p class="mt-1 text-BrandRed">Invalid Principal ID</p>
                          {:else}
                            <p class="mt-1 text-BrandSuccess">Valid Principal ID</p>
                          {/if}
                        </div>
                      {/if}
                    </div>

                    <div class="flex flex-col space-y-1">
                      <p class="form-title">OpenWSL Principal ID</p>
                      <p class="form-hint">A valid principal ID</p>
                      <input
                        type="text"
                        bind:value={openWslPrincipalId}
                        class="brand-input"
                        placeholder="Enter OpenWSL Principal ID"
                      />
                      {#if openWslPrincipalId.length > 0}
                        <div class="mt-1 text-sm">
                          {#if !isPrincipalValid(openWslPrincipalId)}
                            <p class="mt-1 text-BrandRed">Invalid Principal ID</p>
                          {:else}
                            <p class="mt-1 text-BrandSuccess">Valid Principal ID</p>
                          {/if}
                        </div>
                      {/if}
                    </div>
                  </div>
                </div>

                <div class="border-t horizontal-divider border-BrandGrayShade3"></div>
              
                <button 
                  class="py-2 text-white transition rounded-lg brand-button bg-BrandBlue hover:bg-BrandInfo disabled:bg-BrandGrayShade3" 
                  on:click={createProfile} 
                  disabled={isSubmitDisabled}
                >
                  JOIN
                </button>

              </div>

            </div>
          {/if}
        {/if}
        <div class="h-6"></div>
      </div>
           
    </div>
  </div>
{/if}