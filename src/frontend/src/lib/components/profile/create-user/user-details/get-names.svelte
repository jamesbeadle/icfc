<script lang="ts">
    import { isUsernameValid } from "$lib/utils/helpers";
    import { userStore } from "$lib/stores/user-store";
    
    export let username: string;
    export let displayName: string;
    export let store: typeof userStore;

    let isCheckingUsername = false;
    let usernameError = "";
    let usernameAvailable = false;
    let usernameTimeout: NodeJS.Timeout;

    async function checkUsername() {
        isCheckingUsername = true;
        try {
            if(!isUsernameValid(username)){
                usernameError = "Username must be between 5 and 20 characters.";
            }
            const available = await store.isUsernameAvailable(username);
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
</script>

<div class="grid grid-cols-1 gap-6 md:grid-cols-2">
    <div class="space-y-5">
        <p class="form-title">Username</p>
        <p class="form-hint">
            5-20 characters, letters & numbers only. 
        </p>
        <input
            type="text"
            bind:value={username}
            on:input={handleUsernameInput}
            class="w-full brand-input"
            placeholder="Enter username"
        />
        {#if username.length > 0}
            <div class="mt-1 text-sm">
                {#if isCheckingUsername}
                    <p class="text-BrandGrayShade2">Checking availability...</p>
                {:else if usernameError}
                    <p class="text-BrandRed">{usernameError}</p>
                {:else if usernameAvailable}
                    <p class="text-BrandSuccess">Username available</p>
                {/if}
            </div>
        {/if}
    </div>
    
    <div class="space-y-5">
        <p class="form-title">Display Name</p>
        <p class="form-hint ">
            5-20 characters, letters & numbers only
        </p>
        <input
            type="text"
            bind:value={displayName}
            placeholder="Enter display name"
            class="w-full brand-input"
        />
    </div>
</div>