<div class="border-b border-BrandGrayShade2 dark:border-BrandGrayShade3 overflow-x-auto whitespace-nowrap">
    <div class="flex items-center">
        <slot />
    </div>
</div>

<style>
    .whitespace-nowrap {
        white-space: nowrap;
    }

    .overflow-x-auto::-webkit-scrollbar {
        display: none;
    }

    .overflow-x-auto {
        -ms-overflow-style: none; 
        scrollbar-width: none;  
    }

    .flex {
        padding-right: 1rem;
    }
</style>