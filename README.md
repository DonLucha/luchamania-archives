# LuchaMania Official Archives — Version 1

A standalone, responsive website with roster profiles, titles and title lineages, events and match results, articles, storylines, rankings, and a browser-local admin dashboard.

## Open it now

Double-click `index.html` in a desktop web browser. No installation, server, or coding required.

## Edit data

Open **Admin**. Pick a section, add or edit records, then click **Export backup JSON** to save your work. **Import backup JSON** restores an exported copy.

**Important:** Local edits are saved only in the current browser/device using localStorage. They do not sync to other visitors. There is no password protection or real server-side admin yet. The initial sample content is a partial archive, not a claim of comprehensive historical data.

## Publish a read-only website using GitHub Pages

1. Create a free GitHub account.
2. Create a new **public** repository named `luchamania-site`.
3. Upload `index.html` (and optionally this README).
4. In the repository, open **Settings → Pages**. Set **Deploy from a branch**, choose `main` and `/ (root)`, then save.
5. Open the Pages URL GitHub provides, usually `https://YOUR-USERNAME.github.io/luchamania-site/`.

Anyone can see the original bundled data. Local admin edits do **not** update the live site for other users. Treat Admin as a prototype/editor for now, not an authenticated admin panel.

## Next version

Connect an online database (for example, Supabase), add sign-in and authorization, replace localStorage with API queries and writes, and move admin to authenticated routes. Enable database row-level access rules before launch. Then add linked participant IDs, stats from match results, images, and audit history.