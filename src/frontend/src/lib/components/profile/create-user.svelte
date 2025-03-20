<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { goto } from "$app/navigation";
    import type { CreateProfile } from "../../../../../declarations/backend/backend.did";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import Header from "../shared/header.svelte";
    import { toasts } from "$lib/stores/toasts-store";
  
    let isLoading = false;
    let username = "";
    let displayName = "";
    let isSubmitDisabled = true;
    let isCheckingUsername = false;
    let usernameError = "";
    let usernameAvailable = false;
  
    let usernameTimeout: NodeJS.Timeout;
  
    $: isSubmitDisabled = !username || !usernameAvailable;
  
    async function checkUsername() {
      if (username.length < 5) {
        usernameError = "Username must be at least 5 characters";
        usernameAvailable = false;
        return;
      }
      
      isCheckingUsername = true;
      try {
        const available = await userStore.isUsernameAvailable(username);
        usernameAvailable = available;
        usernameError = available ? "" : "Username is already taken";
      } catch (error) {
        console.error("Error checking username:", error);
        usernameError = "Error checking username availability";
      } finally {
        isCheckingUsername = false;
      }
    } 
    
    function handleUsernameInput() {
      clearTimeout(usernameTimeout);
      usernameAvailable = false;
      if (username.length >= 5) {
        usernameTimeout = setTimeout(checkUsername, 500);
      }
    } 
  
    async function createProfile() {
      isLoading = true;
      try {
        const dto: CreateProfile = {
          displayName: displayName,
          profilePicture: [],
          profilePictureExtension: [],
          username: username,
        };
        await userStore.createProfile(dto);
        await userStore.sync();
        toasts.addToast({type: 'success', message: 'Profile successfully created'})
        window.location.href = "/";
      } catch (error) {
        console.error("Error creating profile:", error);
      } finally {
        isLoading = false;
      }
    }
  </script>


{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="flex flex-col w-full h-full max-w-2xl mx-auto">
      <Header />
      <div class="flex-1 w-full mt-16 overflow-x-hidden">

        <div class="border-b border-white/10 mt-4">
            <div class="flex items-center justify-between">
                <h3 class="text-2xl text-white cta-text">Create Profile</h3>
            </div>
        </div>
        <div class="my-4">
            <h3 class="mb-2">Username</h3>
            <div class="mb-2 text-sm text-white/50">
                <p>Username requirements:</p>
                <ul class="ml-4 list-disc">
                    <li>Between 5-20 characters</li>
                    <li>Only letters & numbers allowed</li>
                </ul>
            </div>
            <input
              type="text"
              bind:value={username}
              on:input={handleUsernameInput}
              class="w-full p-2 text-white rounded-md bg-BrandGray"
              placeholder="Enter username"
            />
            {#if username.length > 0}
              <div class="mt-2 text-sm">
                  {#if isCheckingUsername}
                      <p class="text-BrandGrayShade3">Checking username availability...</p>
                  {:else if usernameError}
                      <p class="text-BrandRed">{usernameError}</p>
                  {:else if usernameAvailable}
                      <p class="text-BrandSuccess">Username is available!</p>
                  {/if}
              </div>
            {/if}
        </div>

        <div class="my-4">
            <h3 class="mb-2">Display Name</h3>
            <input
                type="text"
                bind:value={displayName}
                class="w-full p-2 text-white rounded-md bg-BrandGray"
                placeholder="Enter display name"
            />
        </div>

        <!-- //TODO: Add Nationality -->

        <!-- //TODO: Add Favourite League -->

        <!-- //TODO: Add Favourite Club Id -->

        <div class="flex justify-between">
            <button 
            class="brand-button"
            on:click={createProfile}
            disabled={isSubmitDisabled}
            >
            Create
            </button>
        </div>

      </div>
  </div>
{/if}