<script lang="ts">
    import ProfileImage from "$lib/components/profile/profile-image.svelte";
    import ProfileProperties from "$lib/components/profile/profile-properties.svelte";
    import CreateUserModal from "$lib/components/profile/create-user-modal.svelte";
    import Layout from "../Layout.svelte";
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";

    let showCreateUserModal = false;
    let profile = null;

    onMount(() => {
        let unsubscribe = () => {};
        
        (async () => {
            try {
                await userStore.sync();
                
                unsubscribe = userStore.subscribe(value => {
                    profile = value;
                    if (profile === null || profile === undefined) {
                        showCreateUserModal = true;
                    }
                });
            } catch (error) {
                console.error(error);
            }
        })();

        return () => unsubscribe();
    });
</script>

<Layout>
    <div class="container p-4 mx-auto">
        <div class="flex flex-wrap">
            <ProfileImage />
            <ProfileProperties />
        </div>
    </div>
</Layout>

<CreateUserModal 
    visible={showCreateUserModal}
    onSignUpComplete={() => showCreateUserModal = false}
/>