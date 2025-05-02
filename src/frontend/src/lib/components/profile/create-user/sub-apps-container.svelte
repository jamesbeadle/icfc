<script lang="ts">
    import { isPrincipalValid } from "$lib/utils/helpers";

    interface Props {
        openFplPrincipalId: string;
    }

    let { openFplPrincipalId } : Props = $props();
</script>


<div class="flex flex-col space-y-4">
    <p class="text-lg text-white cta-text">Sub-App Principal IDs</p>
    <p class="text-BrandGrayShade2">
        Enter your Principal IDs for ICFC sub-applications (optional)
    </p>
    
    <div class="flex flex-col space-y-4">
        <p class="form-title">OpenFPL Principal ID</p>
        <p class="form-hint">Valid principal ID</p>
        <input
            type="text"
            bind:value={openFplPrincipalId}
            class="brand-input"
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
    <div class="border-t horizontal-divider border-BrandGrayShade3"></div>
</div>