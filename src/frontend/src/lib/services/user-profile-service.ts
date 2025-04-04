import { userStore } from "$lib/stores/user-store";
import { toasts } from "$lib/stores/toasts-store";
import { userIdCreatedStore } from "$lib/stores/user-control-store";
import { initErrorSignOut } from "./auth.services";
import type { OptionIdentity } from "$lib/types/identity";

export type InitUserProfileResult = { result: "skip" | "success" | "error" };

export const initUserProfile = async ({
  identity,
}: {
  identity: OptionIdentity;
}): Promise<InitUserProfileResult> => {
  if (!identity) return { result: "skip" };

  try {
    const profile = await userStore.getProfile();
    console.log("profile when doing initUserProfile", profile);
    if (profile) {
      userIdCreatedStore.set({ data: profile.principalId, certified: true });
      return { result: "success" };
    }
    return { result: "skip" };
  } catch (err) {
    toasts.addToast({
      message: "Error initializing user profile",
      type: "error",
    });
    console.error("initUserProfile error", err);
    await initErrorSignOut();
    return { result: "error" };
  }
};
