<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { countryStore } from "$lib/stores/country-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { membershipStore } from "$lib/stores/membership-store";
  import { toasts } from "$lib/stores/toasts-store";
  
  import type { CreateProfile, MembershipType, Neuron, PrincipalId, SubApp } from "../../../../../declarations/backend/backend.did";
  import type { LeagueId, ClubId, CountryId, ClubDTO, CountryDTO, FootballLeagueDTO } from "../../../../../external_declarations/data_canister/data_canister.did";
  
  import LocalSpinner from "../shared/local-spinner.svelte";
  import AvailableMembership from "../membership/available-membership.svelte";
  import LogoIcon from "$lib/icons/LogoIcon.svelte";
  import CopyPrincipal from "./copy-principal.svelte";
  import DropdownSelect from "../shared/dropdown-select.svelte";
  import { getFileExtensionFromFile, isPrincipalValid, isUsernameValid } from "$lib/utils/helpers";
    
  let isLoading = true;
  let isSubmitDisabled = true;
  let isCheckingUsername = false;
  let usernameAvailable = false;
  let usernameError = "";
  let loadingNeurons = false;
  
  let username = "";
  let displayName = "";
  let favouriteLeagueId: LeagueId | null = null;
  let favouriteClubId: ClubId | null = null;
  let nationalityId: CountryId | null = null;
  let openFplPrincipalId = '';
  let footballGodPrincipalId = '';
  let transferKingsPrincipalId = '';
  let jeffBetsPrincipalId = '';
  let openWslPrincipalId = '';
  
  let neurons: Neuron[] = [];
  let maxStakedICFC = 0n;
  let clubs: ClubDTO[] = [];
  let countries: CountryDTO[] = [];
  let leagues: FootballLeagueDTO[] = [];
  
  let userMembershipEligibility: MembershipType = { NotEligible: null };
  
  let usernameTimeout: NodeJS.Timeout;

  let profileSrc = '/profile_placeholder.png';
  let file: File | null = null;
  let fileInput: HTMLInputElement;

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
    isCheckingUsername = true;
    try {
      if(!isUsernameValid(username)){
        usernameError = "Username must be between 5 and 20 characters.";
      }
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
          profilePictureExtension: [extension],
          username,
          appPrincipalIds
        };

        await userStore.createProfile(dto);
      } else {
        const dto: CreateProfile = {
          displayName,
          profilePicture: [],
          profilePictureExtension: [],
          username,
          appPrincipalIds
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

  function clickFileInput() {
      fileInput.click();
  } 

  function handleFileChange(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      file = input.files[0];
      if (file.size > 1000 * 1024) {
        toasts.addToast({ 
          type: "error", 
          message: "Profile image too large. The maximum size is 1MB." 
        });
        file = null;
        profileSrc = '/profile_placeholder.png';
        return;
      }
      profileSrc = URL.createObjectURL(file);
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

      <div class="horizontal-divider border-t border-BrandGrayShade3"></div>
      
      <p class="text-lg text-BrandGrayShade5">
        The ICFC is the world's first, fully decentralised, fan owned football ecosystem. To become a member you will need to become an owner, we believe our 'Own to Use' model is the future access model for decentralised services. 
      </p>

      <div class="horizontal-divider border-t border-BrandGrayShade3"></div>

      <div class="flex flex-col space-y-4">
        <p class="cta-text text-lg text-white">User Details</p>
        
        <div class="flex flex-col md:flex-row gap-6">
          <div class="flex flex-col space-y-2 w-full md:w-1/5">
            <p class="form-title">Profile Picture</p>
            <p class="form-hint">Max size 1mb</p>
            
            <img 
              src={profileSrc} 
              alt="Profile" 
              class="profile-picture w-full h-48 object-cover rounded-lg"
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

          <div class="flex flex-col space-y-6 w-full md:w-4/5">
            <div class="flex flex-col md:flex-row gap-4">
              <div class="flex flex-col space-y-1 w-full md:w-1/2">
                <p class="form-title">Username</p>
                <p class="form-hint">5-20 characters, letters & numbers only. <span class="text-xs">(Required)</span></p>
                <input
                  type="text"
                  bind:value={username}
                  on:input={handleUsernameInput}
                  class="brand-input"
                  placeholder="Enter username"
                />
                {#if username.length > 0}
                  <div class="text-sm">
                    {#if isCheckingUsername}
                      <p class="text-BrandGrayShade2 mt-2">Checking username availability...</p>
                    {:else if usernameError}
                      <p class="text-BrandRed mt-2">{usernameError}</p>
                    {:else if usernameAvailable}
                      <p class="text-BrandSuccess mt-2">Username is available!</p>
                    {/if}
                  </div>
                {/if}
              </div>
              <div class="flex flex-col space-y-1 w-full md:w-1/2">
                <p class="form-title">Display Name</p>
                <p class="form-hint">5-20 characters, letters & numbers only.</p>
                <input
                  type="text"
                  bind:value={displayName}
                  placeholder="Enter display name"
                  class="brand-input"
                />
              </div>
            </div>

            <div class="flex flex-col md:flex-row gap-4">
              <div class="flex flex-col space-y-1 w-full md:w-1/3">
                <p class="form-title">Nationality</p>
                <p class="form-hint">Select to participate in nationwide football competitions.</p>
                <DropdownSelect
                  options={countries.sort((a, b) => a.name.localeCompare(b.name)).map((country: CountryDTO) => ({ id: country.id, label: country.name }))}
                  value={nationalityId}
                  onChange={(value: string | number) => {
                    nationalityId = Number(value);
                  }}
                />
              </div>
              <div class="flex flex-col space-y-1 w-full md:w-1/3">
                <p class="form-title">Your Favourite League</p>
                <p class="form-hint">Select to find your favourite club.</p>
                <DropdownSelect
                  options={leagues.map(league => ({ id: league.id, label: league.name }))}
                  value={favouriteLeagueId}
                  onChange={(value: string | number) => {
                    favouriteLeagueId = Number(value);
                  }}
                  scrollOnOpen={true}
                />
              </div>
              <div class="flex flex-col space-y-1 w-full md:w-1/3">
                <p class="form-title">Your Favourite Club</p>
                <p class="form-hint">Select to enable club based rewards.</p>
                <DropdownSelect
                  options={clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName)).map(club => ({ id: club.id, label: club.friendlyName }))}
                  value={favouriteClubId}
                  onChange={(value: string | number) => {
                    favouriteClubId = Number(value);
                  }}
                  scrollOnOpen={true}
                  disabled={favouriteLeagueId == null || favouriteLeagueId == 0}
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="horizontal-divider border-t border-BrandGrayShade3"></div>

      <div class="flex flex-col space-y-4">
        <p class="cta-text text-lg text-white">Neuron Based Membership</p>
        <p class="text-BrandGrayShade5">
          To join the ICFC you need to have a non-dissolving NNS neuron with at least 1,000 ICFC staked, max staked for 2 years. Add your ICFC Principal as a hotkey to any ICFC NNS neuron over 1,000 ICFC to continue:
        </p>
        <CopyPrincipal />
        {#if loadingNeurons}
          <LocalSpinner />
        {:else}
          {#if neurons.length > 0}
            <div class="flex flex-col space-y-4">

              <AvailableMembership {neurons} {refreshNeurons} availableMembership={userMembershipEligibility} {maxStakedICFC} />

              <div class="horizontal-divider border-t border-BrandGrayShade3"></div>

              <div class="flex flex-col space-y-4">
                <p class="cta-text text-lg text-white">Sub-App Principal IDs</p>
                <p class="text-BrandGrayShade2">
                  Enter your Principal IDs for ICFC sub-applications (optional)
                </p>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
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
                            <p class="text-BrandRed mt-1">Invalid Principal ID</p>
                          {:else}
                            <p class="text-BrandSuccess mt-1">Valid Principal ID</p>
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
                            <p class="text-BrandRed mt-1">Invalid Principal ID</p>
                          {:else}
                            <p class="text-BrandSuccess mt-1">Valid Principal ID</p>
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
                            <p class="text-BrandRed mt-1">Invalid Principal ID</p>
                          {:else}
                            <p class="text-BrandSuccess mt-1">Valid Principal ID</p>
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
                            <p class="text-BrandRed mt-1">Invalid Principal ID</p>
                          {:else}
                            <p class="text-BrandSuccess mt-1">Valid Principal ID</p>
                          {/if}
                        </div>
                      {/if}
                    </div>
                  </div>
                </div>

                <div class="horizontal-divider border-t border-BrandGrayShade3"></div>
              
                <button 
                  class="brand-button bg-BrandBlue text-white py-2 rounded-lg hover:bg-BrandInfo transition disabled:bg-BrandGrayShade3" 
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