import { ActorFactory } from "$lib/utils/ActorFactory";
import { isError } from "$lib/utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import { toasts } from "$lib/stores/toasts-store";
import type { UserNeuronsDTO, MembershipClaim } from "../../../../declarations/backend/backend.did";

export class MembershipService {
    constructor() {}

    async getUserNeurons(): Promise<UserNeuronsDTO | undefined> {
        try{
            const identityActor: any = await ActorFactory.createIdentityActor(
                authStore,
                process.env.BACKEND_CANISTER_ID ?? "",
            );

            const result = await identityActor.getUserNeurons();

            if(isError(result)){
            throw new Error("Failed to get user neurons");
            }

            return result.ok;
        } catch (error) {
            toasts.addToast({
                message: "Failed to get user neurons",
                type: "error",
            });
            throw error;
        }
    }

    async claimMembership(): Promise<MembershipClaim | undefined> {
        try{
            const identityActor: any = await ActorFactory.createIdentityActor(
                authStore,
                process.env.BACKEND_CANISTER_ID ?? "",
            );

            const result = await identityActor.claimMembership();

            if(isError(result)){
                console.error("Failed to claim membership", result);
            throw new Error("Failed to claim membership");
            }

            return result.ok;
        } catch (error) {
            toasts.addToast({
                message: "Failed to claim membership",
                type: "error",
            });
            console.error("Failed to claim membership", error);
            throw error;
        }
    }
    
}