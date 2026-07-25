# Phase 1 Demo Checklist

Private local checklist for the reviewable Phase 1 prototype. Phase 1 is mock UI
only: no live Supabase, no live Google Maps, no live seller billing/tools payment setup, and no
buyer-to-seller item payment processing.

## Scope Boundary

- Buyer posts a request.
- Seller browses nearby buyer requests.
- Seller submits an offer.
- Buyer compares offers.
- Buyer selects a seller.
- Chat opens after selection.
- Buyer and seller choose a public meeting place.
- Item payment happens offline outside Hocalist.
- Buyer can complete, report, or recover a failed deal.
- Seller tools, credits, maps, admin actions, and support queues are placeholders
  until Phase 2 backend/billing/map integration.

## Buyer Demo Path

1. Start as buyer.
2. Set up buyer profile with city, radius, and notification preference.
3. Post a buying request with category, item, budget, location, timing, and
   reference photos.
4. Review request detail and confirm approximate location privacy.
5. Compare seller offers.
6. Open seller profile and inspect seller trust/location signals.
7. Select seller and confirm chat opens.
8. Review map-ready meetup area in chat.
9. Finalize deal and confirm meeting-place details.
10. Complete the deal and leave a review.
11. Run the alternate path: selected seller unavailable, recover deal, compare
    backup offers, or reopen request.

## Seller Demo Path

1. Start as seller.
2. Set up seller profile and service radius.
3. Complete mock verification.
4. Browse buyer requests.
5. Use location search and radius controls.
6. Open a request and review approximate buyer geography.
7. Send an offer with price, availability, item photos, and meetup/service area.
8. Review offer history.
9. Open selected offer detail.
10. Open seller-side chat and review deal/meeting context.
11. Review seller tools placeholder, making clear live pricing/payment setup is Phase 2.
12. Review seller-specific settings for public profile, service area, and
    plan/credit visibility.

## Required Mock States

- No nearby requests.
- Expired request.
- No offers yet.
- Chat locked until seller selection.
- Meeting confirmed.
- Deal completed.
- Deal failed or seller unavailable.
- Request reopened.
- Report submitted.
- Loading state.
- Error/retry state.
- Seller tools/credits placeholder.
- Local prototype data saved on device.

## Proof Checklist

- `dart.exe format lib\main.dart test\widget_test.dart`
- `flutter analyze`
- `flutter test`
- Android emulator or device screenshots for buyer and seller demo paths.
- iOS simulator or device review when available; at minimum, record iOS as a
  required unresolved proof gate if not available on the current machine.
- Check common mobile widths for text fit, button tap comfort, no overlap, and
  no clipped location/map cards.
- Confirm copy does not imply checkout, escrow, shipping, inventory, purchase
  protection, seller payouts, or in-app item payment.

## Phase 2 Deferred

- Supabase schema, RLS, and storage.
- Real auth/session/account lifecycle.
- Google Maps SDK, Places autocomplete, API keys, permissions, and map failure
  handling.
- Seller plan prices, credits, billing, Stripe checkout, or customer portal.
- Admin-managed categories, cities, plans, report reasons, safety content, and
  marketplace statistics.
- Real push notifications, chat transport, moderation queue, and support queue.
