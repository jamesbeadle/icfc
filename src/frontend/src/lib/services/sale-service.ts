import { ActorFactory } from "$lib/utils/ActorFactory";
import { isError } from "$lib/utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import type { SaleGoalDTO, SaleCountDownDTO } from "../../../../declarations/backend/backend.did";

export interface SaleCountdown {
  status: string;
  stringTime: string;
  timeRemaining: bigint;
}

type Result<T> = { ok: T } | { err: any };

export class SaleService {
  constructor() {}

  async getGoal(): Promise<SaleGoalDTO> {
    try {
        const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            process.env.CANISTER_ID_BACKEND ?? "",
        );
        const result = await identityActor.get_goal();
        if (isError(result)) {
            throw new Error("Failed to get goal");
        }
        return result;
    } catch (error) {
        console.error("Error fetching goal:", error);
        throw error;
    }
  }

  async getSaleCountdown(): Promise<SaleCountDownDTO> {
    try {
        const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            process.env.CANISTER_ID_BACKEND ?? "",
        );
        const result = await identityActor.get_sale_countdown()
        if (isError(result)) {
            throw new Error("Failed to get sale countdown");
        }
        return result;
    } catch (error) {
        console.error("Error fetching sale countdown:", error);
        throw error;
    }
  }

  async getUserBalance(): Promise<bigint> {
    try {
        const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            process.env.CANISTER_ID_BACKEND ?? "",
        );
        const result = await identityActor.get_user_balance() as Result<bigint>;
        if ('err' in result) {
            throw new Error("Failed to get user balance");
        }
        return result.ok;
    } catch (error) {
        console.error("Error fetching user balance:", error);
        throw error;
    }
  }

  async particpate(amount: bigint): Promise<void> {
    try {
        const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            process.env.CANISTER_ID_BACKEND ?? "",
        );
        const adjustedAmount = amount * BigInt(10 ** 8);
        const result = await identityActor.participate(adjustedAmount);
        if (isError(result)) {
            throw new Error("Failed to participate");
        }
    } catch (error) {
        console.error("Error participating in sale:", error);
        throw error;
    }
  }
}
