<script lang="ts">
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
          class="w-full transition-shadow brand-button-purple hover:shadow-2xl"
        >
          Create Full Profile
        </button>
        
        <button
          onclick={onSale}
          class="w-full transition-shadow brand-button hover:shadow-2xl"
          disabled={processing}
        >
          {#if processing}
          <span class="inline-flex items-center">
            Processing...
            <svg class="w-4 h-4 ml-2 text-white animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          </span>
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