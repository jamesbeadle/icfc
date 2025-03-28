<script lang="ts">
    import DropdownSelect from "$lib/components/shared/dropdown-select.svelte";
    import type { CountryDTO, FootballLeagueDTO, ClubDTO, CountryId, LeagueId, ClubId } from "../../../../../../../external_declarations/data_canister/data_canister.did";

    export let countries: CountryDTO[];
    export let leagues: FootballLeagueDTO[];
    export let clubs: ClubDTO[];
    export let nationalityId: CountryId | null;
    export let favouriteLeagueId: LeagueId | null;
    export let favouriteClubId: ClubId | null;
    
</script>

<div class="grid grid-cols-1 gap-6 md:grid-cols-3">
    <div class="space-y-2">
        <p class="form-title">National Team</p>
        <p class="form-hint min-h-[40px]">Select to participate in nationwide football competitions.</p>
        <DropdownSelect
            options={countries.sort((a, b) => a.name.localeCompare(b.name)).map((country: CountryDTO) => ({ id: country.id, label: country.name }))}
            bind:value={nationalityId}
        />
    </div>
    <div class="space-y-2">
        <p class="form-title">Your Favourite League</p>
        <p class="form-hint min-h-[40px]">Select to find your favourite club.</p>
        <DropdownSelect
            options={leagues.map(league => ({ id: league.id, label: league.name }))}
            bind:value={favouriteLeagueId}
            scrollOnOpen={true}
        />
    </div>
    <div class="space-y-2">
        <p class="form-title">Your Favourite Club</p>
        <p class="form-hint min-h-[40px]">Select to enable club based rewards.</p>
        <DropdownSelect
            options={clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName)).map(club => ({ id: club.id, label: club.friendlyName }))}
            bind:value={favouriteClubId}
            scrollOnOpen={true}
            disabled={favouriteLeagueId == null || favouriteLeagueId == 0}
        />
    </div>
  </div>