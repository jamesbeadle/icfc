<script lang="ts">
  import CopyIcon from "$lib/icons/CopyIcon.svelte";
  import { onMount } from "svelte";
  import UpdateUsernameModal from "./update-username-modal.svelte";
  import { getDateFromBigInt } from "$lib/utils/helpers";
  import { authStore } from "$lib/stores/auth-store";
  import { appStore } from "$lib/stores/app-store";
  import LoadingDots from "../shared/loading-dots.svelte";
  import type { ProfileDTO } from "../../../../../declarations/backend/backend.did";

  export let profile: ProfileDTO;

  let isLoading = true;
  let showUsernameModal: boolean = false;
  let username = "Not Set";
  let joinedDate = "";

  onMount(async () => {
      username = profile.username;
      joinedDate = getDateFromBigInt(Number(profile.createdOn));
      isLoading = false;
  });

  function displayUsernameModal(): void {
      showUsernameModal = true;
  }

  async function copyTextAndShowToast() {
      await appStore.copyTextAndShowToast(profile.principalId);
  }
</script>

<div class="w-full text-white space-y-4">
  <div>
      <p class="text-sm text-BrandGrayShade5">Username:</p>
      <div class="flex items-center justify-between">
          <h2 class="text-xl mini:text-2xl font-semibold">
              {#if isLoading}
                  <LoadingDots />
              {:else}
                  {username}
              {/if}
          </h2>
          <button 
              class="px-3 py-1 text-sm mini:text-base font-semibold text-white bg-BrandBlue rounded-lg hover:bg-opacity-80 transition-all duration-300"
              on:click={displayUsernameModal}
          >
              Update
          </button>
      </div>
  </div>

  <div>
      <p class="text-sm text-BrandGrayShade5">Joined:</p>
      <h2 class="text-xl mini:text-2xl font-semibold">
          {#if isLoading}
              <LoadingDots />
          {:else}
              {joinedDate}
          {/if}
      </h2>
  </div>

  <div>
      <p class="text-sm text-BrandGrayShade5">Principal:</p>
      <div class="flex items-center">
          <button class="flex items-center space-x-2" on:click={copyTextAndShowToast}>
              <span class="text-sm mini:text-base truncate max-w-xs">
                  {#if isLoading}
                      <LoadingDots />
                  {/if}
                  {$authStore.identity?.getPrincipal().toText()}
              </span>
              <CopyIcon className="w-5 h-5 text-BrandGrayShade5 hover:text-white transition-colors" fill="currentColor" />
          </button>
      </div>
  </div>
</div>

{#if !isLoading}
  <UpdateUsernameModal
      newUsername={profile.username}
      bind:visible={showUsernameModal}
  />
{/if}