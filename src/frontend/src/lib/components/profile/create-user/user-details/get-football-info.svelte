<script lang="ts">
    import { countryStore } from "$lib/stores/country-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
    import { busy } from "$lib/stores/busy-store";
    import { toasts } from "$lib/stores/toasts-store";

    import type { Club, ClubId, Country, CountryId, League, LeagueId } from "../../../../../../../declarations/backend/backend.did";
    
    export let nationalityId: CountryId | null;
    export let favouriteLeagueId: LeagueId | null;
    export let favouriteClubId: ClubId | null;

    let leagues: League[] = [];
    let clubs: Club[] = [];
    
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

    $: if (favouriteLeagueId && favouriteLeagueId !== lastFetchedLeagueId) {
      lastFetchedLeagueId = favouriteLeagueId;
      getClubs();
    }
</script>

<div class="grid grid-cols-1 gap-6 md:grid-cols-3">
    <div class="space-y-2">
        <p class="form-title">National Team <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
        <p class="form-hint min-h-[40px]">Select to participate in nationwide football competitions.</p>
        <select
            bind:value={nationalityId}
            class="w-full brand-input"
        >
            <option value={null}>Select...</option>
            {#each $countryStore as country}
                <option value={country.id}>{country.name}</option>
            {/each}
        </select>
    </div>

    <div class="space-y-2">
        <p class="form-title">Your Favourite League <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
        <p class="form-hint min-h-[40px]">Select to find your favourite club.</p>
        <select
            bind:value={favouriteLeagueId}
            class="w-full brand-input"
        >
            <option value={null}>Select...</option>
            {#each leagues as league}
                <option value={league.id}>{league.name}</option>
            {/each}
        </select>
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
        <select
            bind:value={favouriteClubId}
            disabled={!favouriteLeagueId}
            class="w-full brand-input disabled:opacity-50"
        >
            <option value={null}>Select...</option>
            {#each clubs as club}
                <option value={club.id}>{club.friendlyName}</option>
            {/each}
        </select>
    </div>
</div>