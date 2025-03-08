<script lang="ts">

export let title: string;
export let content: string[];

</script>


<div class="flex flex-col">
    <span class="section-header">{title}</span>
    {#each content as line}
        <span class="mt-1">{line}</span>
    {/each}
</div>
