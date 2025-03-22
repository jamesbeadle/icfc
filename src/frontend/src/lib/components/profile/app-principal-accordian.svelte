<script lang="ts">
    import type { PrincipalId, SubApp } from "../../../../../declarations/backend/backend.did";
  
    export let appPrincipalIds: Array<[SubApp, PrincipalId]>;
    export let isEditable = true;
  
    let selectedSubApp: SubApp = { OpenFPL: null };
    let principalId = "";
    let isOpen = false;
  
    const subAppOptions: SubApp[] = [
      { OpenFPL: null },
      { OpenWSL: null },
      { FootballGod: null },
      { TransferKings: null },
      { JeffBets: null }
    ];
  
    function getSubAppName(subApp: SubApp): string {
      if ("OpenFPL" in subApp) return "OpenFPL";
      if ("OpenWSL" in subApp) return "OpenWSL";
      if ("FootballGod" in subApp) return "Football God";
      if ("TransferKings" in subApp) return "Transfer Kings";
      if ("JeffBets" in subApp) return "Jeff Bets";
      return "Unknown";
    }
  
    function addPrincipalId() {
      if (principalId.trim() && !appPrincipalIds.some(([_, id]) => id === principalId)) {
        appPrincipalIds = [...appPrincipalIds, [selectedSubApp, principalId]];
        principalId = "";
      }
    }
  
    function removePrincipalId(index: number) {
      appPrincipalIds = appPrincipalIds.filter((_, i) => i !== index);
    }
  </script>
  
  <div class="w-full accordion">
    <button 
      class="w-full p-2 text-left bg-BrandGray text-white rounded-md"
      on:click={() => (isOpen = !isOpen)}
    >
      App Principal IDs {isOpen ? "▼" : "▶"}
    </button>
  
    {#if isOpen}
      <div class="p-4 bg-BrandGray mt-2 rounded-md">
        {#if isEditable}
          <div class="mb-4">
            <p class="block mb-1">Sub App</p>
            <select 
              class="w-full p-2 text-white rounded-md bg-BrandDarkGray"
              on:change={(e) => {
                const value = e.currentTarget.value;
                selectedSubApp = subAppOptions.find((opt) => getSubAppName(opt) === value) || selectedSubApp;
              }}
            >
              {#each subAppOptions as option}
                <option value={getSubAppName(option)} selected={getSubAppName(option) === getSubAppName(selectedSubApp)}>
                  {getSubAppName(option)}
                </option>
              {/each}
            </select>
          </div>
  
          <div class="mb-4">
            <p class="block mb-1">Principal ID</p>
            <input
              type="text"
              bind:value={principalId}
              class="w-full p-2 text-white rounded-md bg-BrandDarkGray"
              placeholder="Enter Principal ID"
            />
          </div>
  
          <button 
            class="brand-button"
            on:click={addPrincipalId}
            disabled={!principalId.trim()}
          >
            Add Principal ID
          </button>
        {/if}
  
        {#if appPrincipalIds.length > 0}
          <ul class="mt-4">
            {#each appPrincipalIds as [subApp, id], index}
              <li class="flex justify-between items-center p-2 bg-BrandDarkGray mb-2 rounded-md">
                <span>{getSubAppName(subApp)}: {id}</span>
                {#if isEditable}
                  <button 
                    class="text-BrandRed"
                    on:click={() => removePrincipalId(index)}
                  >
                    Remove
                  </button>
                {/if}
              </li>
            {/each}
          </ul>
        {:else}
          <p class="text-white/50">No Principal IDs added yet.</p>
        {/if}
      </div>
    {/if}
  </div>