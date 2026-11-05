// =====================================================================
// login.js · YOUR TURN (P01-T04)
// Makes the login form on login.html work.
// Follow the 5 steps. Each step is 1–4 lines of code.
// =====================================================================

import { supabase } from './supabase.js';
import { getSession, ADMIN_URL } from './auth.js';

// Step 1 · Already logged in? Skip the form and go to the editor.
//   - call getSession() (it is async, so use await)
//   - if there is a session, window.location.replace(ADMIN_URL)


// Step 2 · Grab the elements you need from login.html by their id:
//   form "login-form", error message "login-error", button "login-button"
const form = document.getElementById('login-form');
// ...the other two here


// Step 3 · Listen for the form being submitted.
form.addEventListener('submit', async (event) => {
  // Stop the browser from reloading the page (the default form behaviour).
  event.preventDefault();

  // Step 4 · Read the email and password, then ask Supabase to log in.
  //   - read the values:  form.email.value.trim()  and  form.password.value
  //   - disable the button and change its text to "Logging in…"
  //   - const { error } = await supabase.auth.signInWithPassword({ email, password });


  // Step 5 · Handle the result.
  //   - if (error): show "Email or password is incorrect." in the error
  //     paragraph (set .textContent and .hidden = false), re-enable the
  //     button and change its text back to "Log in"
  //   - else: window.location.replace(ADMIN_URL)

});
