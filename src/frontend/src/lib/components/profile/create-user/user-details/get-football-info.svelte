<script lang="ts">
    import { countryStore } from "$lib/stores/country-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
    import { busy } from "$lib/stores/busy-store";
    import { toasts } from "$lib/stores/toasts-store";

    import type { ClubId, CountryId, LeagueId } from "../../../../../../../declarations/backend/backend.did";
    
    export let nationalityId: CountryId | null;
    export let favouriteLeagueId: LeagueId | null;
    export let favouriteClubId: ClubId | null;

    $: clubs = $clubStore;

    let lastFetchedLeagueId: LeagueId | null = null;
    let loadingClubs = false;

    async function getClubs() {
        try {
            loadingClubs = true;
            const clubsResult = await clubStore.getClubs(favouriteLeagueId!);
            if (clubsResult) {
                clubs = clubsResult.clubs;
                clubStore.setClubs(clubs);
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
            loadingClubs = false;
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
        {#each $countryStore.sort((a, b) => a.name.localeCompare(b.name)) as country}
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
            {#each $leagueStore.sort( (a, b) => a.name.localeCompare(b.name) ) as league}
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
            disabled={!favouriteLeagueId || loadingClubs}
            class="w-full brand-input disabled:opacity-50"
        >
            <option value={null}>Select...</option>
            {#each $clubStore.sort( (a, b) => a.friendlyName.localeCompare(b.friendlyName) ) as club}
                <option value={club.id}>{club.friendlyName}</option>
            {/each}
        </select>
    </div>
</div>