<script lang="ts">
    import { onMount } from "svelte";
    import { getDateFromBigInt, getImageURL } from "$lib/utils/helpers";
    import type { Club, Country, League, ProfileDTO } from "../../../../../declarations/backend/backend.did";
    import { countryStore } from "$lib/stores/country-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
    import { toasts } from "$lib/stores/toasts-store";
    
    import CopyPrincipal from "./copy-principal.svelte";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import UpdateFavouriteClubModal from "./update-modals/update-favourite-club-modal.svelte";
    import UpdateNationalityModal from "./update-modals/update-nationality-modal.svelte";
  
    export let profile: ProfileDTO;

    let isLoading = false;

    let showUpdateFavouriteClubModal: boolean = false;
    let showUpdateNationalityModal: boolean = false;
    let clubs: Club[] = [];
    let countries: Country[] = [];
    let leagues: League[] = [];

    let joinedDate = "";
    let principalId = "";
    let favouriteLeagueId = 0;
    let favouriteClubId = 0;
    let nationalityId = 0;
    
    onMount(async () => {
      try{
        isLoading = true;
        principalId = profile.principalId;
        joinedDate = getDateFromBigInt(Number(profile.createdOn));
        countries = await countryStore.getCountries();
        leagues = await leagueStore.getLeagues();
        favouriteLeagueId = profile?.favouriteLeagueId[0] ?? 0;
        clubs = await clubStore.getClubs(favouriteLeagueId);
        favouriteClubId = profile?.favouriteClubId[0] ?? 0;
        nationalityId = profile?.nationalityId[0] ?? 0;
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

    function getCountryName(countryId: number): string {
        const country = countries.find(x => x.id === countryId);
        return country?.name ?? 'Not found';
    }

    function getLeagueName(leagueId: number): string {
        const league = leagues.find(x => x.id === leagueId);
        return league?.name ?? 'Not found';
    }

    function getClubName(clubId: number): string {
        const club = clubs.find(x => x.id === clubId);
        return club?.name ?? 'Not found';
    }
</script>
  
{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="p-4 space-y-6 text-white">
    <div>
        <h2 class="text-2xl text-white cta-text">PROFILE DETAILS</h2>
      <p class="text-sm text-BrandGrayShade3">Joined: {joinedDate}</p>
  </div>

  <div class="flex flex-row items-center">
    <h2 class="text-lg text-white cta-text">Principal ID:</h2>
    <CopyPrincipal bgColor="bg-BrandBlueComp" borderColor="border-none" />
  </div>

  <h2 class="text-lg text-white cta-text">Football Preferences: </h2>
  <div class="grid grid-cols-1 gap-3 sm:grid-cols-3">
    <div class="p-3 border rounded-lg border-BrandGrayShade3">
      <div class="flex items-start justify-between">
        <div class="space-y-2">
              <h3 class="text-lg text-white">Nationality</h3>
              <p class="form-hint">Participate in competitions</p>
              <p class="mt-1 text-sm font-medium text-white">
                  {getCountryName(nationalityId)}
              </p>
        </div>
          <button
            on:click={() => showUpdateNationalityModal = true}
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
          <p class="form-hint">Find your favourite club</p>
          <p class="mt-1 text-sm font-medium text-white">
              {getLeagueName(favouriteLeagueId)}
          </p>
        </div>
        <button
          on:click={() => showUpdateFavouriteClubModal = true}
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
          <p class="form-hint">Enable club rewards</p>
          <p class="mt-1 text-sm font-medium text-white">
              {getClubName(favouriteClubId)}
          </p>
        </div>
        <button
            on:click={() => showUpdateFavouriteClubModal = true}
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
      {principalId}
      {nationalityId}
      bind:visible={showUpdateNationalityModal} 
  />
{/if}

{#if showUpdateFavouriteClubModal}
  <UpdateFavouriteClubModal
      {principalId}
      {favouriteLeagueId}
      {favouriteClubId}
      bind:visible={showUpdateFavouriteClubModal} 
  />
{/if}