# Gotchas

Add repeatable or high-risk lessons here.

## Known

- `.codex-local/` contains local keys and secrets. Keep it ignored and never commit it.
- The mobile app is not hosted on Vercel. Flutter mobile is built as APK/AAB for Android and later iOS builds for App Store.
- Vercel may still be useful for landing pages, privacy policy, terms, support, download pages, and the future admin dashboard.
- Admin should not be built as a phone-first app unless explicitly rescoped.
- The Stitch export includes HTML, but Hocalist mobile must be implemented in Flutter. Use the HTML only as layout/style reference.
- The owner may change the design. Avoid one-off screen styling; use reusable Flutter tokens and components so redesigns do not require editing every screen.
- Product item payment must stay offline in MVP. Avoid language or flows that imply Hocalist guarantees, holds, or transfers buyer-to-seller item payment.
- Stripe is for seller subscriptions, credits, access fees, or targeting fees only.
- `gh` CLI auth may not match the Git SSH deploy key identity. SSH push can work even when `gh pr create` fails. Verify before promising CLI-created PRs.
- The repo uses `staging -> PR -> main`; do not push directly to `main`.
- Public commits, PRs, and deployment notes should not mention local workflow labels, AI tooling, prompts, or agent names.
- Hocalist shares the Postaneur Supabase project, but app data must stay in a dedicated Hocalist schema/storage namespace. Do not mix Postaneur assumptions or tables into Hocalist work.
- Confirm Flutter/Supabase client support and Supabase exposed schema settings before relying on non-public schema access from the mobile app.
- Do not hardcode countries, cities, categories, plans, credit rules, commission rules, or withdrawal rules in Flutter. These are admin-managed configuration.

## Template

```text
Difficulty:
What failed:
Why it failed:
Workaround:
Where to check first next time:
```
