<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";

    interface Props {
        file: File | null
    }

    let { file } : Props = $props();

    let fileInput: HTMLInputElement;
    let profileSrc = '/profile_placeholder.png';

    function clickFileInput() {
        fileInput.click();
    } 

    function handleFileChange(event: Event) {
        const input = event.target as HTMLInputElement;
        if (input.files && input.files[0]) {
            file = input.files[0];
            if (file.size > 1000 * 1024) {
                toasts.addToast({ 
                    type: "error", 
                    message: "Profile image too large. The maximum size is 1MB." 
                });
                file = null;
                profileSrc = '/profile_placeholder.png';
                return;
            }
            toasts.addToast({ 
                    type: "success", 
                    message: "Profile image uploaded successfully." 
                });
            profileSrc = URL.createObjectURL(file);
        }
    }

</script>

<div class="flex flex-col space-y-4">
    <p class="form-title">Profile Picture <span class="text-xs text-BrandGrayShade3">(Optional)</span></p>
    <p class="form-hint">Max size 1mb</p>
    
    <div class="relative w-full overflow-hidden rounded-lg aspect-square">
        <img 
            src={profileSrc} 
            alt="Profile" 
            class="absolute object-cover w-full h-full"
        />
    </div>
    
    <button 
        class="w-full mt-auto brand-button"
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