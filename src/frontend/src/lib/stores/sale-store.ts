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

  async function claimICFCPackets(numberOfPackets: number): Promise<boolean> {
    return new SaleService().claimICFCPackets(numberOfPackets);
  }

  async function participateInSale(): Promise<any> {
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

        const { transfer } = IcrcLedgerCanister.create({
          agent,
          canisterId: Principal.fromText("ryjl3-tyaaa-aaaaa-aaaba-cai")
        });

        let principalId = identity.getPrincipal();

        if (principalId) {
          let subaccount: Uint8Array = principalToSubAccount(principalId);
          try {
            let _ = await transfer({
              to: {
                owner: Principal.fromText(
                  process.env.FOOTBALL_GOD_BACKEND_CANISTER_ID ?? "",
                ),
                subaccount: [subaccount],
              },
              fee: 100_000n,
              memo: new Uint8Array(Text.encodeValue("0")),
              from_subaccount: undefined,
              created_at_time: BigInt(Date.now()) * BigInt(1_000_000),
              amount: 9_999_900_000n,
            });

            const identityActor = await ActorFactory.createIdentityActor(
              authStore,
              process.env.BACKEND_CANISTER_ID ?? "",
            );
  
            const result = await identityActor.claimICFCPackets();
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
        console.error("Error saving Euro2024 prediction.", error);
        throw error;
      }
  }

  return {
    getProgress,
    getUserParticipation,
    getUsersICFCDistributions,
    claimICFCPackets,
    participateInSale
  };
}

export const saleStore = createSaleStore();
