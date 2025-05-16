<script lang="ts">
    import type { PrincipalId, SubApp } from "../../../../../declarations/backend/backend.did";
    import DropdownSelect from "../shared/dropdown-select.svelte";

    interface Props {
        appPrincipalIds: Array<[SubApp, PrincipalId]>;
    }

    let { appPrincipalIds } : Props = $props();
  
    let isOpen = $state(false);
    let selectedApp: SubApp | null = $state(null);
    let principalId: string = $state("");
    let errorMessage: string = $state("");
  
    const availableApps = [
      { value: { OpenFPL: null }, label: "OpenFPL" },
      { value: { OpenWSL: null }, label: "OpenWSL" },
      { value: { FootballGod: null }, label: "Football God" },
      { value: { TransferKings: null }, label: "Transfer Kings" },
      { value: { JeffBets: null }, label: "Jeff Bets" },
    ].filter(app => !isAppAdded(app.value))
    .map(app => ({ id: app.label, label: app.label }));
  
    function isAppAdded(app: SubApp): boolean {
      return appPrincipalIds.some(([existingApp]) => 
        JSON.stringify(existingApp) === JSON.stringify(app)
      );
    }
  
    function addAppPrincipal() {
      if (!selectedApp) {
        errorMessage = "Please select an app";
        return;
      }
  
      if (!principalId.trim()) {
        errorMessage = "Please enter a Principal ID";
        return;
      }
  
      if (principalId.length < 10) {
        errorMessage = "Invalid Principal ID format";
        return;
      }
  
      if (isAppAdded(selectedApp)) {
        errorMessage = "This app is already added";
        return;
      }
  
      if (appPrincipalIds.length >= 5) {
        errorMessage = "You can only add up to 5 Principal IDs";
        return;
      }
  
      appPrincipalIds = [...appPrincipalIds, [selectedApp, principalId]];
      selectedApp = null;
      principalId = "";
      errorMessage = "";
    }
  
    function removeAppPrincipal(appToRemove: SubApp) {
      appPrincipalIds = appPrincipalIds.filter(([app]) => 
        JSON.stringify(app) !== JSON.stringify(appToRemove)
      );
    }
  
    function toggleAccordion() {
      isOpen = !isOpen;
    }
  
    function getAppBackground(app: SubApp): string {
      const appKey = Object.keys(app)[0];
      switch (appKey) {
        case "OpenFPL":
          return "bg-OpenFPLBackground";
        case "OpenWSL":
          return "bg-OpenWSLBackground";
        case "FootballGod":
          return "bg-FootballGodBackground";
        case "TransferKings":
          return "bg-TransferKingsBackground";
        case "JeffBets":
          return "bg-JeffBetsBackground";
        default:
          return "bg-BrandGray";
      }
    }
  </script>
  
  <div class="my-6 !bg-BrandBlack min-h-screen p-6">
    <div class="max-w-2xl mx-auto">
      <div class="border border-ModalBorder rounded-lg shadow-lg bg-ModalBackground bg-opacity-90 backdrop-blur-sm">
        <button 
          class="w-full p-4 text-left bg-BrandBlack rounded-t-lg flex justify-between items-center hover:bg-BrandGray transition-all duration-300"
          onclick={toggleAccordion}
        >
          <h3 class="text-xl font-semibold !text-white">App Principal IDs (Optional)</h3>
          <span class="text-BrandBlue">{isOpen ? '▼' : '▶'}</span>
        </button>
        
        {#if isOpen}
          <div class="!p-6 border-t border-ModalBorder transition-all duration-300 animate-fadeIn">
            <div class="space-y-8">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <p class="block mb-2 !text-white !font-medium">Select App:</p>
                  <select 
                      bind:value={selectedApp}
                      class="border p-2 rounded w-full"
                  >
                      <option value="0">SELECT APP</option>
                      {#each availableApps as app}
                          <option value={app.id}>
                              {app.label}
                          </option>
                      {/each}
                  </select>
                </div>
  
                <div>
                  <label for="principal-id" class="block mb-2 !text-white !font-medium">Principal ID:</label>
                  <input
                    id="principal-id"
                    type="text"
                    bind:value={principalId}
                    class="w-full p-3 !text-white rounded-md bg-BrandGray border border-BrandBlue/50 focus:ring-2 focus:ring-BrandBlue focus:outline-none placeholder-BrandGrayShade2 shadow-sm"
                    placeholder="Enter Principal ID"
                  />
                </div>
              </div>
  
              {#if errorMessage}
                <p class="text-BrandRed text-sm bg-BrandError/20 p-2 rounded-md animate-fadeIn">{errorMessage}</p>
              {/if}
  
              <button
                onclick={addAppPrincipal}
                class="w-full md:w-auto px-6 py-3 text-base font-semibold !text-white bg-BrandBlue rounded-lg hover:bg-BrandBlueComp transition-all duration-300 shadow-md hover:shadow-lg"
              >
                Add Principal ID
              </button>
            </div>
  
            <div class="mt-8">
              <p class="mb-3 !text-white !font-medium text-lg">Added Apps ({appPrincipalIds.length}/5):</p>
              {#if appPrincipalIds.length === 0}
                <p class="text-BrandGrayShade4">No Principal IDs added yet.</p>
              {:else}
                <div class="space-y-3">
                  {#each appPrincipalIds as [app, pid]}
                    <div class="flex items-center justify-between p-3 bg-BrandGray rounded-lg shadow-sm">
                      <div class="flex items-center">
                        <span class="w-4 h-4 rounded-full mr-2 {getAppBackground(app)}"></span>
                        <span class="!text-white">
                          {availableApps.find(a => JSON.stringify(a.label) === JSON.stringify(app))?.label}: {pid}
                        </span>
                      </div>
                      <button
                        onclick={() => removeAppPrincipal(app)}
                        class="text-BrandRed hover:text-BrandError transition-colors duration-200"
                      >
                        Remove
                      </button>
                    </div>
                  {/each}
                </div>
              {/if}
            </div>
          </div>
        {/if}
      </div>
    </div>
  </div>
