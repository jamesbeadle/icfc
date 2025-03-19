<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import type { ProfileDTO } from "../../../../declarations/backend/backend.did";
    
    import ProfileImage from "$lib/components/profile/profile-image.svelte";
    import ProfileProperties from "$lib/components/profile/profile-properties.svelte";
    import LinkICFCAppsModal from "$lib/components/profile/link-ICFC-apps-modal.svelte";
    import Layout from "../Layout.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    
    let isLoading = true;
    let showLinkICFCAppsModal = false;
    let profile: ProfileDTO | null = null;

    onMount(async () => {
        try{
            let profileResult = await userStore.getProfile();
            if(!profileResult) {return}
            profile = profileResult
        } catch{
            toasts.addToast({ type: 'error', message: 'Error fetching user profile.'});
        } finally {
            isLoading = false;
        }
    });

    function openLinkICFCAppsModal() {
        showLinkICFCAppsModal = true;
    }

    function closeLinkICFCAppsModal() {
        showLinkICFCAppsModal = false;
    }
</script>

<Layout>
    {#if isLoading}
        <LocalSpinner />
    {:else}
        <div class="flex flex-col w-full p-8 space-y-8">
            <div class="flex flex-col gap-4 lg:gap-0 lg:items-center lg:flex-row lg:justify-between mini:px-4">
                <h1 class="text-3xl lg:text-4xl cta-text">ICFC Profile</h1>
                <button 
                    class="p-3 text-base font-bold text-white transition-all duration-300 rounded-lg bg-BrandBlue hover:bg-opacity-90"
                    on:click={openLinkICFCAppsModal}
                >
                    Link ICFC Apps
                </button>
            </div>
            <ProfileImage />
            <ProfileProperties />
        </div>
        {#if showLinkICFCAppsModal}
            <LinkICFCAppsModal
                isOpen={showLinkICFCAppsModal}
                onClose={closeLinkICFCAppsModal}
            />
        {/if}
    {/if}
</Layout>
