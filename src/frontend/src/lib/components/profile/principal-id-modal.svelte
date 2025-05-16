<script lang="ts">
    import Modal from "$lib/components/shared/global/modal.svelte";
    import CloseIcon from "$lib/icons/CloseIcon.svelte";

    interface Props {
        isOpen: boolean;
        onClose: () => void;
        appName: string;
        onSubmit: (principalId: string) => void;
    }

    let { isOpen, onClose, appName, onSubmit  } : Props = $props();

    let principalId = $state("");

    function handleSubmit() {
        onSubmit(principalId);
        onClose();
    }
</script>
{#if isOpen}
<Modal title={`Link ${appName} Account`} {onClose}>
    <div class="flex flex-col w-full h-full">
        <div class="top-0 p-6 pb-2 border-b border-BrandGrayShade3 z-60 bg-ModalBackground">
            <div class="flex items-center justify-between">
                <button 
                    onclick={onClose}
                    class="p-2 transition-colors duration-300 rounded-lg hover:bg-white/10"
                >
                    <CloseIcon className="w-8 h-8" fill="white" />
                </button>
            </div>
        </div>

        <div class="flex-1 p-6">
            <div class="flex flex-col gap-4">
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
                    onclick={handleSubmit}
                    class="px-4 py-2 text-white transition-colors bg-BrandBlue rounded-lg hover:bg-BrandInfo"
                >
                    Link Account
                </button>
            </div>
        </div>
    </div>
</Modal> 
{/if}