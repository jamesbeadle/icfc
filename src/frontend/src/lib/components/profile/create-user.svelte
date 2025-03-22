<script lang="ts">
  import { onMount } from "svelte";
  
  import { authStore } from "$lib/stores/auth-store";
  import { userStore } from "$lib/stores/user-store";
  import { countryStore } from "$lib/stores/country-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { clubStore } from "$lib/stores/club-store";
  import { membershipStore } from "$lib/stores/membership-store";
  import { toasts } from "$lib/stores/toasts-store";
  
  import type { CreateProfile, MembershipType, Neuron, PrincipalId, SubApp } from "../../../../../declarations/backend/backend.did";
  import type { LeagueId, ClubId, CountryDTO, CountryId, ClubDTO } from "../../../../../external_declarations/data_canister/data_canister.did";
  
  import LocalSpinner from "../shared/local-spinner.svelte";
  import AppPrincipalAccordian from "./app-principal-accordian.svelte";
  import CopyIcon from "$lib/icons/CopyIcon.svelte";
  import AvailableMembership from "../membership/available-membership.svelte";
  import DropdownSelect from "../shared/dropdown-select.svelte";
  import LogoIcon from "$lib/icons/LogoIcon.svelte";
  
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

  async function copyTextAndShowToast(text: string) {
      try {
          await navigator.clipboard.writeText(text);
          toasts.addToast({
          type: "success",
          message: "Copied to clipboard.",
          duration: 2000,
          });
      } catch (err) {
          console.error("Failed to copy:", err);
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
  <div class="flex flex-col w-full h-full p-8 mt-16 overflow-x-hidden space-y-8">

    <div class="border-b border-white/10 w-full flex">
      <div class="flex flex-row items-center w-full flex">
        <p class="text-4xl cta-text flex flex-row space-y-1">Welcome to the 
          <span class="flex flex-row items-center">
            <LogoIcon className='w-8 mx-2' />
            ICFC
          </span>
        </p>
      </div>
    </div>

    <div class="w-full flex flex-col">
      <p class="w-full text-lg">
        The ICFC is the world's first, fully decentralised, fan owned football ecosystem. To become a member you will need to become an owner, we believe our 'Own to Use' model is the future access model for decentralised services. 
      </p>
    </div>

    <div class="flex w-full">
      <p class="cta-text text-lg mb-1 w-full">User Details</p>
    </div>

    <div class="w-full flex flex-col md:flex-row space-y-2 md:space-y-0 md:space-x-2">
           
      <div class="flex w-full md:w-1/5 flex-col">
        <p class="form-title">Profile Picture</p>
        <p class="form-hint">Max size 1mb</p>
        <img 
          src="/profile_placeholder.png" 
          alt="Profile" 
          class="profile-picture"
        />
        <button 
          class="brand-button"
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

      <div class="flex w-full md:w-4/5 flex-col">
      

        <div class="flex w-full flex-col">
          <p class="form-title">Username</p>
          <p class="form-hint">5-20 characters,letters & numbers only.</p>
          <input
            type="text"
            bind:value={username}
            on:input={handleUsernameInput}
            class="brand-input"
            placeholder="Enter username"
          />
          {#if username.length > 0}
            <div class="mt-1 text-sm">
                {#if isCheckingUsername}
                    <p class="text-BrandGrayShade3">Checking username availability...</p>
                {:else if usernameError}
                    <p class="text-BrandRed">{usernameError}</p>
                {:else if usernameAvailable}
                    <p class="text-BrandSuccess">Username is available!</p>
                {/if}
            </div>
          {/if}
        </div>
      
        <div class="flex w-full flex-col mt-4">
          <p class="form-title">Display Name</p>
          <p class="form-hint">5-20 characters,letters & numbers only.</p>
          <input
            type="text"
            bind:value={displayName}
            placeholder="Enter display name"
            class="brand-input"
          />
        </div>
        
      </div>
      
    </div>

    <div class="flex w-full">
      <p class="cta-text text-lg mb-1 w-full">Neuron Based Membership</p>
    </div>

    <div class="w-full flex flex-col space-y-2">
      <p>
        To join the ICFC you need to have a non-dissolving NNS neuron with at least 1,000 ICFC staked, max staked for 2 years.
      </p>
      <p>
        Add your ICFC Principal as a hotkey to any ICFC NNS neuron over 1,000 ICFC to continue:
      </p>

      <div class="relative bg-BrandGrayShade3 rounded-lg p-4">
        <button 
            on:click={() => { copyTextAndShowToast($authStore.identity?.getPrincipal().toString() ?? "") }}
            class="absolute top-2 right-2 text-white"
        >
            <CopyIcon className="w-5 h-5" fill='#FFFFFF' />
        </button>
        <p class="text-white font-mono text-sm break-all px-4">
            {$authStore.identity?.getPrincipal().toString() ?? "Not available"}
        </p>
      </div>

      {#if neurons.length > 0}
        <div class="flex w-full mt-8">
          <AvailableMembership {neurons} {refreshNeurons} availableMembership={userMembershipEligibility} {maxStakedICFC} />
        </div>
       
        <div class="my-4">
          <AppPrincipalAccordian bind:appPrincipalIds />
        </div>

        <p>Additional Information:</p>

        <p>Your Nationality:</p>
        <DropdownSelect
          options={$countryStore.map((country: CountryDTO) => ({ id: country.id, label: country.name }))}
          value={nationalityId}
          onChange={(value: string | number) => {
            nationalityId = Number(value);
          }}
        />

        <p>Your Favourite League:</p>
        <DropdownSelect
          options={$leagueStore.map(league => ({ id: league.id, label: league.name }))}
          value={favouriteLeagueId}
          onChange={(value: string | number) => {
            favouriteLeagueId = Number(value);
          }}
          scrollOnOpen={true}
        />

        {#if favouriteLeagueId && favouriteLeagueId > 0 }
          <p>Your Favourite Club Id:</p>
          <DropdownSelect
            options={$clubStore.map(club => ({ id: club.id, label: club.friendlyName }))}
            value={favouriteClubId}
            onChange={(value: string | number) => {
              favouriteClubId = Number(value);
            }}
            scrollOnOpen={true}
          />
        {/if}

        <div class="flex justify-between">
          <button 
          class="brand-button"
          on:click={createProfile}
          disabled={isSubmitDisabled}
          >
          JOIN
          </button>
        </div>
      {/if}
    </div>

  </div>
{/if}