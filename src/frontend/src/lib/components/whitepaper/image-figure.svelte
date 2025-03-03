<script lang="ts">
    import { scale } from 'svelte/transition';
    export let src: string;
    export let alt: string;
    export let caption: string | null = null;
  </script>
  
  <figure 
    class="my-8" 
    in:scale={{ start: 0.8, duration: 800 }}
  >
    <img 
      {src} 
      {alt} 
      class="w-full max-w-3xl mx-auto rounded-lg shadow-md border border-BrandGrayShade2" 
    />
    {#if caption}
      <figcaption class="mt-2 text-sm text-BrandGrayShade3 text-center">
        {caption}
      </figcaption>
    {/if}
  </figure>