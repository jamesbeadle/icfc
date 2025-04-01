<script lang="ts">
    import DropdownSelect from "$lib/components/shared/dropdown-select.svelte";
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import Modal from "$lib/components/shared/modal.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import type { PrincipalId, UpdateFavouriteClub } from "../../../../../../declarations/backend/backend.did";
    import type { ClubDTO, ClubId, FootballLeagueDTO, LeagueId } from "../../../../../../external_declarations/data_canister/data_canister.did";
    import { clubStore } from "$lib/stores/club-store";
    import { leagueStore } from "$lib/stores/league-store";


    export let visible: boolean = false;
    export let favouriteLeagueId: LeagueId;
    export let favouriteClubId: ClubId;
    export let principalId: PrincipalId;

    let isLoading = false;
    let newFavouriteLeagueId = favouriteLeagueId;
    let newFavouriteClubId = favouriteClubId;
    let clubs: ClubDTO[] = [];
    let leagues: FootballLeagueDTO[] = [];


    onMount(async () => {
        try{
        leagues = await leagueStore.getLeagues();
        clubs = await clubStore.getClubs(favouriteLeagueId);
        } catch {
        toasts.addToast({type: 'error', message: 'Failed to load data.'});
        } finally {
        isLoading = false;
        }
    });

    $: isSubmitDisabled = newFavouriteLeagueId > 0 && newFavouriteLeagueId != favouriteLeagueId && newFavouriteClubId > 0 && newFavouriteClubId != favouriteClubId;

    const cancelModal = () => {
        newFavouriteLeagueId = favouriteLeagueId;
        newFavouriteClubId = newFavouriteClubId;
        visible = false;
    };

    const handleSubmit = async (e: Event) => {
        e.preventDefault();
        if (isSubmitDisabled) return;

        isLoading = true;
        try {
            let dto: UpdateFavouriteClub =  {
                favouriteLeagueId: newFavouriteLeagueId,
                favouriteClubId: newFavouriteClubId,
                principalId
            }
            await userStore.updateFavouriteClub(dto);
            await userStore.sync();
            visible = false;
            toasts.addToast({
                message: "Favourite club updated.",
                type: "success",
                duration: 2000,
            });
        } catch (error) {
            console.error("Error updating favourite club:", error);
            toasts.addToast({
                message: "Error updating favourite club.",
                type: "error",
            });
        } finally {
            isLoading = false;
        }
    };
</script>

{#if visible}
    <Modal onClose={cancelModal} title="Update Favourite League & Club">
        {#if isLoading}
            <LocalSpinner />
        {:else}
            <div class="flex flex-col p-4 space-y-4 md:justify-between md:flex-row md:space-y-0">
                <form class="flex flex-col w-full space-y-4" on:submit={handleSubmit}>
                    <div class="flex flex-col space-y-2">
                        <p class="form-title">Your Favourite League</p>
                        <p class="form-hint">Select to find your favourite club.</p>
                        <DropdownSelect
                        options={leagues.map(league => ({ id: league.id, label: league.name }))}
                        value={favouriteLeagueId}
                        onChange={(value: string | number) => {
                            favouriteLeagueId = Number(value);
                        }}
                        scrollOnOpen={true}
                        />
                    </div>
                    <div class="flex flex-col w-full space-y-2">
                        <p class="form-title">Your Favourite Club</p>
                        <p class="form-hint">Select to enable club based rewards.</p>
                        <DropdownSelect
                        options={clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName)).map(club => ({ id: club.id, label: club.friendlyName }))}
                        value={favouriteClubId}
                        onChange={(value: string | number) => {
                            favouriteClubId = Number(value);
                        }}
                        scrollOnOpen={true}
                        disabled={favouriteLeagueId == null || favouriteLeagueId == 0}
                        />
                    </div>
                    <div class="flex flex-row items-center py-3 space-x-4">
                        <button
                            class="px-4 py-2 default-button fpl-cancel-btn"
                            type="button"
                            on:click={cancelModal}
                            disabled={isLoading}
                        >
                            Cancel
                        </button>
                        <button
                            class="px-4 py-2 default-button"
                            class:bg-BrandGrayShade3={isSubmitDisabled}
                            class:brand-button={!isSubmitDisabled}
                            type="submit"
                            disabled={isSubmitDisabled}
                        >
                            Update
                        </button>
                    </div>
                </form>
            </div>
        {/if}
    </Modal>
{/if}