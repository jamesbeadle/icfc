<script lang="ts">
    import MultiLineContentSection from "../shared/multi-line-content-section.svelte";
    import WhitepaperPage from "./whitepaper-page.svelte";
    import WhitepaperSection from "./whitepaper-section.svelte";
    import IcfcAppsModal from "../shared/icfc-apps-modal.svelte";

    let showApps = $state(false);
</script>

<WhitepaperPage 
    title="ICFC Apps: An Ecosystem Powered by Governance"
    intro="
        Our ecosystem of applications run 100% on-chain with zero dependencies. 
        This is acheived through owning our underlying dataset, validating it using the DAO's governance system.
        We have taken great care to create applications that have their own brands, 
        ensuring they can form their own community within our football ecosystem.">

    <button 
        slot="action"
        class="flex items-center gap-2 px-4 py-2 text-white transition bg-blue-600 rounded-md hover:bg-blue-500"
        onclick={() => showApps = true}
    >
        View Apps
    </button>

    <WhitepaperSection title="ICFC Product Ecosystem">

            <MultiLineContentSection 
                title='Governance Data: Football God'
                titleColor="FootballGodBackground"
                content={[
                    "Football God is the brain of the ICFC ecosystem, distributing messages to each ICFC application, allowing them to react to data updates in real time. ", 
                    "As our dataset becomes the single source of truth for all football data, other projects can integrate Football God’s dataset by purchasing API access to this valuable asset. This revenue generation model allows third-party developers to tap into this football data resource, reinforcing ICFC’s position at the forefront of decentralised football data.   ",
                    "We plan on utilising our football dataset to train various AI models to extend our dataset and backfill football data, for all leagues, for all of time. We aim for Football God to know everything about football, hold this data on-chain and power more and more fan based experiences."]} 
            />
            
            <MultiLineContentSection 
                title='Fantasy Football: OpenFPL & OpenWSL'
                titleColor="OpenFPLBackground"
                secondTitleColor="OpenWSLBackground"
                content={[
                    "OpenFPL is the ICFC's Premier League fantasy football game, meticulously designed to allow fans to show off in-depth footballing knowledge. ",
                    "We have designed OpenFPL's reward system to ensure users engage with the platform frequently, spreading out rewards over various timeframes. We have created a range of reward categories each tailored to ensure the appropriate recognition is given to players who top leaderboards or set new records. ",
                    "OpenFPL aims to generate revenue from private leagues & merchandise sales along with continued sponsorship revenue. OpenFPL rewards are funded by the ICFC DAO treasury with a plan to fund a WSL version of our fantasy football game, branded as OpenWSL.",]} 
            />
             
             <MultiLineContentSection 
                title='Trading Cards: Transfer Kings'
                titleColor="TransferKingsBackground"
                content={[
                    "Transfer Kings is our official ICFC digital trading card game, modernising the excitement of collecting rare football cards through utilising new and exciting technology. ",
                    "These real-time, up-to-date football cards allow fans to build their collections with unique rarity stats, linked to their form. ",
                    "Transfer Kings has been designed to reward fans who engage with football in real time, allowing them to put together truly unique collections.",]} 
            />
            
            <MultiLineContentSection 
                title='Betting: Jeff Bets' 
                titleColor="JeffBetsBackground"
                content={[
                    "Jeff Bets is our fully denetralised fixed-odds betting platform (gambling license pending). The odds on Jeff Bets are calculated in real time by the verification of data through the ICFC DAO, allowing users to bet on games in any league. ",
                    "With Jeff Bets, you don’t need to risk your own money. Win tokens through ICFC’s fantasy football leagues and use them to place bets, creating a sustainable, risk-free model designed to protect fans. ",
                    "Jeff Bets will be at the core of ICFC’s economic stability, providing a large burning pressure on the tokens that can always be offset by providing more rewards to users in our other game applications. ",
                    "Jeff Bets will evolve to use conversational AI to create a game-changing new betting medium. We plan to gi ve users access to 'Jeff', an engaging conversational AI experience users can utilse to create better betting strategies. Jeff will allow users to create custom betting rules that are only triggered if other events occur, allowing users to gamble using thoughtful discussion to generate patterns over just selecting large odds. ",
                    "We’ve entered a world where AI-powered systems operate at levels designed to maximise user enjoyment. With Jeff, betting becomes a dynamic, intelligent process. Merging AI, social interaction and cutting-edge technology  - creating a new way to experience sports betting. "]} 
            />
        </WhitepaperSection> 
</WhitepaperPage>

<IcfcAppsModal 
    isOpen={showApps} 
    onClose={() => showApps = false} 
/>
