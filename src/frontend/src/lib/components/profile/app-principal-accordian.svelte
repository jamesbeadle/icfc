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
      class="w-full py-3 px-4 text-left bg-gray-700 text-white rounded-lg hover:bg-gray-600 transition flex justify-between items-center"
      on:click={() => (isOpen = !isOpen)}
  >
      <span>App Principal IDs</span>
      <span>{isOpen ? "▼" : "▶"}</span>
  </button>

  {#if isOpen}
      <div class="p-4 bg-gray-800 mt-2 rounded-lg">
          {#if isEditable}
              <div class="flex flex-col gap-4 max-w-md mx-auto">
                  <div>
                      <p class="block mb-1 text-gray-300">Sub App</p>
                      <select 
                          class="w-full p-2 text-white rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:border-blue-500"
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

                  <div>
                      <p class="block mb-1 text-gray-300">Principal ID</p>
                      <input
                          type="text"
                          bind:value={principalId}
                          class="w-full p-2 text-white rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:border-blue-500"
                          placeholder="Enter Principal ID"
                      />
                  </div>

                  <button 
                      class="brand-button bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition disabled:bg-gray-600"
                      on:click={addPrincipalId}
                      disabled={!principalId.trim()}
                  >
                      Add Principal ID
                  </button>
              </div>
          {/if}

          {#if appPrincipalIds.length > 0}
              <ul class="mt-4 space-y-2">
                  {#each appPrincipalIds as [subApp, id], index}
                      <li class="flex justify-between items-center p-3 bg-gray-700 rounded-lg">
                          <span class="text-gray-300">{getSubAppName(subApp)}: {id}</span>
                          {#if isEditable}
                              <button 
                                  class="text-red-500 hover:text-red-400"
                                  on:click={() => removePrincipalId(index)}
                              >
                                  Remove
                              </button>
                          {/if}
                      </li>
                  {/each}
              </ul>
          {:else}
              <p class="text-gray-400 text-center">No Principal IDs added yet.</p>
          {/if}
      </div>
  {/if}
</div>