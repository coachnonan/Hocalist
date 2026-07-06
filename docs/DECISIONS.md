# Decisions

## 2026-07-06 - Mobile-First Flutter

Decision: Build Hocalist as a Flutter mobile app for buyer/seller flows.

Reason: The product is a mobile marketplace experience. Flutter keeps Android first and iOS later in one mobile codebase.

## 2026-07-06 - Android First, iOS Later

Decision: Release Android first and keep iOS possible.

Reason: Google Play is the current staged release target. iOS publishing is not included unless separately scoped.

## 2026-07-06 - Admin Is Web Later

Decision: Admin should be a desktop web dashboard, likely Next.js on Vercel, after core mobile flow is stable.

Reason: Admin needs dense tables, filters, reports, billing controls, moderation, and audit logs that are better on desktop.

## 2026-07-06 - Vercel Is Not The Mobile Host

Decision: Do not use Vercel to host the buyer/seller mobile app UI.

Reason: Flutter mobile ships through app stores. Vercel may host landing, legal, support, download, and later admin web pages.

## 2026-07-06 - Offline Item Payment Boundary

Decision: Hocalist does not process buyer-to-seller item payment in the MVP.

Reason: Avoids checkout, escrow, shipping, seller payout, and marketplace payment complexity. Stripe is only for seller platform fees.

## 2026-07-06 - Stitch Export As Reference

Decision: Use the Stitch export as design reference, not implementation code.

Reason: The target app is Flutter. HTML/CSS from Stitch should be translated into native Flutter design tokens and widgets.

## 2026-07-06 - Git Staging Flow

Decision: Use `staging` as the working branch and PR into `main`.

Reason: Keeps main controlled for release/deploy behavior and avoids direct production changes.

## 2026-07-06 - Reusable Component Foundation

Decision: Build the Flutter UI through reusable theme tokens and shared components before broad screen implementation.

Reason: The owner may change the design after review. Shared tokens and components make redesigns safer and faster than editing one-off styles across many screens.

## 2026-07-06 - Public Git Hygiene

Decision: Public commit messages, PR descriptions, and deployment notes should use product and technical language only.

Reason: GitHub history should be clear for future debugging and should not expose internal local workflow labels or tooling names.

## 2026-07-06 - Shared Supabase Project With Hocalist Schema

Decision: Use the same Supabase project as Postaneur, but create a dedicated `hocalist` database schema for Hocalist app data.

Reason: Reuses existing Supabase setup while keeping Hocalist data, policies, storage naming, and future admin logic separated from Postaneur.

## 2026-07-06 - Admin-Managed Business Configuration

Decision: Countries, cities, categories, seller plans, credit rules, commission rules, withdrawal settings, safety content, and report reasons should be backend/admin-managed.

Reason: The owner needs to adjust launch markets and monetization rules without rebuilding the mobile app. Flutter should read configuration from Supabase.

## 2026-07-06 - Primary Domain

Decision: Use `hocalist.com` as the primary domain.

Reason: The domain can support public pages such as landing, privacy, terms, support, download links, and later admin access.
