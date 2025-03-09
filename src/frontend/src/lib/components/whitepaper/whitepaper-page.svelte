<script lang="ts">

    export let title: string;
    export let intro: string;

</script>
<div class="flex flex-col mb-4 space-y-8 text-lg">
    <div class="flex items-center justify-between pr-4">
        <p class="section-title">
            {title}
        </p>
        <slot name="action" />
    </div>
    
    <p class="page-intro">
        {intro}
    </p>

    <slot></slot>
</div>