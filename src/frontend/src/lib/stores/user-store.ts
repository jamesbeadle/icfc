import { authStore } from "./auth-store";
import { ActorFactory } from "../utils/ActorFactory";
import { isError } from "../utils/helpers";
import { writable } from "svelte/store";
import { UserService } from "../services/user-service";
import { userIdCreatedStore } from "./user-control-store";
import type {
  ProfileDTO,
  CreateProfile,
  IsUsernameValid,
  UpdateUserName,
  UpdateDisplayName,
  UpdateFavouriteClub,
  UpdateNationality,
} from "../../../../declarations/backend/backend.did";

function createUserStore() {
  const { subscribe, set } = writable<any>(null);

  async function sync() {
    let localStorageString = localStorage.getItem("user_profile_data");
    if (localStorageString) {
      const localProfile = JSON.parse(localStorageString);
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
      const identityActor = await ActorFactory.createIdentityActor(
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
      const identityActor = await ActorFactory.createIdentityActor(
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
      const identityActor = await ActorFactory.createIdentityActor(
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
      const identityActor = await ActorFactory.createIdentityActor(
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

  async function updateProfilePicture(picture: File): Promise<any> {
    try {
      const maxPictureSize = 1000;
      const extension = getFileExtensionFromFile(picture);

      if (picture.size > maxPictureSize * 1024) {
        return null;
      }
      const reader = new FileReader();
      reader.readAsArrayBuffer(picture);
      reader.onloadend = async () => {
        const arrayBuffer = reader.result as ArrayBuffer;
        const uint8Array = new Uint8Array(arrayBuffer);
        try {
          const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            process.env.BACKEND_CANISTER_ID ?? "",
          );
          const result = await identityActor.updateProfilePicture(
            uint8Array,
            extension,
          );
          if (isError(result)) {
            console.error("Error updating profile picture");
            return;
          }

          await cacheProfile();
          return result;
        } catch (error) {
          console.error(error);
        }
      };
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
      return;
    }

    let profileData = getProfileResponse.ok;
    set(profileData);

    userIdCreatedStore.set({ data: profileData.principal, certified: true});
  }

  async function getProfile(): Promise<ProfileDTO | undefined> {
    return new UserService().getProfile();
  }

  async function createProfile(dto: CreateProfile): Promise<any> {
    return new UserService().createProfile(dto);
  }

  return {
    subscribe,
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
  };
}

export const userStore = createUserStore();
