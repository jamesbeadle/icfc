import { ActorFactory } from "$lib/utils/ActorFactory";
import { isError } from "$lib/utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import type {
  SaleProgressDTO,
  UserParticipationDTO,
  ICFCDistribution,
} from "../../../../declarations/icfc_sale_2/icfc_sale_2.did";

export class SaleService {
  constructor() {}

  async getProgress(): Promise<SaleProgressDTO | undefined> {
    try {
      const identityActor: any =
        await ActorFactory.createSaleCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_ICFC_SALE_2 ?? "",
        );
      const result = await identityActor.getProgress();
      if (isError(result)) {
        throw new Error("Failed to get progress");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching progress:", error);
      throw error;
    }
  }

  async getUserParticipation(): Promise<UserParticipationDTO | undefined> {
    try {
      const identityActor: any =
        await ActorFactory.createSaleCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_ICFC_SALE_2 ?? "",
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
      const identityActor: any =
        await ActorFactory.createSaleCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_ICFC_SALE_2 ?? "",
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

  async claimICFCPackets(numberOfPackets: number): Promise<boolean> {
    try {
      const identityActor: any =
        await ActorFactory.createSaleCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_ICFC_SALE_2 ?? "",
        );
      const result = await identityActor.claimICFCPackets({
        packets: numberOfPackets,
      });
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
