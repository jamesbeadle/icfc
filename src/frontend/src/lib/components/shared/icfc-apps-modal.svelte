<script lang="ts">
    import { createEventDispatcher } from "svelte";
  
    export let isOpen: boolean = false;
    const dispatch = createEventDispatcher();
  
    const closeModal = () => {
      dispatch("close");
    };
  
    const apps = [
      { name: "FootballGod", description: "A fully decentralised football dataset, managed by the fans.", link: "https://footballgod.xyz" },
      { name: "OpenFPL", description: "Web3 Fantasy Football.", link: "https://openfpl.xyz" },
      { name: "OpenWSL", description: "Web3 Fantasy Football.", link: "https://openwsl.xyz" },
      { name: "Jeff Bets", description: "Converastional AI powered fixed odds pattern based betting.", link: "https://jeffbets.com" }
    ];
  </script>
  
  {#if isOpen}
    <div class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
      <div class="bg-white rounded-lg shadow-lg max-w-md w-full p-6 transform transition-all duration-300 scale-100">
        
        <div class="flex justify-between items-center border-b pb-3">
          <h2 class="text-xl font-bold text-gray-900">ICFC Apps</h2>
          <button on:click={closeModal} class="text-gray-500 hover:text-gray-700 transition duration-200">
            ✖
          </button>
        </div>
  
        <div class="mt-4 space-y-4">
          {#each apps as app}
            <a href={app.link} target="_blank" class="block p-3 border rounded-lg hover:bg-gray-100 transition duration-200">
              <h3 class="text-lg font-semibold text-gray-800">{app.name}</h3>
              <p class="text-sm text-gray-600">{app.description}</p>
            </a>
          {/each}
        </div>
  
        <div class="mt-4 flex justify-end">
          <button on:click={closeModal} class="px-4 py-2 bg-BrandBlue text-white rounded-lg hover:bg-BrandYellow transition duration-200">
            Close
          </button>
        </div>
  
      </div>
    </div>
  {/if}
  