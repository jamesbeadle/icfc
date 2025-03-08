<div class="border-b border-gray-300 dark:border-gray-700 overflow-x-auto whitespace-nowrap">
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

    @media (min-width: 640px) {
        .overflow-x-auto {
            overflow-x: visible;
        }
        .whitespace-nowrap {
            white-space: normal;
        }
        .flex {
            padding-right: 0;
        }
    }
</style>