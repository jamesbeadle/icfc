<script lang="ts">
    import Apps from "$lib/components/shared/apps.svelte";
    import LandingPage from "$lib/components/landing/landing-page.svelte";

    import { authSignedInStore } from "$lib/derived/auth.derived";
</script>

{#if $authSignedInStore}    
    <Apps />
{:else}
    <LandingPage />
{/if}