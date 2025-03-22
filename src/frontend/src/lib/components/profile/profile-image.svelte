<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { getImageURL } from "$lib/utils/helpers";

    import type { ProfileDTO } from "../../../../../declarations/backend/backend.did";
    import LocalSpinner from "../shared/local-spinner.svelte";

    export let profile: ProfileDTO;
    let fileInput: HTMLInputElement;
    let uploadingImage = false;

    function clickFileInput() {
        fileInput.click();
    } 

    function handleFileChange(event: Event) {
        const input = event.target as HTMLInputElement;
        if (input.files && input.files[0]) {
            const file = input.files[0];
            if (file.size > 1000 * 1024) {
                toasts.addToast({ type: "error", message: "Profile image too large. The maximum size is 1MB." });
                console.error("Error updating profile image.");
                return;
            }
            uploadProfileImage(file);
        }
    }

    async function uploadProfileImage(file: File) {
        uploadingImage = true;

        try {
            await userStore.updateProfilePicture(file);
            await userStore.cacheProfile();
            await userStore.sync();
            toasts.addToast({
                message: "Profile image updated.",
                type: "success",
                duration: 2000,
            });
        } catch (error) {
            toasts.addToast({
                message: "Error updating profile image.",
                type: "error",
            });
            console.error("Error updating profile image", error);
        } finally {
            uploadingImage = false;
        }
    }
</script>

<div class="w-full">
    {#if uploadingImage}
        <div class="flex justify-center items-center h-64">
            <LocalSpinner />
        </div>
    {:else}
        <div class="relative group">
            <img 
                src={getImageURL(profile ? profile.profilePicture : "/profile_placeholder.png")} 
                alt="Profile" 
                class="relative w-full h-64 object-cover rounded-xl"
            />
            
            <div class="mt-4 flex justify-center">
                <button 
                    class="px-4 py-2 text-sm mini:text-base font-semibold text-white bg-BrandBlue rounded-lg hover:bg-opacity-80 transition-all duration-300"
                    on:click={clickFileInput}
                >
                    Upload Photo
                </button>
                <input
                    type="file"
                    id="profile-image"
                    accept="image/*"
                    bind:this={fileInput}
                    on:change={handleFileChange}
                    class="hidden"
                />
            </div>
        </div>
    {/if}
</div>