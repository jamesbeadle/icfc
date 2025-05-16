<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import ProfilePicture from "./profile-picture.svelte";
    import GetFootballInfo from "./get-football-info.svelte";
    import GetNames from "./get-names.svelte";
    import type { ClubId, CountryId, LeagueId } from "../../../../../../../declarations/backend/backend.did";

    interface Props {
        file: File | null;
        nationalityId: CountryId | null;
        favouriteLeagueId: LeagueId | null;
        favouriteClubId: ClubId | null;
        username: string;
        usernameAvailable: boolean;
        displayName: string;
    }

    let { file, nationalityId, favouriteLeagueId, favouriteClubId, username, usernameAvailable, displayName } : Props = $props();

</script>

<p class="mb-8 text-xl text-white cta-text">User Details</p>
<div class="flex flex-col gap-8 p-6 border rounded-lg border-BrandGrayShade3 md:flex-row md:items-start">
    <div class="w-full md:w-1/4">
        <ProfilePicture {file} />
    </div>
    
    <div class="flex flex-col w-full space-y-8 base:space-y-14 md:w-3/4">
        <GetNames {username} {usernameAvailable} {displayName} />
        <GetFootballInfo {nationalityId} {favouriteLeagueId} {favouriteClubId} />
    </div>
</div>
<div class="mt-8 border-t border-BrandGrayShade3"></div>