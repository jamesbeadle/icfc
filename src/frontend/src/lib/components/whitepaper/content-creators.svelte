<script>
    import ListSection from "./list-section.svelte";
    import WhitepaperPage from "./whitepaper-page.svelte";
    import WhitepaperSection from "./whitepaper-section.svelte";

</script>
<WhitepaperPage 
    title="Content Creators"
    intro="ICFC is transforming football media by creating a community-powered platform where fans become the creators and investors in the content they love. Whether it's articles, podcasts or even future immersive extended reality experiences, ICFC provides the infrastructure for supporters to build their own Football Channels, monetise their work and compete in a fan-driven media landscape.">

    
    <WhitepaperSection title="Create your own Football Channel">

        <p>
            ICFC allows writers, podcasters and content creators to establish their own Football Channel within a decentralised ecosystem. By purchasing a verified Football Channel account, users gain access to a suite of powerful tools designed to help them.
        </p>

        <ListSection
            title="Creator Tools"
            items={[
                "Build an audience through a customisable content hub.",
                "Publish exclusive articles and host podcasts.",
                "Monetise content through subscriptions, sponsorships and token incentives.",
                "Engage with fans & compete against rival club creators."
            ]}
        />

        <p>
            A small percentage of each purchase is allocated to the DAO, helping to sustain and grow the ICFC ecosystem. 
        </p>

        <p>
            ICFC becomes the home of club-specific podcasts, making it easier for fans to discover authentic voices covering their team - whether it's match analysis, tactical breakdowns, transfer news or in-depth discussions. Fans can subscribe to their favourite writers and podcasters through premium content models, unlocking bonus episodes, behind-the-scenes insights and interactive Q&As.
        </p>

    </WhitepaperSection>

    
    <WhitepaperSection title="Channel Graduation">

        <p>
            To ensure efficient growth without unnecessary costs, ICFC will implement a canister graduation system for Football Channels. This dynamic scalability model will optimise storage and computational resource costs.
        </p>

        <ListSection 
            title="Graduation Process"
            items={[
                "New creators begin by sharing a canister with other early-stage channels, keeping costs low while allowing content to grow organically.",
                "Once a channel reaches a defined popularity threshold, it graduates to its own dedicated canister, ensuring increased storage and faster load times.",
                "This approach ensures that rising creators gain resources when they need them, while keeping ICFC's infrastructure cost-effective. "
            ]}
        
        />
        
        
    </WhitepaperSection>

    
    <WhitepaperSection title="Decentralised, Community-Driven Football Media">

        <p>
            ICFC's Football Channels break away from the centralised control of mainstream media, empowering fans to own and control their content. By decentralising football journalism and media production, ICFC creates an environment where engagement, insight and storytelling thrive.
        </p>

        <p>
            This isn't just about content creation - it's a revolution in how football content is created, consumed and monetised.
        </p>
        
    </WhitepaperSection>


</WhitepaperPage>