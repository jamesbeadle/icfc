<script lang="ts">
    import Modal from "$lib/components/shared/modal.svelte";
    import CloseIcon from "$lib/icons/CloseIcon.svelte";

    export let isOpen: boolean;
    export let onClose: () => void;
    export let appName: string;
    export let onSubmit: (principalId: string) => void;

    let principalId = "";

    function handleSubmit() {
        onSubmit(principalId);
        onClose();
    }
</script>
{#if isOpen}
<Modal {onClose}>
    <div class="flex flex-col w-full h-full">
        <h2 class="text-2xl text-white cta-text">Link ICFC App Principal IDs</h2>
        <div class="top-0 p-6 pb-2 border-b border-BrandGrayShade3 z-60 bg-ModalBackground">
            <div class="flex items-center justify-between">
                <h2 class="text-2xl text-white cta-text">Link {appName} Account</h2>
                <button 
                    on:click={onClose}
                    class="p-2 transition-colors duration-300 rounded-lg hover:bg-white/10"
                >
                    <CloseIcon className="w-8 h-8" fill="white" />
                </button>
            </div>
        </div>

        <div class="flex-1 p-6">
            <form on:submit|preventDefault={handleSubmit} class="flex flex-col gap-4">
                <div class="flex flex-col gap-2">
                    <label for="principalId" class="text-white">Enter your Principal ID:</label>
                    <input
                        type="text"
                        id="principalId"
                        bind:value={principalId}
                        class="p-2 text-white bg-BrandGrayShade5 border border-BrandGrayShade3 rounded-lg"
                        placeholder="Enter Principal ID"
                    />
                </div>
                <button
                    type="submit"
                    class="px-4 py-2 text-white transition-colors bg-BrandBlue rounded-lg hover:bg-BrandInfo"
                >
                    Link Account
                </button>
            </form>
        </div>
    </div>
</Modal> 
{/if}