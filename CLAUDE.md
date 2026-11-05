# CLAUDE.md: Portfolio (P01)

This is the **code** for project **P01 · Portfolio** by REN_DC.DEV (GitHub: `Clarence-C-P`).
Planning and tracking live in a separate project:

- **Plan:** `../Planning_and_Documentation/projects/01-portfolio/Project_Plan.docx` (overview, data model, step-by-step guide, tasks T01–T19, schedule)
- **Tracker:** `../Planning_and_Documentation/Progress_Tracker.xlsx`
- **Planning routine:** `../Planning_and_Documentation/CLAUDE.md`

## What we're building
A public portfolio website with a private editor (only the owner can log in). The owner keeps resume content in 9 sections, creates resume versions with picked content, chooses a template (single-column or two-column), previews on **US Letter** (8.5 × 11 in), and exports to PDF and DOCX. The PDF can be imported into Canva.

## Stack (owner's choice: open source only, built from scratch)
- HTML, CSS, vanilla JavaScript (ES modules). **No framework, no build step.**
- Supabase: Postgres + Auth + Storage, via `@supabase/supabase-js@2` from jsDelivr.
- PDF: browser print with CSS `@page { size: letter }`. DOCX: `docx` (docx.js) from jsDelivr.
- Hosting: GitHub Pages.

## How to help in this repo
- The owner is learning. They're strongest in HTML/CSS/PHP/SQL, and JavaScript and Supabase are new to them. **Explain, and let them write the code when they ask to learn.** Don't dump whole features unasked.
- Work task by task (P01-T01 … T19). Branch per task: `feature/t04-login`. Use Conventional Commits (`feat:`, `fix:`, `style:`, `docs:`, `chore:`).
- For UI and design work, use the **frontend-design** skill. The target look is professional and minimalist.
- Security: Row Level Security on every table. The anon key may be committed; the **service_role key never**. Phone, address and referees are private (not on the public site). Sign-ups stay disabled.
- Never delete files or data without asking the owner first.
- When a work session ends, remind the owner to log hours and finished tasks (in the planning session or in `Progress_Tracker.xlsx`). If the planning folder has been added to this session, you may update the tracker yourself using `../Planning_and_Documentation/tools/tracker_lib.py`. Always save through `tracker_lib.save()`, which keeps the dashboard charts.
