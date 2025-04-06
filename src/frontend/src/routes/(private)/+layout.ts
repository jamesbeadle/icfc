import { redirect } from '@sveltejs/kit';
import { get } from 'svelte/store';
import { authStore } from '$lib/stores/auth-store';
import { initUserProfile } from '$lib/services/user-profile-service';
import { displayAndCleanLogoutMsg } from '$lib/services/auth.services';
import type { ProfileDTO } from '../../../../declarations/backend/backend.did';

export const ssr = false; 
export const load = async ({ url }) => {
  if (typeof window !== 'undefined') {
    displayAndCleanLogoutMsg();
  }

  await authStore.sync();
  const { identity } = get(authStore);

  if (!identity) {
    const redirectUrl = url.pathname !== '/' 
      ? `/auth/login?redirect=${encodeURIComponent(url.pathname)}`
      : '/auth/login';
    throw redirect(307, redirectUrl);
  }

  try {
    const profile = await initUserProfile({ identity });
    
    return {
      profile: profile.profile as ProfileDTO,
      identity 
    };
  } catch (error) {
    console.error('Profile initialization failed:', error);

    if (error instanceof Error && error.message.includes('II')) {
      throw redirect(307, '/auth/login?error=ii_timeout');
    }
    
    throw redirect(307, '/error?code=profile_init');
  }
};