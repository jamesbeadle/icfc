<script>

    import HeaderContentSection from "../shared/header-content-section.svelte";
    import MultiLineContentSection from "../shared/multi-line-content-section.svelte";
    import WhitepaperPage from "./whitepaper-page.svelte";
    import WhitepaperSection from "./whitepaper-section.svelte";

</script>
<WhitepaperPage 
    title="The ICFC DAO" 
    intro="The ICFC utility token is used throughout our ecosystem within various governance, payment and reward mechanisms.
        Each mechanism has been carefully thought out to balance token supply through the online services we offer.">
    
        <WhitepaperSection title="ICFC Ecosystem Tokenisation Mechanisms">
            <HeaderContentSection title="Proof-Of-Stake Membership" content="The ICFC uses a new Proof-Of-Stake membership mechanism to reward users for their long term commitment to the ICFC. Users claim their membership by linking their profile to a non-dissolving staked neuron, allowing them to receive membership benefits across our ecosystem." />
            <HeaderContentSection title="The Ultimate Burning Mechanism" content="Our ecosystem is designed to maximise the available tokens for burning, ensuring the DAO can control the token supply. 
            We have designed our expected highest revenue raising application, Jeff Bets, to only utilise the ICFC token and burn any losing bet stakes.
            We aim to ensure the token supply is non-inflationary, repeatedly burning down to our starting token supply of 100M ICFC tokens.
                 " />
            <HeaderContentSection title="Governance Rewards" 
                content="ICFC apps use real time data that is verified through our governance data platform, Football God. 
                This platform ensures we own our own data, keeping us free from any third party dependencies.
                Users can then earn ICFC through voting to verify this data. These rewards are minted and added to the total token supply." />
            <HeaderContentSection title="Minting" content="
                The ICFC DAO attracts users by providing rewards in our free to play games, provided users have claimed a valid membership.
                These rewards give the DAO another tokenomic lever to pull, allowing us to reward members for winning in OpenFPL, OpenWSL and any other future games we create." />
        </WhitepaperSection>
    


</WhitepaperPage>