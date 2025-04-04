<script lang="ts">
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import Modal from "$lib/components/shared/modal.svelte";
    import EditIcon from "$lib/icons/EditIcon.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { isDisplayNameValid, isUsernameValid } from "$lib/utils/helpers";
    import type { PrincipalId, UpdateDisplayName, UpdateUserName, UpdateProfilePicture } from "../../../../../../declarations/backend/backend.did";

    export let visible: boolean = false;
    export let username: string;
    export let displayName: string;
    export let profileSrc: string;
    export let principalId: PrincipalId;

    let isLoading = false;
    let loadingMessage = ("");
    let newUsername = username;
    let newDisplayName = displayName;
    let isCheckingUsername = false;
    let usernameError = "";
    let displayNameError = "";
    let newProfilePic: File | null = null;
    let profilePicError = "";
    let previewUrl: string = profileSrc;
    let fileInput: HTMLInputElement;

    const validateDisplayName = async (): Promise<boolean> => {
        if (!isDisplayNameValid(newDisplayName)) {
            displayNameError = "Display name must be between 5 and 20 characters.";
            return false;
        }
        return true;
    };

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

    function clickFileInput() {
        fileInput.click();
    } 

    function handleFileChange(event: Event) {
        const input = event.target as HTMLInputElement;
        if (input.files && input.files[0]) {
            newProfilePic = input.files[0];
            if (newProfilePic.size > 1000 * 1024) {
                toasts.addToast({ 
                    type: "error", 
                    message: "Profile image too large. The maximum size is 1MB." 
                });
                newProfilePic = null;
                previewUrl = '/profile_placeholder.png';
                return;
            }
            previewUrl = URL.createObjectURL(newProfilePic);
        }
    }

    const handleSubmitUsername = async (e: Event) => {
        e.preventDefault();
        if (isUsernameSubmitDisabled) return;
        loadingMessage = "Updating Username";
        isLoading = true;
        try {
            let dto: UpdateUserName =  {
                username: newUsername,
                principalId
            }
            await userStore.updateUsername(dto);
            await userStore.cacheProfile();
            visible = false;
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
    const handleSubmitDisplayName = async (e: Event) => {
        e.preventDefault();
        if (isDisplayNameSubmitDisabled) return;
        loadingMessage = "Updating Display Name";
        isLoading = true;
        try {
            let dto: UpdateDisplayName =  {
                displayName: newDisplayName,
                principalId
            }
            await userStore.updateDisplayName(dto);
            await userStore.cacheProfile();
            visible = false;
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

    const handleSubmitProfilePicture = async (e: Event) => {
        e.preventDefault();
        if (!newProfilePic) return;
        loadingMessage = "Updating Profile Picture";
        isLoading = true;
        try {
            await userStore.updateProfilePicture(newProfilePic, principalId);
            await userStore.cacheProfile();
            
            visible = false;
            toasts.addToast({
                message: "Profile picture updated!",
                type: "success",
                duration: 4000,
            });
        } catch (error) {
            console.error("Error updating profile picture:", error);
            toasts.addToast({
                message: "Failed to update profile picture",
                type: "error",
            });
        } finally {
            isLoading = false;
        }
    };

    const cancelModal = () => {
        newUsername = username;
        newDisplayName = displayName;
        newProfilePic = null;
        visible = false;
    };
    
    function hasChanges(field: 'username' | 'displayName' | 'profilePic'): boolean {
        switch (field) {
            case 'username':
                return newUsername !== username;
            case 'displayName':
                return newDisplayName !== displayName;
            case 'profilePic':
                return newProfilePic !== null;
            default:
                return false;
        }
    }

    $: isUsernameSubmitDisabled = !newUsername || isCheckingUsername || !!usernameError || !hasChanges('username');
    $: isDisplayNameSubmitDisabled = !newDisplayName || !!displayNameError || !hasChanges('displayName');
    $: isProfilePicSubmitDisabled = !newProfilePic || !!profilePicError || !hasChanges('profilePic');

</script>

{#if visible}
    <Modal onClose={cancelModal} title="Update Required Details">
        {#if isLoading}
            <LocalSpinner message={loadingMessage} />
        {:else}
            <div class="flex flex-col p-4 space-y-6">
                <form on:submit|preventDefault={handleSubmitProfilePicture} class="space-y-4">
                    <div class="flex items-center space-x-4">
                        <div class="relative">
                            <img 
                                src={previewUrl} 
                                alt="Profile Preview" 
                                class="object-cover w-16 h-16 border-2 rounded-full border-BrandBlue"
                            />
                            <label class="absolute p-1 rounded-full cursor-pointer -bottom-2 -right-2 bg-BrandBlue">
                                <input 
                                    type="file"
                                    bind:this={fileInput}
                                    class="hidden"
                                    accept="image/*"
                                    on:change={handleFileChange}
                                />
                                <EditIcon className="w-5 h-5 ml-2 mt-1" fill="white" />
                            </label>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm text-BrandGrayShade3">
                                Supported formats: JPG, JPEG, PNG
                                <br>
                                Max size: 1MB
                            </p>
                            {#if profilePicError}
                                <p class="mt-1 text-sm text-BrandRed">{profilePicError}</p>
                            {/if}
                        </div>
                    </div>
                    <button
                        class="w-full brand-button"
                        disabled={isProfilePicSubmitDisabled}
                    >
                        Update Profile Picture
                    </button>
                </form>

                <form on:submit|preventDefault={handleSubmitUsername} class="space-y-2">
                    <label class="block text-sm font-medium text-BrandGrayShade3">
                        Username
                        <input
                            type="text"
                            bind:value={newUsername}
                            class="w-full mt-1 brand-input"
                            placeholder="Enter new username"
                            on:input={validateUsername}
                        />
                    </label>
                    {#if usernameError}
                        <p class="text-sm text-BrandRed">{usernameError}</p>
                    {/if}
                    {#if isCheckingUsername}
                        <p class="text-sm text-BrandGrayShade3">Checking availability...</p>
                    {/if}
                    <button
                        class="w-full brand-button"
                        disabled={isUsernameSubmitDisabled}
                    >
                        Update Username
                    </button>
                </form>

                <form on:submit|preventDefault={handleSubmitDisplayName} class="space-y-2">
                    <label class="block text-sm font-medium text-BrandGrayShade3">
                        Display Name
                        <input
                            type="text"
                            bind:value={newDisplayName}
                            on:input={validateDisplayName}
                            class="w-full mt-1 brand-input"
                            placeholder="Enter new display name"
                        />
                    </label>
                    {#if displayNameError}
                        <p class="text-sm text-BrandRed">{displayNameError}</p>
                    {/if}
                    <button
                        class="w-full brand-button"
                        disabled={isDisplayNameSubmitDisabled}
                    >
                        Update Display Name
                    </button>
                </form>
            </div>
        {/if}
    </Modal>
{/if}