<script lang="ts">
    import AvailableMembershipDisplay from "./available-membership-display.svelte";
    import IcfcInfo from "./icfc-info.svelte";
    import type { MembershipType } from "../../../../../../declarations/backend/backend.did";
    
    export let availableMembership: MembershipType;
    export let maxStakedICFC: bigint;
    export let formatICFC: (amount: bigint) => string;
</script>


<div class="flex flex-col p-4 border rounded md:flex-row bg-BrandGray border-BrandGrayShade3">
    <IcfcInfo {maxStakedICFC} {formatICFC} />
    <AvailableMembershipDisplay {availableMembership} />
</div>