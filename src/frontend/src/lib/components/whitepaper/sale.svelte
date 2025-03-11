<script>

    import HeaderContentSection from "../shared/header-content-section.svelte";
    import ListSection from "./list-section.svelte";
    import WhitepaperPage from "./whitepaper-page.svelte";
    import WhitepaperSection from "./whitepaper-section.svelte";

</script>
<WhitepaperPage
    title="Decentralisation Sale 2: Financial Focus"
    intro="A swap will occur throughout April 2025, if successful, decentralising 25% of the ICFC platform.">
    

    <WhitepaperSection title="Token Sale">
        <p>25 million ICFC will be transferred from the ICFC SNS treasury into a swap canister to undertake a fully automated sale.</p>
        <ListSection
            title="ICFC Swap Details"
            items={[
                "ICFC to be swapped: 25 million.",
                "Swap Currency: ckBTC.",
                "Minimum amount for swap to be successful: 50 ckBTC.",
                "Maximum amount to be raised: 100 ckBTC."
            ]}
        />
        
        <ListSection
            title="Purpose of Funds"
            items={[
                "Acquiring a real-world football club.",
                "Continued development & promotion of the ICFC ecosystem.",
                "Providing liquidity for future token trading."
            ]}
        />     
    </WhitepaperSection>

    <WhitepaperSection title="Token Vesting Schedule:">
        <HeaderContentSection title='Dissolve Delays' content="Tokens are securely locked in five non-dissolving neurons with delays equally staggered ranging from 6 months to a 2.5-year delay." />
        <HeaderContentSection title='Liquid Tokens' content="When fully dissolved, liquid ICFC tokens are added to your ICFC wallet balance. Participants can log into the ICFC platform to track the dissolution of their ICFC neurons, confirming the amount that becomes liquid." />
    </WhitepaperSection>

    <p>
        After the sale the DAO will remain in control of the Bitcoin (ckBTC) raised, only withdrawable via a DAO proposal.
    </p>

    <p class="small-header">
        RWA Acquisition 
    </p>

    <p>
        The largest use of the funds raised will be to purchase a UK football club through a broker here in the UK to run through the ICFC DAO. Our aim is to bring the football club under complete control of the DAO, we anticipate future legal frameworks that will make this possible.
    </p>

    <p>
        For clubs acquired by ICFC, their revenue streams will remain fully with each club. This approach ensures that each club retains financial independence and continues to reinvest in its own growth and success, while still benefiting from the strategic support provided by ICFC.
    </p>

</WhitepaperPage>