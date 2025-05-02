<script lang="ts">
	import { onMount } from 'svelte';
	import { toasts } from '$lib/stores/toasts-store';
	import type { Toast } from '$lib/stores/toasts-store';
    import { appStore } from '$lib/stores/app-store';

	interface Props {
		toast: Toast;
	}

	let { toast } : Props = $props();

	let timer: ReturnType<typeof setTimeout> | null = null;

	onMount(() => {
		if (toast.duration && toast.duration > 0) {
			timer = setTimeout(closeToast, toast.duration);
		}
	});

	function closeToast() {
		toasts.removeToast(toast.id);
	}

	function updateFrontend(){
		appStore.updateFrontend();
	}

	let backgroundColour = 
		toast.type === 'success' ? 'bg-BrandSuccess' :
		toast.type === 'error' ? 'bg-BrandError' :
		toast.type === 'info' ? 'bg-BrandInfo' :
		toast.type === 'frontend-update' ? 'bg-BrandInfo' :
		'bg-BrandInfo';

	let textColorClass = toast.type === 'success' ? 'text-BrandGray' : 'text-white';
</script>

<div class={`fixed top-0 left-0 right-0 z-[9999] p-4 shadow-md flex justify-between items-center ${backgroundColour} ${textColorClass}`}>
  <span>{toast.message}</span>
  {#if toast.type === "frontend-update"}
	<button onclick={updateFrontend} class="brand-button">Update Website</button>
  {/if}
  <button class="ml-4 font-bold" onclick={closeToast}>
    &times;
  </button>
</div>
