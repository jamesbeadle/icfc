<script lang="ts">
    import type { PrincipalId, SubApp } from "../../../../../declarations/backend/backend.did";
    import DropdownSelect from "../shared/dropdown-select.svelte";

    export let appPrincipalIds: Array<[SubApp, PrincipalId]> = [];

    let isOpen = false;
    let selectedApp: SubApp | null = null;
    let principalId: string = "";
    let errorMessage: string = "";

    const availableApps = [
        { value: { OpenFPL: null }, label: "OpenFPL" },
        { value: { OpenWSL: null }, label: "OpenWSL" },
        { value: { FootballGod: null }, label: "Football God" },
        { value: { TransferKings: null }, label: "Transfer Kings" },
        { value: { JeffBets: null }, label: "Jeff Bets" }
    ];

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
</script>

<div class="my-4">
    <div class="border border-white/10 rounded-lg">
        <button 
            class="w-full p-4 text-left bg-gray-900 rounded-t-lg flex justify-between items-center"
            on:click={toggleAccordion}
        >
            <h3 class="text-lg font-semibold text-white">App Principal IDs</h3>
            <span class="text-white">{isOpen ? '▼' : '▶'}</span>
        </button>
        
        {#if isOpen}
            <div class="p-4 border-t border-white/10">
                <div class="space-y-4">
                    <div>
                        <p class="mb-2 text-white">Select App:</p>
                        <DropdownSelect
                            options={availableApps
                                .filter(app => !isAppAdded(app.value))
                                .map(app => ({ id: app.label, label: app.label }))}
                            value={selectedApp ? Object.keys(selectedApp)[0] : null}
                            onChange={(value: string) => {
                                selectedApp = availableApps.find(app => app.label === value)?.value || null;
                            }}
                            placeholder="Select an app"
                        />
                    </div>

                    <div>
                        <p class="mb-2 text-white">Principal ID:</p>
                        <input
                            type="text"
                            bind:value={principalId}
                            class="w-full p-2 text-white rounded-md bg-BrandGray"
                            placeholder="Enter Principal ID"
                        />
                    </div>

                    {#if errorMessage}
                        <p class="text-BrandRed text-sm">{errorMessage}</p>
                    {/if}

                    <button
                        on:click={addAppPrincipal}
                        class="px-4 py-2 text-sm font-semibold text-white bg-BrandBlue rounded-lg hover:bg-opacity-80 transition-all duration-300"
                    >
                        Add Principal
                    </button>
                </div>

                {#if appPrincipalIds.length > 0}
                    <div class="mt-6">
                        <p class="mb-2 text-white font-medium">Added Apps:</p>
                        <div class="space-y-2">
                            {#each appPrincipalIds as [app, pid]}
                                <div class="flex items-center justify-between p-2 bg-gray-800 rounded">
                                    <span class="text-white">
                                        {availableApps.find(a => JSON.stringify(a.value) === JSON.stringify(app))?.label}: {pid}
                                    </span>
                                    <button
                                        on:click={() => removeAppPrincipal(app)}
                                        class="text-BrandRed hover:text-red-400"
                                    >
                                        Remove
                                    </button>
                                </div>
                            {/each}
                        </div>
                    </div>
                {/if}
            </div>
        {/if}
    </div>
</div>