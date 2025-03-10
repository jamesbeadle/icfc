<script>

    import HeaderContentSection from "../shared/header-content-section.svelte";
    import ListSection from "./list-section.svelte";
    import WhitepaperPage from "./whitepaper-page.svelte";
    import WhitepaperSection from "./whitepaper-section.svelte";

</script>
<WhitepaperPage
    title="Artificial Intelligence"
    intro="The ICFC ecosystem is perfectly positioned to utilise in-house LLMs, analytical and predictive models to utliise artificial intelligence & drive decentralised AI development with real world use cases.">

        <ListSection
            title="Objectives"
            items={[
                "Automate, expand and improve the capture of all football data.",
                "Provide new chat based conversational AI experiences that interact with our football ecosystem to boost user engagement.",
                "Provide advanced financial protections that enable the system to operate within safe yet attractive limits.",
                "Highlight the advancements in AI tooling on the Internet Computer blockchain by utilising new features within our real world use cases."
            ]}    
        />

        <WhitepaperSection title="A Complete Football Dataset">


            <HeaderContentSection 
                title="Extending Our Dataset"
                content="We will develop in-house models that utilise our existing dataset to extend the data categories managed by Football God. Football God will contain comprehensive stats for all leagues and eras, using generative techniques to fill data gaps and automate data population."
             />
            

            <HeaderContentSection 
                title="Verification"
                content="We will build data pipelines that ensure all data captured and entered via the DAO's governance system is verified by a range of available sources."
             />

            <p>
                This dataset will ensure the ICFC is the decentralised source of truth for all of football data.
            </p>


        </WhitepaperSection>



        <WhitepaperSection title="Conversational AI Experiences">
            
            <p class="small-header">
                Jeff Bets Conversational AI
            </p>

            <p>
                Conversational AI experiences are the natural progression for the medium in which users interact with applications. 
                We are focused on this next generation of user experience, beginning with introducing our first AI agent within the Jeff Bets platform.
            </p>

            <p>
                Jeff Bets is designed to use an in-house developed conversational LLM to enable a completely new way for football fans to bet. 
                Fans will be able to have a more natural conversation around football, identifying key patterns to bet on rather than just picking attractive odds. 
                This new way of betting gives fans the experience of not knowing which bets will be placed and the excitement of knowing when they are, it's based of a pattern they've predicted.
            </p>
            
            
            <p class="small-header">
                OpenFPL Assistant Manager
            </p>

            <p>
                After we have setup our first AI on Jeff Bets we would look to create an assistant manager agent within our fantasy football apps, allowing users to more naturally obtain and utilise football statistics when setting up their fantasy football team.
            </p>


        </WhitepaperSection>



        <WhitepaperSection title="Advanced Financial Controls">
            
            <p class="small-header">
                Jeff Bets Allowable Stake Calculation
            </p>

            <p>
                We will use AI to more precisely predict the amount of ICFC that can be wagered at any one time. This figure can be far more accurate using an AI's ability to check all possible result combination payout totals in relation to each other.
            </p>

            <p>
                This will enable Jeff Bets to provide attractive yet safe system betting limits, ensure token holders are protected.
            </p>

            <p class="small-header">
                Tokenomics AI
            </p>

            <p>
                We will develop an ecosystem AI bot that will manage the varied and complex tokenomic levers availabe to the DAO. This bot will manage token unlock schedules, when to burn or buy ICFC to ensure our token supply is kept and a level in the best interest of token holders.
            </p>
            
        </WhitepaperSection>

        

        <WhitepaperSection
            title="The Road to Decentralised AI"
        >

        <p>
            Decentralised AI (DeAI) is a target we aim to reach incrementally, step by step, rather than claiming it prematurely. The journey involves disparate elements that, when unified, form a compelling vision for the future.
        </p>

        <HeaderContentSection 
            title="Computational Power and Optimisation"
            content="A key challenge lies in computational resources. The current architecture relies on CPU-based computation nodes, which presents limitations. To address this, we propose a hybrid approach: off-chain pre-training paired with on-chain inference to optimise resource use. We’re also exploring the potential for GPU-based nodes to future-proof the system, pending resource availability and ecosystem advancements."
        />

        <HeaderContentSection 
            title="Tackling Hallucinations"
            content="AI hallucinations—where models generate inaccurate or fabricated outputs—are a challenge, especially when datasets are small. Initially, our models may encounter this issue due to limited data size. However, as we grow and feed more data points into our system, our datasets will expand, enabling our models to improve continuously. The more data we integrate, the more effectively we overcome hallucinations, refining the accuracy and reliability of our AI tools."
        />

        <HeaderContentSection 
            title="Governance and Tokenomics"
            content="While an AI agent will play an advisory role in creating tokenomic schedules, the DAO retains ultimate authority over their approval and implementation. This ensures that human oversight guides the process, balancing innovation with accountability."
        />

        <HeaderContentSection 
            title="Resource Allocation"
            content="Funds raised through the decentralisation sale will be strategically invested in hiring skilled staff, acquiring additional hardware, and covering processing costs. Funds used will be subject to funding availability and DAO approval. This approach ensures sustainable growth and long-term commitment to our mission."
        />

        <HeaderContentSection 
            title="Building On-Chain Expertise"
            content="Waterway Labs will harness existing in-house expertise to develop and refine large language models (LLMs), analytical tools, and predictive models—all working toward fully decentralised AI running 100% on-chain. By keeping all data verified and stored on-chain under DAO oversight, we gain a competitive edge. This contrasts with projects that rely on centralised data or off-chain processing, positioning us as leaders in data ownership and on-chain AI execution."
        />

        <HeaderContentSection 
            title="Enhancing Infrastructure"
            content="We’ll collaborate with ecosystem partners to strengthen subnets, exploring GPU-based enhancements for greater computational power. Our goal is to upgrade canisters to handle real-time conversational workloads, leveraging the platform’s HTTP-serving capabilities to deliver seamless, practical use cases."
        />

        </WhitepaperSection>
    
        
    
</WhitepaperPage>