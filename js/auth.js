// =====================================================================
// auth.js · small helpers for login state, used by the admin pages.
//
// IMPORTANT: redirecting to the login page is for USER EXPERIENCE only.
// Anyone can read this JavaScript and skip it. What actually protects
// your data is Row Level Security in Supabase (supabase/schema.sql).
// =====================================================================

import { supabase } from './supabase.js';

// Build page links relative to THIS file (js/auth.js), so they work both
// on localhost and on GitHub Pages (where the site lives under /portfolio/).
export const LOGIN_URL = new URL('../login.html', import.meta.url).href;
export const ADMIN_URL = new URL('../admin/', import.meta.url).href;

/**
 * Returns the current session, or null if nobody is logged in.
 * Supabase keeps the session in the browser's localStorage, so you stay
 * logged in after a page reload.
 */
export async function getSession() {
  const { data, error } = await supabase.auth.getSession();
  if (error) {
    console.error('Could not read the session:', error.message);
    return null;
  }
  return data.session;
}

/**
 * Put this at the top of every admin page.
 * - Logged out → send to the login page.
 * - Logged in  → show the page and return the session.
 */
export async function requireAuth() {
  const session = await getSession();
  if (!session) {
    // replace() instead of href = ... so the Back button does not
    // bounce the visitor back to the protected page.
    window.location.replace(LOGIN_URL);
    return null;
  }
  document.documentElement.removeAttribute('data-auth');
  return session;
}

/** Log out, then go to the login page. */
export async function signOut() {
  await supabase.auth.signOut();
  window.location.replace(LOGIN_URL);
}

// If you log out in another tab, this tab follows.
supabase.auth.onAuthStateChange((event) => {
  if (event === 'SIGNED_OUT' && document.documentElement.dataset.page === 'admin') {
    window.location.replace(LOGIN_URL);
  }
});
