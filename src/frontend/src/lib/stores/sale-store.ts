import { writable } from "svelte/store";
import { SaleService } from "../services/sale-service";
import type { SaleProgressDTO, UserParticipationDTO, ICFCDistribution } from "../../../../declarations/icfc_sale_2/icfc_sale_2.did";

function createSaleStore() {

  async function getProgress(): Promise<SaleProgressDTO | undefined> {
    return new SaleService().getProgress();
  }

  async function getUserParticipation(): Promise<UserParticipationDTO | undefined> {
    return new SaleService().getUserParticipation();
  }

  async function getUsersICFCDistributions(): Promise<ICFCDistribution[] | undefined> {
    return new SaleService().getUsersICFCDistributions();
  }

  async function claimICFCPackets(numberOfPackets: number): Promise<boolean> {
    return new SaleService().claimICFCPackets(numberOfPackets);
  }

  return {
    getProgress,
    getUserParticipation,
    getUsersICFCDistributions,
    claimICFCPackets,
  };
}

export const saleStore = createSaleStore();
