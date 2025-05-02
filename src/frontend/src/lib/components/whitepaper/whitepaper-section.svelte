<script lang="ts">

    interface Props {
        title: string;
    }
  
    let { title } : Props = $props();

</script>

<p class="sub-header">
    {title}
</p>

<div class="space-y-4">
    <slot></slot>
</div>