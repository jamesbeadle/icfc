<script lang="ts">
	import { getContext } from 'svelte';
	import { derived, type Writable } from 'svelte/store';

	interface Props {
		value: string;
	}

	let { value } : Props = $props();

	const activeTab = getContext<Writable<string>>('activeTab');
	const isActive = derived(activeTab, ($activeTab) => $activeTab === value);
</script>

{#if $isActive}
	<div class="mt-4">
		<slot />
	</div>
{/if}