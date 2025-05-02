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
</script>

{#if $isActive}
	<div class="mt-4">
		{@render children()}  
	</div>
{/if}