<script lang="ts">
    import type { Snippet } from "svelte";


    interface Props {
        title: string;
        intro: string;
        children: Snippet;
    }
  
    let { title, intro, children } : Props = $props();

</script>
<div class="flex flex-col mb-4 space-y-4 text-lg">
    <div class="flex items-center justify-between pr-4">
        <p class="section-title">
            {title}
        </p>
    </div>
    
    <p class="page-intro">
        {intro}
    </p>

    {@render children()}  
</div>