import { ActorFactory } from "$lib/utils/ActorFactory";
import { isError } from "$lib/utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import { toasts } from "$lib/stores/toasts-store";
import type { Profile, CreateProfile } from "../../../../declarations/backend/backend.did";

//TODO: CHANGE TO PROFILEDTO when backend is updated
export class UserService {
    constructor() {}

    async createProfile(dto: CreateProfile): Promise<any> {
        try {
          const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            process.env.BACKEND_CANISTER_ID ?? "",
          );
          const result = await identityActor.createProfile(dto);
          return result;
        } catch (error) {
            toasts.addToast({
                message: "Failed to create profile",
                type: "error",
            });
          throw error;
        }
    }

    async getProfile(): Promise<Profile> {
        try {
            const identityActor = await ActorFactory.createIdentityActor(
                authStore,
                process.env.BACKEND_CANISTER_ID ?? "",
            );
    
            const result: any = await identityActor.getProfile();
            if (isError(result)) throw new Error("Failed to get profile");
            return result.ok;
        } catch (error) {
            toasts.addToast({
                message: "Failed to get profile",
                type: "error",
            });
            throw error;
        }
    }
}


