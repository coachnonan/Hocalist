# Hocalist Accessibility Implementation Plan

## 1. Purpose

Build a native Flutter `Settings > Accessibility` experience that follows the
approved accessibility reference while protecting the client's approved mobile
designs as the default visual contract.

The feature must let a user intentionally increase readability without causing
text clipping, one-letter columns, hidden actions, broken navigation, or a
different default design for users who never change accessibility settings.

## 2. Product Outcome

The finished behavior should be:

1. A new installation opens with the approved Hocalist design at the exact
   baseline typography and component geometry.
2. Buyer and seller users can open the same accessibility screen from their
   role-appropriate settings/menu surface.
3. Text-size changes apply across the app only after the user chooses Apply,
   persist locally in the first implementation stage, and never reduce a larger
   Android or iOS system accessibility setting.
4. The accessibility page updates its local preview immediately while keeping
   the rest of the app unchanged until Apply is confirmed.
5. Font and button profiles use approved assets/tokens and do not silently
   reinterpret the client's default design.
6. Android and iOS are independently proved at normal and aggressive text
   scales.

## 3. Confirmed Direction

- The approved app designs remain the default. Accessibility is an explicit
  user preference, not a redesign automatically applied to everyone.
- Accessibility is ultimately an account-synced preference shared by buyer and
  seller modes. Stage 1 persists the same model on the device until the approved
  authentication/backend sync contract exists.
- Buyer `Account settings > Accessibility` is the first approved entry point.
  Seller navigation and seller-settings placement are deferred until the owner
  supplies the seller reference screenshots.
- The accessibility screen should faithfully reproduce the supplied layout:
  header, introduction panel, text-size choices, live text preview, font-style
  choices, button-style choices, and the green full-preview panel.
- The app keeps its role-appropriate Hocalist bottom navigation. The reference
  image's `Customers`, `Meets`, and `Messages` labels must not replace current
  app navigation without a separate information-architecture approval.
- No Supabase migration, RLS change, authentication change, or billing work is
  part of the visual Stage 1 implementation. Account sync is a recorded final
  requirement, not permission to invent a temporary backend contract.
- There is no Figma or editable design source. Approved screenshots are the
  visual source of truth; measurements, color sampling, icon extraction, and
  same-viewport overlays replace design-file inspection.
- The first-launch profile is `Medium / Default / Rounded`. The supplied
  accessibility screenshot is reproduced in its visible
  `Large / Default / Rounded` comparison state.
- Rounded is the approved default button treatment. High Contrast is the
  alternative rectangular treatment shown in the reference.
- Accessibility changes only typography family, text size, and button profile.
  It does not silently recolor the complete interface.
- Existing buyer wording and functionality are frozen during this design batch.
  The new Accessibility page uses the wording visible in its approved screenshot;
  existing buyer screens retain their currently implemented strings, including
  owner-directed wording changes already made. No copy rewrite is part of this
  visual implementation. Payment-protection wording remains a separately named
  product/release concern and does not authorize copy changes in this batch.

## 4. Current-State Findings

The codebase already has part of the needed foundation:

- `AppTextSize` currently contains `medium`, `large`, and `extraLarge` values.
- `HocalistPrototype` already owns the selected text size and dark-mode state.
- `MaterialApp.builder` applies a global text scaler and caps the result at 1.6.
- `SharedPreferences` already saves and restores the text-size selection.
- Buyer More and Seller Profile both open the same `SettingsPage`, although the
  route is currently named `buyerSettings`.
- `SettingsPage` currently embeds a slider-based `TextSizePreferenceCard` under
  Preferences; there is no dedicated accessibility route or exact reference UI.
- Widget tests already include a 360 logical-pixel "boss phone" viewport at
  1.6 text scale and a 390-pixel accessibility viewport at 1.3.

Important gaps:

- There is no `Small` option and no font-style or button-style preference.
- Text size is presented as a slider rather than the approved selection cards.
- The app declares `Roboto` but does not bundle font files. Android may find
  Roboto, while iOS can fall back to Arial/Helvetica, so exact cross-platform
  typography is not yet guaranteed.
- `PrimaryButton` and other shared widgets hardcode shapes and some colors, so a
  ThemeData-only button preference would not reach every component.
- Several screens contain fixed rows, fixed heights, one-line labels, and direct
  numeric font overrides. Global scaling therefore needs an app-wide responsive
  hardening pass, not only a new settings screen.
- The shared route name and buyer-only selected-nav mapping obscure the fact that
  settings are already used by both roles.

## 5. Resolved Owner Decisions And Remaining Gates

The owner decisions in this section are implementation requirements. Only items
explicitly listed as remaining proof or platform gates remain open.

### 5.1 Exact Default Font

Because no original font source or Figma file exists, use this three-family
shortlist and bundle every selected file from the official Google Fonts source:

| UI profile | Family | Bundled source file | Required weights | License |
| --- | --- | --- | --- | --- |
| Default | Nunito | `Nunito-Variable.ttf` | 400, 500, 600, 700, 800 | SIL Open Font License 1.1 |
| Friendly | Lexend | `Lexend[wght].ttf` | 400, 500, 600, 700 | SIL Open Font License 1.1 |
| High Contrast | Archivo | `Archivo-Variable.ttf` | 100-900 | SIL Open Font License 1.1 |

Store each upstream `OFL.txt` beside its family in `assets/fonts/licenses/` and
record source URL, download date, exact filename, and SHA-256 in a font manifest.
Do not rely on an operating-system copy of any family.

Expected repository layout:

```text
assets/fonts/nunito/Nunito-Variable.ttf
assets/fonts/lexend/Lexend[wght].ttf
assets/fonts/archivo/Archivo-Variable.ttf
assets/fonts/licenses/Nunito-OFL-1.1.txt
assets/fonts/licenses/Lexend-OFL-1.1.txt
assets/fonts/licenses/Archivo-OFL-1.1.txt
assets/fonts/FONT_MANIFEST.md
```

Official source records:

- Nunito: `https://github.com/google/fonts/tree/main/ofl/nunito`
- Lexend: `https://github.com/google/fonts/tree/main/ofl/lexend`
- Archivo: `https://github.com/google/fonts/tree/main/ofl/archivo`

Weight mapping is explicit. Nunito, Lexend, and Archivo use their variable
weight axes. Archivo reaches 900 so the High Contrast profile can reproduce the
approved heavy display treatment without synthetic platform weights.
Italic files are not bundled unless an approved screenshot requires italics.

Resolved visual decision: use Nunito as the Default family. A direct raster
comparison against Nunito Sans, Lexend, and Archivo found Nunito closest in
title width, rounded terminals, lowercase proportions, and overall visual weight.
Implementation overlays still tune the exact Nunito weight, optical-size axis,
font size, line height, and baseline; they are QA, not another owner decision.

### 5.2 Initial Selected Text Size

Resolved: `Medium` is selected on first launch and maps to the approved baseline
at 1.0. The supplied reference is tested and presented with `Large` selected;
that screenshot state does not change the first-launch default.

### 5.3 Friendly Font Profile

Resolved candidate: `Lexend`, bundled from the official Google Fonts repository
with its SIL OFL 1.1 license. The option card must render the actual Lexend font,
not a label drawn in the default family.

### 5.4 Button Geometry

Resolved: `Rounded (Default)` preserves the approved rounded Hocalist treatment
shown in the screenshot. `High Contrast` uses the visible rectangular treatment
and stronger contrast. The selection changes only the shared button profile and
does not trigger a complete-interface contrast theme.

### 5.5 Apply Behavior

Resolved: option taps modify draft preferences and the preview only. The rest of
the app changes only after `Apply changes` is selected in the full-preview flow.
Back or Cancel discards unapplied changes after a confirmation prompt when the
draft differs from the applied profile.

### 5.6 Preference Sync

Final product requirement: sync applied accessibility preferences to the signed-
in user account so buyer and seller modes and future devices share one profile.
Stage 1 remains device-local because the owner has deferred backend logic. Stage
2 may add account sync only after the schema, RLS, offline conflict behavior, and
signed-out behavior are separately approved.

## 6. Proposed Preference Model

Create a single immutable preference object rather than adding unrelated state
fields throughout the app.

```dart
enum AccessibilityTextSize {
  small('Small', 0.90),
  medium('Medium', 1.00),
  large('Large', 1.15),
  extraLarge('Extra Large', 1.30);
}

enum AccessibilityFontStyle {
  standard,
  friendly,
  highContrast;
}

enum AccessibilityButtonStyle {
  rounded,
  highContrast;
}

class AccessibilityPreferences {
  final AccessibilityTextSize textSize;
  final AccessibilityFontStyle fontStyle;
  final AccessibilityButtonStyle buttonStyle;
}
```

Implementation requirements:

- Maintain separate `appliedPreferences` and page-local `draftPreferences`.
- Option taps update only `draftPreferences` and the preview surface.
- `Apply changes` copies the draft into `appliedPreferences`, updates the app
  theme, and persists the result as one atomic preference record.
- Cancel/back restores the draft from the applied value and never partially
  persists one option.
- Use enum names or explicit stable storage codes, never display labels, as
  persisted values.
- Add a preference schema version so future renames can migrate safely.
- Preserve old stored `medium`, `large`, and `extraLarge` values.
- Missing or invalid values fall back to approved defaults instead of failing app
  startup.
- Keep `copyWith`, equality, and defaults together with the model.
- Keep display labels in the UI/localization layer when localization begins.

Recommended SharedPreferences keys:

```text
hocalist.accessibility.version
hocalist.accessibility.textSize
hocalist.accessibility.fontStyle
hocalist.accessibility.buttonStyle
```

The old `hocalist.textSize` key should be read once as a migration fallback, then
the new key should be written on the next save. Do not delete the old key during
the first implementation pass; retaining it makes rollback safer.

## 7. Text-Scaling Policy

The client-selected size and the operating-system accessibility size must not be
multiplied blindly. Multiplication can turn a 1.6 system scale and 1.3 app scale
into 2.08, producing the exact overflow problem this feature is meant to solve.

Recommended rule:

1. At the default Android/iOS text scale, use the selected app tier directly.
2. When the operating system requests a scale above 1.0, never return an
   effective scale below the system request.
3. Use the larger of the system request and selected app tier rather than
   multiplying them.
4. Keep the present 1.6 prototype ceiling only as a documented temporary safety
   guard. Reconsider the cap after the app passes layouts at 1.6 without it.

Conceptually:

```dart
final systemScale = MediaQuery.textScalerOf(context).scale(1);
final selectedScale = preferences.textSize.scale;
final effectiveScale = systemScale > 1.0
    ? max(systemScale, selectedScale)
    : selectedScale;
```

This lets a user choose Small on a device at the normal system setting but does
not let the app cancel an enlarged operating-system preference.

## 8. Theme And Component Architecture

### 8.1 Theme Extension

Add a `HocalistAccessibilityTheme` ThemeExtension containing resolved values:

- font family and fallback list
- text-weight profile
- primary text and muted text contrast values
- button radius
- button minimum height
- button border width
- button foreground/background behavior
- focus/selected border treatment

`HocalistTheme.light` and `HocalistTheme.dark` should become preference-aware
builders. Their default output must remain visually identical to the approved
baseline.

### 8.2 Shared Components First

Update shared components before repairing individual screens:

- `PrimaryButton`
- `SecondaryButton`
- settings/action cards
- alert banners
- app header and role badge
- buyer and seller bottom navigation
- form fields and labels
- badges and compact status chips
- modal/dialog action rows

Rules for shared components:

- minimum tap target: 48 logical pixels where layout allows, never below 44
- no fixed text-bearing height that cannot grow
- critical actions wrap or expand; they are not ellipsized
- compact metadata may ellipsize only when the full value is available elsewhere
- body text is never placed in `FittedBox`
- responsive decisions use the component's available width from `LayoutBuilder`,
  not only the full device width
- selected state uses border/check/icon plus color, not color alone

## 9. Navigation And Screen Placement

### 9.1 Routes

- Rename `AppPage.buyerSettings` to `AppPage.accountSettings`.
- Add `AppPage.accessibility`.
- Add the accessibility page to the buyer More selected-nav group.
- Keep the shared route capable of supporting seller mode later, but do not add
  or visually approve seller navigation/settings placement until the seller
  references arrive.
- Preserve normal back behavior to the buyer Account Settings screen in Stage 1.
- Do not create separate buyer and seller accessibility pages.

### 9.2 Entry Point

Replace the embedded text-size slider in `SettingsPage` with one action tile:

```text
Accessibility
Text size, font readability, button visibility, and preview.
Current: Medium / Default / Rounded
```

The tile opens the dedicated page. Dark mode remains in general Preferences
unless the client later asks to move appearance controls into Accessibility.

### 9.3 App Shell

The accessibility route should suppress the normal Hocalist logo/role header if
that header prevents faithful reproduction of the supplied page header. The
bottom navigation remains fixed and role-appropriate.

The page itself owns:

- back button with tooltip and semantic label
- centered `Accessibility` title
- centered `Customize Hocalist to fit your needs` subtitle
- scrollable body with bottom padding above the fixed navigation

## 10. Accessibility Screen Specification

### 10.1 Intro Panel

- soft lavender surface matching the reference
- accessibility icon in a circular tinted treatment
- title: `Make Hocalist easier to read and use`
- supporting text from the approved image
- icon is decorative only if the full meaning is in the text; otherwise provide
  one concise semantic label

### 10.2 Text-Size Selection

- section number, title, and supporting instruction
- four selection cards: Small, Medium, Large, Extra Large
- large `Aa` sample scaled to represent the option
- selected card has primary border and a checkmark in the top-right corner
- entire card is one radio-style semantic control
- tapping a card updates the draft and live preview only
- screen-reader announcement reports the selected value

### 10.3 Live Text Preview

- lavender preview panel
- eye icon and `Preview` label
- title: `This is how text will look`
- approved supporting copy
- uses the draft/current text and font settings, not hardcoded preview typography
- reflows vertically; no fixed height

### 10.4 Font-Style Selection

- three option cards: Default, Friendly, High Contrast
- each card displays `Hocalist` in the actual candidate style
- selected state follows the same radio-card pattern
- Default uses the approved bundled family
- Friendly uses only a client-approved bundled family
- High Contrast uses the approved family with stronger weight and contrast; it
  must not rely on all-caps alone

### 10.5 Button-Style Selection

- two option cards: Rounded (Default) and High Contrast
- sample buttons are real disabled/example widgets, not screenshot crops
- card tap changes the draft button profile and local preview only
- selected checkmark remains separate from the sample button
- High Contrast increases contrast and border clarity while preserving at least
  a 48-pixel tap target

### 10.6 Full Preview Panel

- pale green surface and green success/eye treatment matching the reference
- title: `Preview your selection`
- supporting text from the reference
- `Show Preview` opens a full-screen dialog or route using current preferences
- preview includes at minimum: page title, body text, primary button, secondary
  button, form field, card, status badge, and bottom-nav label
- preview has an `Apply changes` primary action and a Cancel/back action
- `Apply changes` commits all three draft values together, updates the app, and
  persists the applied profile
- close/back returns to the accessibility page without applying the draft

## 11. Responsive Layout Matrix

| Condition | Text-size cards | Font cards | Button cards | Intro/full-preview panels |
| --- | --- | --- | --- | --- |
| 375-430 px, scale <= 1.15 | 4 columns | 3 columns | 2 columns | horizontal |
| 360-374 px or scale > 1.15 | 2 x 2 grid | 1 column or 2 + 1 only if labels fit | 1 column | stack icon/text/action |
| 344-359 px | 2 x 2 grid | 1 column | 1 column | vertical |
| >= 600 px | centered max-width mobile canvas | centered max-width mobile canvas | centered max-width mobile canvas | no uncontrolled stretching |

Additional responsive requirements:

- Grid breakpoints use the local content width after page/card padding.
- A 375 px iPhone X-class viewport and a 390 px iPhone 13-class viewport retain
  the same four/three/two-column composition at normal text scale.
- Do not scale font sizes as a direct function of viewport width. Keep the
  selected typography tokens stable; adapt side padding, gaps, card widths, and
  wrapping so smaller phones preserve the same design without unreadably small
  text.
- Cards use minimum heights at normal scale but can grow vertically.
- `Extra Large` may wrap to two lines; it must never shrink below the selected
  accessibility size to fit a card.
- Section spacing remains visually close to the reference at normal scale and
  expands naturally at higher scales.
- Safe-area padding protects the first header row and final preview panel on both
  platforms.
- The bottom navigation must grow or adapt at large text scales; a fixed 72-pixel
  seller navigation height cannot be assumed safe.

## 12. Proposed File Ownership

### New Files

- `approved resign/accessibility/accessibility-settings-approved.jpeg`
  - repository copy of the owner/client reference used for visual proof
- `lib/features/accessibility/accessibility_preferences.dart`
  - enums, model, defaults, migration helpers, resolved profile values
- `lib/features/accessibility/accessibility_page.dart`
  - page composition, draft-selection behavior, and Apply/Cancel flow
- `lib/features/accessibility/accessibility_components.dart`
  - option card, preview card, section header, and full-preview UI
- `test/accessibility_settings_test.dart`
  - focused route, persistence, semantics, scaling, and overflow tests

### Existing Files

- `lib/main.dart`
  - add parts/imports, state, route, callbacks, persistence wiring, shell/header
    exception, role-aware selected-nav mapping, and global scale resolution
- `lib/theme/hocalist_theme.dart`
  - preference-aware typography, font family, contrast, and button tokens
- `lib/components/ui_components.dart`
  - make shared buttons/navigation/text-bearing components respond to the theme
    extension and larger text
- `lib/features/screens.dart`
  - replace embedded slider with Accessibility tile; responsive repairs found in
    journey testing
- `pubspec.yaml`
  - register approved font files and the reference/feature assets if required
- `test/widget_test.dart`
  - retain broad journey regressions and add shared-shell assertions only where
    they belong to existing flows

The current project uses Dart `part` files. The first pass should preserve that
structure to keep scope controlled while moving accessibility code into its own
feature directory. A package-wide architecture rewrite is not required for this
feature.

## 13. Implementation Phases

### Phase 0: Lock The Visual Contract

1. Copy the supplied reference into `approved resign/accessibility/`.
2. Record the reference pixel dimensions and target logical viewport.
3. Vendor Nunito as the resolved Default plus Lexend and Archivo as the two
   selectable alternatives, with all OFL files.
4. Confirm `Medium / Default / Rounded` as the first-launch baseline and
   `Large / Default / Rounded` as the supplied screenshot state.
5. Capture current approved buyer screens at 390 px and text scale 1.0.
6. Treat those captures as regression baselines for the untouched default mode.

Exit gate: no unresolved decision changes baseline typography or default buttons.

### Phase 1: Preference Model And Migration

1. Add the accessibility enums and immutable model.
2. Replace the single `textSize` field with `AccessibilityPreferences`.
3. Add stable SharedPreferences keys and schema version.
4. Read legacy `hocalist.textSize` values.
5. Keep draft and applied values separate; save all three values only on Apply.
6. Add parsing fallbacks for invalid or future values.
7. Unit-test defaults, migration, save, restore, and corrupted values.

Exit gate: app cold-start restores the same preference values without changing
the default appearance.

### Phase 2: Shared Route And Settings Entry

1. Rename the shared account-settings route.
2. Add the accessibility route and buyer More navigation grouping.
3. Add the settings action tile with a current-value summary.
4. Remove the embedded slider to avoid two competing controls.
5. Verify buyer More reaches the screen.
6. Verify back returns to buyer Account Settings.
7. Leave seller placement disabled until the seller navigation/settings
   screenshots are supplied and measured.

Exit gate: route and navigation tests pass for the approved buyer flow; seller
placement is listed as deferred rather than guessed.

### Phase 3: Exact Accessibility Page

1. Build the custom page header and intro panel.
2. Build reusable semantic selection cards.
3. Build text-size section and live preview.
4. Build font-style section using approved font assets.
5. Build button-style section using real button widgets.
6. Build green preview panel and full-screen preview.
7. Add immediate draft preview, Apply/Cancel behavior, persistence on Apply,
   haptics only if already supported, and accessible announcements.
8. Match colors, border widths, radii, padding, icon treatment, font sizes, and
   weights against the reference.

Exit gate: side-by-side comparison at the reference viewport has no unexplained
visual substitutions or structural drift.

### Phase 4: Global Theme Integration

1. Resolve font family/weights from the preference model.
2. Resolve high-contrast foregrounds, backgrounds, borders, and focus states.
3. Resolve button radius, border, height, and label style.
4. Apply text scaling without double-multiplying system and app settings.
5. Update shared components that bypass ThemeData.
6. Confirm Default/Medium output matches Phase 0 baseline screenshots.

Exit gate: default-mode image comparison remains stable and each non-default
profile is visibly distinct.

### Phase 5: App-Wide Responsive Hardening

Repair by shared component and journey rather than changing every numeric value
blindly.

1. App shell: global header, back-title rows, buyer nav, snackbars, dialogs, and
   keyboard insets.
2. Public/onboarding: welcome, account access, buyer benefits, seller setup.
3. Buyer core: dashboard, post request, request details, offers, offer details,
   chat, deal finalization, confirmation, review, wallet, support.
4. Shared support/settings: notifications, saved items, safety, reports, help,
   profile edit, account settings, accessibility.
5. Replace unsafe fixed rows with `Wrap`, responsive `Column`, or locally
   constrained alternatives.
6. Remove fixed text-bearing heights or make them minimum constraints.
7. Preserve approved normal-scale spacing and sizes while adding high-scale
   escape paths.

Seller-wide responsive hardening is a later batch after the seller reference set
is supplied. Shared components may be made safe now, but seller screen geometry
must not be visually redesigned from buyer evidence.

Exit gate: every priority route completes without Flutter overflow exceptions at
360 px / 1.6 scale and remains visually correct at 390 and 430 px / 1.0 scale.

### Phase 6: Platform Proof And Review

1. Run targeted accessibility tests first.
2. Run the full Flutter widget suite once after the coherent batch is stable.
3. Run `flutter analyze` as the authoritative analyzer.
4. Capture Android emulator or physical-device proof at 360, 390, and 430
   logical pixels; Flutter web on localhost is owner preview only.
5. Capture iOS proof on a small iPhone and a modern notched/Dynamic Island
   iPhone.
6. Compare the approved reference and implementation at matching viewport/state
   in one side-by-side image.
7. Run a UX review for contrast, touch targets, text fit, semantics, navigation,
   and preview clarity.
8. Record remaining platform blockers separately; Android proof never stands in
   for iOS proof.

Exit gate: all acceptance criteria below pass, with evidence paths recorded.

## 14. Test Plan

### 14.1 Preference And Migration Tests

- new install receives approved defaults
- legacy medium/large/extraLarge values migrate correctly
- missing font/button values receive defaults
- invalid enum values do not crash startup
- changing a draft option does not affect the surrounding app before Apply
- Apply persists all three selections across a reconstructed app
- Cancel/back discards the unapplied draft
- buyer/seller role switch does not reset an already applied preference model
- dark-mode persistence remains unaffected

### 14.2 Accessibility Page Widget Tests

- buyer can open `Account settings > Accessibility`
- seller entry remains absent until its approved navigation/settings reference
- all four text-size cards render and expose radio/selected semantics
- all three font cards render with actual profile styles
- both button cards render with actual profile styles
- one and only one option per section is selected
- tapping each option updates only the local preview and draft summary
- Show Preview opens and closes without applying or losing draft state
- Apply changes commits all three draft selections and updates the app
- Cancel leaves the applied app profile unchanged
- back navigation returns to Account Settings
- no control is hidden behind the bottom navigation or safe area

### 14.3 Responsive/Overflow Matrix

Run the accessibility page and priority journeys at:

- 344 x 900 at 1.0 and 1.3
- 360 x 900 at 1.0, 1.3, and 1.6
- 375 x 812 at 1.0 and 1.3
- 390 x 1000 at 1.0, 1.3, and 1.6
- 430 x 1000 at 1.0 and 1.3
- tablet width at 1.0 and 1.3

For each matrix case:

- `tester.takeException()` is null
- no RenderFlex overflow banner appears
- primary actions remain visible and tappable
- critical labels are not ellipsized
- text does not overlap icons, checkmarks, cards, or subsequent sections
- option-card selection does not resize neighboring cards unexpectedly

### 14.4 System Accessibility Tests

- Android/iOS system scale above 1.0 is never reduced by an app preference
- system 1.6 plus app Large does not compound beyond the documented policy
- changing app size does not alter icon-only semantic labels
- TalkBack and VoiceOver announce section labels, selected options, and buttons
- selected state is understandable without color
- focus order follows visual top-to-bottom order

### 14.5 Visual Regression Proof

At minimum capture:

- accessibility page at Medium/Default/Rounded
- accessibility page at Large/Default/Rounded to match the supplied selected state
- accessibility page at Extra Large/High Contrast/High Contrast
- approved buyer home/dashboard at default preferences
- one dense buyer request/offer screen at 1.6
- buyer bottom navigation at 1.6

Use equal viewport sizes and place reference plus rendered implementation into
one comparison image. Screenshots alone are evidence; the comparison and
documented differences are the review.

## 15. Android Proof

- `localhost`/Flutter web may be used for quick owner review, but it is not
  accepted as Android platform proof.
- Small Android logical width around 360 px with display/font scale 1.6
- Common Android width around 390 px at default scale
- Large Android width around 430 px at default and 1.3
- gesture-navigation bottom inset
- hardware/system back returns to Account Settings
- keyboard does not cover preview close/action controls
- TalkBack labels and selected states
- debug APK or app launch proof after tests pass

## 16. iOS Proof

- The installed iOS plugin provides tooling, not an iOS runtime on Windows.
- Preferred proof route: connect the installed iOS plugin to a local or remote
  Mac running Xcode and use Simulator for repeatable screenshots at iPhone X
  (375 logical px) and iPhone 13-class (390 logical px) viewports.
- Follow Simulator proof with one physical iPhone smoke check when available;
  Simulator supplies the repeatable visual matrix, while a physical device
  catches rendering or safe-area behavior simulation cannot fully reproduce.
- A plugin installed only on this Windows host cannot create an Apple Simulator.
  The current task exposes no callable Xcode/Simulator runtime, so the installed
  plugin is not yet connected to a usable iOS proof host. Without a reachable
  Mac/Xcode host, report iOS proof as explicitly blocked.
- small iPhone viewport with increased Dynamic Type
- modern 393 px iPhone viewport with notch/Dynamic Island safe area
- large iPhone viewport around 430 px
- home-indicator inset above bottom navigation
- iOS back behavior and preview dismissal
- VoiceOver labels, traits, selected states, and focus order
- font files render identically instead of falling back silently
- simulator launch/build proof or an explicit machine/tooling blocker

## 17. Acceptance Criteria

The feature is complete only when all of the following are true:

1. Default preferences reproduce the approved app typography and buttons without
   unexplained visual changes.
2. The dedicated accessibility page matches the supplied reference in structure,
   spacing, colors, typography, icons, selection treatment, and scroll behavior.
3. Buyer users can reach the page through Account Settings; seller placement is
   deferred until its approved screenshots are supplied.
4. Text-size, font-style, and button-style values change globally only after
   Apply and persist across app restart.
5. The page and priority journeys show no overflow at 360 px and 1.6 text scale.
6. The same responsive fixes do not make 390/430 px phones unnecessarily small.
7. Android and iOS safe areas keep headers, content, actions, and navigation clear.
8. System accessibility scaling is respected according to the documented policy.
9. Selected options are exposed semantically and do not rely on color alone.
10. Interactive targets are at least 44 px and normally 48 px.
11. The full preview accurately uses the draft preferences and exposes Apply and
    Cancel without accidental global changes.
12. `flutter analyze` and the focused/full Flutter tests pass.
13. Android and iOS risks are reported separately with rendered proof or a named
    blocker.
14. No backend, payment, marketplace, seller-navigation, or other approved
    navigation behavior changes as a side effect.

## 18. Risks And Mitigations

### Font Mismatch

Risk: declaring a font name without bundling it gives different Android/iOS
results. Mitigation: obtain and bundle the approved family and weights before
visual signoff.

### Default-Design Drift

Risk: a global theme refactor changes every approved screen. Mitigation: capture
default baselines first, keep 1.0/default tokens unchanged, and compare after
each coherent phase.

### Double Scaling

Risk: multiplying app and system scales creates extreme sizes. Mitigation: use
the documented max-based policy and test system/app combinations.

### Fixed Layouts Outside Settings

Risk: the new control works but other routes overflow. Mitigation: shared
component repair followed by journey-based 360/390/430 tests.

### Misleading High Contrast

Risk: bold text or uppercase is labelled accessible without sufficient contrast.
Mitigation: define verified foreground/background/border token pairs and inspect
light/dark modes.

### Navigation Drift

Risk: copying the reference bottom-nav labels changes Hocalist's product flow.
Mitigation: replicate the accessibility content while preserving approved
role-specific navigation unless the owner separately approves an IA change.

### Prototype Persistence Growth

Risk: more fields make the current monolithic session store harder to maintain.
Mitigation: isolate accessibility parsing/model logic now and defer a larger
state-management migration until real backend work requires it.

## 19. Delivery Shape And Estimate

Recommended delivery is one coherent Flutter accessibility feature followed by
one consolidated proof pass, with client decisions locked before global theme
changes.

Estimated implementation effort after font/button decisions:

- visual/spec lock and baseline proof: 0.5-1 day
- preference model, migration, and routes: 0.5-1 day
- exact accessibility screen and preview: 1-2 days
- shared theme/component integration: 1-2 days
- priority journey responsive hardening: 2-4 days
- Android/iOS proof and final visual review: 1-2 days

Expected total: approximately 6-12 engineering/QA days depending on how many
existing screens fail at 1.6 scale and whether iOS tooling is immediately
available. This estimate excludes a new font design, backend preference sync,
localization, and store release work.

## 20. Ownership And Gates

### Product/UX Desk

- owns exact reference interpretation, unresolved client questions, typography
  specification, responsive behavior, and final side-by-side review
- stops when an asset, font, button shape, or navigation detail would be guessed

### Flutter App Desk

- owns the files listed above, local persistence, routes, theme integration,
  responsive widgets, semantics, and tests
- excludes backend, auth, billing, and release mutation
- checks the approved-screenshot, boss-phone, available-width, small-phone, and
  Flutter-analyzer gotchas before editing

### UX Review Desk

- owns text fit, touch targets, contrast, non-color state, semantics, navigation,
  safe areas, and reference comparison at required viewports
- cannot pass from source code alone; rendered evidence is required

### Proof/Release Desk

- owns authoritative `flutter analyze`, targeted/full tests, Android build/launch
  proof, iOS proof or blocker, evidence paths, branch state, and closeout
- does not promote or deploy production without separate approval

## 21. Out Of Scope For This Feature

- implementing Supabase/account-profile sync in Stage 1; account sync remains the
  approved final requirement for a later backend stage
- seller navigation, seller Settings placement, and seller-specific screenshot
  replication until the owner supplies those references
- changing buyer/seller marketplace business behavior
- replacing Hocalist bottom navigation with the reference image's labels
- adding ecommerce checkout, escrow, shipping, or inventory
- localization of the entire app
- full WCAG/TalkBack/VoiceOver certification of every future screen
- production App Store/Play Store release
- redesigning approved default screens beyond responsive escape paths required to
  prevent accessibility breakage

## 22. Final Implementation Sequence

1. Record the owner decisions in Section 32 and resolve only the remaining font
   overlay, neutral-copy, and platform-tooling gates.
2. Save the reference in the approved-design folder.
3. Capture default regression baselines.
4. Implement preference model and legacy migration.
5. Implement the buyer route and Settings entry while keeping seller placement
   deferred.
6. Build the exact accessibility screen and full preview.
7. Integrate preference-aware theme and shared components.
8. Harden priority buyer journeys at high text scale.
9. Run focused tests, then one consolidated full proof pass.
10. Complete Android and iOS rendered review.
11. Record decisions, proof, and any repeatable gotchas.
12. Present the default and accessibility variants to the client as separate,
    intentional experiences.

## 23. Pixel-Exact Visual Contract

This section converts the approved raster references into an implementation and
review contract. It is intentionally stricter than the earlier feature plan.

### 23.1 What "Exact" Means

At the approved default preference, exact means:

- the same content hierarchy and section order
- the same line wrapping at the reference width
- the same visible font family and weight
- text baselines within 1 logical pixel of the approved reference
- component edges within 1 logical pixel of the approved reference
- spacing, radius, stroke, icon, and artwork geometry within 1 logical pixel
- flat colors matched to the approved token or within a CIEDE2000 delta of 3
- shadows and antialiasing visually equivalent at normal inspection size
- no substituted logo, illustration, social icon, navigation icon, or product art
- no default-mode responsive change unless required by a smaller viewport than
  the approved reference

At non-default accessibility sizes, exact means preserving the same design
language and content priority while following the reflow rules in this contract.
It does not mean forcing the original coordinates after text becomes larger.

### 23.2 Evidence Levels

Every visual number below is labelled by its source:

- `Measured`: derived directly from the supplied raster reference.
- `Normalized`: source pixels converted to the common logical-width coordinate
  system described below.
- `Token`: a central Flutter value that must be used consistently.
- `Pending source`: cannot be guaranteed from a JPEG/PNG alone and needs the
  client font, source design, or explicit approval.

Raster references can establish visible geometry and approximate color. They
cannot prove the original font file, font internal metrics, hidden layers,
responsive constraints, or semantic behavior. Those remain named gates rather
than guesses.

## 24. Reference Coordinate System

### 24.1 Canonical Width

The approved screens were exported at different raster scales but share nearly
the same phone aspect ratio. Normalize all full-screen references to a canonical
logical width of `426.5`.

Use:

```text
normalizationScale = sourcePixelWidth / 426.5
logicalX = sourcePixelX / normalizationScale
logicalY = sourcePixelY / normalizationScale
logicalSize = sourcePixelSize / normalizationScale
```

For the common `853 x 1844` references, the scale is exactly `2.0`, producing a
canonical `426.5 x 922` canvas. Do not infer device pixel ratio from exports that
have been resized; normalize by width instead.

### 24.2 Approved Reference Inventory

| Reference | Source pixels | Normalized target | Contract role |
| --- | ---: | ---: | --- |
| Accessibility settings reference | 853 x 1844 | 426.5 x 922.0 | Exact accessibility page and selected states |
| Account creation | 853 x 1844 | 426.5 x 922.0 | Auth sheet, role switch, fields, social actions |
| Buyer benefit 3 | 853 x 1844 | 426.5 x 922.0 | Buyer onboarding benefit layout A |
| Buyer benefit 4 | 853 x 1844 | 426.5 x 922.0 | Buyer onboarding benefit layout B |
| Created-account home | 854 x 1844 | 426.5 x 920.9 | Buyer dashboard and signed-in navigation |
| Edit request details | 853 x 1844 | 426.5 x 922.0 | Request detail/edit form |
| Offers received | 1726 x 3646 | 426.5 x 900.9 | Rewards summary and offer cards |
| Hocatrends | 853 x 1844 | 426.5 x 922.0 | Ranked category list |
| Hocatrends sellers | 853 x 1844 | 426.5 x 922.0 | Seller list and controls |
| Logged-out home top | 853 x 1844 | 426.5 x 922.0 | Home header, role cards, feature list |
| Logged-out home continuation | 853 x 1844 | 426.5 x 922.0 | Video, FAQ, signup banner |
| Recent activity | 853 x 1844 | 426.5 x 922.0 | Segmented filter and activity rows |
| Offer details | 862 x 1825 | 426.5 x 903.0 | Seller summary, rewards, description, CTA |
| Seller chat | 853 x 1844 | 426.5 x 922.0 | Chat header, offer panel, messages, composer |
| Post product request | 852 x 1846 | 426.5 x 924.1 | Product detail step |
| Post service request | 1107 x 2393 | 426.5 x 922.0 | Service detail step |
| Post service location | 554 x 1197 | 426.5 x 921.5 | Location step and form |
| Buyer bottom navigation crop | 854 x 241 | 426.5 x 120.4 | Nav geometry and selected state |

Asset-only references are not screens and must not be resized into a screen
coordinate system:

- `competitive-flame-reference.png`: 34 x 55 pixels; use as supplied artwork.
- circled brand mark: 4563 x 4563 pixels.
- squared brand mark: 4560 x 4560 pixels.
- vertical transparent brand source: 2400 x 3204 pixels.
- logo with background: 9000 x 4800 pixels.
- logo without background: 5915 x 2524 pixels.

## 25. Baseline Design Tokens

### 25.1 Typography Tokens

Use the following baseline text roles at `Medium` / 1.0. These are the existing
Hocalist token sizes and the approved-reference starting point. A side-by-side
comparison decides any per-screen exception; individual widgets must not invent
nearby values without documenting the exception.

| Role | Size | Line height | Weight | Intended use |
| --- | ---: | ---: | ---: | --- |
| Display | 30 | 36 | 800 | Large marketing or screen statement |
| Page title | 26 | 31 | 800-900 | Request details, Offers received |
| Section title | 20 | 26 | 800 | Major content sections |
| Prominent title | 18 | 23 | 700-800 | Card and compact page headings |
| Component title | 16 | 21 | 700-800 | List/card title, field group title |
| Body | 14 | 20 | 400-600 | Primary descriptions and form content |
| Caption | 13 | 18 | 400-700 | Secondary descriptions and metadata |
| Small | 12 | 16 | 600-800 | Navigation labels and compact metadata |
| Badge | 11 | 14 | 700-800 | Status badges only |
| Button | 16 | 20 | 700-800 | Primary and secondary action labels |
| Metric | 26 | 31 | 700-900 | Money/reward values |

Rules:

- Letter spacing is `0` throughout.
- Page and section headings may use weight 900 only where the reference visibly
  requires it and the approved font has a real 900 weight.
- Body copy uses an explicit line height; Flutter's font default is not the
  contract.
- Navigation labels may not fall below 11 logical pixels.
- Functional text must remain Flutter text, never raster text inside a PNG.
- Nunito is the resolved Default family. Its bundled file and recorded hash
  become the cross-platform typography source of truth; platform fallback is not
  accepted. Screenshot overlays tune weight/size/line metrics, not family choice.

### 25.2 Text-Size Tier Mapping

The visual contract uses absolute tiers at a default operating-system text
scale. The platform scale can raise these values according to Section 7.

| Token | Small 0.90 | Medium 1.00 | Large 1.15 | Extra Large 1.30 |
| --- | ---: | ---: | ---: | ---: |
| Display | 27.0 | 30.0 | 34.5 | 39.0 |
| Page title | 23.4 | 26.0 | 29.9 | 33.8 |
| Section title | 18.0 | 20.0 | 23.0 | 26.0 |
| Prominent title | 16.2 | 18.0 | 20.7 | 23.4 |
| Component title | 14.4 | 16.0 | 18.4 | 20.8 |
| Body | 12.6 | 14.0 | 16.1 | 18.2 |
| Caption | 11.7 | 13.0 | 15.0 | 16.9 |
| Small | 10.8 | 12.0 | 13.8 | 15.6 |
| Badge | 9.9* | 11.0 | 12.7 | 14.3 |
| Button | 14.4 | 16.0 | 18.4 | 20.8 |
| Metric | 23.4 | 26.0 | 29.9 | 33.8 |

`*` The rendered badge font must be clamped to 11 for readability. Small affects
badge padding/density instead of making the text smaller than 11.

Round only at paint/layout boundaries. Keep the underlying calculated value so
small rounding differences do not accumulate across nested components.

### 25.3 Core Color Tokens

The repository's central tokens remain the baseline for existing approved
screens:

| Purpose | Token |
| --- | --- |
| Brand/primary navy | `#00036C` |
| Primary container | `#20258F` |
| Action blue | `#1400C8` |
| Main text | `#0C123D` |
| Muted text | `#5E657F` |
| Canvas/background | `#F7F9FF` or screen-specific white |
| Surface | `#FFFFFF` |
| Soft lavender | `#F1F0FF` |
| Outline | `#C7C9D8` |
| Semantic green | `#078B2D` |
| Error red | `#B42318` |
| Reward gold | `#FFB331` |

Measured accessibility-reference values:

| Purpose | Raster sample | Implementation rule |
| --- | --- | --- |
| Page canvas | `#FFFFFF` | Use white, not the blue-tinted app background |
| Lavender panels | `#F8F7FD` | Accessibility intro and text preview |
| Selected nav fill | approximately `#EFEBFC` | Normalize to `#EFEBFC` after source confirmation |
| Green preview panel | `#F1FAF5` | Full-preview panel background |
| Standard selected/button purple | approximately `#4011FF` | Exact flat source sample; do not substitute Material blue |
| High-contrast button | approximately `#2B11AA` | Exact flat source sample |
| Selected border | approximately `#3C2AB2` | One logical-pixel border at canonical width |
| Card border | approximately `#D9D8DD` | One logical-pixel neutral border |

The screenshot is JPEG-compressed. Before committing these accessibility colors
as permanent tokens, sample the original design source if available. If no source
exists, use the listed flat-area modes and approve a same-size rendered overlay.

### 25.4 Spacing, Radius, And Stroke Tokens

Use this base spacing scale:

```text
4, 6, 8, 10, 12, 16, 18, 20, 24, 28, 32 logical pixels
```

General rules:

- Default page horizontal padding: 20 on the accessibility screen; 16-20 on
  existing screens only as measured from their reference.
- Standard card internal padding: 16.
- Dense card internal padding: 12.
- Section-to-section spacing: 24-28.
- Related label-to-control spacing: 8-12.
- Standard card radius: 8 on the accessibility screen.
- Existing approved cards may retain 12-16 where their source visibly requires
  it; do not replace every radius with one global value.
- Selection/outline stroke: 1 logical pixel normally, 1.5-2 for selected/focus.
- Shadows remain soft and low elevation; no new dark drop shadows.

## 26. Accessibility Screen Measured Specification

The values below use the normalized `426.5 x 922` coordinate space. A tolerance
of 1 logical pixel applies to outer edges and baselines.

### 26.1 Major Geometry

| Element | Normalized position/size |
| --- | --- |
| Status/safe region | y 0-32 |
| Back control | x 20-36, visual center around y 62; 44 x 44 hit target |
| Page title block | x 88-338, y 43-82, centered |
| Intro panel | x 20, y 103, width 387, height 78 |
| Text-size section heading block | x 20, y 205-234 |
| Text-size option row | x 20-407, y 246-315, height 69-70 |
| Text preview panel | x 20, y 328, width 387, height 114 |
| Font-style heading block | x 20, y 467-499 |
| Font-style option row | x 20-407, y 506-573, height 67 |
| Button-style heading block | x 20, y 599-628 |
| Button-style option row | x 20-407, y 636-716, height 80 |
| Green preview panel | x 20, y 736, width 387, height 81 |
| Bottom-nav divider | y 827-830 |
| Bottom navigation | y 830-922 |
| Selected Menu tile | x 329-407, y 843-896 |

### 26.2 Option Grid Geometry

Text-size row at the reference state:

- four columns
- outer width: 387
- horizontal gap: approximately 6
- first two cards: approximately 88-90 wide
- final two cards: approximately 95 wide to accommodate longer labels
- selected checkmark visual size: approximately 14; hit/semantic state belongs to
  the full card
- option card radius: approximately 8
- unselected border: 1; selected border: approximately 1.5

Font-style row:

- three columns
- widths approximately 126, 123, and 126
- gaps approximately 6
- card height approximately 67

Button-style row:

- two columns
- widths approximately 190 and 191
- gap approximately 6
- card height approximately 80
- sample button height approximately 32
- rounded sample uses an approximately 16-pixel radius
- high-contrast sample uses an approximately 3-pixel radius

### 26.3 Accessibility Typography Mapping

| Visible text | Role/starting size | Alignment |
| --- | --- | --- |
| Accessibility | Page title, 24-26 / 800 | Center |
| Customize Hocalist to fit your needs | Caption, 12-13 / 600 | Center |
| Intro title | Prominent title, 16-18 / 800 | Left |
| Intro body | Body, 13-14 / 500 | Left, wraps to two lines |
| Numbered section titles | Component title, 14-16 / 800 | Left |
| Section instructions | Caption/body, 13-14 / 500 | Left |
| Aa samples | 24-28 / 700 | Center |
| Option labels | 12-13 / 700 | Center |
| Preview label | 12-13 / 700 | Left |
| This is how text will look | 20-22 / 800 | Left |
| Preview body | 14-16 / 500 | Left, wraps to two lines |
| Hocalist font samples | 17-19 / profile-specific | Center |
| Sample buttons | 13-14 / 600-800 | Center |
| Preview your selection | 14-16 / 800 | Left |
| Show Preview | 13-14 / 700 | Center |
| Bottom-nav labels | 11-12 / 600 | Center |

The ranges above describe the likely original design value from rasterized
glyphs. The approved font file decides the exact final value because cap height,
x-height, and weight materially change the visible result. Implementation starts
from the central token table and adjusts only after same-size overlay comparison.

### 26.4 Accessibility Screen State Contract

The supplied screenshot specifically captures:

- Text size: `Large` selected.
- Font style: `Default` selected.
- Button style: `Rounded (Default)` selected.
- Bottom navigation: `Menu` selected in the source design.

Use this exact state for source comparison. Separately test the product default
state `Medium / Default / Rounded` so the screenshot state is not confused with
the first-launch preference.

## 27. Shared Shell Contract

### 27.1 Header

- Status and safe-area content must never be reconstructed in app UI.
- Use the exact supplied Hocalist logo asset at the measured fit; do not render
  the scripted wordmark as a font.
- Notification bell uses the approved outline artwork/treatment and red unread
  dot.
- Buyer-mode pill preserves its icon, lavender fill, and 44-pixel minimum target.
- At high scale, the logo, mode pill, and notification button may wrap into two
  rows; they may not be uniformly shrunk below approved normal-scale dimensions.

### 27.2 Bottom Navigation

At the canonical width, the approved buyer nav is approximately 92-120 logical
pixels including the safe-area/home-indicator region, depending on whether the
reference is a full screenshot or isolated crop.

- five equal destinations
- selected tile uses a soft lavender rectangle with approximately 8 radius
- selected icon/label use primary blue
- unselected icon/label use muted navy-gray
- icon visual size approximately 26-30
- label size 11-12
- every destination receives at least a 44 x 44 target
- navigation content cannot be given a fixed height that overflows at 1.6 scale
- buyer labels remain `Home`, `Hocatrends`, `Offers`, `Chats`, `More`
- seller labels remain the currently approved seller navigation until a separate
  seller reference replaces them
- accessibility-reference labels `Customers`, `Meets`, `Messages`, `Menu` are
  evidence for visual styling only, not authorization to change Hocalist IA

## 28. Per-Screen Exactness And Reflow Matrix

### 28.1 Account Creation

Reference: `account-creation-buyers-sellers-approved-talk-details.png`.

Default contract:

- bottom-sheet treatment, top grabber, close control, centered account artwork
- buyer/seller segmented choice remains two equal columns
- five outlined fields, primary CTA, divider, three exact social icons, login row
- all field and action labels use Flutter text

Large-text reflow:

- sheet scrolls; it does not reduce field/action heights
- role options stack only when each option cannot retain a 44-pixel target and
  readable label
- social button labels wrap to two lines before truncation
- keyboard inset keeps the active field and Create account action reachable

### 28.2 Buyer Benefit Screens

References: benefit descriptions 3 and 4.

Default contract:

- progress indicator, close control, avatar/title block, 16:9 video frame,
  benefit cards, green reassurance banner, full-width CTA, page dots
- artwork and video poster stay image assets; all explanatory text stays native

Large-text reflow:

- avatar/title row stacks when the title/body cannot preserve the reference wrap
- benefit cards allow unlimited height and keep icon aligned to the first text row
- reassurance banner stacks icon above/alongside text according to local width
- CTA stays visible after scrolling and keeps at least 48 height

Content boundary:

- Do not overwrite the currently implemented benefit wording from this screenshot.
  This batch matches geometry, typography, and responsive behavior only. If the
  current implementation still contains prohibited escrow/payment-holding
  claims, report that separately as a production-release gate without changing
  the copy during this visual pass.

### 28.3 Logged-Out Home

References: `1-home-with-no-account-approved.png` and its continuation.

Default contract:

- exact logo, bell, buyer/seller photography, role-card crops, colored icon
  circles, CTAs, feature icons, video poster, FAQ state, signup artwork, and nav
- the two source files describe one scrollable page, not two routes
- buyer/seller role-card text is native Flutter text over supplied artwork

Large-text reflow:

- role-card copy/button column gains height while artwork remains contained
- feature rows allow 2-3 lines and do not squeeze icons
- video keeps its aspect ratio
- FAQ answers expand naturally
- signup banner stacks copy and CTA below 360 available pixels or above 1.15 scale

### 28.4 Created-Account Buyer Home

Reference: `home-with-created-account-approved-talk-details.png`.

Default contract:

- signed-in shell, greeting/gift artwork, two reward cards, request CTA, active
  request, activity list, reward banner, bottom navigation
- the approved two-column reward-card proportions are preserved at canonical
  width

Large-text reflow:

- reward cards stack below 350 available content width or above 1.15 scale
- request CTA and active request switch from row to column when actions compress
- activity amount/rating moves below metadata when required
- reward banner stacks below 360 card width; artwork uses contained fit

### 28.5 Recent Activity

Reference: `7.2 view all notifications approved.png`.

Default contract:

- centered title/back, five-part segmented filter, eight activity rows, bottom nav
- icon circles, separators, amounts/ratings, and timestamps align consistently

Large-text reflow:

- segmented control becomes horizontally scrollable with full labels; labels are
  not reduced below 11
- row amount/rating moves below the title/time column at high scale
- each row expands vertically and keeps the icon top-aligned

### 28.6 Post Request: Product And Service

References: product step, service step, and location step.

Default contract:

- shared header, two-option Product/Service selector, two-step progress, centered
  prompt, grouped fields/cards, bottom action row, buyer navigation
- product and service variants share geometry and differ only in approved content
- location uses the exact address-card, OR divider, field grid, and Post request
  action hierarchy

Large-text reflow:

- Product/Service choices remain two columns at normal scale, stack when either
  subtitle cannot fit
- two-column option groups stack using local available width
- progress labels remain under their step circles without overlap
- city/state and ZIP/country fields stack at high scale
- Back/Continue actions stack when both cannot retain readable labels and 48
  height

### 28.7 Request Details

Reference: `4.3 Edit Request Details For Products-approved.png`.

Default contract:

- product summary, active badge/delete action, edit sections, two-column compact
  cards, location/reward pair, Save changes footer, nav

Large-text reflow:

- summary image, text, badge, and delete action become a vertical composition
- compact option groups and location/reward pair stack
- edit icons keep independent 44-pixel targets
- Save changes explanation and action stack; the action stays full width

### 28.8 Offers Received

Reference: `5 Offers Received Dashboard-approved.png`.

Default contract:

- heading/artwork, rewards summary, sort/filter row, seller offer cards, security
  banner, selected Offers navigation
- seller identity, price, product summary, three trust metrics, and action row keep
  the approved hierarchy

Large-text reflow:

- reward illustration, metric, and rules stack instead of narrowing copy
- sort and filter wrap
- seller identity and price occupy separate rows when needed
- three trust metrics use Wrap or vertical rows
- View offer details and disabled chat action stack at high scale

### 28.9 Hocatrends And Seller Results

References: Hocatrends and Hocatrends sellers.

Default contract:

- exact reward artwork, search/filter treatment, ranking badges, product images,
  competition bars/icons, seller count, action buttons, list/grid control
- use the supplied flame artwork where specified

Large-text reflow:

- category-card image, copy/progress, and CTA become vertical below local width
- seller-count copy is never squeezed into one-letter columns
- controls wrap into multiple rows
- seller avatar/identity, price/savings, badge, and chat action stack in content
  priority order

### 28.10 Offer Details

Reference: `6 View Offer From Seller-approved.png`.

Default contract:

- seller summary, three metrics, rewards deadline, product image and two detail
  panels, PIN banner, seller bio, trust notice, primary CTA, nav

Large-text reflow:

- three metrics Wrap or stack
- reward metric moves below the deadline copy
- product image and description panels stack
- PIN moves below explanatory copy and remains readable
- seller bio action and final CTA expand vertically

Content boundary:

- Preserve the currently implemented banner wording. Do not reintroduce the
  screenshot's `Your payment is protected by Hocalist` wording if it was already
  changed. If that prohibited claim is still present, report it separately as a
  production-release gate; this visual pass changes only the banner design.

### 28.11 Seller Chat

Reference: `6.1 Talk to seller chat-approved.png`.

Default contract:

- contact header, verified badge, call/menu actions, item summary, final-offer
  details, two secondary actions, primary Accept To Meet action, chat bubbles,
  safety banner, composer, nav

Large-text reflow:

- contact header wraps without hiding call/menu targets
- final-offer four-cell grid becomes one or two columns based on local width
- action pair stacks before text shrinks
- message bubbles cap at approximately 78% width at normal scale and may grow to
  90% at high scale
- composer remains above keyboard and bottom navigation

Content boundary:

- Preserve the currently implemented chat wording and do not reintroduce an old
  screenshot claim over an owner-approved change. Any remaining prohibited deal-
  protection claim is reported as a separate release issue; this batch preserves
  the visual treatment and does not rewrite copy.

## 29. Icon And Asset Contract

- Use supplied logo files from `approved resign/logos/`; do not redraw the logo.
- Use extracted/provided Google, Apple, and Facebook icons on account creation.
- Use approved buyer/seller photography and product artwork with contained crops
  matching the references.
- Do not use a screenshot crop when the crop contains functional text.
- Material/Cupertino icons are acceptable only for ordinary controls when their
  shape visibly matches the reference and no approved artwork exists.
- If an icon differs materially in stroke, fill, corner, or silhouette, extract
  or source the approved asset before implementation.
- Decorative images are excluded from semantics; informative images receive a
  concise semantic label.
- Image slots receive fixed aspect-ratio/constraint rules so loading does not
  shift surrounding text.

## 30. Exact Comparison Protocol

For every approved screen:

1. Render at the normalized target width and matching state/data.
2. Match the normalized height or capture the same scroll segment.
3. Mask only operating-system status indicators, current time/battery, dynamic
   notification dots, and intentionally dynamic data.
4. Place the reference and render side by side.
5. Create a 50% opacity overlay using identical canvas dimensions.
6. Inspect outer edges, text baselines, line wraps, icon silhouettes, artwork
   crops, card radii, divider positions, and navigation geometry.
7. Record every difference greater than 1 logical pixel.
8. Fix or document each difference; undocumented substitutions fail the gate.
9. Repeat at default scale until stable.
10. Run the accessibility reflow matrix separately; do not compare a reflowed
    high-scale layout to default reference coordinates.

Suggested automated thresholds after masking dynamic regions:

- geometry edge displacement: <= 1 logical pixel
- flat-region color delta: CIEDE2000 <= 3
- unexpected changed-pixel ratio: <= 2% after platform text-antialias masking
- no line-wrap difference on exact default-state copy
- no missing or substituted approved asset

Global SSIM or changed-pixel percentage is supporting evidence only. A high score
cannot pass a screen with a wrong font, hidden action, incorrect copy wrap, or
substituted icon.

## 31. Accessibility Reflow Proof Matrix

Every screen in Section 28 receives the following checks:

| Width | System scale | App tier | Expected proof |
| ---: | ---: | --- | --- |
| 426.5 | 1.0 | Medium | Exact approved-reference comparison |
| 430 | 1.0 | Medium | Same composition, proportional spare width |
| 390 | 1.0 | Medium | Same hierarchy with documented narrow adjustments |
| 375 | 1.0 | Medium | Same normal-scale composition as 390; tighter gaps/cards |
| 360 | 1.0 | Medium | Narrow-phone responsive variant |
| 344 | 1.0 | Medium | Minimum supported logical width |
| 390 | 1.3 | Medium | System accessibility reflow |
| 360 | 1.6 | Medium | Boss-phone no-overflow gate |
| 390 | 1.0 | Large | App-selected accessibility reflow |
| 390 | 1.0 | Extra Large | Maximum app tier reflow |

For each case, record:

- screenshot/evidence path
- `tester.takeException()` result
- first visible primary action
- longest label/copy wrap result
- bottom-nav fit
- safe-area fit
- any component variant activated by local width

## 32. Owner Decision Record And Remaining Approval Sheet

Decisions captured from the owner on 2026-08-02:

```text
Design source: approved screenshots; no Figma or editable source exists
Implementation order: buyer first; seller navigation/settings references pending
Font shortlist: Nunito / Lexend / Archivo
Resolved default family: Nunito
First-launch text tier: Medium
Accessibility screenshot comparison tier: Large
Default button profile: Rounded
Alternative button profile: High Contrast rectangular
Commit behavior: explicit Apply required
Accessibility scope: font family, text size, and button profile
Final persistence target: signed-in user account sync
Stage 1 persistence: device-local until backend/auth work is approved
Device strategy: multiple widths/scales; do not optimize only for one Samsung
Icon source strategy: exact asset, clean screenshot extraction, or reference-
traced high-resolution reconstruction with overlay proof
Color strategy: sample approved screenshot and verify with overlay/delta checks
Internal sign-off: Hocalist owner
Final visual acceptance: client
```

Remaining gates before implementation or release:

```text
High Contrast foreground/background/border tokens: measured and contrast-checked
Android emulator or physical-device proof available: yes/no
remote/local Mac with Xcode Simulator reachable through plugin: yes/no/blocker
Seller navigation/settings screenshots received: deferred/received
```

No missing answer may be silently replaced with a developer preference. The
one-logical-pixel value elsewhere in this plan is an engineering comparison
tolerance, not a visual choice the owner must make: at the canonical viewport,
measured component edges and icon placement may differ from the reference by no
more than one Flutter logical pixel unless antialiasing or a documented platform
difference is explicitly accepted.

## 33. Pixel-Exact Definition Of Done

The plan is implementation-ready when:

1. Every reference in Section 24 has an implementation route/state or a named
   out-of-scope reason.
2. Every remaining Section 32 gate that affects the implemented buyer design is
   resolved; seller-only and production-policy gates may remain deferred.
3. Approved font files are bundled and render from the same asset on Android and
   iOS.
4. Medium/Default/Rounded produces the approved default visuals.
5. The accessibility page matches the supplied Large/Default/Rounded reference
   at 426.5 x 922.
6. All Section 28 reflow rules are implemented and proved.
7. Default screenshots meet Section 30 comparison tolerances.
8. Accessibility screenshots pass Section 31 with no overflow, clipping,
   overlap, hidden action, or one-letter column.
9. Android and iOS proofs are reported independently.
10. The Hocalist owner approves the internal comparison package, and the client
    gives final visual acceptance. Every remaining visual difference is listed
    rather than hidden inside a general approval.

## 34. Exact Icon Replica Contract

Icons are first-class approved artwork. A screen cannot pass visual review while
using an icon that is merely similar to the icon in its approved screenshot.

### 34.1 Non-Negotiable Rule

For every icon visible in an approved screenshot, match all of the following:

- silhouette
- stroke thickness
- stroke caps and joins
- filled versus outlined treatment
- corner radius
- internal negative space
- badge, dot, star, check, or overlay placement
- source color and gradient
- rendered width and height
- optical alignment inside its slot
- transparent whitespace around the visible artwork
- active, inactive, selected, disabled, success, warning, and error variants

An icon with the right meaning but the wrong drawing fails the exact-replica
gate. For example, a generic Material shield cannot replace the approved shield
just because both communicate safety.

### 34.2 Source Priority

Current owner-confirmed condition: no original icon package or Figma export is
available. Therefore each buyer icon starts with the existing repository asset
when one exists; otherwise it is measured and extracted from the highest-quality
approved screenshot. Seller navigation/settings icons remain deferred until the
seller reference is supplied.

Use icon sources in this order:

1. Original client-supplied transparent PNG, SVG, PDF/vector, or design export.
2. Existing repository asset already extracted from the approved screenshot,
   after a fresh overlay comparison confirms it is exact.
3. A clean crop extracted from the approved screenshot when the icon has enough
   source resolution and can be separated without including text or card pixels.
4. A reference-guided high-resolution bitmap reconstruction made from the
   supplied screenshot when JPEG contamination prevents a clean crop.
5. An official brand asset for Google, Apple, Facebook, or another trademark,
   only when it visibly matches the approved screenshot.
6. A library icon only after an overlay proves its silhouette and stroke are an
   exact match.
7. Owner/client-approved substitution when no exact source can be recovered.

The owner authorizes reconstruction when no clean original exists. Reconstruction
must be guided by the screenshot itself, measured at the canonical scale, and
exported as a standalone transparent bitmap asset; do not draw from memory or use
a merely similar generic icon. Iterate the reconstruction against a 50% overlay
and difference view until silhouette, stroke, negative space, color, and optical
alignment pass Section 36. A reconstructed icon is labelled `reference-traced`,
not falsely recorded as an original source asset.

For every state visible in the screenshots, capture the state itself. Active,
inactive, selected, disabled, success, and High Contrast appearances must not be
inferred from a generic opacity or tint rule when the screenshot shows different
stroke, fill, internal detail, or optical weight.

### 34.3 Current Asset Baseline

The repository already contains 71 PNG visual assets across brand, authentication,
buyer navigation, onboarding, dashboard, request, offer, Hocatrends, and home
surfaces. Relevant existing icon groups include:

- social icons: Google 52 x 52, Apple 52 x 52, Facebook 60 x 60
- buyer bottom-nav icons: five 72 x 72 assets intended for approximately 24 x 24
  rendering at 3x source density
- buyer onboarding benefit icons: mostly 144 x 144, plus an 80 x 80 green shield
- post-request icons: twenty-four 256 x 256 extracted assets
- approved brand sources: high-resolution circular, square, vertical, and
  horizontal logo files

These dimensions do not by themselves prove fidelity. Each asset still needs:

- transparent-edge inspection
- source screenshot crop comparison
- confirmation that no white/lavender card background is baked into the asset
- confirmation that no nearby text is baked into the asset
- confirmation that Flutter renders it with the intended contained size

The codebase also contains many generic Material icon usages. Any `Icons.*` value
inside an approved screenshot-driven region is considered `unverified` until it
passes the icon overlay gate or is replaced by an approved asset.

### 34.4 Asset Storage And Naming

Keep feature-specific icons with their feature assets:

```text
assets/auth/icons/
assets/accessibility/icons/
assets/buyer_nav/
assets/buyer_dashboard/icons/
assets/buyer_onboarding/
assets/post_request/
assets/buyer_request_detail/icons/
assets/offers_received/icons/
assets/hocatrends/icons/
assets/offer_detail/icons/
assets/chat/icons/
assets/settings/icons/
```

Use behavior-based names, not extraction coordinates:

```text
accessibility-person.png
selection-check-primary.png
preview-eye-primary.png
preview-check-success.png
nav-home-active.png
nav-home-inactive.png
request-condition-new.png
offer-identity-verified.png
chat-send.png
```

When one asset has multiple density variants, use Flutter's asset variant
folders:

```text
assets/accessibility/icons/selection-check-primary.png
assets/accessibility/icons/2.0x/selection-check-primary.png
assets/accessibility/icons/3.0x/selection-check-primary.png
```

Do not append arbitrary names such as `final2`, `new`, or screenshot coordinates.

### 34.5 Extraction Requirements

When the approved screenshot is the only source:

1. Record the reference file and icon bounding box in source pixels.
2. Normalize the intended render size using Section 24.
3. Extract from the highest-resolution approved copy.
4. Include only the icon artwork; remove surrounding card/background pixels.
5. Preserve antialiasing and premultiplied alpha at the edge.
6. Do not sharpen, stretch, recolor, or redraw the extraction.
7. Crop to a stable transparent canvas that preserves the approved optical
   whitespace.
8. Export at 1x, 2x, and 3x when source resolution supports those densities.
9. Inspect the extraction on white, lavender, green, and dark test surfaces.
10. Reject the extraction if a halo, white box, neighboring pixel, blur, or
    compression block is visible at rendered size.

Minimum source-resolution rule:

- Prefer source artwork at least 3 times the intended logical render size.
- A 72 x 72 source is suitable for a 24 x 24 icon if the extraction is clean.
- Do not upscale a low-resolution screenshot crop and call it exact.
- If the source is below 2 times render size or has JPEG contamination through
  the stroke, use the reference-guided reconstruction path and retain the source
  crop plus overlay evidence beside the resulting asset.

### 34.6 Flutter Rendering Contract

Create one shared `ApprovedIcon` component and an approved-icon registry instead
of scattering asset paths and sizes across screens.

The registry entry should contain:

```dart
class ApprovedIconSpec {
  final String asset;
  final Size logicalSize;
  final BoxFit fit;
  final Alignment alignment;
  final String? semanticLabel;
  final bool decorative;
}
```

Rendering rules:

- use a stable `SizedBox` matching the approved logical slot
- default to `BoxFit.contain`
- use high filter quality for raster artwork
- do not tint multicolor or textured approved assets
- tint a monochrome asset only when the approved states differ solely by color
  and an overlay proves the geometry remains identical
- do not stretch an asset to fill a differently shaped slot
- keep icon size independent from text scaling unless the icon is an inline text
  symbol whose relationship to the text is explicitly approved
- enlarge the surrounding hit target, not the artwork, to reach 44-48 pixels
- exclude decorative icons from semantics and label meaningful icon-only buttons

### 34.7 State Variant Rules

Do not assume an active icon is just an inactive icon recolored.

- Store separate active/inactive assets when fill, stroke, or interior detail
  changes.
- Store a separate selected checkmark asset when its circle/stroke differs.
- Notification bell and unread dot are separate layers only if their reference
  positions are fixed and tested together.
- Disabled icons preserve the approved silhouette and use an approved disabled
  color/opacity; default Flutter opacity is not automatically accepted.
- High Contrast mode may change color and border visibility, but it cannot swap
  the approved icon drawing unless the accessibility reference shows a different
  drawing.

## 35. Approved Icon Inventory

Every row below must receive one status before implementation closeout:

```text
exact asset available
exact extraction approved
library icon overlay-approved
client source required
explicit substitution approved
```

### 35.1 Global And Navigation Icons

| Icon family | Reference treatment | Current source/status | Required action |
| --- | --- | --- | --- |
| Hocalist wordmark | Scripted blue brand artwork | Approved logo files exist | Use exact asset and measured crop |
| Back | Thin blue/navy chevron/arrow | Generic icon used in places | Overlay-test; extract/source if shape differs |
| Notification bell | Approved outline plus red dot | Some extracted and some generic versions | Standardize on exact asset/layers |
| Buyer-mode icon | Circular check/down mark | Extracted post-request asset exists | Verify against each header reference |
| Home nav | Approved house active/inactive treatment | 72 x 72 buyer asset exists | Verify both states and optical size |
| Hocatrends nav | Approved flame/brand mark | 72 x 72 buyer asset exists | Verify exact silhouette and active state |
| Offers nav | Approved tag outline/fill | 72 x 72 buyer asset exists | Verify active/inactive assets |
| Chats nav | Approved double-bubble mark | 72 x 72 buyer asset exists | Verify dot/detail placement |
| More nav | Approved four-line menu | 72 x 72 buyer asset exists | Verify line length, spacing, and state |
| Seller navigation | Seller-specific icons | Owner will supply references later | Deferred; do not infer from buyer nav |

Operating-system status icons, signal, Wi-Fi, battery, and home indicator are not
app artwork. They must be rendered by the platform or simulator and are masked
during visual comparison.

### 35.2 Accessibility Icons

| Icon | Reference render | Required source |
| --- | --- | --- |
| Back chevron | Approximately 16 visual pixels in a 44 target | Extract or exact-match library proof |
| Accessibility person | Approximately 40 visual pixels in a 54 lavender circle | New exact extraction/source asset |
| Text option check | Approximately 14, primary filled circle with white check | New exact asset |
| Preview eye | Approximately 14-16, thin primary outline | New exact asset |
| Font option check | Same family as text selection check | Reuse only if overlay-identical |
| Button option check | Same family, top-right overlap | Reuse only if overlay-identical |
| Green preview check | Approximately 24 in a pale green circle | New exact success asset |
| Show Preview eye | Approximately 16, green outline | New exact green asset or proven color variant |
| Bottom-nav icons | Home, Customers, Meets, Messages, Menu | Extract visible styling/states only | Do not adopt labels/IA; use buyer Hocalist nav |

The accessibility figure, selected checks, and preview icons are part of the
client's exact page identity. Generic `Icons.accessibility_new`, `Icons.check`, or
`Icons.visibility` substitutions are not automatically acceptable.

### 35.3 Authentication Icons

Inventory:

- account-add hero icon
- close icon and top-sheet grabber
- buyer bag and seller storefront role icons
- full name, email, phone, password, and confirm-password field icons
- password visibility icon
- Google, Apple, and Facebook brand icons

Current state:

- exact social PNGs already exist and must remain unchanged unless overlay proof
  shows the crop is wrong
- the remaining line icons require comparison against the auth screenshot; a
  semantically similar Material icon is not enough

### 35.4 Buyer Onboarding Icons

Inventory:

- progress and close controls
- buyer avatar
- video play/player controls
- reward-dollar, tag, shield, chat, location, medal, payment-shield, and review
  dollar illustrations
- green reassurance shield

Current state:

- most approved 144 x 144 icon assets already exist
- verify every icon circle/background is implemented as the correct separate
  layer instead of being accidentally baked into the icon crop
- payment-related icon use does not authorize prohibited escrow copy

### 35.5 Logged-Out Home And Buyer Dashboard Icons

Inventory:

- buyer bag and seller storefront role marks
- role-card arrows
- commission hand/dollar, target, handshake, and safety-shield feature icons
- play control and FAQ expand/collapse chevrons
- ready-to-start gift/reward artwork
- trophy, calendar, plus, clipboard, chat, check, review star, payout wallet,
  reward-medal, information, and chevron icons

Current state:

- key large artworks exist
- many small functional icons are still generic and require exact overlay review
- home-card text must remain native Flutter text even when artwork was extracted

### 35.6 Post Request And Request Details Icons

Inventory:

- Product and Service selector icons
- step circles/progress treatment
- title tag, description document, condition, budget, quantity, higher-offer,
  service type, category, location, radio, information, send, and dropdown icons
- request edit, delete, active status, reward, location, and save icons

Current state:

- twenty-four 256 x 256 post-request icon assets already exist
- use those assets as the starting source, not Material replacements
- inspect each for white background, excess transparent padding, and correct
  normalized render size
- request-detail-only icons still require their own approved assets or overlay
  proof

### 35.7 Offers And Hocatrends Icons

Inventory:

- envelope/gift artwork and reward gift
- calendar, gift, heart, sort, filter, verification badge, star, identity shield,
  location, availability clock, chat-disabled, lock, and chevrons
- Hocatrends search, sliders, flame, rank badges, people/seller count, competition
  bars, list/grid toggle, seller badge, tag, lightning, trophy, and chat icons

Current state:

- large envelope, reward, product, and flame assets exist
- small status, trust, control, and action icons require exact review
- the 34 x 55 flame reference and repository flame extraction must be compared at
  native size before acceptance

### 35.8 Offer Details And Chat Icons

Inventory:

- seller avatar/initial, verification badge, star, identity shield, location,
  clock, gift, info, chat/detail, PIN shield-lock, profile, trust shield, bookmark
- chat verified badge, call, overflow, deal shield, price, location, time, reward
  star, expand chevron, plus, send, safety, and double-check status

Current state:

- product and avatar artwork exists
- functional/status icons require exact source matching
- icon replication does not authorize payment-protection or deal-guarantee claims

## 36. Icon Measurement And Proof

### 36.1 Measurement Record

For each approved icon, add one inventory record:

```text
Icon id:
Approved screenshot:
Source bounding box in source pixels: x, y, width, height
Normalization scale:
Intended logical artwork size:
Intended logical slot size:
Optical offset from slot center: x, y
Source asset path:
States available:
Backgrounds checked:
Semantic label/decorative status:
Proof artifact:
Status:
```

The artwork size and slot size are separate. A 24 x 24 drawing may live inside a
44 x 44 button; enlarging the drawing to fill the button would not be exact.

### 36.2 Overlay Acceptance

At the canonical reference size:

1. Crop the icon and its immediate approved context from the source screenshot.
2. Render the Flutter icon in the same-size context.
3. Place both crops side by side.
4. Create a 50% overlay and a high-contrast difference view.
5. Inspect at 100%, 200%, and 400% zoom.

An icon passes only when:

- visible silhouette displacement is no more than 1 logical pixel
- stroke-width difference is no more than 0.5 logical pixel
- optical center differs by no more than 1 logical pixel
- flat color delta is CIEDE2000 <= 3
- transparent bounding-box padding differs by no more than 1 logical pixel
- no halo, box, crop, blur, text fragment, or neighboring pixel is visible
- active/inactive/selected states match their separate references

### 36.3 Automated Asset Checks

Add focused tests or scripts that verify:

- every registry path exists and is declared in `pubspec.yaml`
- expected source dimensions are unchanged
- files expected to be transparent contain an alpha channel
- no exact approved asset is accidentally replaced by a zero-byte or placeholder
  file
- no screenshot-derived asset contains a large opaque white rectangle unless the
  approved artwork itself includes it
- golden tests render icon slots at their exact logical dimensions

### 36.4 Screen Gate

The icon gate runs before a screen receives final exact-design approval:

```text
[ ] Every visible icon is present in the approved-icon inventory.
[ ] Every icon has an approved source/status.
[ ] No unverified generic icon remains in an approved screenshot region.
[ ] All state variants have been checked.
[ ] All icon render and hit-target sizes match the contract.
[ ] All overlay crops pass or have explicit owner/client approval.
[ ] Decorative and functional semantics are correct.
```

If one icon is unresolved, report that exact icon as the blocker. Do not fail the
entire feature silently and do not substitute a nearby icon to keep moving.
