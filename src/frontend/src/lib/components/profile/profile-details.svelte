<script lang="ts">
    import { onMount } from "svelte";
    import { getDateFromBigInt, getImageURL } from "$lib/utils/helpers";
    import type { ProfileDTO } from "../../../../../declarations/backend/backend.did";
    import UpdateFavouriteClubModal from "./update-modals/update-favourite-club-modal.svelte";
    import UpdateNationalityModal from "./update-modals/update-nationality-modal.svelte";
    import UpdateProfilePictureModal from "./update-modals/update-profile-picture-modal.svelte";
    import UdpateDisplayNameModal from "./update-modals/update-display-name-modal.svelte";
    import UpdateUsernameModal from "./update-modals/update-username-modal.svelte";
    import { countryStore } from "$lib/stores/country-store";
    import type { ClubDTO, CountryDTO, FootballLeagueDTO } from "../../../../../external_declarations/data_canister/data_canister.did";
    import CopyPrincipal from "./copy-principal.svelte";
  
    export let profile: ProfileDTO;

    let showUpdateUsernameModal: boolean = false;
    let showUpdateDisplayNameModal: boolean = false;
    let showUpdateProfilePictureModal: boolean = false; 
    let showUpdateFavouriteClubModal: boolean = false;
    let showUpdateNationalityModal: boolean = false;
    let clubs: ClubDTO[] = [];
    let countries: CountryDTO[] = [];
    let leagues: FootballLeagueDTO[] = [];

    let username = "";
    let displayName = "";
    let joinedDate = "";
    let principalId = "";
    let favouriteLeagueId = 0;
    let favouriteClubId = 0;
    let nationalityId = 0;
    let profileSrc = '/profile_placeholder.png';
    
    onMount(async () => {
        principalId = profile.principalId;
        username = profile.username;
        joinedDate = getDateFromBigInt(Number(profile.createdOn));
        profileSrc = getImageURL(profile.profilePicture);
        countries = await countryStore.getCountries();
    });
  
</script>
  

<div class="flex flex-col p-8 space-y-4">
    <p class="cta-text text-lg text-white">ICFC Profile Details</p>

    <p>Joined: {joinedDate}</p>

    <CopyPrincipal />

    <div class="flex flex-col md:flex-row">
      <div class="w-full md:w-1/6 flex flex-col">
        <p class="form-title">Profile Picture</p>
        <p class="form-hint">Max size 1mb</p>
        <img 
          src={profileSrc} 
          alt="Profile" 
          class="profile-picture w-full h-48 object-cover rounded-lg"
        />
      </div>
      <div class="w-full md:w-5/6 flex flex-col md:flex-row">

        <div class="flex flex-col md:flex-row">
        
          <div class="flex flex-col space-y-1 w-full md:w-1/2">
            <p class="form-title">Username</p>
            <p class="form-hint">5-20 characters, letters & numbers only. <span class="text-xs">(Required)</span></p>
            <p>{username}</p>
          </div>
          <div class="flex flex-col space-y-1 w-full md:w-1/2">
            <p class="form-title">Display Name</p>
            <p class="form-hint">5-20 characters, letters & numbers only.</p>
            <p>{displayName}</p>
          </div>

        </div>
        <div class="flex flex-col md:flex-row">
          <div class="flex flex-col space-y-1 w-full md:w-1/2">
            <p class="form-title">Your Favourite League</p>
            <p class="form-hint">Select to find your favourite club.</p>
            <p>{leagues.find(x => x.id == favouriteLeagueId) }</p>
          </div>
          <div class="flex flex-col space-y-1 w-full md:w-1/2">
            <p class="form-title">Your Favourite Club</p>
            <p class="form-hint">Select to enable club based rewards.</p>
            <p>{clubs.find(x => x.id == favouriteClubId) }</p>
          </div>

        </div>
        <div class="flex flex-col md:flex-row">
          <div class="flex flex-col space-y-1 w-full md:w-1/2">
            <p class="form-title">Nationality</p>
            <p class="form-hint">Select to participate in nationwide football competitions.</p>
            <p>{countries.find(x => x.id == nationalityId) }</p>
          </div>
        </div>

      </div>

    </div>

</div>

  {#if showUpdateUsernameModal}
    <UpdateUsernameModal
        {principalId}
        {username}
        bind:visible={showUpdateUsernameModal}
    />
  {/if}

  {#if showUpdateDisplayNameModal}
    <UdpateDisplayNameModal 
        {principalId}
        {displayName}
        bind:visible={showUpdateDisplayNameModal} 
    />
  {/if}


  {#if showUpdateProfilePictureModal}
    <UpdateProfilePictureModal 
        {principalId}
        {profileSrc}
        bind:visible={showUpdateProfilePictureModal} 
    />
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