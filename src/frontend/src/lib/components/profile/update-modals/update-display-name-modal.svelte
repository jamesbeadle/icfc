<script lang="ts">
    import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
    import Modal from "$lib/components/shared/global/modal.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { isDisplayNameValid } from "$lib/utils/helpers";
    import type { PrincipalId, UpdateDisplayName } from "../../../../../../declarations/backend/backend.did";

    interface Props {
        displayName: string;
        onClose: () => void;
    }

    let { displayName, onClose } : Props = $props();

    let newDisplayName = $state(displayName);
    let isLoading = $state(false);
    let displayNameError = $state("");
    let isSubmitDisabled = $state(false);

    $effect(() => {
        isSubmitDisabled = !newDisplayName || !!displayNameError;
    });

    const validateDisplayName = async (): Promise<boolean> => {
        if (!isDisplayNameValid(newDisplayName)) {
            displayNameError = "Display name must be between 5 and 20 characters.";
            return false;
        }
        return true;
    };

    const handleSubmit = async (e: Event) => {
        e.preventDefault();
        if (isSubmitDisabled) return;

        isLoading = true;
        try {
            let dto: UpdateDisplayName =  {
                displayName: newDisplayName
            }
            await userStore.updateDisplayName(dto);
            await userStore.sync();
            onClose();
            toasts.addToast({
                message: "Display name updated.",
                type: "success",
                duration: 2000,
            });
        } catch (error) {
            console.error("Error updating display name:", error);
            toasts.addToast({
                message: "Error updating display name.",
                type: "error",
            });
        } finally {
            isLoading = false;
        }
    };

    const cancelModal = () => {
        newDisplayName = displayName;
    };
</script>

<Modal title="Update Display Name" onClose={cancelModal}>
    {#if isLoading}
        <LocalSpinner message="Updateing Display Name" />
    {:else}
        <div class="flex flex-col space-y-6">
            <div>
                <div class="mt-4">
                    <input
                        type="text"
                        class="w-full px-4 py-2 text-black border rounded-md focus:outline-none focus:ring-2 focus:ring-BrandBlue"
                        placeholder="New Display Name"
                        bind:value={newDisplayName}
                        oninput={validateDisplayName}
                    />
                    {#if displayNameError}
                        <p class="mt-1 text-sm text-red-500">{displayNameError}</p>
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
                        onclick={handleSubmit}
                        disabled={isSubmitDisabled}
                    >
                        Update
                    </button>
                </div>
            </div>
        </div>
    {/if}
</Modal>