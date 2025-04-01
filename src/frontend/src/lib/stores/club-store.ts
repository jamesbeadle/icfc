import { writable } from "svelte/store";
import { ClubService } from "../services/club-service";
import type {
  Club,
  LeagueId,
} from "../../../../declarations/backend/backend.did";

function createClubStore() {
  const { subscribe, set } = writable<Club[]>([]);

  async function getClubs(leagueId: LeagueId): Promise<any> {
    return new ClubService().getClubs(leagueId);
  }
  return {
    getClubs,
    subscribe,
    setClubs: (clubs: Club[]) =>
      set(clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))),
  };
}

export const clubStore = createClubStore();
