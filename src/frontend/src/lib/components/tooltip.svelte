<script lang="ts">

  interface Props {
    text: string;
  }

  let { text } : Props = $props();
  
  let tooltipVisible = false;

  function toggleTooltip() {
    tooltipVisible = !tooltipVisible;
  }
</script>

<button
  class="relative flex items-center w-6 max-w-6 text-sm"
  onmouseenter={() => (tooltipVisible = true)}
  onmouseleave={() => (tooltipVisible = false)}
  onclick={toggleTooltip}
>
  <slot />
  {#if tooltipVisible}
    <button
    aria-label=""
      class="absolute z-10 p-2 bg-BrandSuccess text-white rounded-md shadow-lg p-2 px-4 hidden md:flex bg-opacity-75"
      style="transform: translate(20%, -50%); top: 50%; left: 50%;"
      onclick={toggleTooltip}
    >
      {text}
    </button>
  {/if}
</button>
