import { ActorFactory } from "$lib/utils/ActorFactory";
import { isError } from "$lib/utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import type {
  ProfileDTO,
  CreateProfile,
  AddSubApp,
  SubApp,
} from "../../../../declarations/backend/backend.did";

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
      console.error("Error creating profile: ", error);
      throw error;
    }
  }

  async getProfile(): Promise<ProfileDTO | undefined> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );

      const result: any = await identityActor.getProfile();
      if (isError(result)) return undefined;
      return result.ok;
    } catch (error) {
      console.error("Error fetching user profile: ", error);
      return undefined;
    }
  }

  async addSubApp(dto: AddSubApp): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );

      const result: any = await identityActor.addSubApp(dto);
      if (isError(result)) throw new Error("Failed to add sub app.");
      return result.ok;
    } catch (error) {
      console.error("Error adding sub app: ", error);
      throw error;
    }
  }

  async removeSubApp(subApp: SubApp): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );

      const result: any = await identityActor.removeSubApp(subApp);
      if (isError(result)) throw new Error("Failed to remove sub app.");
      return result.ok;
    } catch (error) {
      console.error("Error removing sub app: ", error);
      throw error;
    }
  }
}
