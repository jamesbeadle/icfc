<script lang="ts">
    import { writable } from 'svelte/store';
    import { onMount, setContext } from 'svelte';

    interface Props {
        defaultValue: string;
    }

    let { defaultValue } : Props = $props();

    const activeTab = writable(defaultValue);
    setContext('activeTab', activeTab);

    onMount(() => {
        activeTab.set(defaultValue);
    });
</script>

<div class="w-full">
	<slot />
</div>