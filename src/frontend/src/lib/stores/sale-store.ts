import { SaleService } from "../services/sale-service";
import type {
  ICFCDistribution,
  SaleProgress,
  UserParticipation,
} from "../../../../declarations/icfc_sale_2/icfc_sale_2.did";
import { ActorFactory } from "$lib/utils/ActorFactory";
import { authStore } from "./auth-store";
import { IcrcLedgerCanister } from "@dfinity/ledger-icrc";
import { Principal } from "@dfinity/principal";
import type { OptionIdentity } from "$lib/types/identity";
import { createAgent, principalToSubAccount } from "@dfinity/utils";
import { Text } from "@dfinity/candid/lib/cjs/idl";
import { isError } from "$lib/utils/helpers";

function createSaleStore() {
  async function getProgress(): Promise<SaleProgress | undefined> {
    return new SaleService().getProgress();
  }

  async function getUserParticipation(): Promise<
    UserParticipation | undefined
  > {
    return new SaleService().getUserParticipation();
  }

  async function getUsersICFCDistributions(): Promise<
    ICFCDistribution[] | undefined
  > {
    return new SaleService().getUsersICFCDistributions();
  }

  async function claimICFCPacks(): Promise<boolean> {
    let identity: OptionIdentity;

    authStore.subscribe(async (auth) => {
      identity = auth.identity;
    });

    if (!identity) {
      return false;
    }
    let subaccount: Uint8Array = principalToSubAccount(identity.getPrincipal());
    console.log("subaccount", subaccount);
    return new SaleService().claimICFCPacks();
  }

  async function participateInSale(amount: number): Promise<any> {
    try {
      let amounte8s = BigInt(amount) * BigInt(1_00_000_000);
      let tranferFee = BigInt(10_000);
      let identity: OptionIdentity;

      authStore.subscribe(async (auth) => {
        identity = auth.identity;
      });

      if (!identity) {
        return;
      }

      const agent = await createAgent({
        identity: identity,
        host: import.meta.env.VITE_AUTH_PROVIDER_URL,
        fetchRootKey: process.env.DFX_NETWORK === "local",
      });

      const { transfer } = IcrcLedgerCanister.create({
        agent,
        canisterId: Principal.fromText("ryjl3-tyaaa-aaaaa-aaaba-cai"),
      });

      let principalId = identity.getPrincipal();

      if (principalId) {
        let subaccount: Uint8Array = principalToSubAccount(principalId);
        try {
          let _ = await transfer({
            to: {
              owner: Principal.fromText(process.env.BACKEND_CANISTER_ID ?? ""),
              subaccount: [subaccount],
            },
            fee: tranferFee,
            memo: new Uint8Array(Text.encodeValue("0")),
            from_subaccount: undefined,
            created_at_time: BigInt(Date.now()) * BigInt(1_000_000),
            amount: amounte8s - tranferFee,
          });

          const identityActor = await ActorFactory.createSaleActor(
            authStore,
            process.env.ICFC_SALE_2_CANISTER_ID ?? "",
          );

          const result = await identityActor.purchaseICFCPacks();
          if (isError(result)) {
            console.error("Error participating in ICFC sale.");
            return;
          }
          return result;
        } catch (err: any) {
          console.error(err.errorType);
        }
      }
    } catch (error) {
      console.error("Error participating in ICFC sale.", error);
      throw error;
    }
  }
  async function getUserBalance(): Promise<bigint | undefined> {
    try {
      let identity: OptionIdentity;
      authStore.subscribe(async (auth) => {
        identity = auth.identity;
      });

      if (!identity) {
        return;
      }

      const agent = await createAgent({
        identity: identity,
        host: import.meta.env.VITE_AUTH_PROVIDER_URL,
        fetchRootKey: process.env.DFX_NETWORK === "local",
      });

      const { balance } = IcrcLedgerCanister.create({
        agent,
        canisterId: Principal.fromText("ryjl3-tyaaa-aaaaa-aaaba-cai"),
      });

      let principalId = identity.getPrincipal();

      if (principalId) {
        try {
          let res = await balance({
            owner: principalId,
            subaccount: undefined,
          });
          console.log(res);
          if (isError(res)) {
            console.error("Error getting balance.");
            return;
          }
          let icp_balance = res / BigInt(1_00_000_000);
          return icp_balance;
        } catch (err: any) {
          console.error(err.errorType);
        }
      }
    } catch (error) {
      console.error("Error getting user balance.", error);
      throw error;
    }
  }

  return {
    getProgress,
    getUserParticipation,
    getUserBalance,
    getUsersICFCDistributions,
    claimICFCPacks,
    participateInSale,
  };
}

export const saleStore = createSaleStore();
