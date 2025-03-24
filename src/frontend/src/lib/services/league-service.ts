import type {
  FootballLeagueDTO,
  LeagueStatus,
} from "../../../../external_declarations/data_canister/data_canister.did";
import { authStore } from "../stores/auth-store";
import { ActorFactory } from "../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class LeagueService {
  constructor() {}

  async getLeagues(): Promise<FootballLeagueDTO[]> {
    console.log("getting leagues");
    console.log(process.env.CANISTER_ID_DATA);
    const identityActor: any =
      await ActorFactory.createDataCanisterIdentityActor(
        authStore,
        process.env.CANISTER_ID_DATA ?? "",
      );
    const result = await identityActor.getLeagues();
    console.log(result);
    if (isError(result)) throw new Error("Failed to fetch leagues");
    return result.ok;
  }

  async getLeagueStatus(leagueId: number): Promise<LeagueStatus> {
    const identityActor: any =
      await ActorFactory.createDataCanisterIdentityActor(
        authStore,
        process.env.CANISTER_ID_DATA ?? "",
      );
    const result = await identityActor.getLeagueStatus(leagueId);
    if (isError(result)) throw new Error("Failed to fetch league status");
    return result.ok;
  }
}
