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
            <HeaderContentSection title="Proof-Of-Stake Membership" content="The ICFC uses a Proof-Of-Stake membership mechanism to ensure the long term staking of ICFC tokens." />
            <HeaderContentSection title="Betting Stake Burning" content="To ensure the maximum control over the ICFC token supply we have designed our ecosystem to ensure we can always burn the token supply down to the starting amount, 100M ICFC tokens.
                To do this we have ensured that our expected highest revenue raising application, Jeff Bets, only utilises the ICFC token and burns losing bet stakes, effectively redistributing the betting profits to the DAO's token holders.
                As mentioned in the product ecosystem section, we will use the losing stakes from our betting platform (Jeff Bets) as a burning mechanism to control total supply. " />
            <HeaderContentSection title="Governance Rewards" content="At the core of our ecosystem is a governance backed dataset. This new ownership paradigm ensures a generous amount of ICFC rewards for staked ICFC neuron holders. 
                These rewards are minted, adding to the total token supply.  " />
            <HeaderContentSection title="Minting" content="The ICFC DAO provides liquidity to application prizes pools by burning the DAO's biggest potential buying pressure, betting stakes on Jeff Bets.
                These prize pools give the DAO another tokenomic lever to pull when needed, allowing us to reward members for winning in OpenFPL, OpenWSL and any other future games we create." />
        </WhitepaperSection>
    


</WhitepaperPage>