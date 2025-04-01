import { writable } from "svelte/store";
import { LeagueService } from "$lib/services/league-service";
import type {
  League,
} from "../../../../declarations/backend/backend.did";

function createLeagueStore() {
  const { subscribe, set } = writable<League[]>([]);

  async function getLeagues() {
    return new LeagueService().getLeagues();
  }

  return {
    subscribe,
    setLeagues: (leagues: League[]) => set(leagues),
    getLeagues,
  };
}

export const leagueStore = createLeagueStore();
