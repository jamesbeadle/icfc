<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import type { ProfileDTO } from "../../../../declarations/backend/backend.did";
    
    import Layout from "../Layout.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import ProfileDetails from "$lib/components/profile/profile-details.svelte";
    import ProfileMembership from "$lib/components/profile/profile-membership.svelte";;
    import ProfileLinkedApps from "$lib/components/profile/profile-linked-apps.svelte";
    
    let isLoading = true;
    let profile: ProfileDTO | null = null;
    let profileClass = '';
    let activeTab = $state(0);

    onMount(async () => {
        try {
            const profileResult = await userStore.getProfile();
            if (!profileResult) {
                toasts.addToast({ type: 'error', message: 'No profile found.' });
                return;
            }
            
            profile = profileResult;
            const membership = profile.membershipClaims?.[0]?.membershipType;
            profileClass = membership ? Object.keys(membership)[0]?.toLowerCase() : '';
        } catch (error) {
            toasts.addToast({ type: 'error', message: 'Error fetching user profile.' });
            console.error('Profile fetch error:', error);
        } finally {
            isLoading = false;
        }
    });
</script>

<Layout>
    {#if isLoading}
        <div class="flex justify-center items-center h-screen">
            <LocalSpinner />
        </div>
    {:else if profile}
        <div class="min-h-screen bg-BrandBlack flex items-center justify-center p-4 xxs:p-6">
            <div class="bg-BrandGrayShade2 rounded-xl shadow-lg w-full max-w-4xl p-6 xxs:p-8 space-y-6">
                <div class="flex flex-col xxs:flex-row justify-between items-center gap-4">
                    <h1 class="text-3xl cta-text">ICFC Profile</h1>
                </div>

                <div class="flex flex-col w-full">
                    <div class="overflow-x-auto whitespace-nowrap no-scrollbar">
                        <div class="inline-flex w-full border-b min-w-max border-BrandGrayShade3">

                            <button
                                    class={`flex-1 min-w-[125px] px-4 py-2 text-sm font-medium text-center 
                                        border-b-2 transition-colors duration-200
                                        ${activeTab === 0 
                                            ? 'border-BrandBlue text-BrandBlue' 
                                            : 'border-transparent text-BrandGrayShade4 hover:text-BrandGrayShade5 hover:border-BrandGrayShade2'}`}
                                    on:click={() => activeTab = 0}
                                >
                                    <span class="block break-words whitespace-normal cta-text">
                                        Details
                                    </span>
                                </button>

                                <button
                                    class={`flex-1 min-w-[125px] px-4 py-2 text-sm font-medium text-center 
                                        border-b-2 transition-colors duration-200
                                        ${activeTab === 1 
                                            ? 'border-BrandBlue text-BrandBlue' 
                                            : 'border-transparent text-BrandGrayShade4 hover:text-BrandGrayShade5 hover:border-BrandGrayShade2'}`}
                                    on:click={() => activeTab = 1}
                                >
                                    <span class="block break-words whitespace-normal cta-text">
                                        Membership
                                    </span>
                                </button>

                                <button
                                    class={`flex-1 min-w-[125px] px-4 py-2 text-sm font-medium text-center 
                                        border-b-2 transition-colors duration-200
                                        ${activeTab === 2 
                                            ? 'border-BrandBlue text-BrandBlue' 
                                            : 'border-transparent text-BrandGrayShade4 hover:text-BrandGrayShade5 hover:border-BrandGrayShade2'}`}
                                    on:click={() => activeTab = 2}
                                >
                                    <span class="block break-words whitespace-normal cta-text">
                                        Linked Apps
                                    </span>
                                </button>
                        </div>
                    </div>
                    
                    <div class="p-4 mt-4 rounded-lg bg-BrandBlueComp">
                        {#if activeTab == 0}
                            <ProfileDetails {profile} />
                        {/if}
                        {#if activeTab == 1}
                            <ProfileMembership {profile} />
                        {/if}
                        {#if activeTab == 2}
                            <ProfileLinkedApps {profile} />
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    {:else}
        <div class="flex justify-center items-center h-screen text-white">
            No profile data available
        </div>
    {/if}
</Layout>