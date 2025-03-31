<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { isPrincipalValid } from "$lib/utils/helpers";
    import type { PrincipalId, ProfileDTO, SubApp } from "../../../../../declarations/backend/backend.did";
    import LocalSpinner from "../shared/local-spinner.svelte";
    
    export let profile: ProfileDTO;

    let isLoading = false;

    let openFplPrincipalId: string = profile.appPrincipalIds.find(x => Object.keys(x[0])[0].toLowerCase() == "OpenFPL")?.[1] ?? "";

    async function updateLinkedApps() {
        isLoading = true;
        try {
            let appPrincipalIds: Array<[SubApp, PrincipalId]> = [];
            if(openFplPrincipalId.length > 0 && isPrincipalValid(openFplPrincipalId)){
                appPrincipalIds.push([{ OpenFPL: null }, openFplPrincipalId]);
            }
            await userStore.sync();
            toasts.addToast({type: 'success', message: 'Linked app principal IDs successfully created'});
        } catch (error) {
            console.error("Error updating linked app principal IDs:", error);
            toasts.addToast({type: 'error', message: 'Error updating linked app principal IDs'});
        } finally {
            isLoading = false;
        }
    }

</script>

<div class="flex flex-col p-4">
    <p class="mb-2 text-2xl text-white cta-text">Sub-App Principal IDs</p>
    <p class="mb-2 text-lg text-BrandGrayShade2">
        Enter your Principal IDs for ICFC sub-applications
    </p>
    

    {#if isLoading}
        <div class="flex items-center justify-center h-screen">
            <LocalSpinner />
        </div>
    {:else}
        <div class="flex flex-col h-[150px]">
            <p class="form-title">OpenFPL Principal ID</p>
            <p class="form-hint">Valid principal ID</p>
            <input
                type="text"
                bind:value={openFplPrincipalId}
                class="brand-input-profile"
                placeholder="Enter OpenFPL Principal ID"
            />
            {#if openFplPrincipalId.length > 0}
                <div class="mt-1 text-sm">
                    {#if !isPrincipalValid(openFplPrincipalId)}
                        <p class="mt-1 text-BrandRed">Invalid Principal ID</p>
                    {:else}
                        <p class="mt-1 text-BrandSuccess">Valid Principal ID</p>
                    {/if}
                </div>
            {/if}
        </div>

        <div class="flex justify-center w-full my-4">
            <button 
                on:click={updateLinkedApps} 
                class="px-4 py-2 text-white transition border rounded-lg brand-button bg-BrandBlue hover:bg-BrandBlack/50 border-BrandGrayShade3 hover:border-BrandBlue/80"
            >
                Update
            </button>
        </div>
    {/if}
</div>