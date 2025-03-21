<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import Modal from "$lib/components/shared/modal.svelte";
    import LocalSpinner from "../shared/local-spinner.svelte";
  
    export let visible: boolean = false;
    export let newUsername: string = "";
  
    let isLoading = false;
  
    function isDisplayNameValid(displayName: string): boolean {
      if (!displayName) {
        return false;
      }
  
      if (displayName.length < 3 || displayName.length > 20) {
        return false;
      }
  
      return /^[a-zA-Z0-9 ]+$/.test(displayName);
    }
  
    $: isSubmitDisabled = !isDisplayNameValid(newUsername);
  
    async function updateUsername() {
      isLoading=true;
      try {
        await userStore.updateUsername(newUsername);
        await userStore.sync();
        await closeModal();
        toasts.addToast({
          message: "Username updated.",
          type: "success",
          duration: 2000,
        });
      } catch (error) {
        toasts.addToast({
          message:  "Error updating username.",
          type: "error",
        });
        console.error("Error updating username:", error);
        cancelModal();
      } finally {
        isLoading = false;
      }
    }
  
    async function closeModal() {
      await userStore.cacheProfile();
      visible = false;
    }
  
    function cancelModal() {
      visible = false;
    }
    
  </script>
  
{#if visible}
    <Modal onClose={cancelModal}>
    {#if isLoading}
        <LocalSpinner />
    {:else}
    <div class="flex flex-col space-y-6">

      <h2 class="text-2xl text-white cta-text">Update Username</h2>
        <form on:submit|preventDefault={updateUsername}>
          <div class="mt-4">
              <input
              type="text"
              class="w-full px-4 py-2 text-black border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="New Username"
              bind:value={newUsername}
              />
          </div>
          <div class="flex flex-row items-center py-3 space-x-4">
              <button
              class="px-4 py-2 default-button fpl-cancel-btn"
              type="button"
              on:click={cancelModal}
              >
              Cancel
              </button>
              <button
              class={`px-4 py-2 ${
                  isSubmitDisabled ? "bg-gray-500" : "bg-BrandPurple"
              } default-button bg-BrandPurple`}
              type="submit"
              disabled={isSubmitDisabled}
              >
              Update
              </button>
          </div>
        </form>
    

    </div>
    {/if}
    </Modal>
{/if}