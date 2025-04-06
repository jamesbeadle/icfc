<script lang="ts">
  import LocalSpinner from "./local-spinner.svelte";

  const { onFull, onSale, processing } = $props<{
    onFull: () => void;
    onSale: () => void;
    processing: boolean;
  }>();
</script>
  
<div class="relative flex flex-col items-center justify-center min-h-screen bg-BrandBlack">
  <div class="w-full max-w-md px-4 mt-16">
    <div class="p-8 text-center border bg-BrandBlackShade1 rounded-xl border-BrandGrayShade3">
      <h2 class="mb-6 text-2xl font-bold text-white section-header">
        Welcome to the ICFC Community!
      </h2>
      
      <p class="mb-8 text-BrandGrayShade2 brand-sub-title">
        Choose how you'd like to proceed:
      </p>

      <div class="space-y-4">
        <button
          onclick={onFull}
          class="w-full px-4 py-3 text-white transition border rounded-lg border-BrandGrayShade3 brand-button hover:bg-BrandBlack hover:border-BrandBlue/80"
        >
          Create Full Profile
        </button>
        
        <button
          onclick={onSale}
          class="w-full px-4 py-3 text-white transition border rounded-lg border-BrandGrayShade3 brand-button hover:bg-BrandBlack hover:border-BrandBlue/80"
          disabled={processing}
        >
          {#if processing}
            <LocalSpinner message="Loading Sale Page" />
          {:else}
            Continue to Sale
          {/if}
        </button>
      </div>

      <div class="mt-6 horizontal-divider"></div>

      <p class="mt-6 text-xs text-BrandGrayShade3">
        Creating a profile unlocks all features. You can always create one later.
      </p>
    </div>
  </div>
</div>

<style>
  button:disabled {
    opacity: 0.7;
    cursor: not-allowed;
    transform: none !important;
  }
</style>