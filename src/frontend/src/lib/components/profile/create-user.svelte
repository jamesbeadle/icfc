<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { countryStore } from "$lib/stores/country-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { membershipStore } from "$lib/stores/membership-store";
  import { toasts } from "$lib/stores/toasts-store";
  
  import type { CreateProfile, MembershipType, Neuron, PrincipalId, SubApp } from "../../../../../declarations/backend/backend.did";
  import type { LeagueId, ClubId, CountryId, ClubDTO, CountryDTO } from "../../../../../external_declarations/data_canister/data_canister.did";
  
  import LocalSpinner from "../shared/local-spinner.svelte";
  import AppPrincipalAccordian from "./app-principal-accordian.svelte";
  import AvailableMembership from "../membership/available-membership.svelte";
  import LogoIcon from "$lib/icons/LogoIcon.svelte";
  import CopyPrincipal from "./copy-principal.svelte";
  import DropdownSelect from "../shared/dropdown-select.svelte";
  
  let isLoading = false;
  let isSubmitDisabled = true;
  let isCheckingUsername = false;
  let usernameAvailable = false;
  let usernameError = "";
  
  let username = "";
  let displayName = "";
  let appPrincipalIds: Array<[SubApp, PrincipalId]> = [];
  let favouriteLeagueId: LeagueId | null = null;
  let favouriteClubId: ClubId | null = null;
  let nationalityId: CountryId | null = null;
  let fileInput: HTMLInputElement;

  let neurons: Neuron[] = [];
  let maxStakedICFC = 0n;
  let clubs: ClubDTO[] = [];
  
  let userMembershipEligibility: MembershipType = { NotEligible: null };
  
  let usernameTimeout: NodeJS.Timeout;

  $: isSubmitDisabled = !username || !usernameAvailable || appPrincipalIds.length == 0;

  onMount(async () => {
     await loadData();
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
    let neuronsResult = await membershipStore.getUserNeurons();
    if (neuronsResult) {
        neurons = neuronsResult.userNeurons.sort(sortByHighestNeuron);
        userMembershipEligibility = neuronsResult.userMembershipEligibility;
        maxStakedICFC = neuronsResult.totalMaxStaked;
    }
  }

  function sortByHighestNeuron(a: Neuron, b: Neuron): number {
      return Number(b.cached_neuron_stake_e8s) - Number(a.cached_neuron_stake_e8s);
  }

  async function checkUsername() {
    if (username.length < 5) {
      usernameError = "Username must be at least 5 characters";
      usernameAvailable = false;
      return;
    }
    
    isCheckingUsername = true;
    try {
      const available = await userStore.isUsernameAvailable(username);
      usernameAvailable = available;
      usernameError = available ? "" : "Username is already taken";
    } catch (error) {
      console.error("Error checking username:", error);
      usernameError = "Error checking username availability";
    } finally {
      isCheckingUsername = false;
    }
  } 
  
  function handleUsernameInput() {
    clearTimeout(usernameTimeout);
    usernameAvailable = false;
    if (username.length >= 5) {
      usernameTimeout = setTimeout(checkUsername, 500);
    }
  } 

  async function createProfile() {
    isLoading = true;
    try {
      const dto: CreateProfile = {
        displayName,
        profilePicture: [],
        profilePictureExtension: [],
        username,
        appPrincipalIds
      };
      await userStore.createProfile(dto);
      await userStore.sync();
      toasts.addToast({type: 'success', message: 'Profile successfully created'})
      window.location.href = "/";
    } catch (error) {
      console.error("Error creating profile:", error);
    } finally {
      isLoading = false;
    }
  }

  async function refreshNeurons() {
      isLoading = true;
      await loadData();
      isLoading = false;
  }

  $: if (!isLoading && favouriteLeagueId && favouriteLeagueId > 0) {
    getClubs();
  }

  async function getClubs() {
    let clubsResult = await clubStore.getClubs(favouriteLeagueId!);
    if(!clubsResult){ return }
    clubs = clubsResult;
  }

  function clickFileInput() {
      fileInput.click();
  } 

  function handleFileChange(event: Event) {
      const input = event.target as HTMLInputElement;
      if (input.files && input.files[0]) {
          const file = input.files[0];
          if (file.size > 1000 * 1024) {
              toasts.addToast({ type: "error", message: "Profile image too large. The maximum size is 1MB." });
              console.error("Error updating profile image.");
              return;
          }
      }
  }
</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="page-wrapper px-4 py-6 max-w-7xl mx-auto">
    <div class="flex flex-col space-y-6">

      <p class="text-4xl cta-text flex flex-row space-y-1">
        Welcome to the 
        <span class="flex flex-row items-center">
          <LogoIcon className='w-8 mx-2' />
          ICFC
        </span>
      </p>

      <div class="horizontal-divider border-t border-gray-600"></div>
      
      <p class="text-lg text-gray-300">
        The ICFC is the world's first, fully decentralised, fan owned football ecosystem. To become a member you will need to become an owner, we believe our 'Own to Use' model is the future access model for decentralised services. 
      </p>

      <div class="horizontal-divider border-t border-gray-600"></div>

      <div class="flex flex-col space-y-4">
        <p class="cta-text text-lg text-white">User Details</p>
        
        <div class="flex flex-col md:flex-row gap-6">
          <div class="flex flex-col space-y-2 w-full md:w-1/5">
            <p class="form-title text-white">Profile Picture</p>
            <p class="form-hint text-gray-400">Max size 1mb</p>
            <img 
              src="/profile_placeholder.png" 
              alt="Profile" 
              class="profile-picture w-full h-48 object-cover rounded-lg"
            />
            <button 
              class="brand-button bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition"
              on:click={clickFileInput}
            >
              Upload Photo
            </button>
            <input
              type="file"
              id="profile-image"
              accept="image/*"
              bind:this={fileInput}
              on:change={handleFileChange}
              class="hidden"
            />
          </div>

          <div class="flex flex-col space-y-6 w-full md:w-4/5">
            <!-- Row 1: Username and Display Name -->
            <div class="flex flex-col md:flex-row gap-4">
              <div class="flex flex-col space-y-1 w-full md:w-1/2">
                <p class="form-title text-white">Username</p>
                <p class="form-hint text-gray-400">5-20 characters, letters & numbers only. <span class="text-xs">(Required)</span></p>
                <input
                  type="text"
                  bind:value={username}
                  on:input={handleUsernameInput}
                  class="brand-input bg-gray-800 text-white border border-gray-600 rounded-lg p-2 focus:outline-none focus:border-blue-500"
                  placeholder="Enter username"
                />
                {#if username.length > 0}
                  <div class="mt-1 text-sm">
                    {#if isCheckingUsername}
                      <p class="text-gray-400">Checking username availability...</p>
                    {:else if usernameError}
                      <p class="text-red-500">{usernameError}</p>
                    {:else if usernameAvailable}
                      <p class="text-green-500">Username is available!</p>
                    {/if}
                  </div>
                {/if}
              </div>
              <div class="flex flex-col space-y-1 w-full md:w-1/2">
                <p class="form-title text-white">Display Name</p>
                <p class="form-hint text-gray-400">5-20 characters, letters & numbers only.</p>
                <input
                  type="text"
                  bind:value={displayName}
                  placeholder="Enter display name"
                  class="brand-input bg-gray-800 text-white border border-gray-600 rounded-lg p-2 focus:outline-none focus:border-blue-500"
                />
              </div>
            </div>

            <!-- Row 2: Dropdowns -->
            <div class="flex flex-col md:flex-row gap-4">
              <div class="flex flex-col space-y-1 w-full md:w-1/3">
                <p class="form-title text-white">Nationality</p>
                <p class="form-hint text-gray-400">Select your nationality to participate in nationwide football competitions.</p>
                <DropdownSelect
                  options={$countryStore.map((country: CountryDTO) => ({ id: country.id, label: country.name }))}
                  value={nationalityId}
                  onChange={(value: string | number) => {
                    nationalityId = Number(value);
                  }}
                />
              </div>
              <div class="flex flex-col space-y-1 w-full md:w-1/3">
                <p class="form-title text-white">Your Favourite League</p>
                <p class="form-hint text-gray-400">Select your favourite league to find your favourite club.</p>
                <DropdownSelect
                  options={$leagueStore.map(league => ({ id: league.id, label: league.name }))}
                  value={favouriteLeagueId}
                  onChange={(value: string | number) => {
                    favouriteLeagueId = Number(value);
                  }}
                  scrollOnOpen={true}
                />
              </div>
              <div class="flex flex-col space-y-1 w-full md:w-1/3">
                <p class="form-title text-white">Your Favourite Club</p>
                <p class="form-hint text-gray-400">Select your favourite club to enable groupings onto club specific leaderboards.</p>
                <DropdownSelect
                  options={$clubStore.map(club => ({ id: club.id, label: club.friendlyName }))}
                  value={favouriteClubId}
                  onChange={(value: string | number) => {
                    favouriteClubId = Number(value);
                  }}
                  scrollOnOpen={true}
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="horizontal-divider border-t border-gray-600"></div>

      <div class="flex flex-col space-y-4">
        <p class="cta-text text-lg text-white">Neuron Based Membership</p>
        <p class="text-gray-300">
          To join the ICFC you need to have a non-dissolving NNS neuron with at least 1,000 ICFC staked, max staked for 2 years.
        </p>
        <p class="text-gray-300">
          Add your ICFC Principal as a hotkey to any ICFC NNS neuron over 1,000 ICFC to continue:
        </p>
        <CopyPrincipal />
        {#if neurons.length > 0}
          <div class="flex flex-col space-y-4">
            <AvailableMembership {neurons} {refreshNeurons} availableMembership={userMembershipEligibility} {maxStakedICFC} />
            <AppPrincipalAccordian bind:appPrincipalIds />
            <button 
              class="brand-button bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition disabled:bg-gray-600" 
              on:click={createProfile} 
              disabled={isSubmitDisabled}
            >
              JOIN
            </button>
          </div>
        {/if}
      </div>     
    </div>
  </div>
{/if}