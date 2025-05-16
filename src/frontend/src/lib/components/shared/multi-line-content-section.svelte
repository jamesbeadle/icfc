<script lang="ts">


    interface Props {
        title: string;
        content: string[];
        titleColor: string;
        secondTitleColor: string;
    }

    let { title, content, titleColor, secondTitleColor } : Props = $props();

    let parts = title.split(/: |& /).map(t => t.trim());
</script>

<div class="flex flex-col mb-8">
    <span class="mb-4 section-header">
        {parts[0]}:
        {#if titleColor}
            <span class="bg-{titleColor} bg-clip-text text-transparent">{parts[1]}</span>
        {:else}
            {parts[1]}
        {/if}
        {#if parts.length > 2}
            &nbsp;&amp;&nbsp;
            {#if secondTitleColor}
                <span class="bg-{secondTitleColor} bg-clip-text text-transparent">{parts[2]}</span>
            {:else}
                {parts[2]}
            {/if}
        {/if}
    </span>
    <div class="mt-2">
        {#each content as line}
            <span class="leading-relaxed">{line}</span>
        {/each}
    </div>
</div>
