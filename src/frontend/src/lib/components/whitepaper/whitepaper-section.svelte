<script lang="ts">
    import type { Snippet } from "svelte";


    interface Props {
        title: string;
        children: Snippet;
    }
  
    let { title, children } : Props = $props();

</script>

<p class="sub-header">
    {title}
</p>

<div class="space-y-4">
    {@render children()}  
</div>