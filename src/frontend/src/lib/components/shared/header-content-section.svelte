<script lang="ts">

    interface Props {
        title: string;
        content: string;
    }
  
    let { title, content } : Props = $props();

</script>


<div class="flex flex-col text-lg">
    <span class="section-header">{title}</span>
    <span class="mt-2">{content}</span>
</div>
