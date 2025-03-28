<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";

    export let file: File | null = null;

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
            profileSrc = URL.createObjectURL(file);
        }
    }

</script>

<div class="flex flex-col h-full space-y-4">
    <p class="form-title">Profile Picture</p>
    <p class="form-hint">Max size 1mb</p>
    
    <div class="relative w-full overflow-hidden rounded-lg aspect-square bg-BrandGrayShade3">
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