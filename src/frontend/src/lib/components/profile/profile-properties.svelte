<script lang="ts">
    import CopyIcon from "$lib/icons/CopyIcon.svelte";
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import UpdateUsernameModal from "./update-username-modal.svelte";
    import { getDateFromBigInt } from "$lib/utils/helpers";
    import { authStore } from "$lib/stores/auth-store";
    import { appStore } from "$lib/stores/app-store";
    import LoadingDots from "../shared/loading-dots.svelte";

    let isLoading = true;
    let showUsernameModal: boolean = false;
    let username = "Not Set";
    let joinedDate = "";
    let unsubscribeUserProfile: () => void;
  
    onMount(async () => {
      await userStore.sync();

      unsubscribeUserProfile = userStore.subscribe((value) => {
        if (!value) { return; }
        username = value.username;
        joinedDate = getDateFromBigInt(Number(value.createDate));
      });
      isLoading = false;
    });

  function displayUsernameModal(): void {
    showUsernameModal = true;
  }
  async function copyTextAndShowToast() {
    await appStore.copyTextAndShowToast($userStore ? $userStore.principalId : "");
  }
</script>

<div class="w-full mb-4 md:w-1/2 lg:w-2/3 xl:w-3/4 md:px-2 md:mb-0">
    <div class="px-4 mt-2 rounded-lg md:ml-4 md:px-4 md:mt-1">
      <p class="mb-1">Username:</p>
      <h2 class="mb-1 default-header md:mb-2">
        {#if isLoading}
          <LoadingDots />
        {:else}
          {username}
        {/if}
      </h2>
      <button class="p-1 px-2 rounded md:p-2 md:px-4 fpl-button" on:click={displayUsernameModal}>Update</button>
      
      <p class="mt-4 mb-1">Joined:</p>
      <h2 class="mb-1 default-header md:mb-2">
        {#if isLoading}
          <LoadingDots />
        {:else}
          {joinedDate}
        {/if}</h2>
      <p class="mb-1">Principal:</p>
      <div class="flex items-center">
        <button class="flex items-center text-left" on:click={copyTextAndShowToast}>
          <span>
            {#if isLoading}
              <LoadingDots />
            {:else}
              {$authStore.identity?.getPrincipal().toText()}
            {/if}
          </span>
          <CopyIcon className="w-7 xs:w-6 text-left" fill="#FFFFFF" />
        </button>
      </div>
    </div>
</div>

  {#if !isLoading}
  <UpdateUsernameModal
    newUsername={$userStore.username}
    bind:visible={showUsernameModal}
  />
  {/if}