<script lang="ts">
    import CopyIcon from "$lib/icons/CopyIcon.svelte";
    import { authStore } from "$lib/stores/auth-store";
    import { toasts } from "$lib/stores/toasts-store";

        async function copyTextAndShowToast(text: string) {
            try {
                await navigator.clipboard.writeText(text);
                toasts.addToast({
                type: "success",
                message: "Copied to clipboard.",
                duration: 2000,
                });
            } catch (err) {
                console.error("Failed to copy:", err);
            }
        }
</script>

<div class="relative flex items-center p-4 rounded-lg bg-BrandGrayShade2">
    <button 
        on:click={() => { copyTextAndShowToast($authStore.identity?.getPrincipal().toString() ?? "") }}
        class="absolute text-white right-2"
    >
        <CopyIcon className="w-5 h-5" fill='#FFFFFF' />
    </button>
    <p class="px-4 font-mono text-sm text-white break-all">
        {$authStore.identity?.getPrincipal().toString() ?? "Not available"}
    </p>
</div>