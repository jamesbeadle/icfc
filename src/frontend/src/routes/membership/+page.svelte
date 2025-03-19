<script lang="ts">
    import Layout from '../Layout.svelte';
    import MembershipDetailsModal from '$lib/components/membership/membership-details-modal.svelte';
    import HowToModalAddICFC from '$lib/components/membership/how-to-addICFC-modal.svelte';
    import HowToModalStakeICFC from '$lib/components/membership/how-to-stakeICFC-modal.svelte';
    import NeuronList from '$lib/components/membership/neuron-list.svelte';

    let showMembershipDetailsModal = false;
    let showHowToStakeICFCModal = false;
    let showHowToAddICFCModal = false;
    
    function openMembershipDetailsModal() {
        showMembershipDetailsModal = true;
    }

    function closeMembershipDetailsModal() {
        showMembershipDetailsModal = false;
    }

    function openHowToStakeICFCModal() {
        showHowToStakeICFCModal = true;
    }

    function closeHowToStakeICFCModal() {
        showHowToStakeICFCModal = false;
    }

    function openHowToAddICFCModal() {
        showHowToAddICFCModal = true;
    }

    function closeHowToAddICFCModal() {
        showHowToAddICFCModal = false;
    }
</script>

<Layout>
    <div class="flex flex-col w-full p-8 space-y-4">
        <h1 class="flex w-full brand-title">ICFC Membership</h1>
        <div class="flex w-full">
            <button 
                class="brand-info-button"
                on:click={openMembershipDetailsModal}
            >
            Membership Levels
            </button>
        </div>
        <p class="brand-sub-title">
            Stake ICFC tokens for max time to unlock exclusive membership benefits
        </p>

        <NeuronList />
    </div>
</Layout>

{#if showMembershipDetailsModal}
    <MembershipDetailsModal 
        showModal={showMembershipDetailsModal}
        onClose={closeMembershipDetailsModal}
    />
{/if}

{#if showHowToStakeICFCModal}
    <HowToModalStakeICFC
        showModal={showHowToStakeICFCModal}
        onClose={closeHowToStakeICFCModal}
    />
{/if}

{#if showHowToAddICFCModal}
    <HowToModalAddICFC
        showModal={showHowToAddICFCModal}
        onClose={closeHowToAddICFCModal}
    />
{/if}