<script lang="ts">
    import Apps from "$lib/components/shared/apps.svelte";
    import LandingPage from "$lib/components/landing/landing-page.svelte";

    import { authSignedInStore } from "$lib/derived/auth.derived";
</script>

<svelte:head>
    <link rel="preload" href="/background.jpg" as="image" />
</svelte:head>

{#if $authSignedInStore}    
    <Apps />
{:else}
    <LandingPage />
{/if}