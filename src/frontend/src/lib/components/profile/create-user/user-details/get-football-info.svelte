<script lang="ts">
    import DropdownSelect from "$lib/components/shared/dropdown-select.svelte";
    import type { Country, League, Club, CountryId, LeagueId, ClubId } from "../../../../../../../declarations/backend/backend.did";
    export let countries: Country[];
    export let leagues: League[];
    export let clubs: Club[];
    export let nationalityId: CountryId | null;
    export let favouriteLeagueId: LeagueId | null;
    export let favouriteClubId: ClubId | null;

    $: if (favouriteLeagueId) {
        favouriteClubId = null;
    }

    $: clubOptions = clubs.length > 0 
        ? clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))
            .map(club => ({ id: club.id, label: club.friendlyName }))
        : [];
</script>

<div class="grid grid-cols-1 gap-6 md:grid-cols-3">
    <div class="space-y-2">
        <p class="form-title">National Team <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
        <p class="form-hint min-h-[40px]">Select to participate in nationwide football competitions.</p>
        <DropdownSelect
            options={countries.sort((a, b) => a.name.localeCompare(b.name)).map((country: Country) => ({ id: country.id, label: country.name }))}
            bind:value={nationalityId}
            searchOn={true}
        />
    </div>
    <div class="space-y-2">
        <p class="form-title">Your Favourite League <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
        <p class="form-hint min-h-[40px]">Select to find your favourite club.</p>
        <DropdownSelect
            options={leagues.map(league => ({ id: league.id, label: league.name }))}
            bind:value={favouriteLeagueId}
            searchOn={true}
        />
    </div>
    <div class="space-y-2">
        <p class="form-title">Your Favourite Club <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
        <p class="form-hint min-h-[40px]">
            {#if !favouriteLeagueId}
                Please select a league first
            {:else if clubs.length === 0}
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