<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import type { ClubId, CountryDTO, CountryId, CreateProfile, LeagueId, MembershipType, Neuron, PrincipalId, SubApp, UserNeuronsDTO } from "../../../../../declarations/backend/backend.did";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import Header from "../shared/header.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import AppPrincipalAccordian from "./app-principal-accordian.svelte";
    import CopyIcon from "$lib/icons/CopyIcon.svelte";
    import { authStore } from "$lib/stores/auth-store";
    import { onMount } from "svelte";
    import { membershipStore } from "$lib/stores/membership-store";
    import AvailableMembership from "../membership/available-membership.svelte";
    import DropdownSelect from "../shared/dropdown-select.svelte";
    import { countryStore } from "$lib/stores/country-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
  
    let isLoading = false;
    let username = "";
    let displayName = "";
    let isSubmitDisabled = true;
    let isCheckingUsername = false;
    let usernameError = "";
    let usernameAvailable = false;
    let appPrincipalIds: Array<[SubApp, PrincipalId]> = [];
    let neurons: Neuron[] = [];
    let maxStakedICFC = 0n;
    let favouriteLeagueId: LeagueId | null = null;
    let favouriteClubId: ClubId | null = null;
    let nationalityId: CountryId | null = null;
    
    let userNeurons: UserNeuronsDTO | undefined;
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
            console.error("Error fetching funding data:", error);
        } finally {
            isLoading = false;
        }
    }

    async function getNeurons() {
      userNeurons = await membershipStore.getUserNeurons();
      if (userNeurons) {
          neurons = userNeurons.userNeurons.sort(sortByHighestNeuron);
          userMembershipEligibility = userNeurons.userMembershipEligibility;
          maxStakedICFC = userNeurons.totalMaxStaked;
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

  </script>


{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="flex flex-col w-full h-full max-w-2xl mx-auto">
      <Header />
      <div class="flex-1 w-full mt-16 overflow-x-hidden">

        <div class="border-b border-white/10 mt-4">
            <div class="flex items-center justify-between">
                <h3 class="text-2xl text-white cta-text">Create Profile</h3>
            </div>
        </div>
        <div class="my-4">
            <h3 class="mb-2">Username</h3>
            <div class="mb-2 text-sm text-white/50">
                <p>Username requirements:</p>
                <ul class="ml-4 list-disc">
                    <li>Between 5-20 characters</li>
                    <li>Only letters & numbers allowed</li>
                </ul>
            </div>
            <input
              type="text"
              bind:value={username}
              on:input={handleUsernameInput}
              class="w-full p-2 text-white rounded-md bg-BrandGray"
              placeholder="Enter username"
            />
            {#if username.length > 0}
              <div class="mt-2 text-sm">
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

        <div class="my-4">
            <h3 class="mb-2">Display Name</h3>
            <input
                type="text"
                bind:value={displayName}
                class="w-full p-2 text-white rounded-md bg-BrandGray"
                placeholder="Enter display name"
            />
        </div>

        <p class="cta-text">Neuron Based Membership</p>
        <p>
          To join the ICFC you need to have a non-dissolving NNS neuron with at least 1,000 ICFC staked, max staked for 2 years.
        </p>

        <p>
          Once you have your neuron, add your ICFC Principal as a hotkey to your neuron:
        </p>

        <div class="relative bg-gray-800 rounded-lg p-4">
            <button 
                on:click={() => { copyTextAndShowToast($authStore.identity?.getPrincipal().toString() ?? "") }}
                class="absolute top-2 right-2 text-gray-400 hover:text-white"
            >
                <CopyIcon className="w-5 h-5" fill='#FFFFFF' />
            </button>
            <p class="text-gray-300 font-mono text-sm break-all px-4">
                {$authStore.identity?.getPrincipal().toString() ?? "Not available"}
            </p>
        </div>

        {#if neurons.length > 0}

          <AvailableMembership {neurons} {refreshNeurons} availableMembership={userMembershipEligibility} {maxStakedICFC} />

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

          <p>Your Favourite Club Id:</p>
          <DropdownSelect
            options={$clubStore.map(club => ({ id: club.id, label: club.friendlyName }))}
            value={favouriteClubId}
            onChange={(value: string | number) => {
              favouriteClubId = Number(value);
            }}
            scrollOnOpen={true}
          />

          <div class="flex justify-between">
            <button 
            class="brand-button"
            on:click={createProfile}
            disabled={isSubmitDisabled}
            >
            Create
            </button>
          </div>



        {/if}

      </div>
  </div>
{/if}