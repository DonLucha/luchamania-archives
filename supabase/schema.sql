-- LuchaMania Archives database foundation, v1
-- Run in your own Supabase project's SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  added_at timestamptz not null default now()
);

create or replace function public.is_lm_admin()
returns boolean language sql stable security definer
set search_path = '' as $$
  select exists (select 1 from public.admin_users where user_id = (select auth.uid()));
$$;

create table if not exists public.wrestlers (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  debut_date date,
  faction text,
  bio text not null default '',
  published boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.championships (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text not null default '',
  published boolean not null default true
);
create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  event_date date not null,
  brand text not null default '',
  description text not null default '',
  published boolean not null default true
);
create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  event_id uuid references public.events(id) on delete set null,
  match_order integer,
  match_name text not null,
  winner_text text not null default '',
  score text not null default '',
  stipulation text not null default '',
  published boolean not null default true
);
create table if not exists public.title_reigns (
  id uuid primary key default gen_random_uuid(),
  championship_id uuid not null references public.championships(id) on delete cascade,
  holder_name text not null,
  started_on date not null,
  ended_on date,
  defenses integer not null default 0 check (defenses >= 0),
  notes text not null default '',
  published boolean not null default true,
  check(ended_on is null or ended_on >= started_on)
);
create table if not exists public.articles (
  id uuid primary key default gen_random_uuid(),
  headline text not null,
  category text not null default 'News',
  body text not null default '',
  published_at timestamptz not null default now(),
  published boolean not null default false
);
create table if not exists public.storylines (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  summary text not null default '',
  status text not null default 'Ongoing',
  published boolean not null default true
);
create table if not exists public.rankings (
  id uuid primary key default gen_random_uuid(),
  division text not null,
  wrestler_name text not null,
  position integer not null check(position > 0),
  updated_at timestamptz not null default now(),
  published boolean not null default true,
  unique(division,position)
);

-- Anonymous visitors may read published records only.
-- Mutations are restricted to a manually authorized authenticated user.
do $$ declare tbl text; begin
  foreach tbl in array array['wrestlers','championships','events','matches','title_reigns','articles','storylines','rankings']
  loop
    execute format('alter table public.%I enable row level security',tbl);
    execute format('drop policy if exists lm_read on public.%I',tbl);
    execute format('create policy lm_read on public.%I for select to anon,authenticated using (published or public.is_lm_admin())',tbl);
    execute format('drop policy if exists lm_add on public.%I',tbl);
    execute format('create policy lm_add on public.%I for insert to authenticated with check (public.is_lm_admin())',tbl);
    execute format('drop policy if exists lm_change on public.%I',tbl);
    execute format('create policy lm_change on public.%I for update to authenticated using (public.is_lm_admin()) with check(public.is_lm_admin())',tbl);
    execute format('drop policy if exists lm_remove on public.%I',tbl);
    execute format('create policy lm_remove on public.%I for delete to authenticated using (public.is_lm_admin())',tbl);
  end loop;
end $$;
alter table public.admin_users enable row level security;
drop policy if exists lm_admin_own_record on public.admin_users;
create policy lm_admin_own_record on public.admin_users for select
to authenticated using (user_id = (select auth.uid()));
-- No browser/API policy allows assigning admin powers.

grant usage on schema public to anon,authenticated;
grant select on public.wrestlers,public.championships,public.events,public.matches,public.title_reigns,public.articles,public.storylines,public.rankings to anon,authenticated;
grant insert,update,delete on public.wrestlers,public.championships,public.events,public.matches,public.title_reigns,public.articles,public.storylines,public.rankings to authenticated;
grant select on public.admin_users to authenticated;
grant execute on function public.is_lm_admin() to anon,authenticated;
