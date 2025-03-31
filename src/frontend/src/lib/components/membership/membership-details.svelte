<script lang="ts">
    import MembershipTier from '$lib/components/membership/membership-tier.svelte';
    import CloseIcon from '$lib/icons/CloseIcon.svelte';

    const membershipTiers = [
        {
            name: 'Monthly',
            stakingRequirement: '1,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 1,
            freeBetsFrequency: 'per month',
            benefits: [
                'ICFC membership profile display',
                'Access to the ICFC tokenised football ecosystem',
                '1 free Transfer Kings pack per week',
                '1 free bet per month on Jeff Bets',
                'Entry to merchandise and prize draws'
            ]
        },
        {
            name: 'Season',
            stakingRequirement: '10,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 3,
            freeBetsFrequency: 'per month',
            benefits: [
                'ICFC season membership profile display',
                'Access to the ICFC tokenised football ecosystem',
                '1 free OpenFPL private league per season for up to 100 users.',
                '1 free OpenWSL private league per season for up to 100 users.',
                '2 free Transfer Kings pack per week',
                '3 free bets per month on Jeff Bets',
                'Entry to merchandise and prize draws'
            ]
        },
        {
            name: 'Lifetime',
            stakingRequirement: '100,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 5,
            freeBetsFrequency: 'per month',
            benefits: [
                'ICFC lifetime membership profile display',
                'Access to the ICFC tokenised football ecosystem',
                '3 free OpenFPL private league per season for up to 100 users.',
                '3 free OpenWSL private league per season for up to 100 users.',
                '1 free OpenFPL private league per season for up to 10000 users.',
                '1 free OpenWSL private league per season for up to 10000 users.',
                '4 free Transfer Kings pack per week',
                '5 free bets per month on Jeff Bets',
                'Can give 5 free season memberships out per season',
                'Entry to merchandise and prize draws'
            ]
        },
        {
            name: 'Founding',
            stakingRequirement: '1,000,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 10,
            freeBetsFrequency: 'per month',
            benefits: [
                'ICFC Founding membership profile display',
                'Access to the ICFC tokenised football ecosystem',
                '10 free OpenFPL private league per season for up to 100 users.',
                '10 free OpenWSL private league per season for up to 100 users.',
                '10 free OpenFPL private league per season for up to 10000 users.',
                '10 free OpenWSL private league per season for up to 10000 users.',
                '10 free Transfer Kings pack per week',
                '10 free bets per month on Jeff Bets',
                'Can give 50 free season memberships out per season',
                'Entry to merchandise prize draws',
                'Entry to ticket prize draws',
            ]
        }
    ];

</script>
<div class="flex flex-col w-full h-full">
    <div class="top-0 p-6 z-60 bg-ModalBackground">
        <div class="flex items-center justify-between pb-4 mb-4 border-b border-BrandGrayShade4">
            <h3 class="text-2xl text-white cta-text">Membership Benefits</h3>
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