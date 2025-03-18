import { authStore } from "./auth-store";
import { ActorFactory } from "../utils/ActorFactory";
import { isError } from "../utils/helpers";
import { writable } from "svelte/store";
import { UserService } from "../services/user-service";
import type { Profile, CreateProfile } from "../../../../declarations/backend/backend.did";

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

  async function updateUsername(username: string): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.updateDisplayName(username);
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

  async function agreeTerms(): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.agreeTerms();
      if (isError(result)) {
        console.error("Error agreeing terms");
        return;
      }

      await cacheProfile();
      return result;
    } catch (error) {
      console.error(error);
      console.error("Error agreeing terms:", error);
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
    return await identityActor.isUsernameValid(username);
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
  }

  async function getProfile(): Promise<Profile | null> {
    return new UserService().getProfile();
  }

  async function createProfile(dto: CreateProfile): Promise<any> {
    return new UserService().createProfile(dto);
  }

  return {
    subscribe,
    sync,
    getProfile,
    agreeTerms,
    updateUsername,
    updateProfilePicture,
    isUsernameAvailable,
    cacheProfile,
    createProfile,
  };
}

export const userStore = createUserStore();
