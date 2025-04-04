<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { countryStore } from "$lib/stores/country-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { membershipStore } from "$lib/stores/membership-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { getFileExtensionFromFile, sortByHighestNeuron } from "$lib/utils/helpers";
  
  import type { CreateProfile, EligibleMembership, Neuron, LeagueId, ClubId, CountryId, Country, League } from "../../../../../../declarations/backend/backend.did";

  import LocalSpinner from "../../shared/local-spinner.svelte";
  import AvailableMembership from "../../membership/available-membership.svelte";
  import CopyPrincipal from "../copy-principal.svelte";
  import CreateUserHeader from "./create-user-header.svelte";
  import UserDetailsLayout from "./user-details/user-details-layout.svelte";

  let isLoading = false;
  let isSubmitDisabled = true;
  
  let usernameAvailable = false;
  let username = "";
  let displayName = "";

  let loadingNeurons = true;
  let neurons: Neuron[] = [];
  let maxStakedICFC = 0n;

  let countries: Country[] = [];
  let leagues: League[] = [];
  let favouriteLeagueId: LeagueId | null = null;
  let favouriteClubId: ClubId | null = null;
  let nationalityId: CountryId | null = null;

  let file: File | null = null;
  
  let userMembershipEligibility: EligibleMembership | null = null;
  let loadingDropdownData = true;
  $: isSubmitDisabled = !username || !usernameAvailable;

  onMount(() => {
    Promise.all([
      getNeurons(),
      loadCountriesAndLeagues()
    ]);
  });

  async function loadCountriesAndLeagues() {
    try {
      const [countriesResult, leaguesResult] = await Promise.all([
        countryStore.getCountries(),
        leagueStore.getLeagues()
      ]);

      if (countriesResult) {
        countries = countriesResult.countries;
        countryStore.setCountries(countries);
      }

      if (leaguesResult) {
        leagues = leaguesResult.leagues;
        leagueStore.setLeagues(leagues);
      }
      console.log('load countries and leagues complete')
    } catch {
      toasts.addToast({ type: 'info', message: 'Error loading league and country data.' });
    } finally {
      loadingDropdownData = false;
    }
  }

  async function getNeurons() {
    try {
      loadingNeurons = true;
      let neuronsResult = await membershipStore.getUserNeurons();
      if (neuronsResult) {
        neurons = neuronsResult.userNeurons.sort(sortByHighestNeuron);
        userMembershipEligibility = neuronsResult.userMembershipEligibility;
        maxStakedICFC = neuronsResult.totalMaxStaked;
      }
      console.log('get neurons complete')
    } catch {
      toasts.addToast({ type: 'info', message: 'No neurons found' });
      neurons = [];
      userMembershipEligibility = { membershipType: { NotEligible: null }, eligibleNeuronIds: [] };
      maxStakedICFC = BigInt(0);
    } finally {
      loadingNeurons = false;
    }
  }

  async function createProfile() {
    isLoading = true;
    try {

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
          favouriteLeagueId: favouriteLeagueId != null ? [favouriteLeagueId] : [],
          favouriteClubId: favouriteClubId != null ? [favouriteClubId!] : [],
          nationalityId: nationalityId != null ? [nationalityId!] : []
        };

        await userStore.createProfile(dto);
      }
      await userStore.sync();
      toasts.addToast({type: 'success', message: 'Profile successfully created'});
      toasts.addToast({type: 'info', message: 'You can link your OpenFPL account in the profile section'});
      window.location.href = "/";
    } catch (error) {
      console.error("Error creating profile:", error);
      toasts.addToast({type: 'error', message: 'Failed to create profile. Please try again.'});
    } finally {
      isLoading = false;
    }
  }

  async function refreshNeurons() {
    try{
      loadingNeurons = true;
      await getNeurons();
    } catch {
      toasts.addToast({ type: 'error', message: 'Failed to refresh neurons' })
    } finally {
      loadingNeurons = false;
    }
  }
</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="flex flex-col mx-auto space-y-6">
    <div class="px-8 py-6 ">
      <CreateUserHeader />
      {#if loadingDropdownData}
        <LocalSpinner />
      {:else}
        <UserDetailsLayout bind:file bind:nationalityId bind:favouriteLeagueId bind:favouriteClubId bind:username bind:usernameAvailable bind:displayName store={userStore} />
      {/if}
      
      <div class="flex flex-col mt-8 space-y-6">
        <p class="text-lg text-white cta-text">Neuron Based Membership</p>
        <p class="text-BrandGrayShade5">
          To join the ICFC you need to have a non-dissolving NNS neuron with at least 1,000 ICFC staked, max staked for 2 years. Add your ICFC Principal as a hotkey to any ICFC NNS neuron over 1,000 ICFC to continue:
        </p>
        <CopyPrincipal />
        {#if loadingNeurons}
          <LocalSpinner />
        {:else}
          {#if neurons.length >= 0}
            <div class="flex flex-col space-y-4">
              <AvailableMembership {neurons} {refreshNeurons} availableMembership={userMembershipEligibility?.membershipType!} {maxStakedICFC} />        
            </div>
          {/if}
        {/if}
        
      </div>
      <button 
        class="w-full my-8 transition brand-button bg-BrandBlue hover:bg-BrandInfo disabled:bg-BrandGrayShade3" 
        on:click={createProfile} 
        disabled={isSubmitDisabled}
      >
        JOIN ICFC
      </button>
    </div>
  </div>
{/if}