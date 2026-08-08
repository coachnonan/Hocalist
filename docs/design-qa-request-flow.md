# Approved Request Flow Design QA

## Scope

The owned request-flow widgets cover product details, service details, service
location, and buyer request details/editing. Existing wording, callbacks,
UI-only state, and supplied artwork remain unchanged. No backend, payment,
checkout, shipping, or inventory behavior was added.

Owned files:

- `lib/features/approved/request_flow_pages.dart`
- `test/approved_request_flow_test.dart`
- `docs/design-qa-request-flow.md`

## Approved References

- `approved resign/post-request-approved/4.2-post-new-request-products-approved.png`
- `approved resign/post-request-approved/4.2.1-post-new-request-service-approved.png`
- `approved resign/post-request-approved/4.2.2-post-new-request-location-approved.png`
- `approved resign/post-request-approved/buyer-bottom-nav-reference.jpeg`
- `approved resign/buyer-request-navigation-approved/4.3 Edit Request Details For Products-approved.png`
- `output/playwright/buyer-320-before-comparison.png`
- `output/playwright/request-current-320x693.png`
- `output/playwright/request-final-comparison-320.png`
- `output/playwright/compare-request-final-390.png`
- `output/playwright/compare-request-detail-final-390.png`
- `output/playwright/replica-final-compare-request-390.png`

## Replica Contract

Default/Medium rendering now uses `ApprovedReplicaMetrics` for every owned
screen. Geometry and typography are discrete, not fluid:

| Available width | Geometry/type scale | Canvas behavior |
| --- | ---: | --- |
| 320-339 | `320 / 390` | Whole 390 reference composition scales to 320 |
| 340-389 | `360 / 390` | Whole 390 reference composition scales to 360 |
| 390-429 | `1.0` | 390 reference composition |
| 430 and wider | `1.0` | Unchanged 390 canvas centered in viewport |

External text scale above `1.0` switches to accessibility reflow. It restores
unscaled control geometry, allows wrapping/stacking where required, caps the
working canvas at 430 logical pixels, and keeps the page scrollable.

## Measurements Adjusted

All listed values are 390-reference logical pixels and are scaled only through
the shared metrics contract:

- Shell: 390 canvas, 24 body inset, 58.5 header and bottom navigation.
- Header: 41.5 back target, 25.6 back artwork, 95x53.625 logo, 36.56 buyer
  control, 18.28 buyer artwork, 39 notification target, 28 notification art.
- Request selector: 57.28 card height, 11 outer inset, 8 radius, 17.06 artwork,
  10.97 title, and 7.92 subtitle.
- Step selector: 24.375 circles, 2.44 connector, and source-aligned asymmetric
  75.56/104.81 horizontal inset.
- Form intro: 12.19 heading, 8.53 supporting copy, 4.875/17.06 vertical gaps.
- Field cards: 9.75 vertical padding, 8 radius, 31.69 prefix well, and 14.625
  artwork. The description uses seven locked lines, a 79.75 reference input,
  and 6.1/12.19 internal text gaps at Medium. Its measured height is 137.54 at
  390 and 112.85 at 320.
- Paired panels: 8.53 column gap, 9.75 request-form row gap and vertical
  padding, 30.47 controls, 12.19 artwork, 8.53 panel labels, and 6.7 helper
  copy. Screenshot-locked Quantity/Category cards are 88.01 high and Higher
  Offers is 100.01 high at 390; those heights scale proportionally at 320.
- Form stack: 9.75 title/description, description/panel, and panel-row gaps,
  followed by a 12.19 gap before the action row.
- Actions: 30.47 height, 8 radius, 8.53 column gap, and 12.19 send artwork.
- Detail summary: 58.5x73.125 product art with source-scaled badge, offer,
  delete, fact, edit, reward, location, and save treatments.
- Surface treatment: 1 border, 8 radius, 18 shadow blur, and 6 shadow offset.

The 390 same-canvas comparison showed that the selector and stepper were close,
while the form ended too early. The retained expansion is concentrated in the
seven-line description and explicit 30.47 CTA. Field values and hints use
Nunito 700 and panel labels use the source-matched 8.53 size.

Focused proof then found the accumulated gaps pushed the 320 Continue bottom to
641.42 and the description to 138.76 at 390. The transitional gaps were restored
to their source-safe values, the description now has a screenshot-only locked
input height, and the lower cards have screenshot-only reference heights. A
small compensation removes `InputDecorator`'s fixed narrow-width contribution.
Large/XL remains intrinsic and reflowing. The final 320 composition satisfies
the unchanged 595-625 Continue bound without wrapping or clipping.

## Focused Proof Defined

`test/approved_request_flow_test.dart` loads Nunito through the actual-font
test helper and defines these checks:

- Every distinct state at 320x693, 360, 390x844, 430, 600, 768, and 1024.
- Explicit 320 and 360 whole-composition scale ratios against 390.
- Explicit 430/600/768/1024 centered, unchanged 390 canvas geometry.
- Strict 320 source-row checks for request kind, paired panels, address fields,
  action rows, and request-detail pairs.
- Strict screenshot-locked single-line checks at 320.
- A 320 Continue-action vertical bound of 595-625 logical pixels to prevent
  the previously excessive blank region above navigation.
- Source-height guards for the description card, lower paired row, and CTA at
  390, plus exact proportional-height guards for the same widgets at 320.
- Product, service, location, and detail actions at 390x844.
- Large/XL accessibility reflow at 1.15, 1.3, and 1.6 text scale on 320x693.
- Existing callback and local-control wiring.
- A labelled 390-wide source/render contact sheet when proof writing is enabled.

## Proof Status And Risk

The direct SDK analyzer was run only against the two owned Dart files:

- `dart analyze lib/features/approved/request_flow_pages.dart test/approved_request_flow_test.dart`
  - Passed: no issues found.

Focused Flutter proof used the SDK snapshot directly to avoid the Windows batch
wrapper:

- `320px default preserves approved single-row composition`
  - Passed.
- `390 and 320 preserve approved form card and CTA heights`
  - Passed.

Remaining risks:

- Fresh post-fix 390 comparison completed at
  `output/playwright/replica-final-compare-request-rebuilt-390.png`.
- Android safe area and keyboard behavior remain unverified on device.
- iOS safe area, keyboard, Dynamic Type, and archive behavior remain unverified.
- The buyer-navigation reference's separate Offers Received page is outside
  this owned request-flow surface.

Final result: passed for local responsive implementation and rendered web QA;
native Android/iOS rendered-device proof remains pending.
