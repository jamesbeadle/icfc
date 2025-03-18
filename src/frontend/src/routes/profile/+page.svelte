<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import type { ProfileDTO } from "../../../../declarations/backend/backend.did";
    
    import ProfileImage from "$lib/components/profile/profile-image.svelte";
    import ProfileProperties from "$lib/components/profile/profile-properties.svelte";
    import CreateUserModal from "$lib/components/profile/create-user-modal.svelte";
    import LinkICFCAppsModal from "$lib/components/profile/link-ICFC-apps-modal.svelte";
    import Layout from "../Layout.svelte";
    
    let showCreateUserModal = false;
    let showLinkICFCAppsModal = false;
    let profile: ProfileDTO | null = null;


    onMount(() => {
        let unsubscribe = () => {};
        
        (async () => {
            try {
                await userStore.sync();
                
                unsubscribe = userStore.subscribe(value => {
                    profile = value;
                    if (profile === null || profile === undefined) {
                        //showCreateUserModal = true;
                        profile = {
                            principalId: "2vxsx-fae",
                            username: "test",
                            displayName: "Test User",
                            profilePicture: [],
                            profilePictureExtension: "",
                            createdOn: BigInt(0),
                            termsAgreed: true,
                            membershipType: { NotClaimed: null },
                            membershipClaims: [],
                            membershipExpiryTime: BigInt(0),
                            appPrincipalIds: [],
                            podcastIds: []
                        };
                    }
                });
            } catch (error) {
                console.error(error);
            }
        })();

        return () => unsubscribe();
    });

    function openLinkICFCAppsModal() {
        showLinkICFCAppsModal = true;
    }

    function closeLinkICFCAppsModal() {
        showLinkICFCAppsModal = false;
    }
</script>

<Layout>
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
</Layout>

<CreateUserModal 
    visible={showCreateUserModal}
    onSignUpComplete={() => showCreateUserModal = false}
/>

<LinkICFCAppsModal
    isOpen={showLinkICFCAppsModal}
    onClose={closeLinkICFCAppsModal}
/>