import type {
  AppStatus,
  TokenBalances,
} from "../../../../declarations/backend/backend.did";
import { isError } from "../utils/helpers";
import { idlFactory as backend_canister } from "../../../../declarations/backend";
import { ActorFactory } from "$lib/utils/ActorFactory";
import { authStore } from "$lib/stores/auth-store";

export class AppService {
  constructor() {}

  async getAppStatus(): Promise<AppStatus | undefined> {
    const identityActor: any = await ActorFactory.createActor(
      backend_canister,
      process.env.BACKEND_CANISTER_ID,
    );

    const result = await identityActor.getAppStatus();
    if (isError(result)) throw new Error("Failed to get app status");
    return result.ok;
  }

  async getTokenBalances(): Promise<TokenBalances | undefined> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );

      const result: any = await identityActor.getTokenBalances();
      if (isError(result)) throw new Error("Failed to get token balances");
      return result.ok;
    } catch (error) {}
  }
}
