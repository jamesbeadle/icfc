<script lang="ts">
    import Layout from '../Layout.svelte';
    import MembershipTier from '$lib/components/membership/membership-tier.svelte';

    const membershipTiers = [
        {
            name: 'Monthly',
            stakingRequirement: '1,000 ICFC',
            stakingPeriod: 'Max Time',
            freeBets: 1,
            freeBetsFrequency: 'per month',
            benefits: [
                'Basic profile display features',
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
        }
    ];
</script>

<Layout>
    <div class="flex flex-col w-full p-8 space-y-8">
        <div>
            <h1 class="text-3xl mini:px-4 lg:text-4xl cta-text">ICFC Membership</h1>
            <p class="mt-2 text-sm mini:px-4 lg:text-base text-BrandGrayShade4">
                Stake ICFC tokens to unlock exclusive membership benefits
            </p>
        </div>

        <div class="grid grid-cols-1 gap-12 place-items-center mini:place-items-start sm:grid-cols-2 lg:grid-cols-3 auto-rows-[minmax(min-content,400px)] px-4">
            {#each membershipTiers as tier}
                <MembershipTier {tier} />
            {/each}
        </div>

        <div class="text-sm text-BrandGrayShade4">
            * Terms and conditions apply to free bets
        </div>
    </div>
</Layout>
