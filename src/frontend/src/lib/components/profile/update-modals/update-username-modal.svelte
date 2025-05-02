<script lang="ts">
    import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
    import Modal from "$lib/components/shared/global/modal.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { isUsernameValid } from "$lib/utils/helpers";
    import type { UpdateUserName } from "../../../../../../declarations/backend/backend.did";

    interface Props {
        username: string;
        onClose: () => void;
    }

    let { username, onClose } : Props = $props();

    let isLoading = $state(false);
    let newUsername = $state(username);
    let isCheckingUsername = $state(false);
    let usernameError = $state("");
    let isSubmitDisabled = $state(true);
    
    $effect(() => {
        isSubmitDisabled = !newUsername || isCheckingUsername || !!usernameError;
    });
    
    const validateUsername = async (): Promise<boolean> => {
        if (!isUsernameValid(newUsername)) {
            usernameError = "Username must be between 5 and 20 characters.";
            return false;
        }

        try {
            isCheckingUsername = true;
            const isAvailable = await userStore.isUsernameAvailable(newUsername);
            usernameError = isAvailable ? "" : "Username is already taken";
            return isAvailable;
        } catch (error) {
            console.error("Error checking username:", error);
            usernameError = "Error checking username availability";
            return false;
        } finally {
            isCheckingUsername = false;
        }
    };

    const handleSubmit = async (e: Event) => {
        e.preventDefault();
        if (isSubmitDisabled) return;

        isLoading = true;
        try {
            let dto: UpdateUserName =  {
                username: newUsername
            }
            await userStore.updateUsername(dto);
            await userStore.sync();
            onClose();
            toasts.addToast({
                message: "Username updated.",
                type: "success",
                duration: 2000,
            });
        } catch (error) {
            console.error("Error updating username:", error);
            toasts.addToast({
                message: "Error updating username.",
                type: "error",
            });
        } finally {
            isLoading = false;
        }
    };

    const cancelModal = () => {
        newUsername = username;
        onClose();
    };
</script>

<Modal title="Update Username" onClose={cancelModal}>
        {#if isLoading}
            <LocalSpinner message="Loading" />
        {:else}
            <div class="flex flex-col space-y-6">
                <div>
                    <div class="mt-4">
                        <input
                            type="text"
                            class="w-full px-4 py-2 text-black border rounded-md focus:outline-none focus:ring-2 focus:ring-BrandBlue"
                            placeholder="New Username"
                            bind:value={newUsername}
                            oninput={validateUsername}
                            disabled={isCheckingUsername}
                        />
                        {#if usernameError}
                            <p class="mt-1 text-sm text-red-500">{usernameError}</p>
                        {/if}
                    </div>
                    <div class="flex flex-row items-center py-3 space-x-4">
                        <button
                            class="px-4 py-2 default-button fpl-cancel-btn"
                            type="button"
                            onclick={cancelModal}
                            disabled={isLoading}
                        >
                            Cancel
                        </button>
                        <button
                            class="px-4 py-2 default-button"
                            class:bg-BrandGrayShade3={isSubmitDisabled}
                            class:bg-BrandPurple={!isSubmitDisabled}
                            disabled={isSubmitDisabled}
                            onclick={handleSubmit}
                        >
                            Update
                        </button>
                    </div>
                </div>
            </div>
        {/if}
</Modal>