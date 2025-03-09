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
                    "Our project centers around our governance backed dataset which powers our suite of applications. ",
                    "ICFC maintains this comprehensive world football database through our governance data management platform, Football God. This database serves as the backbone of ICFC’s digital ecosystem, providing a continuously updated repository of football information. ",
                    
                    "As our dataset becomes the single source of truth for all football data, other projects can integrate Football God’s dataset by purchasing API access to this valuable asset. This revenue generation model allows third-party developers to tap into this football data resource, reinforcing ICFC’s position at the forefront of decentralised football data.   ",

                    "We plan to utilise our football dataset to train an AI to extend and backfill all of football data, for all leagues, for all of time. We aim for Football God to know everything about football, hold this data on-chain and power more and more new fan based experiences."]} 
            />
            
            <MultiLineContentSection 
                title='Fantasy Football: OpenFPL & OpenWSL'
                titleColor="OpenFPLBackground"
                secondTitleColor="OpenWSLBackground"
                content={[
                    "Our flagship product is OpenFPL, a unique fantasy football game built to reward players of fantasy football fairly. ",
                    "OpenFPL is funded through ICFC rewards provided by the ICFC DAO, generating revenue streams from sponsorship income, future private league revenue and merchandise sales.",]} 
            />
             
             <MultiLineContentSection 
                title='Trading Cards: Transfer Kings'
                titleColor="TransferKingsBackground"
                content={[
                    "We’re introducing official ICFC digital trading cards, bringing the excitement of classic football card collecting into the modern era.",
                    "These real-time, up-to-date football cards allow fans to build their collections with limited-time drops, rewarding the most engaged players with unique, collectible assets.",]} 
            />
            
            <MultiLineContentSection 
                title='Betting: Jeff Bets' 
                titleColor="JeffBetsBackground"
                content={[
                    "At the core of ICFC’s economic stability is a revolutionary burning mechanism designed to offset in-game rewards, powered by our very own fixed-odds betting platform, Jeff Bets (gambling license pending).",
                    "This isn’t just another betting platform. With Jeff Bets, you don’t need to risk your own money. Win tokens through ICFC’s fantasy football leagues and use them to place bets, creating a sustainable, risk-free model designed to protect fans.",
                    "Jeff Bets is a burner token, keeping the fun in betting without the financial pitfalls.",
                    "Jeff isn’t only about numbers, he’s your football conversation partner.",
                    "Imagine chatting to Jeff about match predictions, discussing team form, debating transfers, or even crafting custom betting rules based on thoughtful discussions. This is betting in its most engaging, interactive form. Not just transactions, but experiences.",
                    "We’ve entered a world where AI-powered systems operate at levels designed to maximise user enjoyment. With Jeff, betting becomes a dynamic, intelligent process. Merging AI, social interaction and cutting-edge technology  - creating a new way to experience sports betting. "]} 
            />
        </WhitepaperSection> 
</WhitepaperPage>

<IcfcAppsModal 
    isOpen={showApps} 
    onClose={() => showApps = false} 
/>
