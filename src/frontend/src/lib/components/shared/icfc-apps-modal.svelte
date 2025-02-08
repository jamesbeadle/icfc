<script lang="ts">
    import { createEventDispatcher } from "svelte";
  
    export let isOpen: boolean = false;
    const dispatch = createEventDispatcher();
  
    const closeModal = () => {
      dispatch("close");
    };
  
    const apps = [
      { name: "OpenFPL", description: "Fantasy football with Web3 governance.", link: "https://openfpl.app" },
      { name: "ICFC Club Governance", description: "Decentralized club management system.", link: "https://icfc.app" },
      { name: "Scout Network", description: "Earn ICFC for scouting football talent.", link: "https://scout.icfc.app" },
      { name: "Fan Engagement", description: "Vote on club decisions and influence your team.", link: "https://fans.icfc.app" },
    ];
  </script>
  
  <!-- Modal Background Overlay -->
  {#if isOpen}
    <div class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50">
      <!-- Modal Container -->
      <div class="bg-white rounded-lg shadow-lg max-w-md w-full p-6 transform transition-all duration-300 scale-100">
        
        <!-- Modal Header -->
        <div class="flex justify-between items-center border-b pb-3">
          <h2 class="text-xl font-bold text-gray-900">ICFC Ecosystem Apps</h2>
          <button on:click={closeModal} class="text-gray-500 hover:text-gray-700 transition duration-200">
            ✖
          </button>
        </div>
  
        <!-- Modal Content -->
        <div class="mt-4 space-y-4">
          {#each apps as app}
            <a href={app.link} target="_blank" class="block p-3 border rounded-lg hover:bg-gray-100 transition duration-200">
              <h3 class="text-lg font-semibold text-gray-800">{app.name}</h3>
              <p class="text-sm text-gray-600">{app.description}</p>
            </a>
          {/each}
        </div>
  
        <!-- Modal Footer -->
        <div class="mt-4 flex justify-end">
          <button on:click={closeModal} class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition duration-200">
            Close
          </button>
        </div>
  
      </div>
    </div>
  {/if}
  