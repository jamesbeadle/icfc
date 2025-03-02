<script lang="ts">
    import { slide } from 'svelte/transition';
    export let heading: string | null = null;
    export let text: string;
  </script>
  
  <div 
    class="my-6" 
    in:slide={{ delay: 300, duration: 600 }}
  >
    {#if heading}
      <h2 class="text-2xl font-semibold text-BrandGrayShade4 mb-2">
        {heading}
      </h2>
    {/if}
    <p class="text-base text-BrandGrayShade3 leading-relaxed">
      {text}
    </p>
  </div>