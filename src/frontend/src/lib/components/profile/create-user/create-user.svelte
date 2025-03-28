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
      //countries = await countryStore.getCountries();
      countries = [
        { id: 1, name: "England", code: "ENG" },
        { id: 2, name: "Spain", code: "ESP" },
        { id: 3, name: "Germany", code: "GER" },
        { id: 4, name: "France", code: "FRA" }
      ];
      
      //leagues = await leagueStore.getLeagues();
      leagues = [
        { 
          id: 1, 
          name: "Premier League",
          logo: new Uint8Array([]), // Empty logo for testing
          teamCount: 20,
          relatedGender: { Male: null },
          countryId: 1,
          abbreviation: "PL",
          governingBody: "The FA",
          formed: BigInt(1992)
        },
        { 
          id: 2, 
          name: "La Liga",
          logo: new Uint8Array([]),
          teamCount: 20,
          relatedGender: { Male: null },
          countryId: 2,
          abbreviation: "LaLiga",
          governingBody: "RFEF",
          formed: BigInt(1929)
        },
        { 
          id: 3, 
          name: "Bundesliga",
          logo: new Uint8Array([]),
          teamCount: 18,
          relatedGender: { Male: null },
          countryId: 3,
          abbreviation: "BL",
          governingBody: "DFB",
          formed: BigInt(1963)
        },
        { 
          id: 4, 
          name: "Ligue 1",
          logo: new Uint8Array([]),
          teamCount: 20,
          relatedGender: { Male: null },
          countryId: 4,
          abbreviation: "L1",
          governingBody: "FFF",
          formed: BigInt(1932)
        }
      ];

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
    // Dummy neuron data for testing
    neurons = [
        {
            id: [],
            staked_maturity_e8s_equivalent: [BigInt(100000000)],
            permissions: [],
            maturity_e8s_equivalent: BigInt(50000000),
            cached_neuron_stake_e8s: BigInt(1000000000), // 10 ICFC
            created_timestamp_seconds: BigInt(1677649200), // March 1, 2023
            source_nns_neuron_id: [BigInt(12345)],
            auto_stake_maturity: [true],
            aging_since_timestamp_seconds: BigInt(1677649200),
            dissolve_state: [{ DissolveDelaySeconds: BigInt(63072000) }], // 2 years
            voting_power_percentage_multiplier: BigInt(100),
            vesting_period_seconds: [BigInt(31536000)], // 1 year
            disburse_maturity_in_progress: [],
            followees: [],
            neuron_fees_e8s: BigInt(0)
        },
        {
            id: [],
            staked_maturity_e8s_equivalent: [BigInt(200000000)],
            permissions: [],
            maturity_e8s_equivalent: BigInt(75000000),
            cached_neuron_stake_e8s: BigInt(2000000000), // 20 ICFC
            created_timestamp_seconds: BigInt(1672531200), // Jan 1, 2023
            source_nns_neuron_id: [BigInt(67890)],
            auto_stake_maturity: [true],
            aging_since_timestamp_seconds: BigInt(1672531200),
            dissolve_state: [{ DissolveDelaySeconds: BigInt(31536000) }], // 1 year
            voting_power_percentage_multiplier: BigInt(100),
            vesting_period_seconds: [BigInt(15768000)], // 6 months
            disburse_maturity_in_progress: [],
            followees: [],
            neuron_fees_e8s: BigInt(0)
        }
    ];

    userMembershipEligibility = { membershipType: { Seasonal: null }, eligibleNeuronIds: [] };
    maxStakedICFC = BigInt(3000000000000); // 30 ICFC total
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
    // let clubsResult = await clubStore.getClubs(favouriteLeagueId!);
    // if(!clubsResult){ return }
    // clubs = clubsResult;

    // Dummy clubs based on the selected league
    switch(favouriteLeagueId) {
        case 1: // Premier League
            clubs = [
                { 
                    id: 1,
                    name: "Manchester United Football Club",
                    friendlyName: "Man United",
                    abbreviatedName: "MUN",
                    primaryColourHex: "#DA291C",
                    secondaryColourHex: "#FBE122",
                    thirdColourHex: "#000000",
                    shirtType: { Filled: null }
                },
                {
                    id: 2,
                    name: "Liverpool Football Club",
                    friendlyName: "Liverpool",
                    abbreviatedName: "LIV",
                    primaryColourHex: "#C8102E",
                    secondaryColourHex: "#F6EB61",
                    thirdColourHex: "#FFFFFF",
                    shirtType: { Filled: null }
                }
            ];
            break;
        case 2: // La Liga
            clubs = [
                {
                    id: 3,
                    name: "Real Madrid Club de Fútbol",
                    friendlyName: "Real Madrid",
                    abbreviatedName: "RMA",
                    primaryColourHex: "#FFFFFF",
                    secondaryColourHex: "#FEB83D",
                    thirdColourHex: "#000000",
                    shirtType: { Filled: null }
                },
                {
                    id: 4,
                    name: "Fútbol Club Barcelona",
                    friendlyName: "Barcelona",
                    abbreviatedName: "BAR",
                    primaryColourHex: "#A50044",
                    secondaryColourHex: "#004D98",
                    thirdColourHex: "#FFED02",
                    shirtType: { Filled: null }
                }
            ];
            break;
        case 3: // Bundesliga
            clubs = [
                {
                    id: 5,
                    name: "FC Bayern München",
                    friendlyName: "Bayern Munich",
                    abbreviatedName: "BAY",
                    primaryColourHex: "#DC052D",
                    secondaryColourHex: "#0066B2",
                    thirdColourHex: "#FFFFFF",
                    shirtType: { Filled: null }
                },
                {
                    id: 6,
                    name: "Borussia Dortmund",
                    friendlyName: "Dortmund",
                    abbreviatedName: "DOR",
                    primaryColourHex: "#FDE100",
                    secondaryColourHex: "#000000",
                    thirdColourHex: "#FFFFFF",
                    shirtType: { Filled: null }
                }
            ];
            break;
        case 4: // Ligue 1
            clubs = [
                {
                    id: 7,
                    name: "Paris Saint-Germain FC",
                    friendlyName: "PSG",
                    abbreviatedName: "PSG",
                    primaryColourHex: "#004170",
                    secondaryColourHex: "#DA291C",
                    thirdColourHex: "#FFFFFF",
                    shirtType: { Striped: null }
                },
                {
                    id: 8,
                    name: "Olympique de Marseille",
                    friendlyName: "Marseille",
                    abbreviatedName: "MAR",
                    primaryColourHex: "#0B63AF",
                    secondaryColourHex: "#FFFFFF",
                    thirdColourHex: "#DBA111",
                    shirtType: { Filled: null }
                }
            ];
            break;
        default:
            clubs = [];
    }
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