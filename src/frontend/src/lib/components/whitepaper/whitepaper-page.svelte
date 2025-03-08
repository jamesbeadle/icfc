<script lang="ts">

    export let title: string;
    export let intro: string;

</script>
<div class="flex flex-col space-y-4 mb-4 text-lg">

    <p class="section-title">
        {title}
    </p> 
    
    <p class="page-intro">
        {intro}
    </p>

    <slot></slot>
</div>