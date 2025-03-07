<script lang="ts">
  import FootballGodBackground from "$lib/icons/appIcons/background/FootballGodIcon.svelte";
  import OpenFplBackground from "$lib/icons/appIcons/background/OpenFplIcon.svelte";
  import TransferKingsBackground from "$lib/icons/appIcons/background/TransferKingsIcon.svelte";
  import JeffBetsBackground from "$lib/icons/appIcons/background/JeffBetsIcon.svelte";
  import IcpfaBackground from "$lib/icons/appIcons/background/IcpfaBackground.svelte";
  import FootballGodLogo from "$lib/icons/appIcons/logo/FootballGodLogo.svelte";
  import OpenFplLogo from "$lib/icons/appIcons/logo/OpenFplLogo.svelte";
  import TransferKingsLogo from "$lib/icons/appIcons/logo/TransferKingsLogo.svelte";
  import JeffBetsLogo from "$lib/icons/appIcons/logo/JeffBetsLogo.svelte";
  import IcpfaLogo from "$lib/icons/appIcons/logo/IcpfaLogo.svelte";
  import Layout from "./Layout.svelte";
  import AppCard from "$lib/components/shared/app-card.svelte";

  let flippedCards = new Set();

  const toggleFlip = (id: string, event: MouseEvent) => {
      event.preventDefault();
      if (flippedCards.has(id)) {
          flippedCards.delete(id);
      } else {
          flippedCards.add(id);
      }
      flippedCards = flippedCards;
  };
  
  const apps = [
      {
          id: "01",
          name: "Football God",
          background: FootballGodBackground,
          logo: FootballGodLogo,
          color: "FootballGodBackground",
          textColor: "text-white",
          description: "A fully decentralized football data platform where fans manage and contribute to an open-source football dataset.",
          link: "https://footballgod.xyz",
          backgroundOpacity: "opacity-[0.15]",
          backgroundSize: "w-[80%] h-[80%]",
          backgroundPosition: "-bottom-10 -right-20"
      },
      {
          id: "02",
          name: "OpenFPL",
          background: OpenFplBackground,
          logo: OpenFplLogo,
          color: "OpenFPLBackground",
          textColor: "text-black",
          description: "A Web3-powered fantasy football game that leverages blockchain technology for enhanced transparency and ownership.",
          link: "https://openfpl.xyz",
          backgroundOpacity: "",
          backgroundSize: "w-[58%] h-[58%]",
          backgroundPosition: "-bottom-16 -right-32"
      },
      {
          id: "03",
          name: "OpenWSL",
          background: OpenFplBackground,
          logo: OpenFplLogo,
          color: "OpenWSLBackground",
          description: "A Web3-based fantasy football platform tailored for women's football leagues, offering immersive gameplay and digital asset ownership.",
          textColor: "text-white",
          link: "https://openwsl.xyz",
          backgroundOpacity: "",
          backgroundSize: "w-[58%] h-[58%]",
          backgroundPosition: "-bottom-16 -right-32"
      },
      {
          id: "04",
          name: "Jeff Bets",
          background: JeffBetsBackground,
          logo: JeffBetsLogo,
          color: "JeffBetsBackground",
          textColor: "text-black",
          description: "An AI-driven sports betting assistant that analyzes patterns and provides insights for fixed-odds betting through a conversational interface.",
          link: "https://jeffbets.com",
          backgroundOpacity: "",
          backgroundSize: "w-[92%] h-[92%]",
          backgroundPosition: "-bottom-1 -right-5"
      },
      {
          id: "05",
          name: "Transfer Kings",
          background: TransferKingsBackground,
          logo: TransferKingsLogo,
          color: "TransferKingsBackground",
          textColor: "text-white",
          description: "A next-generation trading card platform where users can collect, trade, and own official ICFC digital cards.",
          link: "https://transferkings.xyz",
          backgroundOpacity: "",
          backgroundSize: "w-[84%] h-[84%]",
          backgroundPosition: "-bottom-10 -right-12"
      },
      {
          id: "06",
          name: "ICPFA",
          background: IcpfaBackground,
          logo: IcpfaLogo,
          color: "BrandGrayShade6",
          textColor: "text-black",
          description: "The ICPFA has been setup to support community grassroots football causes, funded by revenue from our football related applications.",
          link: "https://icpfa.org",
          backgroundOpacity: "opacity-[0.15]",
          backgroundSize: "w-[200%] h-[300%]",
          backgroundPosition: "-bottom-10 -right-1"
      }
  ];
</script>

<Layout>
  <div class="p-8">
      <div class="flex items-center justify-between mb-8">
          <h1 class="text-4xl font-bold text-white shadow-lg cta-text">
              ICFC APPS
          </h1>
      </div>
  
      <div class="grid grid-cols-1 gap-6 pb-8 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5">
          {#each apps as app}
              <AppCard 
                  {app}
                  isFlipped={flippedCards.has(app.id)}
                  onFlip={toggleFlip}
              />
          {/each}
      </div>
  </div>
</Layout>
