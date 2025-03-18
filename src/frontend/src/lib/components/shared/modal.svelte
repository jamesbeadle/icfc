<script lang="ts">
  import Portal from 'svelte-portal';
	import type { Snippet } from 'svelte';
	import { quintOut } from 'svelte/easing';
	import { fade, scale } from 'svelte/transition';
  import { isBusy } from '$lib/stores/busy-store';
  import { handleKeyPress } from '$lib/utils/keyboard.utils';
  import { onMount, onDestroy } from 'svelte';
  
  interface Props {
    onClose: () => void;
		children: Snippet;
	}

  let { children, onClose}: Props = $props();

  let visible = $state(true);

  const close = () => {
    if ($isBusy) return;
    visible = false;
    onClose(); 
  }

  const onCloseHandler = ($event: MouseEvent | TouchEvent) => {
    $event.stopPropagation();
    close();
  };

  onMount(() => {
    document.body.style.overflow = 'hidden';
  });

  onDestroy(() => {
    document.body.style.overflow = '';
  });

</script>

{#if visible}
  <Portal>
    <div
      class="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/50 backdrop-blur-sm perspective"
      out:fade
      role="dialog"
      aria-labelledby="modalTitle"
      aria-describedby="modalContent"
    >
      <div
        class="absolute inset-0 bg-black bg-opacity-50 cursor-pointer"
        onclick={onCloseHandler}
        onkeypress={($event) => handleKeyPress({ $event, callback: close })}
        role="button"
        tabindex="-1"
      ></div>
      <div 
        transition:scale={{ delay: 25, duration: 150, easing: quintOut }} 
        class="relative w-auto p-6 shadow-xl"
      >
        <div class="bg-ModalBackground border border-ModalBorder rounded-lg max-w-auto w-auto mx-auto relative overflow-y-auto max-h-[90vh] px-6 py-4 drop-shadow-[0_4px_16px_rgba(0,0,0,0.6)] transform-style-preserve-3d">
          {@render children()}
        </div>
      </div>
    </div>
  </Portal>
{/if}

<style>
  .perspective {
    perspective: 2000px;
  }
  
  .transform-style-preserve-3d {
    transform-style: preserve-3d;
  }
</style>
