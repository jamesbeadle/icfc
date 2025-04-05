import { authStore } from "./auth-store";
import { ActorFactory } from "../utils/ActorFactory";
import { isError } from "../utils/helpers";
import { writable } from "svelte/store";
import { UserService } from "../services/user-service";
import { userIdCreatedStore } from "./user-control-store";
import { getProfileFromDB, setProfileToDB } from "$lib/utils/db.utils";
import type {
  ProfileDTO,
  CreateProfile,
  IsUsernameValid,
  UpdateUserName,
  UpdateDisplayName,
  UpdateFavouriteClub,
  UpdateProfilePicture,
  UpdateNationality,
  AddSubApp,
  SubApp,
} from "../../../../declarations/backend/backend.did";

function createUserStore() {
  const { subscribe, set } = writable<any>(null);

  async function sync() {
    let localProfile = await getProfileFromDB();
    if (localProfile) {
      set(localProfile);
      return;
    }
    try {
      await cacheProfile();
    } catch (error) {
      console.error("Error fetching user profile:", error);
      throw error;
    }
  }

  async function updateUsername(dto: UpdateUserName): Promise<any> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.updateUsername(dto);
      if (isError(result)) {
        console.error("Error updating username");
        return;
      }
      await cacheProfile();
      return result;
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }

  async function updateDisplayName(dto: UpdateDisplayName): Promise<any> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.updateDisplayName(dto);
      if (isError(result)) {
        console.error("Error updating display name");
        return;
      }
      await cacheProfile();
      return result;
    } catch (error) {
      console.error("Error updating display name:", error);
      throw error;
    }
  }

  async function updateFavouriteClub(dto: UpdateFavouriteClub): Promise<any> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.updateFavouriteClub(dto);
      if (isError(result)) {
        console.error("Error updating favourite club.");
        return;
      }
      await cacheProfile();
      return result;
    } catch (error) {
      console.error("Error updating favourite club:", error);
      throw error;
    }
  }

  async function updateNationality(dto: UpdateNationality): Promise<any> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.updateNationality(dto);
      if (isError(result)) {
        console.error("Error updating nationality.");
        return;
      }
      await cacheProfile();
      return result;
    } catch (error) {
      console.error("Error updating nationality:", error);
      throw error;
    }
  }

  async function updateProfilePicture(
    picture: File,
    principalId: string,
  ): Promise<any> {
    try {
      const maxPictureSize = 1000;
      if (picture.size > maxPictureSize * 1024) {
        return null;
      }
      const reader = new FileReader();
      const extension = getFileExtensionFromFile(picture);

      const profilePictureData = new Promise<Uint8Array>((resolve, reject) => {
        reader.onloadend = () => {
          const arrayBuffer = reader.result as ArrayBuffer;
          const uint8Array = new Uint8Array(arrayBuffer);
          resolve(uint8Array);
        };
        reader.onerror = reject;
        reader.readAsArrayBuffer(picture!);
      });

      const profilePicture = await profilePictureData;
      try {
        const identityActor = await ActorFactory.createIdentityActor(
          authStore,
          process.env.BACKEND_CANISTER_ID ?? "",
        );
        let dto: UpdateProfilePicture = {
          principalId: principalId,
          profilePicture: [profilePicture],
        };
        const result = await identityActor.updateProfilePicture(dto);
        if (isError(result)) {
          console.error("Error updating profile picture");
          return;
        }

        await cacheProfile();
        return result;
      } catch (error) {
        console.error(error);
      }
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }

  function getFileExtensionFromFile(file: File): string {
    const filename = file.name;
    const lastIndex = filename.lastIndexOf(".");
    return lastIndex !== -1 ? filename.substring(lastIndex + 1) : "";
  }

  async function isUsernameAvailable(username: string): Promise<boolean> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );
    let dto: IsUsernameValid = { username };
    return await identityActor.isUsernameValid(dto);
  }

  async function cacheProfile() {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.BACKEND_CANISTER_ID ?? "",
    );

    let getProfileResponse = await identityActor.getProfile();
    let error = isError(getProfileResponse);
    if (error) {
      console.error("Error fetching user profile");
      throw new Error("Failed to fetch user profile");
      return;
    }

    let profileData = getProfileResponse.ok;
    set(profileData);
    await setProfileToDB(profileData);
    userIdCreatedStore.set({ data: profileData.principalId, certified: true });
  }

  async function getProfile(): Promise<ProfileDTO | undefined> {
    return new UserService().getProfile();
  }

  async function createProfile(dto: CreateProfile): Promise<any> {
    return new UserService().createProfile(dto);
  }

  async function addSubApp(dto: AddSubApp): Promise<any> {
    return new UserService().addSubApp(dto);
  }

  async function removeSubApp(subApp: SubApp): Promise<any> {
    return new UserService().removeSubApp(subApp);
  }

  return {
    subscribe,
    set,
    sync,
    getProfile,
    updateUsername,
    updateDisplayName,
    updateFavouriteClub,
    updateNationality,
    updateProfilePicture,
    isUsernameAvailable,
    cacheProfile,
    createProfile,
    addSubApp,
    removeSubApp,
  };
}

export const userStore = createUserStore();
