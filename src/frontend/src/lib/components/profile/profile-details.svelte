<script lang="ts">
    import { onMount } from "svelte";
    import { getDateFromBigInt } from "$lib/utils/helpers";
    import type { Club, Country, League, ProfileDTO } from "../../../../../declarations/backend/backend.did";
    import { countryStore } from "$lib/stores/country-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
    import { toasts } from "$lib/stores/toasts-store";
    
    import CopyPrincipal from "./copy-principal.svelte";
    import LocalSpinner from "../shared/global/local-spinner.svelte";
    import UpdateFavouriteClubModal from "./update-modals/update-favourite-club-modal.svelte";
    import UpdateNationalityModal from "./update-modals/update-nationality-modal.svelte";
  
    let { profile } = $props<{ profile: ProfileDTO }>();

    let isLoading = $state(false);
    let loadingMessage = $state("");

    let showUpdateFavouriteClubModal: boolean = $state(false);
    let showUpdateNationalityModal: boolean = $state(false);
    let clubs: Club[] = $state([]);
    let countries: Country[] = $state([]);
    let leagues: League[] = $state([]);

    let joinedDate = $state("");
    let favouriteLeagueId = $state(0);
    let favouriteClubId = $state(0);
    let nationalityId = $state(0);
    
    onMount(async () => {
      loadingMessage = "Loading profile details";
      try{
        isLoading = true;
        joinedDate = getDateFromBigInt(Number(profile.createdOn));
        await getFootballData();
      } catch (error) {
        console.error("Error fetching profile details:", error);
        toasts.addToast({
          message: "Error fetching profile details",
          type: "error",
        });
      } finally {
        isLoading = false;
      }
    });

    async function getFootballData(){
      try{

        favouriteLeagueId = profile?.favouriteLeagueId[0] ?? 0;
        favouriteClubId = profile?.favouriteClubId[0] ?? 0;
        nationalityId = profile?.nationalityId[0] ?? 0;

        if(nationalityId > 0){
          loadingMessage = "Loading National Team";
          let countriesResult = await countryStore.getCountries();
          if(countriesResult){
            countries = countriesResult.countries;
          }
        }
        countryStore.setCountries(countries);
        if(favouriteLeagueId > 0){
          loadingMessage = "Loading Favourite League";
          let leaguesResult = await leagueStore.getLeagues();
          if(leaguesResult){
            leagues = leaguesResult.leagues;
          }
          if(favouriteClubId > 0){
            loadingMessage = "Loading Favourite Club";
            
            let clubsResult = await clubStore.getClubs(favouriteLeagueId);
            if(clubsResult){
              clubs = clubsResult.clubs;
            }
          }
        }
      } catch (error) {
        console.error("Error fetching football data:", error);
        toasts.addToast({
          message: "Error fetching football data",
          type: "error",
        });
      }
    }

    function getCountryName(countryId: number): string {
      if(countryId > 0){
          const country = countries.find(x => x.id === countryId);
          return country?.name ?? 'Not found';
      }
      return 'Not Set';
    }

    function getLeagueName(leagueId: number): string {
      if(leagueId > 0){
        const league = leagues.find(x => x.id === leagueId);
        return league?.name ?? 'Not found';
      }
      return 'Not Set';
    }

    function getClubName(clubId: number): string {
      if(clubId > 0){
        const club = clubs.find(x => x.id === clubId);
        return club?.name ?? 'Not found';
      }
      return 'Not Set';
    }
</script>
  
{#if isLoading}
  <LocalSpinner message={loadingMessage} />
{:else}
  <div class="p-4 space-y-5 text-white">
    <div>
        <h2 class="text-2xl text-white cta-text">PROFILE DETAILS</h2>
      <p class="text-sm text-BrandGrayShade3">Joined: {joinedDate}</p>
  </div>

  <div class="flex flex-col items-start lg:items-center lg:flex-row">
    <h2 class="text-lg text-white cta-text">Principal ID:</h2>
    <CopyPrincipal bgColor="bg-BrandBlackShade1" borderColor="border-none" />
  </div>
  <div class="flex flex-col space-y-2">
    <h2 class="text-lg text-white cta-text">Football Preferences: </h2>
    <p class="text-sm text-BrandGrayShade4">Set further information to further participate with the ICFC ecosystem:</p>
  </div>
  <div class="grid grid-cols-1 gap-3 sm:grid-cols-3">
    <div class="p-3 border rounded-lg border-BrandGrayShade3">
      <div class="flex items-start justify-between">
        <div class="space-y-2">
              <h3 class="text-lg text-white">Nationality</h3>
              <p class="mt-1 text-sm font-medium text-white">
                  {getCountryName(nationalityId)}
              </p>
        </div>
          <button
            onclick={() => showUpdateNationalityModal = true}
            class="px-3 py-1 text-sm text-white border border-white rounded-md hover:border-BrandBlue/80" 
          >
            Edit
          </button>
      </div>
    </div>

    <div class="p-3 border rounded-lg border-BrandGrayShade3">
      <div class="flex items-start justify-between">
        <div class="space-y-2">
          <h3 class="text-lg text-white">Favourite League</h3>
          <p class="mt-1 text-sm font-medium text-white">
              {getLeagueName(favouriteLeagueId)}
          </p>
        </div>
        <button
          onclick={() => showUpdateFavouriteClubModal = true}
          class="px-3 py-1 text-sm text-white border border-white rounded-md hover:border-BrandBlue/80"
        >
          Edit
        </button>
      </div>
    </div>

    <div class="p-3 border rounded-lg border-BrandGrayShade3">
      <div class="flex items-start justify-between">
        <div class="space-y-2">
          <h3 class="text-lg text-white">Favourite Club</h3>
          <p class="mt-1 text-sm font-medium text-white">
              {getClubName(favouriteClubId)}
          </p>
        </div>
        <button
            onclick={() => showUpdateFavouriteClubModal = true}
            class="px-3 py-1 text-sm text-white border border-white rounded-md hover:border-BrandBlue/80"
        >
            Edit
        </button>
      </div>
    </div>
  </div>
</div>
{/if}



{#if showUpdateNationalityModal}
  <UpdateNationalityModal 
      {nationalityId}
      bind:visible={showUpdateNationalityModal} 
  />
{/if}

{#if showUpdateFavouriteClubModal}
  <UpdateFavouriteClubModal
      {favouriteLeagueId}
      {favouriteClubId}
      bind:visible={showUpdateFavouriteClubModal} 
  />
{/if}