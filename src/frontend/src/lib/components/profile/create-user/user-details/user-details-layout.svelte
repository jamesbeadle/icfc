<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
 
    import ProfilePicture from "./profile-picture.svelte";
    import GetFootballInfo from "./get-football-info.svelte";
    import GetNames from "./get-names.svelte";
    import type { Club, ClubId, Country, CountryId, League, LeagueId } from "../../../../../../../declarations/backend/backend.did";

    export let file: File | null = null;
    
    export let countries: Country[];
    export let leagues: League[];
    export let clubs: Club[];
    export let nationalityId: CountryId | null;
    export let favouriteLeagueId: LeagueId | null;
    export let favouriteClubId: ClubId | null;
    
    export let username: string;
    export let usernameAvailable: boolean;
    export let displayName: string;
    export let store: typeof userStore;
</script>

<p class="mb-8 text-xl text-white cta-text">User Details</p>
<div class="flex flex-col gap-8 p-6 border rounded-lg border-BrandGrayShade3 md:flex-row md:items-start">
    <div class="w-full md:w-1/4">
        <ProfilePicture bind:file />
    </div>
    
    <div class="flex flex-col w-full space-y-8 base:space-y-14 md:w-3/4">
        <GetNames bind:username bind:usernameAvailable bind:displayName {store} />
        <GetFootballInfo {countries} {leagues} {clubs} bind:nationalityId bind:favouriteLeagueId bind:favouriteClubId />
    </div>
</div>
<div class="mt-8 border-t border-BrandGrayShade3"></div>