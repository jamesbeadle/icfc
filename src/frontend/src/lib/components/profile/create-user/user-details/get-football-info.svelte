<script lang="ts">
    import DropdownSelect from "$lib/components/shared/dropdown-select.svelte";
    import { countryStore } from "$lib/stores/country-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
    import { busy } from "$lib/stores/busy-store";
    import { toasts } from "$lib/stores/toasts-store";

    import type { Club, ClubId, Country, CountryId, League, LeagueId } from "../../../../../../../declarations/backend/backend.did";
    
    export let nationalityId: CountryId | null;
    export let favouriteLeagueId: LeagueId | null;
    export let favouriteClubId: ClubId | null;

    $: countries = $countryStore;
    $: leagues = $leagueStore;
    $: clubs = $clubStore;
    $: console.log("Country Store:", $countryStore);
    $: console.log("League Store:", $leagueStore);
    $: console.log("Club Store:", $clubStore);

    let lastFetchedLeagueId: LeagueId | null = null;

    async function getClubs() {
        try {
            busy.start();
            const clubsResult = await clubStore.getClubs(favouriteLeagueId!);
            if (clubsResult) {
                clubs = clubsResult;
                clubStore.setClubs(clubsResult);
            } else {
                clubs = [];
                clubStore.setClubs([]);
            }
        } catch (error) {
            console.error("Error fetching clubs:", error);
            toasts.addToast({ type: 'error', message: 'Failed to load clubs' });
            clubs = [];
            clubStore.setClubs([]);
        } finally {
            busy.stop();
        } 
    }

    $: if (favouriteLeagueId) {
        favouriteClubId = null;
    }

    $: countryOptions = Array.isArray(countries) 
        ? countries
            .filter(country => country && country.name)
            .sort((a, b) => a.name.localeCompare(b.name))
            .map(country => ({ id: country.id, label: country.name }))
        : [];

    $: leagueOptions = Array.isArray(leagues)
        ? leagues
            .filter(league => league && league.name)
            .map(league => ({ id: league.id, label: league.name }))
        : [];

    $: clubOptions = Array.isArray(clubs) && clubs.length > 0 
        ? clubs
            .filter(club => club && club.friendlyName)
            .sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))
            .map(club => ({ id: club.id, label: club.friendlyName }))
        : [];

    $: if (favouriteLeagueId && favouriteLeagueId !== lastFetchedLeagueId) {
      lastFetchedLeagueId = favouriteLeagueId;
      getClubs();
    }
</script>

<div class="grid grid-cols-1 gap-6 md:grid-cols-3">
    <div class="space-y-2">
        <p class="form-title">National Team <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
        <p class="form-hint min-h-[40px]">Select to participate in nationwide football competitions.</p>
        <DropdownSelect
            options={countryOptions}
            bind:value={nationalityId}
            searchOn={true}
        />
    </div>
    <div class="space-y-2">
        <p class="form-title">Your Favourite League <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
        <p class="form-hint min-h-[40px]">Select to find your favourite club.</p>
        <DropdownSelect
            options={leagueOptions}
            bind:value={favouriteLeagueId}
            searchOn={true}
        />
    </div>
    <div class="space-y-2">
        <p class="form-title">Your Favourite Club <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
        <p class="form-hint min-h-[40px]">
            {#if !favouriteLeagueId}
                Please select a league first
            {:else if clubs?.length === 0}
                Loading clubs...
            {:else}
                Select to enable club based rewards.
            {/if}
        </p>
        <DropdownSelect
            options={clubOptions}
            bind:value={favouriteClubId}
            searchOn={true}
            disabled={favouriteLeagueId == null || favouriteLeagueId === 0}
        />
    </div>
  </div>