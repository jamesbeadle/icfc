<script lang="ts">
	import { getContext, type Snippet } from 'svelte';
	import { derived, type Writable } from 'svelte/store';

	interface Props {
		value: string;
		children: Snippet;
	}

	let { value, children } : Props = $props();

	const activeTab = getContext<Writable<string>>('activeTab');
	const isActive = derived(activeTab, ($activeTab) => $activeTab === value);

	function selectTab() {
		activeTab.set(value);
	}
</script>

<button
	onclick={selectTab}
	class={`px-4 py-2 text-sm cta-text transition-colors duration-200 border-b-2 min-w-[100px] ${
        $isActive
            ? 'border-BrandBlue text-BrandBlue'
            : 'border-transparent text-BrandGrayShade3 hover:text-BrandGrayShade5'
    }`}
>
	{@render children()}  
</button>



