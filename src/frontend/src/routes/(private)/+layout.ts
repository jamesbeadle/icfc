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

  await authStore.sync();
  const { identity } = get(authStore);

  if (!identity) {
    throw redirect(307, '/');
  }

  try {
    await initUserProfile({ identity });
    
  } catch (error) {
    console.error('Profile initialization failed:', error);
    if (error instanceof Error && error.message.includes('II')) {
      throw redirect(307, '/');
    }
    throw redirect(307, '/');
  }
};