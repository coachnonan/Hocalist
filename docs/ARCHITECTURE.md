# Architecture

## Current Decision

Hocalist is a mobile-first Flutter app for buyers and sellers. Android is the first release target, with iOS kept possible from the same Flutter codebase.

Admin is a separate web dashboard later, not a phone-first app.

## System Map

```text
Flutter buyer/seller app
  -> Supabase Auth
  -> Supabase Postgres
  -> Supabase Storage
  -> Supabase Realtime for chat
  -> Supabase Edge Functions where server-side logic is needed
  -> Stripe seller billing flows only

Admin web dashboard later
  -> same Supabase project
  -> hosted on Vercel if/when built

Domain
  -> landing page
  -> privacy policy
  -> terms
  -> support
  -> download page
  -> admin subdomain later
```

Primary domain: `hocalist.com`.

## Mobile App

- Framework: Flutter/Dart.
- App identity: `Hocalist`.
- Suggested package id: `com.hocalist.app`.
- First release: Android via Google Play.
- Later release: iOS via App Store if scoped.

## UI Architecture

The mobile UI should be built from reusable Flutter theme tokens and components, not one-off screen styling.

The design may change after owner review, so broad visual updates should be possible by editing shared foundations:

- color scheme
- text theme
- spacing and radius constants
- button variants
- input fields
- cards
- badges and status chips
- alerts and modals
- navigation components
- loading, empty, and error states

Screens should compose these shared widgets with feature data. Buyer and seller mode differences should be handled as accent/theme variants where possible.

## Backend

Hocalist will use the same Supabase project as Postaneur, but Hocalist data must live in a dedicated database schema. This keeps the apps operationally separate while sharing the Supabase project.

Supabase owns:

- authentication
- profiles and roles
- buyer requests
- seller offers
- connections
- chat rooms and messages
- deal records and confirmations
- reviews
- buyer commissions and withdrawal requests
- seller plans, credits, charges, subscriptions
- reports and admin audit logs
- storage for request, offer, profile, report, and review images

Admin-managed configuration owns:

- supported countries, cities, and service regions
- marketplace categories and sub-categories
- seller plan definitions
- seller credit packages and credit usage rules
- buyer commission rules
- withdrawal thresholds and fees
- safety/disclaimer copy and report reasons

## Supabase Schema Boundary

Use a dedicated Hocalist schema, proposed name: `hocalist`.

Expected structure:

- `auth.users` remains the shared Supabase Auth user source.
- Hocalist app tables live under the `hocalist` schema.
- Hocalist storage buckets use Hocalist-specific names.
- RLS policies must reference Hocalist tables and roles only.
- Admin/service operations must avoid Postaneur tables unless explicitly approved.
- Any Supabase API exposure for the `hocalist` schema must be configured deliberately before mobile implementation relies on it.

If Supabase client access to non-public schemas becomes awkward for Flutter, stop and confirm whether to continue with the dedicated schema or use `public` tables with a strict `hocalist_` prefix. Do not silently mix the two apps.

## Dynamic Configuration

Do not hardcode launch locations, categories, seller plans, credit usage, or commission rules in the Flutter app. The app should read these from Supabase configuration tables managed by the admin dashboard.

Suggested configuration tables:

- `hocalist.supported_countries`
- `hocalist.supported_cities`
- `hocalist.categories`
- `hocalist.category_children`
- `hocalist.seller_plans`
- `hocalist.seller_credit_packages`
- `hocalist.credit_rules`
- `hocalist.commission_rules`
- `hocalist.withdrawal_rules`
- `hocalist.safety_content`
- `hocalist.report_reasons`

The mobile app can ship with safe fallback labels for empty/loading states, but business configuration must come from the backend.

## Payment Boundary

Hocalist does not process buyer-to-seller item payment in the MVP.

Stripe may be used only for:

- seller subscriptions
- seller credits
- platform access fees
- target/contact fees

Buyer commission withdrawal is manual/admin-approved until separately scoped.

## Admin Boundary

Admin should be built as a desktop web dashboard after the core mobile buyer/seller flow is stable. Admin needs tables, filters, reports, billing controls, moderation, and audit logs, which are better on web.
