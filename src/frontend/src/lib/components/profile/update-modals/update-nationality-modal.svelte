<script lang="ts">
  import LocalSpinner from '$lib/components/shared/local-spinner.svelte';
  import Modal from '$lib/components/shared/modal.svelte';
  import { toasts } from '$lib/stores/toasts-store';
  import { userStore } from '$lib/stores/user-store';
  import { onMount } from 'svelte';
  import { countryStore } from '$lib/stores/country-store';
  import type {
    Country,
    Countries,
    CountryId,
    UpdateNationality,
  } from '../../../../../../declarations/backend/backend.did';

  export let visible: boolean = false;
  export let nationalityId: CountryId;

  let isLoading = false;
  let loadingMessage = '';
  let newNationalityId: CountryId = nationalityId;
  let countries: Country[] = [];

  onMount(async () => {
    try {
      loadingMessage = 'Loading countries';
      isLoading = true;
      const countriesResult: Countries = await countryStore.getCountries();
      if (countriesResult) {
        countries = countriesResult.countries;
        countryStore.setCountries(countries);
      }
    } catch (error) {
      toasts.addToast({
        type: 'error',
        message: 'Failed to load countries.',
        duration: 5000,
      });
      console.error('Failed to load countries.', error);
    } finally {
      isLoading = false;
    }
  });

  $: isSubmitDisabled = newNationalityId < 0 || newNationalityId === nationalityId;

  const cancelModal = () => {
    newNationalityId = nationalityId;
    visible = false;
  };

  async function handleSubmit() {
    loadingMessage = 'Updating National Team';
    isLoading = true;
    try {
      let dto: UpdateNationality = {
        nationalityId: newNationalityId,
      };
      console.log("dto", dto);
      console.log("Submitting update nationality");
      await userStore.updateNationality(dto);
      await userStore.sync();
      console.log("Update nationality and sync complete");
      visible = false;
      toasts.addToast({
        message: 'National Team updated.',
        type: 'success',
        duration: 2000,
      });
    } catch (error) {
      console.error('Error updating nationaliy:', error);
      toasts.addToast({
        message: 'Error updating nationality.',
        type: 'error',
      });
    } finally {
      isLoading = false;
    }
  }
</script>

{#if visible}
  <Modal onClose={cancelModal} title="Update National Team">
    {#if isLoading}
      <LocalSpinner message={loadingMessage} />
    {:else}
      <div class="flex flex-col p-4 space-y-2">
        <p class="form-title">National Team</p>
        <p class="form-hint">
          Select to participate in nationwide football competitions.
        </p>
        <select bind:value={newNationalityId} class="w-full brand-input">
          <option value={null}>Select...</option>
          {#each $countryStore.sort((a, b) => a.name.localeCompare(b.name)) as country}
            <option value={country.id}>{country.name}</option>
          {/each}
        </select>
        <button
          class="w-full brand-button"
          on:click={handleSubmit}
          disabled={isSubmitDisabled}
        >
          Update National Team
        </button>
      </div>
    {/if}
  </Modal>
{/if}
