<script lang="ts">
    import CreateUserHeader from "../profile/create-user/create-user-header.svelte";    
    const { onChoice } = $props<{
      onChoice: (choice: 'profile' | 'sale') => void;
    }>();
    
    let choiceMade = $state(false);
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
          onclick={() => {
            choiceMade = true;
            onChoice('profile');
          }}
          class="w-full transition-shadow brand-button-purple hover:shadow-2xl"
          disabled={choiceMade}
        >
          Create Full Profile
        </button>
        
        <button
          onclick={() => {
            choiceMade = true;
            onChoice('sale');
          }}
          class="w-full transition-shadow brand-button hover:shadow-2xl"
          disabled={choiceMade}
        >
          Continue to Sale
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