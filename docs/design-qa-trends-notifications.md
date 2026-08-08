# Hocatrends and Buyer Notifications Design QA

## Scope

- `ApprovedHocatrendsPage`
- `ApprovedHocatrendsPickedSellersPage`
- `ApprovedBuyerNotificationsPage`
- `test/approved_trends_notifications_test.dart`

Only the three lane-owned files were edited. Shared shell/navigation, theme,
metrics, helpers, assets, manifest, other pages, changelog, and build artifacts
were not changed.

## Approved References

- `approved resign/hocatrends-approved/hocatrends-approved.png`
- `approved resign/hocatrends-approved/7.1 Hocatrends picks sellers-approved (1).png`
- `approved resign/hocatrends-approved/competitive-flame-reference.png`
- `approved resign/home-page-design/7.2 view all notifications approved.png`
- `output/playwright/buyer-320-before-comparison.png`
- `output/playwright/trends-current-320x693.png`
- `output/playwright/compare-hocatrends-final-390.png`
- `output/playwright/compare-notifications-final-390.png`

Exact supplied crops remain in use for product art, gift/flame art, seller
avatars, badges, controls, activity symbols, arrows, stars, and metadata icons.
No artwork was substituted or approximated.

## Replica Contract Migration

- All three page roots now resolve `ApprovedReplicaMetrics` from the full
  viewport, provide `ApprovedReplicaScope`, and center a constrained replica
  body.
- Default/Medium uses discrete screenshot-lock scaling: `320/390` at 320,
  `360/390` at 360, and `1.0` at 390.
- Widths 430, 600, 768, and 1024 center the unchanged 390-wide composition.
- Large 1.15, XL 1.3, and external scaling above 1.0 bypass screenshot shrink,
  use up to 430px content width, and enable wrapping/reflow/scrolling.
- Geometry, typography, line heights, spacing, padding, radii, border widths,
  shadows, icon/art sizes, control dimensions, and row gaps now come from the
  shared metric helpers instead of narrow-width ternaries.
- Text continues to inherit the active theme family. Default screenshot styles
  use Nunito with explicit reference sizes and weights, including 800-weight
  display/card titles and 500-700-weight supporting copy.

## Exact Corrections

- Hocatrends uses the 390 reference hero, notice, search, competitive heading,
  rank, image, progress, metadata, and action measurements at every locked
  width. Default layouts do not introduce a narrow-only stack or truncation.
- The shared header accepts an optional replica reference logo-slot width.
  Hocatrends alone requests 89px: it remains 89px at 390 and on tablets,
  scales to 73.03px at 320, and keeps the existing wordmark asset, aspect
  ratio, 62/60px header height, role pill, and notification control geometry.
  Other pages retain the existing 138/126px logo-slot defaults.
- The signed-in buyer Hocatrends global header is constrained and centered to
  the same 390px replica canvas at tablet widths. Its 320/390 geometry remains
  unchanged, and other buyer pages and all seller headers remain full-width.
- The signed-in global buyer navigation now uses the proven 55px reference
  height instead of the legacy 94px shell. Its 25.59px icon treatment,
  18.28/15.84px active/inactive icons, 1.22px icon-label gap, 10.97px label
  slot, and 2.44px item padding match `ApprovedBuyerBottomNavigation` while
  preserving the existing global buyer assets, colors, callbacks, and
  semantics. At 320 the complete bar scales to 45.13px; at tablets its 390px
  content row remains centered. Seller navigation remains 72px.
- The known 320 list-density defect is corrected by scaling the full reference
  card instead of using the former reduced compact card: 58px reference images
  become 47.59px, 8px vertical card padding becomes 6.56px, and 8px inter-card
  gaps become 6.56px. Detail rows use 1/2/1px vertical gaps, 8px competition
  and percentage type, 9-10px status art, a 3px progress bar, and 10x11px
  people art while retaining the two-line 9.5/10.925 seller copy. An 84px
  reference minimum preserves the approved card rhythm, becoming 68.92px at
  320 and extending the five-card stack into the former blank band above
  navigation.
- Picked sellers now uses source-sized header artwork, 63x80 product art,
  34px controls, 49x52 avatars, intrinsic badges, horizontal price/chat
  commerce, and horizontal seller stats at Default/Medium. Enlarged text may
  reflow these regions.
- Notifications now uses the source-sized 16px header, 29px five-tab strip,
  44px activity artwork, 20px section rhythm, scaled dividers, explicit row
  typography, and side-by-side trailing values/ratings at Default/Medium.
- Wording, callbacks, filters, sorting, view selection, and navigation behavior
  remain unchanged.

## Focused Proof Added

- Actual Nunito font loading remains in `setUpAll`; Ahem is not accepted as
  screenshot evidence.
- Default overflow and metric assertions cover 320x693, 360, 390x844, 430,
  600, 768, and 1024.
- Tests assert 320/360 typography scale factors, 390 1:1 sizing, centered 390px
  content at 430/tablets, no default hero/tab/control wrapping, explicit 800
  weights, and the 320 trend-card height range that catches over-compression.
- Header proof asserts the Hocatrends 89px reference override at 390/tablet,
  its 73.03px replica-scaled width at 320, and the unchanged 138px compact and
  126px tablet defaults used by every caller without an override.
- Integration proof asserts the global buyer navigation at 55px on 390,
  45.13px on 320, and 55px with centered 390px content on tablets. It also
  verifies all five Hocatrends cards end above navigation at 390, buyer-nav
  rendering has no framework overflow, and seller navigation remains 72px.
- The same integration proof asserts the Hocatrends header is exactly 390px
  wide and viewport-centered at both 600px and 768px tablet widths, while its
  wrapper is absent from the seller shell.
- Large 1.15 and XL 1.3 are covered at narrow and reference widths; external
  1.6 scaling remains covered at 360.
- Callback/filter behavior coverage is preserved.

## Proof Record

- Direct SDK formatting of all Dart files changed by this lane: passed.
- Focused direct-SDK widget proof, `global buyer navigation matches approved
  replica geometry`: passed. It covers 320, 390, tablet centering, the fifth
  card boundary, and the unchanged 72px seller navigation.
- Flutter analyze, broader tests, builds, golden generation, and browser/device
  capture were outside this narrow repair.

## Residual Risk

- Fresh 320, 390, and 768 tablet renders completed at
  `output/playwright/replica-final-trends-320x693.png`,
  `output/playwright/replica-final-trends-nav-390x844.png`, and
  `output/playwright/replica-final-trends-tablet-centered-768x1024.png`.
- Same-canvas 390 comparison completed at
  `output/playwright/replica-final-compare-trends-nav-390.png`.
- Android insets/device rendering and iOS safe-area/Dynamic Type rendering remain
  platform QA gates.
- No owned source detail or artwork was ambiguous; no product logic change was
  required.

Final result: passed for local responsive implementation and rendered web QA;
native Android/iOS rendered-device proof remains pending.
