<script lang="ts">
    import AvailableMembershipDisplay from "./available-membership-display.svelte";
    import IcfcInfo from "./icfc-info.svelte";
    import type { MembershipType } from "../../../../../../declarations/backend/backend.did";

    interface Props {
        availableMembership: MembershipType;
        maxStakedICFC: bigint;
        formatICFC: (amount: bigint) => string;
    }

    let { availableMembership, maxStakedICFC, formatICFC } : Props = $props();
    
</script>


<div class="flex flex-col p-4 border rounded md:flex-row bg-BrandGray border-BrandGrayShade3">
    <IcfcInfo {maxStakedICFC} {formatICFC} />
    <AvailableMembershipDisplay {availableMembership} />
</div>