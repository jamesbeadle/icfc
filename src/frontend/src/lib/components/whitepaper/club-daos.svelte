<script>

    import HeaderContentSection from "../shared/header-content-section.svelte";
    import ListSection from "./list-section.svelte";
    import WhitepaperPage from "./whitepaper-page.svelte";
    import WhitepaperSection from "./whitepaper-section.svelte";

</script>
<WhitepaperPage 
    title="The Future of ICFC"
    intro="ICFC will empower fans to own and have their say in club decisions. 
        This new ownership structure will increase global club engagement through content related to real time decisions fans will make.">

        <WhitepaperSection title="Real Club Management">

            <p>Upon successful completion of our second decentralisation we will begin the process to purchase a UK football club within the professional English football league pyramid.</p>
        
            <p>We will showcase the unique abilities of the SNS governance procedure provided by the Internet Computer through the popular medium of showcasing the running of a football club through an online show.</p>
    
            <p>
                Think of Wrexham’s Hollywood-backed resurgence - The ICFC DAO will merge football, entertainment & blockchain into a new medium where fans truly engage with their football club. This new medium will heavily feature the capabilities of the ICP blockchain (internetcomputer.org), enabling it to become a household name among everyday people.
            </p>
            
            <p>
                To enhance and streamline this model, ICFC is exploring a strategic partnership with consultants who work directly with football clubs. This collaboration would facilitate the development of an automated system designed to handle the acquisition, management, and decentralisation process, ensuring a seamless transition of governance to the fans. 
            </p>
    
            <p>
                For many club owners, selling a club isn’t just a financial transaction, it’s about safeguarding their legacy and ensuring the long-term success of the club. Community-led solutions like ICFC’s decentralised governance model offer an attractive pathway for these owners, providing a future where clubs remain deeply connected to their supporters, rather than being subject to short-term commercial interests. 
            </p>

        </WhitepaperSection>


        <WhitepaperSection title="Club DAO Governance">
 
            <p>
                ICFC empowers fans and stakeholders to participate in club decisions by operating on a fully decentralised blockchain.
            </p>
            <ListSection
                title="Club DAO Proposal Types"
                items={[
                    "Add & remove a player to the club’s scout, transfer & loan list.",
                    "Create, renegotiate or terminante a player's contract as a group.",
                    "Hire & fire the team's manager as a group.",
                    "Add & remove the captaincy of a club.",
                    "Sponsorship deal approvals.",
                    "Manage club branding, marketing & sponsorship decisions.",
                    "Propose facilities upgrades and general fan motions."
                ]}
            />
        
            <p>
                We aim to bring in these features over time to ensure the stable success of each football club the DAO controls.
            </p>


        </WhitepaperSection>


        <WhitepaperSection title="Club DAO Tokens">
    
            <ListSection
                title="Initial Token Distribution"
                items={[
                    "Historic Supporters: 25%.",
                    "Season Supporters: 25%.",
                    "Club Treasury (For club events & player social media promotion): 40%.",
                    "ICFC: 10%."
                ]}
            />

        </WhitepaperSection>

        <WhitepaperSection title="Attendance-Based Decentralisation">

            <p>
                Fans who purchase tickets to ICFC club matches will receive Club DAO tokens as part of the transaction. 
                These tokens represent governance rights within the club’s decentralised structure, ensuring those who attend and engage with the club, play a key role in decision-making. 
            </p>
        
            <p>
                Unlike a fully open decentralisation sale, this process prioritises attendance-based decentralisation, where active match-going supporters have the opportunity to participate in club governance. This process also ensures that power isn’t distributed anonymously or speculatively and instead aligns with the club’s most engaged and invested fans. 
            </p>
        
            <p>
                Over time, this framework builds a community-driven governance model, where those who contribute to the club’s success on and off the pitch have a say in its future. These fan based decentralisation sales will be run through the ICFC website, with tokens only purchasable through attending club matches & events.
            </p>

        </WhitepaperSection>

        <WhitepaperSection title="Historic Supporters">

            <p>
                Long term supporters of clubs that are purchased will be invited to attend in person events, where they’ll be rewarded with a Historic Supporter Neuron. This will ensure that fans are well-equipped to ensure they know how to govern their club.
            </p>
        

        </WhitepaperSection>


        <p>
            All tokens received by fans are locked for one year from the received date. After which, fans can begin dissolving their tokens, setup liquidity pools and trade them.
        </p>


        <WhitepaperSection title="Inflationary Control">
            <p>
                Each season an additional 25% of the Club DAO tokens are minted to drive attendance, engagement and promotion. This inflationary mechanism ensures control of a club's decision making is organically transferred to new fans each season.
            </p>

            <p>
                Every year, a larger number of tokens is minted than in the previous year, ensuring that ownership primarily rests with recent attendees while earlier participation gradually carries less weight.
            </p>

            <p>
                Fans who stake their Club DAO tokens will earn maturity interest as a reward for keeping their neurons active. Maturity interest figures will be set inline with the ICFC DAO and can be changed by the Club DAO by proposal.
            </p>
        </WhitepaperSection>

        <WhitepaperSection title="ICFC Club DAO Tokens">
            
            <p>
                The ICFC DAO will retain a small stake and minor voting power (10%) in every club purchased to ensure it can guide fans on the broader ecosystem goals.
            </p>


            <ListSection
                title="ICFC Responsibilities"
                items={[
                    "Allocate capital raised to purchase clubs.",
                    "Providing standardised smart contracts and voting structures for clubs.",
                    "Managing token liquidity pools.",
                    "Proposing high-level strategies that impact the entire ecosystem.",
                    "Strengthening financial resilience and treasury stability via on-chain mechanisms."
                ]}
            />

            <p>
                All tokens acquired by the ICFC DAO for governance purposes will remained staked.
            </p>

        </WhitepaperSection>

        <p class="small-header">
            Revenue Allocation & Club Independence Statement
        </p>

        <p>
            All earnings generated on match days are the sole revenue of the individual clubs.  This income is dedicated exclusively to the club’s operations, development, and community activities. No portion of match day revenue will be diverted into any communal fund.
        </p>

</WhitepaperPage>