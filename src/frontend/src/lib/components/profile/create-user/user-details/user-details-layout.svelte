<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import type { CountryDTO, FootballLeagueDTO, ClubDTO, CountryId, LeagueId, ClubId } from "../../../../../../../external_declarations/data_canister/data_canister.did";

    import ProfilePicture from "./profile-picture.svelte";
    import GetFootballInfo from "./get-football-info.svelte";
    import GetNames from "./get-names.svelte";

    export let file: File | null = null;
    
    export let countries: CountryDTO[];
    export let leagues: FootballLeagueDTO[];
    export let clubs: ClubDTO[];
    export let nationalityId: CountryId | null;
    export let favouriteLeagueId: LeagueId | null;
    export let favouriteClubId: ClubId | null;
    
    export let username: string;
    export let usernameAvailable: boolean;
    export let displayName: string;
    export let store: typeof userStore;
</script>

<p class="mb-8 text-lg text-white cta-text">User Details</p>
<div class="flex flex-col gap-8 md:flex-row md:items-start">
    <div class="w-full md:w-1/4">
        <ProfilePicture bind:file />
    </div>
    
    <div class="flex flex-col w-full space-y-8 base:space-y-14 md:w-3/4">
        <GetNames bind:username bind:usernameAvailable bind:displayName {store} />
        <GetFootballInfo 
            {countries} 
            {leagues} 
            {clubs} 
            bind:nationalityId 
            bind:favouriteLeagueId 
            bind:favouriteClubId 
        />
    </div>
</div>
<div class="mt-8 border-t border-BrandGrayShade3"></div>