<script lang="ts">
  interface Props {
    id: string;
    isFlipped?: boolean;
    onFlip?: (id: string, e: MouseEvent | KeyboardEvent) => void;
    disableFlip?: boolean;
    frontContent: (props: { isFlipped: boolean }) => any;
    backContent: (props: { isFlipped: boolean }) => any;
    frontClasses?: string;
    backClasses?: string;
  }

  let {
    id,
    isFlipped = false,
    onFlip = () => {},
    disableFlip = false,
    frontClasses = '',
    backClasses = '',
    frontContent,
    backContent
  }: Props = $props();

  function handleFlip(e: MouseEvent | KeyboardEvent) {
      if (disableFlip || (e.target as HTMLElement).closest('a')) return;
      onFlip(id, e);
  }
</script>

<div
  class="relative w-full group perspective transition-transform duration-300 aspect-[1/1.54] min-h-[400px] min-w-[260px] xs:min-h-[320px] xs:min-w-[208px] mini:min-h-[400px] mini:min-w-[260px] hover:scale-[1.02] cursor-pointer}"
  onclick={handleFlip}
  onkeydown={(e) => e.key === 'Enter' && handleFlip(e)}
  tabindex="0"
  role="button"
>
  <div
      class="relative w-full h-full transition-all duration-500 transform-style-3d {isFlipped ? 'rotate-y-180' : ''}"
  >
      <div
          class="absolute w-full h-full min-h-[400px] min-w-[260px] p-8 text-left rounded-2xl backface-hidden transform transition-all duration-200 overflow-hidden flex flex-col {frontClasses} hover:-translate-y-1 hover:shadow-xl}"
      >
          {#if frontContent}
              {@render frontContent({ isFlipped })}
          {:else}
              <div>Default Front Content</div>
          {/if}
      </div>

      <div
          class="absolute w-full h-full min-h-[400px] min-w-[260px] p-8 text-left rounded-2xl backface-hidden rotate-y-180 flex flex-col {backClasses}"
      >
          {#if backContent}
              {@render backContent({ isFlipped })}
          {:else}
              <div>Default Back Content</div>
          {/if}
      </div>
  </div>
</div>

<style>
  .perspective {
      perspective: 1000px;
  }

  .transform-style-3d {
      transform-style: preserve-3d;
  }

  .backface-hidden {
      backface-visibility: hidden;
  }

  .rotate-y-180 {
      transform: rotateY(180deg);
  }
</style>