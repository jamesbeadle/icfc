<script lang="ts">
    import Layout from '../Layout.svelte';
	import Tabs from './../../lib/components/whitepaper/tabs/tabs.svelte';
    import TabsList from './../../lib/components/whitepaper/tabs/tabs-list.svelte';
    import TabsTrigger from './../../lib/components/whitepaper/tabs/tabs-trigger.svelte';
    import TabsContent from './../../lib/components/whitepaper/tabs/tabs-content.svelte';

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
      { id: 'revenue', title: 'Our Products', component: Revenue },
      { id: 'sale', title: 'Decentralisation Sale 2', component: Sale },
      { id: 'membership', title: 'Membership', component: Membership },
      { id: 'club-daos', title: 'Club DAOs', component: ClubDAOs },
      { id: 'content-creators', title: 'Content Creators', component: ContentCreators },
      { id: 'deai', title: 'Decentralised AI', component: DecentralisedAi },
      { id: 'roadmap', title: 'Roadmap', component: Roadmap },
      { id: 'notes', title: 'Notes', component: Notes },
    ];
</script>

<Layout>
    <div class="flex flex-col w-full p-4 mb-8 space-y-4">
        <p class="main-title">ICFC Whitepaper</p>
        <p class="px-4">
            This whitepaper outlines the vision, token economics, and long-term strategy for icfc.app.
        </p>

        <Tabs defaultValue="vision">
            <TabsList class="flex flex-wrap gap-2">
                {#each sections as section}
                    <TabsTrigger value={section.id}>{section.title}</TabsTrigger>
                {/each}
            </TabsList>

            {#each sections as section}
                <TabsContent value={section.id}>
                    <div class="p-4 bg-gray-100 rounded-lg shadow-sm dark:bg-gray-800">
                    <svelte:component this={section.component} />
                    </div>
                </TabsContent>
            {/each}
        </Tabs>
    </div>
</Layout>