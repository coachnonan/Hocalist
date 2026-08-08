# Onboarding and Home Design QA

## Scope

Implemented isolated replacement widgets for these approved targets:

- account creation for buyers and sellers
- buyer benefit introduction, first and second benefit sets
- signed-out home, including the continuation content and bottom navigation
- signed-in buyer home and bottom navigation

The implementation preserves current callbacks and current MVP-safe wording. In
particular, item payment remains outside Hocalist rather than repeating the
escrow wording visible in one older approved reference.

## Replication Inventory

- Exact screenshot-derived wordmark, role cards, people, video frames, gift art,
  social logos, benefit icons, status art, notification art, and navigation art
  are stored under `assets/approved_onboarding_home/`.
- Typography uses fixed sizes and weights while inheriting the active theme font
  family. No font size is calculated from viewport width.
- Approved navy, action blue, green, lavender, muted text, borders, card radii,
  selected states, spacing, and navigation treatments are represented locally.
- The account page scrolls under large text and stacks the role control at high
  scaling.
- The benefit flow uses two responsive steps with the approved progress and dot
  treatments.
- Signed-out and signed-in home pages retain fixed bottom navigation while body
  content scrolls.
- The signed-in dashboard uses a discrete compact composition at 320 logical px
  and preserves the normal approved composition at 390 and 426 logical px.
  Enlarged text above 1.3 may stack and scroll rather than clip.

## Proof

- `dart analyze lib/features/approved/onboarding_home_pages.dart test/approved_onboarding_home_test.dart`: passed before final documentation closeout.
- Actual Nunito is loaded through `test/test_fonts.dart`.
- Widget layout tests cover 360, 390, and 426 logical px at 1.6 text scale for all
  four public surfaces.
- Callback tests cover account role/signup, onboarding completion, signed-out
  buyer entry, and signed-in request creation.
- The 360 px signed-in header regression was reproduced and fixed with a flexible
  buyer-mode pill.

## Account And Benefit Density Repair

- Inspected `output/playwright/compare-account-final-390.png` against the exact
  390x844 approved source. The account modal header, role control, fields,
  primary action, divider, social actions, and login row were compacted to keep
  the complete approved composition in the first viewport.
- Inspected `output/playwright/compare-benefits-1-final-390.png` and
  `output/playwright/compare-benefits-2-final-390.png`. Avatar, copy, video,
  cards, actions, and progress spacing were reduced to the approved density.
- Fixed account fields retain all wording and callbacks. The account and benefit
  screens remain scrollable/reflowable for narrow widths and large text.
- `flutter test test/approved_onboarding_home_test.dart -r compact --name account`:
  passed, 5 tests.
- `flutter test test/approved_onboarding_home_test.dart -r compact --name benefit`:
  passed, 4 tests.
- Focused tests include 360, 390, and 426 logical px at 1.6 text scale, plus
  390x844 first-viewport assertions for the Facebook/login actions and both
  benefit actions.
- `git diff --check` for the three owned files: passed.

## Remaining Integration

The pre-existing signed-out-home golden remains skipped and is outside this
focused account/benefit repair. Regenerate the same-viewport Playwright
comparisons after integration to visually confirm the final pixels, then run the
separate Android and iOS rendered UX gates. No dashboard code was changed in
that account/benefit repair.

## Integration Closeout - 2026-08-02

- Final real-browser comparisons were regenerated for account, benefits,
  signed-out home, and signed-in dashboard at 390x844.
- Account and benefit actions remain in the first viewport at normal scale;
  360/390/426 coverage at 1.6 text scale remains scrollable and actionable.
- Full repository proof passed with 63 tests and 4 intentional proof-writer
  skips. `flutter analyze --no-pub` and the web build also passed.

Native Android and iOS route-level rendering remains a release QA gate.

## Dashboard 320 Density Repair

- Audited `output/playwright/dashboard-320-before-comparison.png` against the
  approved created-account source at identical 320px scaling.
- Replaced the default below-330 stacking behavior with the shared discrete
  replica tokens. The hero, reward pair, post-request row, and active-request
  row retain the approved horizontal composition at Small and Medium.
- Removed `IntrinsicHeight` and forced cross-axis stretching from the reward
  pair. Both cards stay side-by-side and independently size below the 120px test
  ceiling, matching the approximately 111px source target without blank fill.
- The 320 header, activity rows, reward banner, gaps, and bottom navigation use
  the 320/390 token so the complete recent-activity panel and banner retain the
  approved 320x693 density.
- Widths 390 through 430 use reference tokens. Effective text scale above 1.0
  uses the larger stack/reflow/scroll paths, including the external system scale
  preserved by the application-level maximum behavior.
- `flutter test test/approved_onboarding_home_test.dart -r compact`: 18 tests
  passed; the pre-existing signed-out-home golden remains intentionally skipped.

A fresh post-change Playwright comparison is still required for final pixel
inspection. No source detail was ambiguous and no artwork, wording, callbacks,
or product logic changed.

## Shared Replica Metrics Pilot - 2026-08-03

- `ApprovedReplicaMetrics` uses a 390 logical-pixel reference canvas with four
  discrete classes: narrow below 340 (`320/390 = 0.8205128`), compact below 390
  (`360/390 = 0.9230769`), reference through 599 (`1.0`), and tablet at 600+
  (`1.0`) centered in a 390 logical-pixel composition.
- Small `0.9` and Medium `1.0` retain screenshot lock. Any effective text scale
  above `1.0`, including Large `1.15`, XL `1.3`, and external scaling, activates
  accessibility reflow and restores reference geometry before Flutter applies
  the effective text scaler.
- Reference dashboard measurements now drive the width tokens: page insets
  `18/8/18/24`; logo `96x58`; mode control minimum `42`, padding `12x8`, icon
  `24`; notification target `44`; hero art `100x82`; hero type `18/11.5` with
  `1.15/1.3` height; reward gap `8`; card padding `10`, radius `8`, border `1`,
  shadow blur `14` at y `5`; reward type `10.5/23`; reward icons `34`; progress
  `6`; request art `36/40`; activity art `30`; banner art `40/84`; navigation
  minimum `78`, icon `28`, label `11`. Letter spacing remains `0`.
- Reward cards use intrinsic independent heights in a top-aligned row during
  screenshot lock; no `IntrinsicHeight`, forced stretch, or blank fill returns.
- The test suite loads the real Nunito variable font through `test/test_fonts.dart`.
  New proof cases cover locked 320/360/390/430 phones, centered 600/768/1024
  tablets, and 320x693 at `1.6` with stack/scroll resilience.

Centralized Flutter proof and a regenerated visual comparison remain pending.

## Exact 390 Replica Pass - 2026-08-03

Compared the five owned surfaces against
`output/playwright/complete-comparison-contact-sheet.png` and the full approved
sources. Source status-bar pixels were separated from in-app geometry before
measuring vertical endpoints.

- Account reference geometry now uses `22px` horizontal insets, a `38x4` grab
  handle, `74px` profile art, `23px` role spacing, `42px` role controls, `44px`
  fields with `9px` gaps, `14/11px` divider spacing, `42px` social actions with
  `5px` gaps, and `10px` before the login row. This restores the cumulative
  source endpoint without inflating one control or changing callbacks.
- Benefit reference geometry now uses a `70px` avatar, `18/11.5px` welcome
  type, `14px` media gaps, `272px` exact-width supplied video, `64px` card
  minimums, `44px` exact icons, `7px` vertical card padding, weight `700` card
  titles, `20px` before a `54px` action, and `6px` progress dots. Longer step-two
  copy may determine intrinsic height as in the source.
- Signed-out home keeps the exact supplied role-card and video assets. Its
  section heading/body are corrected to `14/10px`, reward rows use a `51px`
  minimum, `34px` supplied icons, `12px` radius, `9.5/8.5px` type, and weight
  `700` titles so source-single-line labels remain single-line at Medium.
- Buyer dashboard header geometry is corrected to an `88x54` wordmark, `38px`
  buyer-mode control with `22px` supplied icon and `12px` label, while reward
  cards retain independent intrinsic heights. Activity rows use `7.5px`
  vertical padding, producing the source-height activity panel without blank
  reward-card fill. Existing colors, `8px` card radius, `1px` border, shadow,
  `6px` progress bar, supplied reward art, selected states, and `78px`
  navigation contract remain unchanged.
- All new geometry is expressed through the frozen replica metrics, so 320 and
  360 use their discrete proportional tokens. Widths 430/600/768/1024 center the
  unchanged 390 composition. Effective scaling above `1.0` keeps stack, wrap,
  grow, and scroll escape paths.

Focused tests now assert account field/social rhythm, benefit/avatar/video/card
and action sizes, source-single-line home labels, dashboard reward/activity
composition, centered content at 430/600/768/1024, proportional 320/360 sizes,
320x693 fit, and Large `1.15`/XL `1.3` reflow. Tests continue to load the actual
Nunito variable font. Flutter commands were intentionally not run in this lane.

No supplied artwork, wording, callback, or behavior was changed. Remaining
visual risk is the required regenerated 390 and 320 rendered comparison plus
centralized Flutter proof and Android/iOS safe-area review.

## Account Endpoint Density Correction - 2026-08-03

Centralized proof measured the final 390x844 login action at `832px`, while the
approved source keeps it above the `820px` home-indicator boundary. The modal
header now uses a `103px` stack with the profile starting at the source's `29px`
offset: the `38x4px` grab handle and unchanged `36px` close target share that
upper band instead of consuming serial `4px + 36px` rows before the unchanged
`74px` profile art. This removes `11px` of non-source header whitespace. The
gap from the `42px` Facebook action to the login row is corrected from `10px`
to the source-measured `8px`, recovering the remaining `2px`.

The focused test locks the `103px` combined header, `8px` final gap, unchanged
`44px` fields and `42px` social controls, and requires the login action endpoint
below `820px`. Large/XL retains the existing scroll and accessibility reflow
path. Flutter proof was intentionally left for Po Desk's consolidated run.

## Integration Constraint Correction - 2026-08-03

The password and confirm-password suffixes no longer use `IconButton`, whose
Material minimum contributed a `48px` field height in centralized proof. Each
eye action now uses a semantic `InkWell` constrained by the `42x42px` suffix
slot, with the unchanged supplied `28px` eye artwork and tooltip. This lets every
Medium field honor the source-exact `44px` container while remaining labelled,
tappable, unclipped, and free to grow with Large/XL text.

The proportional `64px` benefit-card minimum assertion now allows `0.01px` of
floating-point tolerance. Production geometry remains unchanged. Focused tests
retain the exact `44px` field contract, assert the `42px` eye tap slot and `28px`
artwork, and preserve the corrected login endpoint below `820px`. Flutter proof
remains for Po Desk's consolidated run.

## Dashboard Reward Pair Equality - 2026-08-03

The same-canvas 390 comparison showed the current Total rewards card ending
about `20-22px` above Pending rewards, while the approved cards share one bottom
edge. Default/Medium now gives only the dedicated reward row intrinsic height
and cross-axis stretch. Pending rewards remains the row's intrinsic height
authority; Total rewards stretches to that edge while retaining its existing
`10px` padding and top-aligned content. No fixed screen-height spacer was added.

The stacked Large/XL branch is unchanged. Replica metrics still scale the row at
320/360, and 430/tablet widths retain the centered 390 composition. Focused
tests now assert equal card heights throughout the locked width contract, exact
equality at 390, and the 320 height proportional to the 390 reference. Request,
activity, onboarding, account, and benefit widgets were not changed. Flutter
proof and regenerated Android/iOS comparison remain with Po Desk.

## Reward Action Alignment Correction - 2026-08-03

Focused 320 proof showed `22.67px` between the Total rewards card bottom and its
action text after equal-height stretching. The row height itself was correct;
the added height had accumulated below the original top-packed CTA. In locked
Default/Medium, the Total rewards column now assigns that extra height before
the CTA, keeping its existing `6px` content gap and `10px` card padding while
moving the action with the shared bottom edge. This restores the proportional
320 bottom gap below `16px` without changing the equal card bottoms or Pending
rewards height.

Large/XL does not receive the flex spacer, so its unbounded stacked/scrolling
layout is unchanged. The existing focused assertion remains strict. The named
320 dashboard test was started through the direct Flutter SDK route, produced no
output, and was terminated after the documented Windows wrapper hang. Its
result remains pending Po Desk's centralized proof.

## Consolidated Proof Update - 2026-08-03

- The unchanged strict 320 dashboard assertion passed in the consolidated
  focused matrix.
- Full repository suite passed with 119 active tests and 4 intentional
  screenshot-writer skips.
- `flutter analyze --no-pub`, web build, and Android debug APK build passed.
- Fresh 390 comparison:
  `output/playwright/replica-final-compare-home-rebuilt-390.png`.
- The reward cards now share one bottom edge and retain proportional 320
  behavior; Large/XL remains stacked and scrollable.

Final result: passed for local responsive implementation and rendered web QA;
native Android/iOS rendered-device proof remains pending.
