import { userStore } from "$lib/stores/user-store";
import { toasts } from "$lib/stores/toasts-store";
import { userIdCreatedStore, restrictedSaleStore } from "$lib/stores/user-control-store";
import { initErrorSignOut } from "./auth.services";
import type { OptionIdentity } from "$lib/types/identity";
import type { ProfileDTO } from "../../../../declarations/backend/backend.did";
import { get } from "svelte/store";

export type InitUserProfileResult = { 
  result: "has-profile" | "no-profile" | "unauthenitcated" | "error";
  profile?: ProfileDTO; 
  requiresAction?: "create-profile" | "temp-access" | "continue-creation";
};

export const initUserProfile = async ({
  identity,
  context = "default",
  allowAunthenticated = false
}: {
  identity: OptionIdentity;
  context?: "default" | "create-profile" | "sale-access";
  allowAunthenticated?: boolean;
}): Promise<InitUserProfileResult> => {
  if (!identity) return allowAunthenticated 
    ? { result: "unauthenitcated" } 
    : { result: "error", requiresAction: "create-profile" };

  try {
    const profile = await userStore.getProfile();

    console.log("profile when doing initUserProfile", profile);
    if (profile) {
      userIdCreatedStore.set({ data: profile.principalId, certified: true });
      return { result: "has-profile", profile };
    }

    /* 
    const saleProfile = await saleStore.getSaleProfile();
    if (saleProfile) {
      restrictedSaleStore.set({
        data: saleProfile.principalId,
        certified: true
      });
      return { result: "has-profile", requiresAction: "temp-access" };
    } */
    if (context === "create-profile") {
      return { result: "no-profile", requiresAction: "continue-creation" };
    }

    if (context === "sale-access" && get(restrictedSaleStore)?.data) {
      return { result: "no-profile", requiresAction: "temp-access" };
    }

    return { result: "no-profile", requiresAction: "create-profile" };

  } catch (err) {
    toasts.addToast({
      message: "Error initializing user profile",
      type: "error",
    });
    console.error("initUserProfile error", err);
    await initErrorSignOut();
    return { result: "error", requiresAction: "create-profile" };
  }
};
