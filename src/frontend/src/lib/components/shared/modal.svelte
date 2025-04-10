<script lang="ts">
  import Portal from 'svelte-portal';
  import type { Snippet } from 'svelte';
  import { quintOut } from 'svelte/easing';
  import { fade, scale } from 'svelte/transition';
  import { isBusy } from '$lib/stores/busy-store';
  import { handleKeyPress } from '$lib/utils/keyboard.utils';
  import { onMount, onDestroy } from 'svelte';
  import CloseIcon from '$lib/icons/CloseIcon.svelte';
  
  interface Props {
    onClose: () => void;
    title?: string;
    children: Snippet;
  }

  let { children, onClose, title }: Props = $props();
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
        class="relative w-[95%] sm:w-[90%] md:w-[85%] lg:w-[80%] max-w-[1400px] mx-auto p-4 sm:p-6"
      >
        <div 
          class="bg-ModalBackground border border-ModalBorder rounded-lg relative h-[80vh] drop-shadow-[0_4px_16px_rgba(0,0,0,0.6)] transform-style-preserve-3d flex flex-col"
        >
          <div class="flex-none px-6 py-6 border-b sm:px-8 sm:py-6 border-white/10">
            <div class="flex items-center justify-between">
              <h3 class="text-2xl text-white cta-text md:text-3xl">{title}</h3>
              <button 
                onclick={onClose}
                class="p-2 transition-colors duration-300 rounded-lg hover:bg-white/10"
              >
                <CloseIcon className="w-6 h-6" fill="white" />
              </button>
            </div>
          </div>
          <div class="flex-1 px-6 py-6 overflow-y-auto sm:px-8 sm:py-6">
            {@render children()}
          </div>
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