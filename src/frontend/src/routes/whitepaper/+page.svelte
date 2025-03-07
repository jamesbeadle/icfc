<script lang="ts">
    import Layout from "../Layout.svelte";
    import Section1 from "$lib/components/whitepaper/section1.svelte";
    import Section2 from "$lib/components/whitepaper/section2.svelte";
    import Section3 from "$lib/components/whitepaper/section3.svelte";
    import Section4 from "$lib/components/whitepaper/section4.svelte";
    import Section5 from "$lib/components/whitepaper/section5.svelte";
    import Section6 from "$lib/components/whitepaper/section6.svelte";
    import Section7 from "$lib/components/whitepaper/section7.svelte";
</script>
<Layout>
    <div class="flex flex-col space-y-2 w-full p-4 mb-8">

        <p class="main-title">ICFC Whitepaper</p>

        <p>
            This whitepaper outlines the vision, token economics and long-term strategy for icfc.app.
        </p>

        <div class="horizontal-divider"></div>

        <Section1 />
        
        <div class="horizontal-divider"></div>

        <Section2 />
        
        <div class="horizontal-divider"></div>

        <Section3 />
        
        <div class="horizontal-divider"></div>

        <Section4 />
        
        <div class="horizontal-divider"></div>

        <Section5 />
        
        <div class="horizontal-divider"></div>
        
        <Section6 />
        
        <div class="horizontal-divider"></div>
        
        <Section7 />
    </div>
</Layout>