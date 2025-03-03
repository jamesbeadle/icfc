<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "./Layout.svelte";
  import { appStore } from "$lib/stores/app-store";
  import { authStore, type AuthSignInParams } from "$lib/stores/auth-store";
  import { userStore } from "$lib/stores/user-store";
  import LandingPage from "$lib/components/homepage/landingPage/landing-page.svelte";

  let isLoggedIn: Boolean;
    let termsAgreed: Boolean;
    let isLoading = true;
    let user: any = undefined;

  onMount(async () => {
    try {
      await appStore.checkServerVersion();
      await checkUser();
    } catch (error) {
      console.error("Error fetching funding data:", error);
    } finally {
      isLoading = false;
    }
  });

  async function checkUser(){
      authStore.subscribe((store) => {
          isLoggedIn = store.identity !== null && store.identity !== undefined;
      });
      userStore.subscribe((store) => {
          if(store == null){
              return;
          }
          user = store;
          termsAgreed = store == null 
              ? false 
              : store.termsAcceptedDate == undefined 
                  ? false 
                  : store.termsAcceptedDate > 0;
      });
  }
</script>

<Layout>
  {#if !isLoggedIn}
    <LandingPage />
  {:else}
    {#if user}
      <p>Logged in with principal ID {user.principalId}</p>
    {:else}
      <p>Logged in, please create a profile.</p>
    {/if}
  {/if}
</Layout>
