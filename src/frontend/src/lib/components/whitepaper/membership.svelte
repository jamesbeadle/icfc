<script>

    import HeaderContentSection from "../shared/header-content-section.svelte";
    import ListSection from "./list-section.svelte";
    import WhitepaperPage from "./whitepaper-page.svelte";
    import WhitepaperSection from "./whitepaper-section.svelte";

</script>
<WhitepaperPage
    title="ICFC Membership: Join the Club"
    intro="ICFC’s membership-based revenue model is structured around staking-based access, ensuring that governance is community-driven while also generating revenue through token utility.">
    
    <WhitepaperSection
    title="Proof-of-Stake Membership">
        <p>
            ICFC membership is designed to reward long-term commitment to the ecosystem while providing exclusive benefits to supporters. 
            Membership tiers are structured around staking ICFC, ensuring alignment with the growth and sustainability of the community.
        </p>
    </WhitepaperSection>

    <WhitepaperSection
    title="Membership Tiers, Benefits & Rewards">
        <HeaderContentSection title='Monthly Membership' content="Available by staking 1,000 ICFC for the maximum duration." />
        <HeaderContentSection title='Seasonal (July - August) Membership' content="Requires staking 10,000 ICFC for the maximum duration." />
        <HeaderContentSection title='Lifetime Membership' content="Can be claimed by any Internet Identity linked to a neuron with 100,000 ICFC or more, staked for the maximum duration." />


        <p>         
            ICFC membership is dynamic, with numbers fluctuating based on the value and supply of ICFC tokens, ensuring a truly community-driven and market-responsive system.
        </p>
    
        <ListSection
            title="Benefits & Rewards"
            items={[
                "Eligibility to receive in-game ICFC tokens rewards on play for free ICFC platforms like OpenFPL & OpenWSL.",
                "Enhanced profile recognition on the ICFC website, with an official membership status displayed.",
                "Enhanced profile recognition in all related linked ecosystem apps profiles (Football God, OpenFPL, OpenWSL, Transfer Kings & Jeff Bets).",
                "Free Private Leagues on OpenFPL & OpenWSL.",
                "Free bets on Jeff Bets.",
                "Free Transfer King Card Packs.",
                "Merchandise giveaways.",
                "Tickets to ICFC football club events and matches.",
                "Entry into prize draws featuring exclusive rewards."
            ]}
        />

        <p>
            By participating, members not only gain valuable rewards, but also contribute to the development of a decentralised football community. 
        </p>


    </WhitepaperSection>
    
    
</WhitepaperPage>
    
<p class="text-xs">
    Note: Free Bets on Jeff Bets
</p>

<p class="text-xs">
    Free bets will be 1% of the total bets placed on Jeff Bets. This 1% will be placed into a free bet pool and then distributed to the number of players based on their membership. A month where more bets are placed will result in an increased value in the betting pool as the amount of ICFC placed is greater. 
</p>