<script lang="ts">
	import { getContext } from 'svelte';
	import { derived, type Writable } from 'svelte/store';

	export let value: string;

	const activeTab = getContext<Writable<string>>('activeTab');
	const isActive = derived(activeTab, ($activeTab) => $activeTab === value);

	function selectTab() {
		activeTab.set(value);
	}
</script>

<button
	on:click={selectTab}
	class={`px-4 py-2 text-sm font-medium cta-text transition-colors duration-200 border-b-2 ${
        $isActive
            ? 'border-BrandBlue text-BrandBlue'
            : 'border-transparent text-BrandGrayShade3 hover:text-BrandGrayShade5'
    }`}
>
	<slot />
</button>



