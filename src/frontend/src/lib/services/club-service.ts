import { authStore } from "$lib/stores/auth-store";
import { toasts } from "$lib/stores/toasts-store";
import { ActorFactory } from "$lib/utils/ActorFactory";
import type {
  Club,
  GetClubs,
  LeagueId,
} from "../../../../declarations/backend/backend.did";
import { isError } from "../utils/helpers";

export class ClubService {
  private actor: any;

  constructor() {}

  async getClubs(leagueId: LeagueId): Promise<Club[] | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );
      let dto: GetClubs = { leagueId };
      const result = await identityActor.getClubs(dto);
      if (isError(result)) throw new Error("Failed to fetch clubs");
      return result.ok;
    } catch (error) {
      console.error("Error fetching clubs: ", error);
      toasts.addToast({ type: "error", message: "Error fetching clubs." });
    }
  }
}
