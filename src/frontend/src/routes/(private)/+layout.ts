import { redirect } from '@sveltejs/kit';
import { get } from 'svelte/store';
import { authStore } from '$lib/stores/auth-store';
import { initUserProfile } from '$lib/services/user-profile-service';
import { displayAndCleanLogoutMsg } from '$lib/services/auth.services';

export const ssr = false; 
export const load = async ({ url }) => {
  if (typeof window !== 'undefined') {
    displayAndCleanLogoutMsg();
  }

  try {
    let loadingMessage = "Checking authentication";
    await authStore.sync();
    const { identity } = get(authStore);

    if (!identity) {
      throw redirect(307, '/');
    }
    loadingMessage = "Initializing user profile";
    await initUserProfile({ identity });
    return {
      status: 'authenticated',
      loading: false,
      loadingMessage: "Loading"
    }
  } catch (error) {
    console.error('Profile initialization failed:', error);
    if (error instanceof Error && error.message.includes('II')) {
      throw redirect(307, '/');
    }
    throw redirect(307, '/');
  }
};