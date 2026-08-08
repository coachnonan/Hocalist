# Accessibility Screen Design QA

- Scope: full responsive replica repair for the buyer Accessibility screen.
- Reference: `approved resign/accessibility/accessibility-settings-approved.jpeg`
- Previous render: `output/playwright/replica-final-accessibility-390x844.png`
- Previous comparison: `output/playwright/replica-final-compare-accessibility-390.png`
- Required verification viewport: 390 x 844 logical pixels, Default font,
  Medium text, Rounded button.

## Corrected Replica Contract

| Detail | 390 target | 320 behavior |
| --- | ---: | ---: |
| Content side inset | 18 | 14.77 |
| Intro panel | 354 x 78 | proportional |
| Text-size options | 4 x 84 x 63 | proportional, one row |
| Text preview | 354 x 104 | proportional |
| Font options | 3 x 114 x 61 | proportional, one row |
| Button options | 2 x 174 x 73 | proportional, one row |
| Rounded sample | 135 x 29 | proportional |
| High-contrast sample | 131 x 29 | proportional |
| Green preview panel | 354 x 74 | proportional |

## Findings

- P0: none identified in source review.
- P1: resolved in the fresh 390 comparison and 320/tablet captures.
- Default and Medium preserve the approved single-row composition. Widths below
  390 scale geometry and typography together, so 320 does not introduce new
  default wrapping.
- Applied Large and Extra Large intentionally stop screenshot-lock scaling,
  reflow option grids, stack dense panels, and remain vertically scrollable.
- Existing source image assets are retained for the back chevron,
  accessibility figure, selection check, preview eyes, and success check.
- Apply and discard semantics are unchanged.

## Final Proof

- `test/accessibility_settings_test.dart`: 6 focused tests passed, including
  390 first-viewport fit, 320 proportional scaling, checkmark clearance, and
  Large/XL deliberate reflow.
- Full repository suite: 119 active tests passed with 4 intentional
  screenshot-writer skips.
- `flutter analyze --no-pub`: no issues.
- Same-canvas 390 comparison:
  `output/playwright/replica-final-compare-accessibility-rebuilt-390.png`.
- Responsive captures:
  `output/playwright/replica-final-accessibility-320x693.png` and
  `output/playwright/replica-final-accessibility-768x1024.png`.
- Web build and Android debug APK build passed. Native Android rendered-device
  inspection remains pending because no emulator/device is installed; iOS
  Simulator and archive proof remain unavailable on this Windows host.

Final result: passed for local responsive implementation and rendered web QA;
native device rendering remains a release gate.
