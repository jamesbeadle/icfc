<script lang="ts">
    import MembershipTier from '$lib/components/membership/membership-tier.svelte';
    import Modal from '../shared/modal.svelte';
    import CloseIcon from '$lib/icons/CloseIcon.svelte';

    export let showModal: boolean;
    export let onClose: () => void;

    const membershipTiers = [
        {
            name: 'Monthly',
            stakingRequirement: '1,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 1,
            freeBetsFrequency: 'per month',
            benefits: [
                'Basic profile display features',
                'Entry into ICFC online games',
                'Entry to merchandise prize draws',
                'Entry to ticket prize draws',
                '1 free bet per month on Jeff Bets'
            ]
        },
        {
            name: 'Season',
            stakingRequirement: '10,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 2,
            freeBetsFrequency: 'per month',
            benefits: [
                'Enhanced profile display features',
                'Higher chance in merchandise prize draws',
                'Higher chance in ticket prize draws',
                '2 free bets per month on Jeff Bets'
            ]
        },
        {
            name: 'Lifetime',
            stakingRequirement: '100,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 4,
            freeBetsFrequency: 'per month',
            benefits: [
                'Premium profile display features',
                'Priority in merchandise prize draws',
                'Priority in ticket prize draws',
                '4 free bets per month on Jeff Bets'
            ]
        },
        {
            name: 'Founding',
            stakingRequirement: '1,000,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 4,
            freeBetsFrequency: 'per month',
            benefits: [
                'Premium profile display features',
                'Priority in merchandise prize draws',
                'Priority in ticket prize draws',
                '4 free bets per month on Jeff Bets'
            ]
        }
    ];

</script>

{#if showModal}
    <Modal {onClose}>
        <div class="flex flex-col w-full h-full">
            <h2 class="text-2xl text-white cta-text">Claim Membership</h2>
            <div class="top-0 p-6 z-60 bg-ModalBackground">
                <div class="flex items-center justify-between pb-4 mb-4 border-b border-gray-700">
                    <h3 class="text-2xl text-white cta-text">Membership Benefits</h3>
                    <button 
                        onclick={onClose}
                        class="p-2 transition-colors duration-300 rounded-lg hover:bg-white/10"
                    >
                        <CloseIcon className="w-8 h-8" fill="white" />
                    </button>
                </div>
                <div class="flex-1">
                    <div class="p-6 pt-4">
                        <div class="flex flex-col gap-6 md:flex-row md:overflow-x-auto">
                            {#each membershipTiers as tier}
                                <MembershipTier {tier} />
                            {/each}
                        </div>
                    </div>
                </div>

                <div class="text-sm text-BrandGrayShade4">
                    * Terms and conditions apply to free bets
                </div>
            </div>
        </div>
    </Modal>
{/if}