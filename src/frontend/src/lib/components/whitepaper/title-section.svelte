<script lang="ts">
  import { fade } from 'svelte/transition';
  export let title: string;
  export let subtitle: string | null = null;
  export let divider: boolean = true;
</script>

<div 
  class="mb-8" 
  in:fade={{ delay: 200, duration: 800 }}
>
  <h1 class="text-4xl md:text-5xl font-bold text-BrandGrayShade5 tracking-tight">
    {title}
  </h1>
  {#if subtitle}
    <p class="mt-2 text-lg text-BrandGrayShade3 italic">
      {subtitle}
    </p>
  {/if}
  {#if divider}
    <div 
      class="mt-4 h-1 w-16 bg-BrandBlue rounded-full" 
      in:fade={{ delay: 400, duration: 800 }}
    ></div>
  {/if}
</div>