<script lang="ts">

    interface Props {
        title: string;
        intro: string;
    }
  
    let { title, intro } : Props = $props();

</script>
<div class="flex flex-col mb-4 space-y-4 text-lg">
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