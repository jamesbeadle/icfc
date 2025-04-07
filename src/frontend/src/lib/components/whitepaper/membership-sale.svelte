<script>

    import HeaderContentSection from "../shared/header-content-section.svelte";
    import ListSection from "./list-section.svelte";
    import WhitepaperPage from "./whitepaper-page.svelte";
    import WhitepaperSection from "./whitepaper-section.svelte";

</script>
<WhitepaperPage
    title="Membership Sale: Financial Focus"
    intro="A swap will occur from April 2025 onwards, if successful, decentralising 10% of the ICFC platform.">
    

    <WhitepaperSection title="Token Sale">
        <p>10 million ICFC is now on sale via <a href="https://icfc.app/sale">icfc.app/sale</a> to raise ICP for the continued development of our football ecosystem. We aim to secure our gambling license within the next few months, enabling the ICFC token to be the first SNS token to receive a license to offer fixed odds betting in 170+ countries, including the UK.</p>
        <ListSection
            title="ICFC Swap Details"
            items={[
                "ICFC to be swapped: 10 million.",
                "Swap Currency: ICP.",
                "Raising 33,000 ICP @ 0.0033 ICP per ICFC."
            ]}
        />
        
        <ListSection
            title="Purpose of Funds"
            items={[
                "On-going development, marketing and promotional cost of the ICFC ecosystem.",
                "On-going fees in relation to securing a Internet Computer Protocol based gambling license.",
                "10% of the raise will be used to create a new liquidity pool on Kong Swap, aiming to stabilise our price at this higher level."
            ]}
        />     
    </WhitepaperSection>

    <WhitepaperSection title="Token Vesting Schedule:">
        <HeaderContentSection title='Dissolve Delays' content="Tokens are securely locked in six non-dissolving neurons with delays equally staggered ranging from 3 months of point of purchase and then 5 X 6 month installments thereafter." />
        <HeaderContentSection title='Liquid Tokens' content="When fully dissolved, liquid ICFC tokens are added to your ICFC wallet balance. Participants can log into the ICFC platform to track the dissolution of their ICFC neurons, confirming the amount that becomes liquid." />
    </WhitepaperSection>

    <p>
        After the sale the Waterway Labs will remain in control of the ICP raised, allowing them to fund the on-going costs associated with delivering the ICFC ecosystem.
    </p>

    <p class="small-header">
        The Waterway Labs Team 
    </p>

    <p>
        The largest use of the funds raised will be to fund our team, currently managing a suite of applications with large potential.
    </p>

    <p>
        We aim to grow our development and promotional teams, delivering more products, features and promotional events to further the cause of the Internet Computer.
    </p>

</WhitepaperPage>