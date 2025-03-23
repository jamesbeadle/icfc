<script lang="ts">
  import type { PrincipalId, SubApp } from "../../../../../declarations/backend/backend.did";

  export let appPrincipalIds: Array<[SubApp, PrincipalId]>;
  export let isEditable = true;

  let selectedSubApp: SubApp = { OpenFPL: null };
  let principalId = "";
  let isOpen = false;
  let errorMessage = "";

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

  function isPrincipalValid(principalId: string): boolean {
    if (!principalId) {
      return false;
    }
    const regex = /^([a-z2-7]{5}-){10}[a-z2-7]{3}$/i;
    return regex.test(principalId);
  }

  function addPrincipalId() {
    const trimmedId = principalId.trim();
    if (!trimmedId) {
      errorMessage = "Please enter a Principal ID";
      return;
    }

    if (!isPrincipalValid(trimmedId)) {
      errorMessage = "Invalid Principal ID format";
      return;
    }

    if (appPrincipalIds.some(([_, id]) => id === trimmedId)) {
      errorMessage = "This Principal ID already exists";
      return;
    }

    appPrincipalIds = [...appPrincipalIds, [selectedSubApp, trimmedId]];
    principalId = "";
    errorMessage = "";
  }

  function removePrincipalId(index: number) {
    appPrincipalIds = appPrincipalIds.filter((_, i) => i !== index);
  }
</script>

<div class="w-full accordion">
  <button 
      class="w-full py-3 px-4 text-left bg-BrandGrayShade2 text-white rounded-lg hover:bg-BrandGrayShade3 transition flex justify-between items-center"
      on:click={() => (isOpen = !isOpen)}
  >
      <span>App Principal IDs:</span>
      <span>{isOpen ? "▼" : "▶"}</span>
  </button>

  {#if isOpen}
      <div class="p-4 bg-BrandBlue mt-2 rounded-lg">
          {#if isEditable}
              <div class="flex flex-col gap-4 max-w-md mx-auto">
                  <div>
                      <p class="block mb-1 text-black">Sub App</p>
                      <select 
                          class="w-full p-2 text-black rounded-lg bg-BrandBlue border border-BrandGrayShade3 focus:outline-none focus:border-BrandBlueComp"
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
                      <p class="block mb-1 text-BrandGrayShade2">Principal ID</p>
                      <input
                          type="text"
                          bind:value={principalId}
                          class="w-full p-2 text-white rounded-lg bg-BrandGrayShade3 border border-BrandGrayShade3 focus:outline-none focus:border-blue-500"
                          placeholder="Enter Principal ID"
                      />
                  </div>

                  {#if errorMessage}
                      <p class="text-BrandRed text-sm">{errorMessage}</p>
                  {/if}

                  <button 
                      class="brand-button bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition disabled:bg-BrandGrayShade3"
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
                      <li class="flex justify-between items-center p-3 bg-BrandGrayShade2 rounded-lg">
                          <span class="text-BrandGrayShade2">{getSubAppName(subApp)}: {id}</span>
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
              <p class="text-BrandGrayShade2 text-center mt-4">No Principal IDs added yet.</p>
          {/if}
      </div>
  {/if}
</div>