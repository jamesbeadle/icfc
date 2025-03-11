<script lang="ts">
    export let title: string;
    export let items: string[];
</script>

<div class="flex flex-col">
    <p class="w-full small-header my-2">{title}</p>
    <div class="flex flex-col w-full">
        {#each items as item}
        <div class="w-full flex space-y-2">
            - {item}
        </div>
        {/each}
    </div>
</div>