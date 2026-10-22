# LuchaMania Archives: Database Upgrade

## What exists now
- Public V1 static website in `index.html` (no changes needed to its current content).
- `supabase/schema.sql` creates the hosted database tables with row-level security (RLS).
- `admin-secure.html` is a separate **starter** sign-in and CRUD interface for wrestlers, events, and news. It is not yet linked to the public site's frontend.

## Connect Supabase (beginner steps)
1. Sign up at https://supabase.com and create a new project.
2. Choose a strong **database password**. Never put this password in GitHub or website code.
3. Open **SQL Editor** in Supabase, paste `supabase/schema.sql`, and run it once.
4. Under **Authentication → Users**, create or invite your admin account, and confirm its email.
5. Copy your user's UUID from Authentication → Users. Open SQL Editor and run:
   `insert into public.admin_users(user_id) values ('YOUR-USER-UUID');`
   Only execute this using Supabase SQL Editor as the project owner.
6. Under **Project Settings → API** (or **Connect**), copy the project URL and its **publishable** / legacy **anon** key. Never use the **service_role** or **secret** key in HTML.
7. Open `admin-secure.html` in the GitHub repository editor and replace `PASTE_SUPABASE_URL` and `PASTE_SUPABASE_PUBLISHABLE_KEY`; commit the changes. Both of those values are designed to be exposed publicly; security comes from RLS.
8. Visit your GitHub Pages site, then open `/admin-secure.html` and sign in. Only the authorized user UUID can edit.
9. Test adding a draft record. Confirm it is saved after refreshing.

## Important safety notes
- Do **not** disable RLS. Do **not** put service role / secret keys, database passwords, or personal passwords in public repositories.
- This is **not yet the final live database website**. The public V1 pages still read their browser-local starter records. A later migration will connect those public views to Supabase; existing locally entered data needs import.
- Do not use V1's old `Admin` tab for official shared records; it uses browser localStorage.
- Supabase has email/password login and optional MFA. Consider enabling MFA before using the admin interface for production work.
- Do not bulk import unverified historical results. Match results, title changes, and dates should be checked against archive sources.
