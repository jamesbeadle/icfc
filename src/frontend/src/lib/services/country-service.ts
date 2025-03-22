import { ActorFactory } from "../utils/ActorFactory";
import { isError } from "../utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import type { CountryDTO } from "../../../../external_declarations/data_canister/data_canister.did";

export class CountryService {
  constructor() {}

  async getCountries(): Promise<CountryDTO[]> {
    const identityActor: any =
        await ActorFactory.createDataCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_DATA ?? "",
        );
    const result = await identityActor.getCountries();
    if (isError(result)) throw new Error("Failed to fetch countries");
    return result.ok;
  }
}
