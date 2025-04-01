<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { countryStore } from "$lib/stores/country-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { userIdCreatedStore } from "$lib/stores/user-control-store";
  import { authStore } from "$lib/stores/auth-store";
  import { membershipStore } from "$lib/stores/membership-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { getFileExtensionFromFile, isPrincipalValid, sortByHighestNeuron } from "$lib/utils/helpers";
  
  import type { CreateProfile, EligibleMembership, Neuron, PrincipalId, SubApp, UserNeuronsDTO, LeagueId, ClubId, CountryId, CountryDTO} from "../../../../../../declarations/backend/backend.did";

  import LocalSpinner from "../../shared/local-spinner.svelte";
  import AvailableMembership from "../../membership/available-membership.svelte";
  import CopyPrincipal from "../copy-principal.svelte";
  import CreateUserHeader from "./create-user-header.svelte";
  import UserDetailsLayout from "./user-details/user-details-layout.svelte";
  import SubAppsContainer from "./sub-apps-container.svelte";
  let isLoading = true;
  let isSubmitDisabled = true;
  
  let usernameAvailable = false;
  let username = "";
  let displayName = "";
  
  let openFplPrincipalId = '';
  
  let loadingNeurons = false;
  let neurons: Neuron[] = [];
  let maxStakedICFC = 0n;

  let clubs: Club[] = [];
  let countries: CountryDTO[] = [];
  let leagues: League[] = [];
  let favouriteLeagueId: LeagueId | null = null;
  let favouriteClubId: ClubId | null = null;
  let nationalityId: CountryId | null = null;

  let file: File | null = null;
  
  let userMembershipEligibility: EligibleMembership | null = null;
  $: isSubmitDisabled = !username || !usernameAvailable;

  onMount(async () => {
    try{
      await loadData();
      countries = await countryStore.getCountries();
      leagues = await leagueStore.getLeagues();
    } catch {
        toasts.addToast({type: 'error', message: 'Failed to load data.'});
        leagues = [];
        countries = [];
    } finally {
        isLoading = false;
    }
  });

  async function loadData(){
    await getNeurons();
  }

  async function getNeurons() {
    try{
      loadingNeurons = true;
      let neuronsResult = await membershipStore.getUserNeurons();
      if (neuronsResult) {
        neurons = neuronsResult.userNeurons.sort(sortByHighestNeuron);
        userMembershipEligibility = neuronsResult.userMembershipEligibility;
        maxStakedICFC = neuronsResult.totalMaxStaked;
    }
    } catch {
      toasts.addToast({type: 'info', message: 'No neurons found'});
      neurons = [];
      userMembershipEligibility = { membershipType: { NotEligible: null }, eligibleNeuronIds: [] };
      maxStakedICFC = BigInt(0);
    } finally{
      loadingNeurons = false;
    }
  }

  async function createProfile() {
    isLoading = true;
    try {
      let appPrincipalIds: Array<[SubApp, PrincipalId]> = [];

      if(openFplPrincipalId.length > 0 && isPrincipalValid(openFplPrincipalId)){
        appPrincipalIds.push([{ OpenFPL: null }, openFplPrincipalId]);
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
      userIdCreatedStore.set({ data: $authStore.identity?.getPrincipal().toString() ?? "", certified: true});
      toasts.addToast({type: 'success', message: 'Profile successfully created'});
      //window.location.href = "/";
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
  <div class="flex flex-col mx-auto space-y-6 page-wrapper">
      <CreateUserHeader />
      <UserDetailsLayout bind:file {countries} {leagues} {clubs} bind:nationalityId bind:favouriteLeagueId bind:favouriteClubId bind:username bind:usernameAvailable bind:displayName store={userStore} />

      <div class="flex flex-col space-y-6">
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
              <SubAppsContainer bind:openFplPrincipalId />
            </div>
          {/if}
        {/if}
        
      </div>
      <button 
          class="my-8 transition brand-button bg-BrandBlue hover:bg-BrandInfo disabled:bg-BrandGrayShade3" 
          on:click={createProfile} 
          disabled={isSubmitDisabled}
        >
          JOIN ICFC
      </button>
  </div>
{/if}