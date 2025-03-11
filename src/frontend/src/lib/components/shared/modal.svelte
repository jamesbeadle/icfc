<script lang="ts">
  import { onDestroy } from "svelte";

  const { showModal, onClose, children } = $props<{
    showModal: boolean;
    onClose: () => void;
    children: any;
  }>();

  const isVisible = $derived(showModal);
  let modalContainer = $state<HTMLElement | null>(null);

  const handleKeydown = (e: KeyboardEvent) => {
    if (e.key === 'Escape' && showModal) {
      onClose();
    }
  };

  const handleBackdropClick = (e: MouseEvent) => {
    if (e.target === e.currentTarget) {
      onClose();
    }
  };

  const trapFocus = () => {
    if (modalContainer && showModal) {
      const focusableElements = modalContainer.querySelectorAll<HTMLElement>(
        'a, button, input, textarea, select, details, [tabindex]:not([tabindex="-1"])'
      );

      if (focusableElements.length > 0) {
        focusableElements[0].focus();
      } else {
        modalContainer.focus();
      }
    }
  };

  if (typeof window !== "undefined") {
    window.addEventListener("keydown", handleKeydown);
  }

  onDestroy(() => {
    if (typeof window !== "undefined") {
      window.removeEventListener("keydown", handleKeydown);
    }
  });

  $effect(() => {
    if (showModal) {
      trapFocus(); 
    }
  });
</script>

{#if isVisible}
<div
  class="fixed inset-0 z-40 flex items-center justify-center overflow-y-auto bg-black/50 backdrop-blur-sm perspective"
  onclick={handleBackdropClick}
  aria-hidden={isVisible ? "false" : "true"}
>
  <div
    class="bg-ModalBackground border border-ModalBorder rounded-lg max-w-auto w-full mx-auto relative overflow-y-auto max-h-[90vh] px-6 py-4 drop-shadow-[0_4px_16px_rgba(0,0,0,0.6)] transform-style-preserve-3d"
    role="dialog"
    aria-modal="true"
    tabindex="-1" 
    bind:this={modalContainer}
  >
    {@render children()}
  </div>
</div>
{/if}

<style>
  .perspective {
    perspective: 2000px;
  }
  
  .transform-style-preserve-3d {
    transform-style: preserve-3d;
  }
</style>
