<script lang="ts">
    import { writable } from 'svelte/store';
    import { onMount, setContext, type Snippet } from 'svelte';

    interface Props {
        defaultValue: string;
        children: Snippet;
    }

    let { defaultValue, children } : Props = $props();

    const activeTab = writable(defaultValue);
    setContext('activeTab', activeTab);

    onMount(() => {
        activeTab.set(defaultValue);
    });
</script>

<div class="w-full">
    {@render children()}  
</div>