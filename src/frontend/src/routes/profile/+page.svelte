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
    let profileClass = '';

    onMount(async () => {
        try {
            let profileResult = await userStore.getProfile();
            if (!profileResult) {
                return;
            }
            profile = profileResult;
            
            if (!profile?.membershipClaims?.length) {
                return;
            }
            
            let membership = profile.membershipClaims[0]?.membershipType;
            if (!membership) {
                return;
            }

            profileClass = Object.keys(membership)[0]?.toLocaleLowerCase() || '';
        } catch {
            toasts.addToast({ type: 'error', message: 'Error fetching user profile.' });
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
    {#if isLoading && profile}
        <div class="flex justify-center items-center h-screen">
            <LocalSpinner />
        </div>
    {:else}
        <div class="min-h-screen bg-BrandBlack flex items-center justify-center p-4 xxs:p-6">
            <div class="bg-BrandGray rounded-xl shadow-lg w-full max-w-4xl p-6 xxs:p-8 space-y-6">
                <div class="flex flex-col xxs:flex-row justify-between items-center gap-4">
                    <h1 class="text-3xl mini:text-4xl font-bold text-white">ICFC Profile</h1>
                    <button 
                        class="px-4 py-2 text-sm mini:text-base font-semibold text-white bg-BrandBlue rounded-lg hover:bg-opacity-80 transition-all duration-300"
                        on:click={openLinkICFCAppsModal}
                    >
                        Link ICFC Apps
                    </button>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="w-full">
                        <ProfileImage profile={profile!} />
                    </div>

                    <div class="w-full">
                        <ProfileProperties profile={profile!} />
                    </div>
                </div>
            </div>
        </div>
        {#if showLinkICFCAppsModal}
            <LinkICFCAppsModal
                isOpen={showLinkICFCAppsModal}
                onClose={closeLinkICFCAppsModal}
            />
        {/if}
    {/if}
</Layout>