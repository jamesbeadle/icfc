<script lang="ts">
    import Layout from '../Layout.svelte';
	import Tabs from './../../lib/components/whitepaper/tabs/tabs.svelte';
    import TabsList from './../../lib/components/whitepaper/tabs/tabs-list.svelte';
    import TabsTrigger from './../../lib/components/whitepaper/tabs/tabs-trigger.svelte';
    import TabsContent from './../../lib/components/whitepaper/tabs/tabs-content.svelte';

    import Section1 from '$lib/components/whitepaper/section1.svelte';
    import Section2 from '$lib/components/whitepaper/section2.svelte';
    import Section3 from '$lib/components/whitepaper/section3.svelte';
    import Section4 from '$lib/components/whitepaper/section4.svelte';
    import Section5 from '$lib/components/whitepaper/section5.svelte';
    import Section6 from '$lib/components/whitepaper/section6.svelte';
    import Section7 from '$lib/components/whitepaper/section7.svelte';
  
    const sections = [
      { id: 'vision', title: 'Vision', component: Section1 },
      { id: 'ownership', title: 'Fan Ownership', component: Section2 },
      { id: 'membership', title: 'Membership', component: Section3 },
      { id: 'token', title: 'Token Details', component: Section4 },
      { id: 'rewards', title: 'Governance Rewards', component: Section5 },
      { id: 'burning', title: 'Token Burning', component: Section6 },
      { id: 'roadmap', title: 'Roadmap', component: Section7 },
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