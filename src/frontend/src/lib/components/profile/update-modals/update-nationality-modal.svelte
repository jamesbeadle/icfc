<script lang="ts">
    import DropdownSelect from "$lib/components/shared/dropdown-select.svelte";
    import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    import Modal from "$lib/components/shared/modal.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import type { CountryDTO, CountryId, PrincipalId, UpdateNationality } from "../../../../../../declarations/backend/backend.did";
    import { countryStore } from "$lib/stores/country-store";


    export let visible: boolean = false;
    export let nationalityId: CountryId;
    export let principalId: PrincipalId;

    let isLoading = false;
    let newNationalityId = nationalityId;
    let countries: CountryDTO[] = [];


    onMount(async () => {
        try{
        countries = await countryStore.getCountries();
        } catch {
        toasts.addToast({type: 'error', message: 'Failed to load data.'});
        } finally {
        isLoading = false;
        }
    });

    $: isSubmitDisabled = newNationalityId > 0 && newNationalityId != nationalityId && newNationalityId > 0 && newNationalityId != nationalityId;

    const cancelModal = () => {
        newNationalityId = nationalityId;
        visible = false;
    };

    const handleSubmit = async (e: Event) => {
        e.preventDefault();
        if (isSubmitDisabled) return;

        isLoading = true;
        try {
            let dto: UpdateNationality =  {
                countryId: newNationalityId,
                principalId
            }
            await userStore.updateNationality(dto);
            await userStore.sync();
            visible = false;
            toasts.addToast({
                message: "Nationality updated.",
                type: "success",
                duration: 2000,
            });
        } catch (error) {
            console.error("Error updating nationaliy:", error);
            toasts.addToast({
                message: "Error updating nationality.",
                type: "error",
            });
        } finally {
            isLoading = false;
        }
    };
</script>



{#if visible}
    <Modal onClose={cancelModal}>
        {#if isLoading}
            <LocalSpinner />
        {:else}
            <div class="flex flex-col space-y-1 w-full md:w-1/3">
                <p class="form-title">Nationality</p>
                <p class="form-hint">Select to participate in nationwide football competitions.</p>
                <DropdownSelect
                options={countries.sort((a, b) => a.name.localeCompare(b.name)).map((country: CountryDTO) => ({ id: country.id, label: country.name }))}
                value={nationalityId}
                onChange={(value: string | number) => {
                    nationalityId = Number(value);
                }}
                />
            </div>
        {/if}
    </Modal>
{/if}