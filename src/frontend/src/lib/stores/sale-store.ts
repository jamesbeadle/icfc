import { writable } from "svelte/store";
import { SaleService } from "../services/sale-service";
import type {
  SaleGoalDTO,
  SaleCountDownDTO,
} from "../../../../declarations/backend/backend.did";

function createSaleStore() {
  const { subscribe } = writable<{
    goal: SaleGoalDTO | null;
    countdown: SaleCountDownDTO | null;
    userBalance: bigint | null;
  }>({
    goal: null,
    countdown: null,
    userBalance: null,
  });

  function convertToCkBTC(value: bigint): bigint {
    return value / BigInt(10 ** 8);
  }

  async function getGoal() {
    const goal = await new SaleService().getGoal();
    goal.currentProgress = convertToCkBTC(BigInt(goal.currentProgress));
    goal.maxGoal = convertToCkBTC(BigInt(goal.maxGoal));
    goal.minGoal = convertToCkBTC(BigInt(goal.minGoal));
    return goal;
  }

  async function getSaleCountdown() {
    return new SaleService().getSaleCountdown();
  }

  async function getUserBalance() {
    return new SaleService().getUserBalance();
  }

  async function particpate(amount: bigint) {
    let satoshiAmount = amount * BigInt(10 ** 8);
    return new SaleService().particpate(satoshiAmount);
  }

  return {
    subscribe,
    getGoal,
    getSaleCountdown,
    getUserBalance,
    particpate,
  };
}

export const saleStore = createSaleStore();
