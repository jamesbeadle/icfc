<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { isPrincipalValid } from "$lib/utils/helpers";
    import type { PrincipalId, ProfileDTO, SubApp } from "../../../../../declarations/backend/backend.did";
    
    export let profile: ProfileDTO;

    let isLoading = false;

    let openFplPrincipalId: string = profile.appPrincipalIds.find(x => Object.keys(x[0])[0].toLowerCase() == "OpenFPL")?.[1] ?? "";
    let footballGodPrincipalId: string = profile.appPrincipalIds.find(x => Object.keys(x[0])[0].toLowerCase() == "FootballGod")?.[1] ?? "";
    let transferKingsPrincipalId: string = profile.appPrincipalIds.find(x => Object.keys(x[0])[0].toLowerCase() == "TransferKings")?.[1] ?? "";
    let jeffBetsPrincipalId: string = profile.appPrincipalIds.find(x => Object.keys(x[0])[0].toLowerCase() == "JeffBets")?.[1] ?? "";
    let openWslPrincipalId: string = profile.appPrincipalIds.find(x => Object.keys(x[0])[0].toLowerCase() == "OpenWSL")?.[1] ?? "";

    async function updateLinkedApps() {
        isLoading = true;
        try {
            let appPrincipalIds: Array<[SubApp, PrincipalId]> = [];

            if(openFplPrincipalId.length > 0 && isPrincipalValid(openFplPrincipalId)){
                appPrincipalIds.push([{ OpenFPL: null }, openFplPrincipalId]);
            }

            if(openWslPrincipalId.length > 0 && isPrincipalValid(openWslPrincipalId)){
                appPrincipalIds.push([{ OpenWSL: null }, openWslPrincipalId]);
            }

            if(transferKingsPrincipalId.length > 0 && isPrincipalValid(transferKingsPrincipalId)){
                appPrincipalIds.push([{ TransferKings: null }, transferKingsPrincipalId]);
            }

            if(footballGodPrincipalId.length > 0 && isPrincipalValid(footballGodPrincipalId)){
                appPrincipalIds.push([{ FootballGod: null }, footballGodPrincipalId]);
            }

            if(jeffBetsPrincipalId.length > 0 && isPrincipalValid(jeffBetsPrincipalId)){
                appPrincipalIds.push([{ JeffBets: null }, jeffBetsPrincipalId]);
            }
            await userStore.sync();
            toasts.addToast({type: 'success', message: 'Linked app principal IDs successfully created'});
            window.location.href = "/";
        } catch (error) {
            console.error("Error updating linked app principal IDs:", error);
            toasts.addToast({type: 'error', message: 'Error updating linked app principal IDs'});
        } finally {
            isLoading = false;
        }
    }

</script>

<div class="flex flex-col">
    <p class="cta-text text-lg text-white">Sub-App Principal IDs</p>
    <p class="text-BrandGrayShade2">
        Enter your Principal IDs for ICFC sub-applications (optional)
    </p>
    
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="flex flex-col space-y-4">
            <div class="flex flex-col space-y-1">
                <p class="form-title">OpenFPL Principal ID</p>
                <p class="form-hint">A valid principal ID</p>
                <input
                    type="text"
                    bind:value={openFplPrincipalId}
                    class="brand-input"
                    placeholder="Enter OpenFPL Principal ID"
                />
                {#if openFplPrincipalId.length > 0}
                    <div class="mt-1 text-sm">
                        {#if !isPrincipalValid(openFplPrincipalId)}
                            <p class="text-BrandRed mt-1">Invalid Principal ID</p>
                        {:else}
                            <p class="text-BrandSuccess mt-1">Valid Principal ID</p>
                        {/if}
                    </div>
                {/if}
            </div>
        
            <div class="flex flex-col space-y-1">
                <p class="form-title">Football God Principal ID</p>
                <p class="form-hint">A valid principal ID</p>
                <input
                    type="text"
                    bind:value={footballGodPrincipalId}
                    class="brand-input"
                    placeholder="Enter Football God Principal ID"
                />
                {#if footballGodPrincipalId.length > 0}
                <div class="mt-1 text-sm">
                    {#if !isPrincipalValid(footballGodPrincipalId)}
                        <p class="text-BrandRed">Invalid Principal ID</p>
                    {:else}
                        <p class="text-BrandGreed">Valid Principal ID</p>
                    {/if}
                </div>
                {/if}
            </div>
        
            <div class="flex flex-col space-y-1">
                <p class="form-title">Transfer Kings Principal ID</p>
                <p class="form-hint">A valid principal ID</p>
                <input
                    type="text"
                    bind:value={transferKingsPrincipalId}
                    class="brand-input"
                    placeholder="Enter Transfer Kings Principal ID"
                />
                {#if transferKingsPrincipalId.length > 0}
                    <div class="mt-1 text-sm">
                        {#if !isPrincipalValid(transferKingsPrincipalId)}
                            <p class="text-BrandRed mt-1">Invalid Principal ID</p>
                        {:else}
                            <p class="text-BrandSuccess mt-1">Valid Principal ID</p>
                        {/if}
                    </div>
                {/if}
            </div>
        </div>
    
        <div class="flex flex-col space-y-4">
            <div class="flex flex-col space-y-1">
                <p class="form-title">Jeff Bets Principal ID</p>
                <p class="form-hint">A valid principal ID</p>
                <input
                    type="text"
                    bind:value={jeffBetsPrincipalId}
                    class="brand-input"
                    placeholder="Enter Jeff Bets Principal ID"
                />
                {#if jeffBetsPrincipalId.length > 0}
                    <div class="mt-1 text-sm">
                        {#if !isPrincipalValid(jeffBetsPrincipalId)}
                            <p class="text-BrandRed mt-1">Invalid Principal ID</p>
                        {:else}
                            <p class="text-BrandSuccess mt-1">Valid Principal ID</p>
                        {/if}
                    </div>
                {/if}
            </div>
        
            <div class="flex flex-col space-y-1">
                <p class="form-title">OpenWSL Principal ID</p>
                <p class="form-hint">A valid principal ID</p>
                <input
                    type="text"
                    bind:value={openWslPrincipalId}
                    class="brand-input"
                    placeholder="Enter OpenWSL Principal ID"
                />
                {#if openWslPrincipalId.length > 0}
                    <div class="mt-1 text-sm">
                        {#if !isPrincipalValid(openWslPrincipalId)}
                            <p class="text-BrandRed mt-1">Invalid Principal ID</p>
                        {:else}
                            <p class="text-BrandSuccess mt-1">Valid Principal ID</p>
                        {/if}
                    </div>
                {/if}
            </div>
        </div>
    </div>

    <div class="flex">
        <button on:click={updateLinkedApps} class="brand-button">Update</button>
    </div>
</div>