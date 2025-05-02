<script lang="ts">
  import Modal from "./global/modal.svelte";
  import FootballGodBackground from "$lib/icons/appIcons/background/FootballGodIcon.svelte";
  import OpenFplBackground from "$lib/icons/appIcons/background/OpenFplIcon.svelte";
  import TransferKingsBackground from "$lib/icons/appIcons/background/TransferKingsIcon.svelte";
  import JeffBetsBackground from "$lib/icons/appIcons/background/JeffBetsIcon.svelte";
  import FootballGodLogo from "$lib/icons/appIcons/logo/FootballGodLogo.svelte";
  import OpenFplLogo from "$lib/icons/appIcons/logo/OpenFplLogo.svelte";
  import TransferKingsLogo from "$lib/icons/appIcons/logo/TransferKingsLogo.svelte";
  import JeffBetsLogo from "$lib/icons/appIcons/logo/JeffBetsLogo.svelte";
  import AppCard from "$lib/components/shared/app-card.svelte";
  import CloseIcon from "$lib/icons/CloseIcon.svelte";

  interface Props {
    isOpen: boolean;
    onClose: () => void;
    flippedCards: Set<string>;
    onAppClick: (app: { name: string; id: string }) => void;
  }

  let { isOpen, onClose, flippedCards, onAppClick } : Props = $props();

  const apps = [
        {
            id: "01",
            name: "Football God",
            background: FootballGodBackground,
            logo: FootballGodLogo,
            color: "FootballGodBackground",
            textColor: "text-white",
            description: "A fully decentralised football data platform where fans manage and contribute to an open-source football dataset.",
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
            description: "An AI-driven sports betting assistant that analyses patterns and provides insights for fixed-odds betting through a conversational interface.",
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
        }
  ];

  const toggleFlip = (id: string, event: MouseEvent | KeyboardEvent) => {
    event.preventDefault();
    if (!flippedCards) return;
    
    if (flippedCards.has(id)) {
      flippedCards.delete(id);
    } else {
      flippedCards.add(id);
    }
  };

  function handleCardClick(app: { name: string; id: string }) {
    onAppClick(app);
  }
</script>

{#if isOpen}
  <Modal {onClose}>
    <h2 class="text-2xl text-white cta-text">ICFC Apps</h2>
    <div class="flex-1 overflow-y-auto">
      <div class="p-6 pt-4">
        <div class="flex flex-col gap-3 md:flex-row md:overflow-x-auto">
          {#each apps as app}
          <button on:click={() => handleCardClick(app)} class="cursor-pointer">
            <AppCard 
                {app}
                isFlipped={false}
                onFlip={() => {}}
                isModal={true}
                disableFlip={true}
            />
          </button>
          {/each}
        </div>
      </div>
    </div>
  </Modal>
{/if}