<script lang="ts">

    interface Props {
        tabs:  { id: string; label: string}[];
        activeTab: string;
        setActiveTab: (tabName: string) => void;
    }

</script>

<div class="flex w-full rounded-t-lg bg-light-gray">
    <ul class="flex w-full border-b border-gray-700">
        {#each tabs as tab}
            <li class="relative">
                <button 
                    class={`px-4 py-3 text-base transition-colors duration-200
                        ${activeTab === tab.id 
                            ? 'text-white cta-text' 
                            : 'text-gray-400 cta-text hover:text-gray-200'}`}
                    on:click={() => setActiveTab(tab.id)}
                >
                    {tab.label}
                    {#if activeTab === tab.id}
                        <div class="absolute bottom-0 left-0 w-full h-0.5 bg-BrandBlue"></div>
                    {/if}
                </button>
            </li>
        {/each}
    </ul>
</div>

<style>
    button {
        position: relative;
        outline: none;
    }

    button::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 2px;
        background-color: transparent;
        transform: scaleX(0);
        transition: transform 0.2s ease;
    }

    button:hover::after {
        transform: scaleX(1);
        background-color: rgba(255, 255, 255, 0.1);
    }
</style>