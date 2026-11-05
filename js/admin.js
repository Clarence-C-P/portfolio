// =====================================================================
// admin.js · the editor (admin/index.html)
// T05: profile, private contact and photo upload.
// =====================================================================

import { supabase } from './supabase.js';
import { requireAuth, signOut } from './auth.js';

// Which form fields belong to which table.
const PROFILE_FIELDS = ['full_name', 'headline', 'summary', 'email', 'location',
                        'website', 'github', 'linkedin', 'photo_url'];
const CONTACT_FIELDS = ['phone', 'address'];

const MAX_PHOTO_BYTES = 1024 * 1024; // 1 MB, same limit as the bucket
const PHOTO_TYPES = ['image/jpeg', 'image/png', 'image/webp'];

// ---- Page elements ---------------------------------------------------
const form = document.getElementById('profile-form');
const saveButton = document.getElementById('profile-save');
const statusText = document.getElementById('profile-status');
const photoInput = document.getElementById('photo-input');
const photoPreview = document.getElementById('photo-preview');
const photoEmpty = document.getElementById('photo-empty');
const photoError = document.getElementById('photo-error');

// ---- Start -----------------------------------------------------------
const session = await requireAuth();
if (session) {
  const user = session.user;
  document.getElementById('user-email').textContent = user.email;
  document.getElementById('logout-button').addEventListener('click', signOut);

  await loadProfile(user);
  form.addEventListener('submit', (event) => saveProfile(event, user));
  photoInput.addEventListener('change', () => uploadPhoto(user));
}

// ---- Load: fill the form with what is saved --------------------------
async function loadProfile(user) {
  // Promise.all runs both requests at the same time, then waits for both.
  const [profileResult, contactResult] = await Promise.all([
    supabase.from('profile').select('*').eq('user_id', user.id).maybeSingle(),
    supabase.from('private_contact').select('*').eq('user_id', user.id).maybeSingle(),
  ]);

  if (profileResult.error || contactResult.error) {
    showStatus('Could not load your profile. Check your connection and reload the page.', true);
    return;
  }

  // maybeSingle() returns null when no row exists yet (first visit).
  fillFields(profileResult.data, PROFILE_FIELDS);
  fillFields(contactResult.data, CONTACT_FIELDS);
  showPhoto(form.elements.photo_url.value);
}

function fillFields(row, fields) {
  if (!row) return;
  for (const name of fields) {
    form.elements[name].value = row[name] ?? '';   // ?? = "if null, use ''"
  }
}

// ---- Save: write the form to both tables -----------------------------
async function saveProfile(event, user) {
  event.preventDefault();

  // Let the browser check required fields, emails and URLs first.
  if (!form.reportValidity()) return;

  saveButton.disabled = true;
  saveButton.textContent = 'Saving…';
  showStatus('');

  // upsert = insert the row if it does not exist, update it if it does.
  // onConflict: 'user_id' tells Supabase which column identifies "your" row.
  const [profileResult, contactResult] = await Promise.all([
    supabase.from('profile')
      .upsert({ user_id: user.id, ...readFields(PROFILE_FIELDS) }, { onConflict: 'user_id' }),
    supabase.from('private_contact')
      .upsert({ user_id: user.id, ...readFields(CONTACT_FIELDS) }, { onConflict: 'user_id' }),
  ]);

  saveButton.disabled = false;
  saveButton.textContent = 'Save profile';

  if (profileResult.error || contactResult.error) {
    console.error(profileResult.error || contactResult.error);
    showStatus('Profile not saved. Check your connection and try again.', true);
  } else {
    showStatus('Profile saved.');
  }
}

// Turns the form fields into an object like { full_name: 'Ren', headline: null }.
// Empty boxes are saved as null (no value) instead of an empty string.
function readFields(fields) {
  const values = {};
  for (const name of fields) {
    const value = form.elements[name].value.trim();
    values[name] = value === '' ? null : value;
  }
  return values;
}

// ---- Photo: check, upload, preview -----------------------------------
async function uploadPhoto(user) {
  const file = photoInput.files[0];
  photoError.hidden = true;
  if (!file) return;

  // Check in the browser first so you get a clear message right away.
  // (The bucket enforces the same rules on the server.)
  if (!PHOTO_TYPES.includes(file.type)) {
    return showPhotoError('Choose a JPEG, PNG or WebP image.');
  }
  if (file.size > MAX_PHOTO_BYTES) {
    const sizeMb = (file.size / 1024 / 1024).toFixed(1);
    return showPhotoError(`This photo is ${sizeMb} MB. Choose one under 1 MB.`);
  }

  showStatus('Uploading photo…');

  // One fixed file per user: a new upload replaces the old one.
  const path = `${user.id}/avatar`;
  const { error } = await supabase.storage
    .from('avatars')
    .upload(path, file, { upsert: true, contentType: file.type });

  if (error) {
    console.error(error);
    showStatus('');
    return showPhotoError('Photo not uploaded. Try again.');
  }

  // ?v=... changes the link each time, so browsers show the new photo
  // instead of an old copy from their cache.
  const { data } = supabase.storage.from('avatars').getPublicUrl(path);
  const url = `${data.publicUrl}?v=${Date.now()}`;

  form.elements.photo_url.value = url;
  showPhoto(url);
  showStatus('Photo uploaded. Select Save profile to keep it.');
}

function showPhoto(url) {
  photoPreview.hidden = !url;
  photoEmpty.hidden = Boolean(url);
  if (url) photoPreview.src = url;
}

function showPhotoError(message) {
  photoError.textContent = message;
  photoError.hidden = false;
  photoInput.value = '';
}

function showStatus(message, isError = false) {
  statusText.textContent = message;
  statusText.classList.toggle('is-error', isError);
}
