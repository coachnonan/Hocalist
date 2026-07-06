# Hocalist MVP Plan

## One-Line Product

Hocalist is a local reverse marketplace where buyers post buying intent and sellers send offers to real buyers.

## MVP Boundary

Included:

- buyer and seller auth
- account type onboarding
- buyer request creation
- seller request marketplace and filters
- seller offers
- buyer offer review and seller selection
- buyer/seller chat after selection
- deal finalization with offline payment reminder
- meeting details and deal confirmation
- buyer review of seller
- buyer commission records and manual withdrawal requests
- seller plan/credit/billing screens
- reports, safety guide, notifications
- admin data model and later admin web dashboard
- admin-managed countries/cities, categories, seller plans, credit rules, commission rules, withdrawal rules, and safety/report settings

Excluded:

- ecommerce checkout for item purchase
- escrow
- shipping labels
- inventory management
- automated product seller payouts
- complex AI matching
- automated fraud detection beyond admin/manual controls
- automatic buyer withdrawal payouts unless later approved

## Client Payment Stages

The project should follow the remaining payment stages from the brief. Do not expand into the next stage until the current stage is reviewed, accepted, and payment/approval is handled.

Working timeline target: complete the remaining MVP work across three weeks, with each week aligned to one payment stage.

### Stage 2 - UI Design And App Screens

Target: Week 1.

Goal: Build the mobile UI foundation and screens from the Stitch design reference.

Included:

- Flutter project scaffold.
- Reusable mobile design system foundation.
- Theme tokens from Stitch.
- Shared buttons, fields, cards, badges, alerts, navigation, loading, empty, and error states.
- Buyer screens.
- Seller screens.
- Chat/deal screens.
- Wallet/billing screens as UI.
- Admin design reference only unless explicitly approved for web build.

Stop gate:

- Buyer/seller mobile screens are reviewable.
- Reusable components are in place.
- No backend-heavy logic is required for visual approval.
- Owner/client approves UI stage before backend/core logic work begins.

### Stage 3 - Database, Backend And Core Logic

Target: Week 2.

Goal: Connect the accepted UI to Supabase and implement real app behavior.

Included:

- Dedicated Hocalist Supabase schema.
- Auth and profiles.
- Admin-managed configuration tables for countries, cities, categories, plans, credits, commissions, withdrawal rules, safety content, and report reasons.
- Buyer request flow.
- Seller offer flow.
- Connection and chat logic.
- Deal finalization and confirmation logic.
- Reviews.
- Wallet/commission records.
- Seller plans/credits/charges.
- Storage buckets.
- RLS policies.
- Stripe seller billing only if rules are confirmed.

Stop gate:

- Core buyer and seller flows work against Supabase.
- Main records persist correctly.
- Access rules are tested.
- Business logic matches approved rules.
- Owner/client approves backend/core stage before release work begins.

### Stage 4 - Testing, Fixes And Google Play Submission

Target: Week 3.

Goal: Stabilize, test, package, and prepare Android release.

Included:

- End-to-end buyer demo scenario.
- End-to-end seller demo scenario.
- Permission/RLS checks.
- Loading, empty, and error state pass.
- Bug fixes.
- Android debug APK.
- Release AAB preparation.
- Google Play internal testing support.
- Store requirements: privacy policy, support URL, screenshots, app icon, description.

Stop gate:

- Android build is testable.
- Critical MVP flows pass.
- Known gaps are documented.
- Release candidate is ready for Google Play internal testing or submission.

## Technical Build Phases

These phases sit inside the payment stages above. They are for execution planning only and should not expand the paid scope.

### Phase A - Project Foundation

- Create Flutter app.
- Add Hocalist theme from Stitch mobile framework.
- Add navigation shell.
- Add Supabase environment pattern.
- Add docs and agent workflow rules.

### Phase B - Auth And Profiles

- Signup/login.
- Account type selection.
- Buyer profile.
- Seller profile setup.
- Seller verification status fields.

### Phase C - Buyer Request Flow

- Buyer dashboard.
- Post buying request.
- Request detail/edit/status.
- Image upload.
- Offers received.

### Phase D - Seller Offer Flow

- Seller dashboard.
- Browse/filter active buyer requests.
- Seller request detail.
- Send offer.
- Offer success/history/withdraw.

### Phase E - Chat And Deal

- Buyer selects seller.
- Connection and chatroom creation.
- Messages.
- Deal finalization.
- Meeting details.
- Confirmation outcomes.
- Seller review.

### Phase F - Wallet And Seller Billing Basics

- Buyer commission records.
- Pending/available balances.
- Manual withdrawal request.
- Seller plans and credits loaded from backend configuration.
- Buyer commission and withdrawal rules loaded from backend configuration.
- Stripe test-mode seller billing once rules are confirmed.

### Phase G - Admin Web

- Admin login.
- Dashboard metrics.
- Manage users, buyers, sellers, requests, offers, commissions, billing, reports, categories, supported countries/cities, seller plans, credit rules, commission rules, withdrawal rules, safety content, and settings.

### Phase H - Android Release

- End-to-end test scenarios.
- Debug APK.
- Google Play internal testing.
- Store assets, privacy policy, terms, support URL.
- AAB release build.

## Acceptance Criteria

- Buyer can post a request, receive offers, select a seller, chat, finalize, confirm, review, and view wallet records.
- Seller can onboard, browse requests, send offers, chat, finalize, and view billing/credits.
- Offline item payment boundary is visible in deal screens.
- Supabase records have correct ownership and RLS.
- Categories, launch locations, plans, credits, commissions, and withdrawal rules are backend-configured rather than hardcoded in mobile screens.
- Stitch design system is reflected in Flutter theme and reusable widgets.
- Android build can be tested before Play Store submission.
