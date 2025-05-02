<script lang="ts">
    import IcfcAppsModal from "../shared/icfc-apps-modal.svelte";
    import PrincipalIdModal from "./principal-id-modal.svelte";
    import type { SubApp } from "../../../../../declarations/backend/backend.did";

    interface Props {
        isOpen: boolean;
        onClose: () => void;
    }

    let { isOpen, onClose } : Props = $props();

    let selectedApp: { name: string; id: string } | null = null;
    let showPrincipalModal = false;

    function getSubApp(appName: string): SubApp {
        switch (appName) {
            case "Football God":
                return { FootballGod: null };
            case "OpenFPL":
                return { OpenFPL: null };
            case "OpenWSL":
                return { OpenWSL: null };
            case "Transfer Kings":
                return { TransferKings: null };
            case "Jeff Bets":
                return { JeffBets: null };
            default:
                throw new Error(`Unknown app name: ${appName}`);
        }
    }

    function handleAppClick(app: { name: string; id: string }) {
        selectedApp = app;
        showPrincipalModal = true;
    }

    function handlePrincipalSubmit(principalId: string) {
        if (selectedApp) {
            const subApp = getSubApp(selectedApp.name);
            //TODO Make Store and service for needed call
        }
        showPrincipalModal = false;
        selectedApp = null;
    }

    function handlePrincipalModalClose() {
        showPrincipalModal = false;
        selectedApp = null;
    }
</script>

<IcfcAppsModal {isOpen} {onClose} onAppClick={handleAppClick} />

{#if showPrincipalModal && selectedApp}
    <PrincipalIdModal
        isOpen={showPrincipalModal}
        onClose={handlePrincipalModalClose}
        appName={selectedApp.name}
        onSubmit={handlePrincipalSubmit}
    />
{/if}