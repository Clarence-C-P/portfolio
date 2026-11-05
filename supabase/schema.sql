-- =====================================================================
-- Portfolio (P01) · Supabase schema
-- Every table + Row Level Security (RLS) policy lives in this file.
-- Run it in Supabase → SQL Editor. It is safe to re-run (if not exists /
-- drop policy if exists).
--
-- Security rules for this project:
--   * RLS is ON for every table.
--   * The public (anon) can only READ rows that are meant to be public.
--   * Only the logged-in owner can INSERT / UPDATE / DELETE.
--   * private_contact, referees and resume_versions are owner-only.
--
-- (select auth.uid()) = the id of the logged-in user, or null if logged out.
-- Wrapping it in "select" is Supabase's recommended form: Postgres then
-- runs it once per query instead of once per row.
-- =====================================================================


-- ---------------------------------------------------------------------
-- profile · one row, fully public (name, headline, photo, links)
-- ---------------------------------------------------------------------
create table if not exists public.profile (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null unique default auth.uid()
                references auth.users (id) on delete cascade,
  full_name   text not null,
  headline    text,
  summary     text,
  email       text,
  location    text,
  website     text,
  github      text,
  linkedin    text,
  photo_url   text,
  created_at  timestamptz not null default now()
);

alter table public.profile enable row level security;

drop policy if exists "profile: anyone can read" on public.profile;
create policy "profile: anyone can read"
  on public.profile for select
  to anon, authenticated
  using (true);

drop policy if exists "profile: owner can write" on public.profile;
create policy "profile: owner can write"
  on public.profile for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- ---------------------------------------------------------------------
-- PATTERN A · public if show_on_site, owner can do everything
-- Example: education. Copy this pattern for experience, projects,
-- skills and certifications.
-- ---------------------------------------------------------------------
create table if not exists public.education (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null default auth.uid()
                  references auth.users (id) on delete cascade,
  school        text not null,
  degree        text,
  start_date    date,
  end_date      date,              -- null = "Present"
  details       text,
  sort_order    int not null default 0,
  show_on_site  boolean not null default false,  -- private until you tick it
  created_at    timestamptz not null default now()
);

alter table public.education enable row level security;

-- Visitors: only rows you chose to show.
drop policy if exists "education: public reads shown rows" on public.education;
create policy "education: public reads shown rows"
  on public.education for select
  to anon
  using (show_on_site = true);

-- You: everything (read all rows, add, edit, delete).
drop policy if exists "education: owner full access" on public.education;
create policy "education: owner full access"
  on public.education for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- ---------------------------------------------------------------------
-- PATTERN B · owner-only, never public
-- Example: private_contact. Copy this pattern for referees and
-- resume_versions.
-- ---------------------------------------------------------------------
create table if not exists public.private_contact (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null unique default auth.uid()
                references auth.users (id) on delete cascade,
  phone       text,
  address     text,
  created_at  timestamptz not null default now()
);

alter table public.private_contact enable row level security;

-- No policy for anon = anon can do nothing. That is the point.
drop policy if exists "private_contact: owner full access" on public.private_contact;
create policy "private_contact: owner full access"
  on public.private_contact for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- ---------------------------------------------------------------------
-- experience · Pattern A
-- ---------------------------------------------------------------------
create table if not exists public.experience (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null default auth.uid()
                  references auth.users (id) on delete cascade,
  role          text not null,
  company       text,
  start_date    date,
  end_date      date,              -- null = "Present"
  highlights    text,              -- one bullet point per line
  sort_order    int not null default 0,
  show_on_site  boolean not null default false,
  created_at    timestamptz not null default now()
);

alter table public.experience enable row level security;

drop policy if exists "experience: public reads shown rows" on public.experience;
create policy "experience: public reads shown rows"
  on public.experience for select
  to anon
  using (show_on_site = true);

drop policy if exists "experience: owner full access" on public.experience;
create policy "experience: owner full access"
  on public.experience for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- ---------------------------------------------------------------------
-- projects · Pattern A
-- ---------------------------------------------------------------------
create table if not exists public.projects (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null default auth.uid()
                  references auth.users (id) on delete cascade,
  name          text not null,
  description   text,
  tech          text,              -- e.g. "HTML, CSS, Supabase"
  repo_url      text,
  live_url      text,
  image_url     text,
  sort_order    int not null default 0,
  show_on_site  boolean not null default false,
  created_at    timestamptz not null default now()
);

alter table public.projects enable row level security;

drop policy if exists "projects: public reads shown rows" on public.projects;
create policy "projects: public reads shown rows"
  on public.projects for select
  to anon
  using (show_on_site = true);

drop policy if exists "projects: owner full access" on public.projects;
create policy "projects: owner full access"
  on public.projects for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- ---------------------------------------------------------------------
-- skills · Pattern A
-- ---------------------------------------------------------------------
create table if not exists public.skills (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null default auth.uid()
                  references auth.users (id) on delete cascade,
  name          text not null,
  category      text,              -- e.g. "Frontend", "Backend", "Tools"
  level         text,              -- e.g. "Advanced", "Intermediate"
  sort_order    int not null default 0,
  show_on_site  boolean not null default false,
  created_at    timestamptz not null default now()
);

alter table public.skills enable row level security;

drop policy if exists "skills: public reads shown rows" on public.skills;
create policy "skills: public reads shown rows"
  on public.skills for select
  to anon
  using (show_on_site = true);

drop policy if exists "skills: owner full access" on public.skills;
create policy "skills: owner full access"
  on public.skills for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- ---------------------------------------------------------------------
-- certifications · Pattern A
-- ---------------------------------------------------------------------
create table if not exists public.certifications (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null default auth.uid()
                    references auth.users (id) on delete cascade,
  name            text not null,
  issuer          text,
  issued_on       date,            -- "date" is a type name, so not used as a column
  credential_url  text,
  sort_order      int not null default 0,
  show_on_site    boolean not null default false,
  created_at      timestamptz not null default now()
);

alter table public.certifications enable row level security;

drop policy if exists "certifications: public reads shown rows" on public.certifications;
create policy "certifications: public reads shown rows"
  on public.certifications for select
  to anon
  using (show_on_site = true);

drop policy if exists "certifications: owner full access" on public.certifications;
create policy "certifications: owner full access"
  on public.certifications for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- ---------------------------------------------------------------------
-- referees · Pattern B (private: other people's personal data)
-- ("references" is a reserved word in SQL, hence "referees")
-- ---------------------------------------------------------------------
create table if not exists public.referees (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid()
                references auth.users (id) on delete cascade,
  name        text not null,
  position    text,
  company     text,
  email       text,
  phone       text,
  sort_order  int not null default 0,
  created_at  timestamptz not null default now()
);

alter table public.referees enable row level security;

drop policy if exists "referees: owner full access" on public.referees;
create policy "referees: owner full access"
  on public.referees for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- ---------------------------------------------------------------------
-- resume_versions · Pattern B
-- selected = the ids you ticked per section, e.g.
--   {"education": ["<uuid>"], "skills": ["<uuid>", "<uuid>"]}
-- ---------------------------------------------------------------------
create table if not exists public.resume_versions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid()
                references auth.users (id) on delete cascade,
  name        text not null,       -- e.g. "Web Dev job"
  template    text not null default 'single'
                check (template in ('single', 'two_col')),
  show_photo  boolean not null default true,
  selected    jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now()
);

alter table public.resume_versions enable row level security;

drop policy if exists "resume_versions: owner full access" on public.resume_versions;
create policy "resume_versions: owner full access"
  on public.resume_versions for all
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);


-- =====================================================================
-- STORAGE · "avatars" bucket for the profile photo
-- public = true  → anyone can VIEW a photo by its URL (needed for the site)
-- Only logged-in users (= you, since sign-ups are off) can upload/change.
-- Max 1 MB; JPEG, PNG or WebP only.
-- =====================================================================
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('avatars', 'avatars', true, 1048576,
        array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

-- Upload, replace and delete need these. (Supabase's "upsert" also
-- needs select + update, so all four are granted to the owner.)
drop policy if exists "avatars: owner can upload" on storage.objects;
create policy "avatars: owner can upload"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'avatars');

drop policy if exists "avatars: owner can read" on storage.objects;
create policy "avatars: owner can read"
  on storage.objects for select
  to authenticated
  using (bucket_id = 'avatars');

drop policy if exists "avatars: owner can update" on storage.objects;
create policy "avatars: owner can update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'avatars')
  with check (bucket_id = 'avatars');

drop policy if exists "avatars: owner can delete" on storage.objects;
create policy "avatars: owner can delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'avatars');


-- =====================================================================
-- CHECK · run this on its own after the schema. Every row should say
-- rls_on = true. Expected: 9 tables.
-- =====================================================================
-- select tablename, rowsecurity as rls_on
-- from pg_tables
-- where schemaname = 'public'
-- order by tablename;
