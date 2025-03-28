<script lang="ts">
    import Vision from '$lib/components/whitepaper/vision.svelte';
    import Token from '$lib/components/whitepaper/token.svelte';
    import Products from '$lib/components/whitepaper/products.svelte';
    import Revenue from '$lib/components/whitepaper/revenue.svelte';
    import Sale from '$lib/components/whitepaper/sale.svelte';
    import ClubDAOs from '$lib/components/whitepaper/club-daos.svelte';
    import Notes from '$lib/components/whitepaper/notes.svelte';
    import Membership from '$lib/components/whitepaper/membership.svelte';
    import DecentralisedAi from '$lib/components/whitepaper/decentralised-ai.svelte';
    import Roadmap from '$lib/components/whitepaper/roadmap.svelte';
    import ContentCreators from '$lib/components/whitepaper/content-creators.svelte';
  
    const sections = [
      { id: 'vision', title: 'Vision', component: Vision },
      { id: 'ownership', title: 'The ICFC DAO', component: Token },
      { id: 'products', title: 'Our Products', component: Products },
      { id: 'revenue', title: 'Revenue', component: Revenue },
      { id: 'sale', title: 'Sale #2', component: Sale },
      { id: 'membership', title: 'Membership', component: Membership },
      { id: 'club-daos', title: 'Club DAOs', component: ClubDAOs },
      { id: 'content-creators', title: 'Content Creators', component: ContentCreators },
      { id: 'deai', title: 'Artificial Intelligence', component: DecentralisedAi },
      { id: 'roadmap', title: 'Roadmap', component: Roadmap },
      { id: 'notes', title: 'Notes', component: Notes },
    ];
  
    let activeTab = $state(0);
    
    $effect(() => {
        const currentTab = activeTab;

        setTimeout(() => {
            const mainContent = document.querySelector('main');
            if (mainContent) {
                mainContent.scrollTo({ top: 0, behavior: 'smooth' });
            }
        }, 100);
    });

    function switchTab(index: number) {
        activeTab = index;
    }

    function goToPrevious() {
        if (activeTab > 0) {
            activeTab--;
        }
    }

    function goToNext() {
        if (activeTab < sections.length - 1) {
            activeTab++;
        }
    }
</script>

<div class="flex flex-col w-full p-4 mb-8 space-y-4">
    <p class="main-title">Whitepaper</p>
    <p class="px-4">
        This whitepaper outlines the vision, token economics, and long-term strategy for icfc.app.
    </p>
    <div class="w-full">
        <div class="overflow-x-auto whitespace-nowrap no-scrollbar">
            <div class="inline-flex w-full border-b min-w-max border-BrandGrayShade3">
            {#each sections as tab, index}
                <button
                class={`flex-1 min-w-[125px] px-4 py-2 text-sm font-medium text-center 
                        border-b-2 transition-colors duration-200
                        ${activeTab === index 
                            ? 'border-BrandBlue text-BrandBlue' 
                            : 'border-transparent text-BrandGrayShade4 hover:text-BrandGrayShade5 hover:border-BrandGrayShade2'}`}
                onclick={() => switchTab(index)}
                >
                <span class="block break-words whitespace-normal cta-text">
                    {tab.title}
                </span>
                </button>
            {/each}
            </div>
        </div>
        
        <div class="p-4 mt-4 rounded-lg bg-BrandBlueComp">
            <svelte:component this={sections[activeTab].component} />
        </div><!-- //TODO Deprecated -->

        <div class="flex flex-col items-center mt-6 space-y-4">
            <div class="flex space-x-4">
                <button
                    onclick={goToPrevious}
                    disabled={activeTab === 0}
                    class="px-4 py-2 rounded-md transition-colors min-w-[200px]
                            {activeTab === 0 
                                ? 'bg-BrandGrayShade2 cursor-not-allowed text-BrandGrayShade4' 
                                : 'bg-BrandBlue text-white hover:bg-BrandBlue/90'}"
                >
                    Previous
                </button>
                <button
                    onclick={goToNext}
                    disabled={activeTab === sections.length - 1}
                    class="px-4 py-2 rounded-md transition-colors min-w-[200px]
                            {activeTab === sections.length - 1 
                                ? 'bg-BrandGrayShade2 cursor-not-allowed text-BrandGrayShade4' 
                                : 'bg-BrandBlue text-white hover:bg-BrandBlue/90'}"
                >
                    Next
                </button>
            </div>

            <div class="flex space-x-2">
                {#each sections as _, index}
                    <button
                        onclick={() => switchTab(index)}
                        class="w-3 h-3 rounded-full transition-colors
                                {activeTab === index 
                                    ? 'bg-BrandBlue' 
                                    : 'bg-BrandGrayShade3 hover:bg-BrandGrayShade4'}"
                        aria-label={`Go to page ${index + 1}`}
                    ></button>
                {/each}
            </div>
        </div>
    </div>
</div>

<style>
    .no-scrollbar {
      -ms-overflow-style: none;
      scrollbar-width: none; 
    }
    .no-scrollbar::-webkit-scrollbar {
      display: none;
    }
</style>