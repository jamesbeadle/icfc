<script lang="ts">
	import { getContext } from 'svelte';
	import { derived, type Writable } from 'svelte/store';

	export let value: string;

	const activeTab = getContext<Writable<string>>('activeTab');
	const isActive = derived(activeTab, ($activeTab) => $activeTab === value);
</script>

{#if $isActive}
	<div class="mt-4">
		<slot />
	</div>
{/if}