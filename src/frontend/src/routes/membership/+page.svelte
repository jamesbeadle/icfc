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
    <div class="flex flex-col w-full p-8 space-y-8">
        <div>
            <div class="flex flex-col gap-4 lg:gap-0 lg:items-center lg:flex-row lg:justify-between mini:px-4">
                <h1 class="text-3xl lg:text-4xl cta-text">ICFC Membership</h1>
                <div class="flex flex-col gap-4 md:flex-row">
                    <button 
                        class="p-3 text-base font-bold text-white transition-all duration-300 rounded-lg bg-BrandBlue hover:bg-opacity-90"
                        on:click={openHowToAddICFCModal}
                    >
                        How to Add ICFC
                    </button>
                    <button 
                        class="p-3 text-base font-bold text-white transition-all duration-300 rounded-lg bg-BrandBlue hover:bg-opacity-90"
                        on:click={openHowToStakeICFCModal}
                    >
                        How to Stake ICFC
                    </button>
                    <button 
                        class="p-3 text-base font-bold text-white transition-all duration-300 rounded-lg bg-BrandBlue hover:bg-opacity-90"
                        on:click={openMembershipDetailsModal}
                    >
                        Membership Details
                    </button>
                </div>
            </div>
            <p class="mt-4 text-base mini:mt-2 mini:px-4 text-BrandGrayShade4">
                Stake ICFC tokens for max time to unlock exclusive membership benefits
            </p>
        </div>

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