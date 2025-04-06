<script lang="ts">
    import FullScreenSpinner from '$lib/components/shared/full-screen-spinner.svelte';
    import {onMount, type  Snippet } from 'svelte';

    interface Props {
        data: {
            status: 'authenticated' | 'error';
            loading: boolean;
            loadingMessage: string;
        };
        children: Snippet;
    }
    
    let { data, children }: Props = $props();

    let isLoading = $derived(data.loading);
    let isLoadingMessage = $derived(data.loadingMessage || "Loading...");

    console.log('Layout data:', data);
</script>

{#if isLoading}
    <FullScreenSpinner message={isLoadingMessage} />
{:else if data.status === 'authenticated'}
    {@render children()}
{:else}
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-900 error-container">
        <p class="mb-4 text-xl text-red-500">Failed User Login</p>
        <p class="text-gray-400">Please try refreshing the page</p>
        <button 
            class="px-4 py-2 mt-4 text-white rounded bg-BrandGreen hover:bg-BrandGreen/80"
            onclick={() => window.location.reload()}
        >
            Refresh Page
        </button>
    </div>
{/if}