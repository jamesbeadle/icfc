<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { toasts } from "$lib/stores/toasts-store";
    import { goto } from "$app/navigation";
    import type { CreateProfile } from "../../../../../declarations/backend/backend.did";
    
    import LocalSpinner from "../shared/local-spinner.svelte";
    import CloseIcon from "$lib/icons/CloseIcon.svelte";
    import Layout from "../../../routes/Layout.svelte";
  
    let isLoading = false;
    let username = "";
    let displayName = "";
    let isSubmitDisabled = true;
    let isCheckingUsername = false;
    let usernameError = "";
    let usernameAvailable = false;
  
    let usernameTimeout: NodeJS.Timeout;
  
    $: isSubmitDisabled = !username || !displayName;
  
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
        goto("/profile");
      } catch (error) {
        console.error("Error creating profile:", error);
      } finally {
        isLoading = false;
      }
    }
  </script>


<Layout>
  {#if isLoading}
            <LocalSpinner />
            <p class="pb-4 mb-4 text-center">Creating new profile...</p>
        {:else}
            <div class="flex flex-col w-full h-full max-w-2xl mx-auto">
                <div class="p-2 border-b border-white/10">
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
                            <li>Only letters, numbers, and spaces allowed</li>
                        </ul>
                    </div>
                    <input
                        type="text"
                        bind:value={username}
                        class="w-full p-2 text-white rounded-md bg-BrandGray"
                        placeholder="Enter username"
                    />
                    <!-- {#if username.length > 0}
                    <div class="mt-2 text-sm">
                        {#if isCheckingUsername}
                            <p class="text-BrandLightGray">Checking username availability...</p>
                        {:else if usernameError}
                            <p class="text-BrandRed">{usernameError}</p>
                        {:else if usernameAvailable}
                            <p class="text-BrandGreen">Username is available!</p>
                        {/if}
                    </div>
                    {/if} -->
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

                <div class="flex justify-between">
                    <button 
                    class="px-6 py-2 text-white rounded-md hover:bg-BrandPurple/80 bg-BrandPurple disabled:bg-gray-500"
                    on:click={createProfile}
                    disabled={isSubmitDisabled}
                    >
                    Save
                    </button>
                </div>
            </div>
        {/if}
</Layout>