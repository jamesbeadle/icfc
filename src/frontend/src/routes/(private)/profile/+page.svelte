<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import type { ProfileDTO } from "../../../../../declarations/backend/backend.did";
    
    import { toasts } from "$lib/stores/toasts-store";
    import { getImageURL } from "$lib/utils/helpers";
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import TabContainer from "$lib/components/shared/tab-container.svelte";
    import ProfileDetails from "$lib/components/profile/profile-details.svelte";
    import ProfileMembership from "$lib/components/profile/profile-membership.svelte";
    import ProfileLinkedApps from "$lib/components/profile/profile-linked-apps.svelte";
    import UpdateRequiredDetailsModal from "$lib/components/profile/update-modals/update-required-details-modal.svelte";
    
    let isLoading = $state(true);
    let profile: ProfileDTO | null = $state(null);
    let profileClass = $state('');
    let activeTab = $state("details");
    let showUpdateRequiredDetailsModal: boolean = $state(false);
    let principalId = $state("");
    let username = $state("");
    let displayName = $state("");
    let profileSrc = $state("");

    const tabs = [
        { id: "details", label: "Details" },
        { id: "membership", label: "Membership" },
        { id: "linkedApps", label: "Linked Apps" },
    ];

    function setActiveTab(tab: string): void {
        activeTab = tab;
    }

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
            foundProfile(profile);
        } catch (error) {
            toasts.addToast({ type: 'error', message: 'Error fetching user profile.' });
            console.error('Profile fetch error:', error);
        } finally {
            isLoading = false;
        }
    });

    function foundProfile(profile: ProfileDTO): void {
        principalId = profile.principalId;
        username = profile.username;
        displayName = profile.displayName;
        profileSrc = getImageURL(profile.profilePicture);
    }
</script>

{#if isLoading}
    <div class="flex items-center justify-center h-screen">
        <LocalSpinner />
    </div>
{:else if profile}
    <div class="min-h-screen bg-BrandBlack">
        <div class="p-4 mx-auto">
            <div class="p-2">
                <h1 class="text-3xl cta-text">ICFC Profile</h1>
            </div>

            <div class="p-4 border rounded-lg bg-BrandBlack border-BrandGrayShade3">
                <div class="flex items-start justify-between">
                    <div class="flex items-center space-x-4">
                        <img 
                            src={getImageURL(profile.profilePicture)} 
                            alt="Profile" 
                            class="object-cover w-16 h-16 border rounded-full border-BrandGrayShade3"
                        />
                        <div class="space-y-1">
                            <h3 class="text-lg cta-text text-BrandGrayShade4">{profile.displayName}</h3>
                            <p class="text-base text-BrandGrayShade3">{profile.username}</p>
                        </div>
                    </div>
                    <button 
                        onclick={() => showUpdateRequiredDetailsModal = true}
                        class="px-4 py-1 text-base text-white border border-white rounded-md hover:border-BrandBlue/80">
                            Edit
                    </button>
                </div>
            </div>
            
            <div class="flex flex-col w-full my-4">
                <div class="flex-none overflow-x-auto whitespace-nowrap no-scrollbar">
                        <TabContainer {tabs} {activeTab} {setActiveTab} />
                </div>
                
                <div class="p-4 mt-4 border rounded-lg shadow-lg bg-BrandBlueComp border-BrandGrayShade3/50">
                    {#if activeTab == "details"}
                        <ProfileDetails {profile} />
                    {/if}
                    {#if activeTab == "membership"}
                        <ProfileMembership {profile} />
                    {/if}
                    {#if activeTab == "linkedApps"}
                        <ProfileLinkedApps {profile} />
                    {/if}
                </div>
            </div>
        </div>
    </div>
{:else}
    <div class="flex items-center justify-center h-screen text-white">
        No profile data available
    </div>
{/if}

{#if showUpdateRequiredDetailsModal}
    <UpdateRequiredDetailsModal bind:visible={showUpdateRequiredDetailsModal} {username} {displayName} profileSrc={profileSrc} {principalId} />
{/if}