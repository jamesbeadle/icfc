<script lang="ts">
    import FootballGodIcon from "$lib/icons/football-god-icon.svelte";
    import JeffBetsIcon from "$lib/icons/jeff-bets-icon.svelte";
    import OpenfplIcon from "$lib/icons/openfpl-icon.svelte";
    import OpenwslIcon from "$lib/icons/openwsl-icon.svelte";
    import TransferKingsIcon from "$lib/icons/transfer-kings-icon.svelte";
    import type { Writable } from "svelte/store";

    export let showApps: Writable<Boolean>;
  
    const closeModal = () => {
      $showApps = false;
    };
  
    const apps = [
      { name: "Football God", description: "A fully decentralised football dataset, managed by the fans.", link: "https://footballgod.xyz", icon: FootballGodIcon, fill: 'white', background: 'fgbg', size: 'w-7 mr-2' },
      { name: "OpenFPL", description: "Web3 Fantasy Football.", link: "https://openfpl.xyz", icon: OpenfplIcon, fill: '', background: 'ofplbg', size: 'w-6 mr-2' },
      { name: "OpenWSL", description: "Web3 Fantasy Football.", link: "https://openwsl.xyz", icon: OpenwslIcon, fill: '', background: 'owslbg', size: 'w-6 mr-2' },
      { name: "Transfer Kings", description: "Collect Official ICFC Trading Cards.", link: "https://transferkings.xyz", icon: TransferKingsIcon, fill: '', background: 'tkbg', size: 'w-7 mr-2' },
      { name: "Jeff Bets", description: "Converastional AI powered fixed odds pattern based betting.", link: "https://jeffbets.com", icon: JeffBetsIcon, fill: '', background: 'jbbg', size: 'w-5 mr-3' },
    ];
  </script>
  
  {#if $showApps}
    <div class="fixed inset-0 flex justify-center items-center z-50">
      <div class="bg-BrandGrayShade1 rounded-lg shadow-lg max-w-md w-full p-6 transform transition-all duration-300 scale-100">
        
        <div class="flex justify-between items-center border-b pb-3">
          <h2 class="text-xl font-bold cta-text text-BrandGrayShade5">ICFC Apps</h2>
          <button on:click={closeModal} class="text-BrandGrayShade5 hover:text-BrandGrayShade3 transition duration-200">
            ✖
          </button>
        </div>
  
        <div class="mt-4 space-y-4">
          {#each apps as app}
            <a href={app.link} target="_blank" class={`block p-4 border rounded transition duration-200 text-black ${app.background}` }>
              <span class="flex flex-row items-center mb-2">
                <svelte:component
                  this={app.icon}
                  className={app.size}
                  fill={app.fill}
                />
                <h3 class="text-lg font-semibold">{app.name}</h3>
              </span>
              
              <p class="text-sm">{app.description}</p>
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
  