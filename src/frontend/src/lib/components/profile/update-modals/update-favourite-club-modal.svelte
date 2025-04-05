<script lang="ts">
  import LocalSpinner from '$lib/components/shared/local-spinner.svelte';
  import Modal from '$lib/components/shared/modal.svelte';
  import { toasts } from '$lib/stores/toasts-store';
  import { userStore } from '$lib/stores/user-store';
  import { onMount } from 'svelte';
  import type {
    Club,
    ClubId,
    League,
    LeagueId,
    UpdateFavouriteClub,
  } from '../../../../../../declarations/backend/backend.did';
  import { clubStore } from '$lib/stores/club-store';
  import { leagueStore } from '$lib/stores/league-store';

  export let visible: boolean = false;
  export let favouriteLeagueId: LeagueId;
  export let favouriteClubId: ClubId;

  let isLoading = false;
  let clubsLoading = false;
  let loadingMessage = '';
  let newFavouriteLeagueId: LeagueId;
  let newFavouriteClubId: ClubId;
  let clubs: Club[] = [];
  let leagues: League[] = [];
  let lastFetchedLeagueId = favouriteLeagueId;

  onMount(async () => {
    try {
      loadingMessage = 'Loading leagues';
      isLoading = true;
      let leaguesResult = await leagueStore.getLeagues();
      if (leaguesResult) {
        leagues = leaguesResult.leagues;
        leagueStore.setLeagues(leagues);
      }
      loadingMessage = 'Loading clubs';
      await getClubs(favouriteLeagueId);
      newFavouriteLeagueId = favouriteLeagueId;
    } catch (error) {
      toasts.addToast({
        type: 'error',
        message: 'Failed to load data.',
        duration: 5000,
      });
      console.error('Failed to load data.', error);
    } finally {
      isLoading = false;
    }
  });

  async function getClubs(leagueId: LeagueId) {
    clubsLoading = true;
    try {
        const clubsResult = await clubStore.getClubs(leagueId);
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
      clubsLoading = false;
    } 
  }

  $: isSubmitDisabled =
    newFavouriteLeagueId < 0 &&
    newFavouriteClubId < 0 &&
    newFavouriteClubId == favouriteClubId;

  const cancelModal = () => {
    newFavouriteLeagueId = favouriteLeagueId;
    newFavouriteClubId = newFavouriteClubId;
    visible = false;
  };

  const handleSubmit = async (e: Event) => {
    e.preventDefault();
    if (isSubmitDisabled) return;
    loadingMessage = 'Updating favourite club and league';
    isLoading = true;
    try {
      let dto: UpdateFavouriteClub = {
        favouriteLeagueId: newFavouriteLeagueId,
        favouriteClubId: newFavouriteClubId,
      };
      await userStore.updateFavouriteClub(dto);
      await userStore.sync();
      visible = false;
      toasts.addToast({
        message: 'Favourite club and league updated.',
        type: 'success',
        duration: 4000,
      });
    } catch (error) {
      console.error('Error updating favourite club:', error);
      toasts.addToast({
        message: 'Error updating favourite club and league.',
        type: 'error',
        duration: 4000,
      });
    } finally {
      isLoading = false;
    }
  };

  $: if (newFavouriteLeagueId) {
        newFavouriteClubId = -1;
    }

    $: if (newFavouriteLeagueId && newFavouriteLeagueId !== lastFetchedLeagueId) {
      lastFetchedLeagueId = newFavouriteLeagueId;
      getClubs(newFavouriteLeagueId);
    }
</script>

{#if visible}
  <Modal onClose={cancelModal} title="Update Favourite League & Club">
    {#if isLoading}
      <LocalSpinner message={loadingMessage} />
    {:else}
      <div
        class="flex flex-col p-4 space-y-4 md:justify-between md:flex-row md:space-y-0"
      >
        <form class="flex flex-col w-full space-y-4">
          <div class="flex flex-col space-y-2">
            <p class="form-title">Your Favourite League</p>
            <p class="form-hint">Select to find your favourite club.</p>
            <select bind:value={newFavouriteLeagueId} class="w-full brand-input">
              <option value={null}>Select...</option>
              {#each $leagueStore.sort( (a, b) => a.name.localeCompare(b.name) ) as league}
                <option value={league.id}>{league.name}</option>
              {/each}
            </select>
          </div>
          <div class="flex flex-col w-full space-y-2">
            <p class="form-title">Your Favourite Club</p>
            <p class="form-hint">Select to enable club based rewards.</p>
            {#if clubsLoading}
              <LocalSpinner message="Loading clubs" />
            {:else}
              <select
                bind:value={newFavouriteClubId}
                disabled={!newFavouriteLeagueId}
                class="w-full brand-input disabled:opacity-50"
              >
              <option value={null}>Select...</option>
              {#each $clubStore.sort( (a, b) => a.friendlyName.localeCompare(b.friendlyName) ) as club}
                <option value={club.id}>{club.friendlyName}</option>
              {/each}
              </select>
            {/if}
          </div>
          <div class="flex flex-row items-center py-3 space-x-4">
            <button
              class="w-1/2 brand-button"
              type="button"
              on:click={cancelModal}
              disabled={isLoading}
            >
              Cancel
            </button>
            <button
              class="w-1/2 brand-button"
              disabled={isSubmitDisabled}
              on:click={handleSubmit}
            >
              Update Favourite Club
            </button>
          </div>
        </form>
      </div>
    {/if}
  </Modal>
{/if}
