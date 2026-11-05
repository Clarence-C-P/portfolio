// =====================================================================
// supabase.js · the ONE connection to Supabase, shared by every page.
//
// Other files use it like this:
//   import { supabase } from './supabase.js';
//
// SECURITY
// - The URL and the PUBLISHABLE key (older name: "anon" key) are safe to
//   commit. They are public by design: Row Level Security protects the data.
// - NEVER put the SECRET key (older name: "service_role") here or anywhere
//   in this repo. It bypasses RLS.
// =====================================================================

// "import" loads code from another file. This line downloads the official
// Supabase library (version 2) from the jsDelivr CDN. No npm, no build step.
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

// Supabase dashboard → Project Settings → API Keys
const SUPABASE_URL = 'https://jnsnprzrqrrvwpmszuvs.supabase.co';
const SUPABASE_PUBLISHABLE_KEY = 'PASTE_YOUR_PUBLISHABLE_KEY_HERE';

// "export" makes this variable available to other files that import it.
export const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);
