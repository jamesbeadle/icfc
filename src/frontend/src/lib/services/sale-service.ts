import { ActorFactory } from "$lib/utils/ActorFactory";
import { isError } from "$lib/utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import { idlFactory as sale_canister } from "../../../../declarations/icfc_sale_2";
import type {
  SaleProgress,
  UserParticipation,
  ICFCDistribution,
} from "../../../../declarations/icfc_sale_2/icfc_sale_2.did";

export class SaleService {
  constructor() {}

  async getProgress(): Promise<SaleProgress | undefined> {
    try {
      const actor: any = await ActorFactory.createActor(
        sale_canister,
        process.env.ICFC_SALE_2_CANISTER_ID,
      );
      const result = await actor.getProgress();
      if (isError(result)) {
        throw new Error("Failed to get progress");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching progress:", error);
      throw error;
    }
  }

  async getUserParticipation(): Promise<UserParticipation | undefined> {
    try {
      const identityActor: any = await ActorFactory.createSaleActor(
        authStore,
        process.env.ICFC_SALE_2_CANISTER_ID ?? "",
      );
      const result = await identityActor.getUserParticipation();
      if (isError(result)) {
        throw new Error("Failed to get user participation");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching user participation:", error);
      throw error;
    }
  }

  async getUsersICFCDistributions(): Promise<ICFCDistribution[] | undefined> {
    try {
      const identityActor: any = await ActorFactory.createSaleActor(
        authStore,
        process.env.ICFC_SALE_2_CANISTER_ID ?? "",
      );
      const result = await identityActor.getUsersICFCDistributions();
      if (isError(result)) {
        throw new Error("Failed to get users ICFC distributions");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching users ICFC distributions:", error);
      throw error;
    }
  }

  async claimICFCPackets(): Promise<boolean> {
    try {
      const identityActor: any = await ActorFactory.createSaleActor(
        authStore,
        process.env.ICFC_SALE_2_CANISTER_ID ?? "",
      );
      const result = await identityActor.claimICFCPackets();
      if (isError(result)) {
        console.error("Error claiming packets:", result.err);
        return false;
      }
      return true;
    } catch (error) {
      console.error("Error claiming packets:", error);
      return false;
    }
  }
}
