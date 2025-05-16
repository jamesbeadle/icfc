<script lang="ts">

    interface Props {
      closeModal: () => void;
    }

    let { closeModal } : Props = $props();
  
    const apps = [
      { name: "Football God", description: "A fully decentralised football dataset, managed by the fans.", link: "https://footballgod.xyz" },
      { name: "OpenFPL", description: "Web3 Fantasy Football.", link: "https://openfpl.xyz" },
      { name: "Transfer Kings", description: "Official ICFC Trading Card Game.", link: "https://transferkings.xyz" },
      { name: "OpenWSL", description: "Web3 Fantasy Football.", link: "https://openwsl.xyz" },
      { name: "Jeff Bets", description: "Converastional AI powered fixed odds pattern based betting.", link: "https://jeffbets.com" }
    ];
  </script>
  
  <div class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
    <div class="bg-white rounded-lg shadow-lg max-w-md w-full p-6 transform transition-all duration-300 scale-100">
      
      <div class="flex justify-between items-center border-b pb-3">
        <h2 class="text-xl font-bold text-BrandGrayShade5">Link your ICFC Accounts</h2>
        <button onclick={closeModal} class="text-BrandGrayShade3 hover:text-BrandGrayShade3 transition duration-200">
          ✖
        </button>
      </div>

      <div class="mt-4 space-y-4">
        {#each apps as app}
          <a href={app.link} target="_blank" class="block p-3 border rounded-lg hover:bg-BrandGrayShade2 transition duration-200">
            <h3 class="text-lg font-semibold text-BrandGrayShade5">{app.name}</h3>
            <p class="text-sm text-BrandGrayShade3">{app.description}</p>
          </a>
        {/each}
      </div>

      <div class="mt-4 flex justify-end">
        <button onclick={closeModal} class="px-4 py-2 bg-BrandBlue text-white rounded-lg hover:bg-BrandYellow transition duration-200">
          Close
        </button>
      </div>

    </div>
  </div>