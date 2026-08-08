# Offers / Chat Design QA

## Scope

- `ApprovedOffersReceivedPage`
- `ApprovedViewOfferPage`
- `ApprovedBuyerChatPage`
- Approved sources:
  - `approved resign/buyer-request-navigation-approved/5 Offers Received Dashboard-approved.png`
  - `approved resign/offer-chat-approved/6 View Offer From Seller-approved.png`
  - `approved resign/offer-chat-approved/6.1 Talk to seller chat-approved.png`
- Existing comparison evidence:
  - `output/playwright/buyer-320-before-comparison.png`
  - `output/playwright/offers-current-320x693.png`
  - `output/playwright/chats-current-320x693.png`

## Replica Metrics Migration

- `ApprovedReplicaMetrics` now owns the entire default/Medium replica canvas.
  The 390 logical-pixel composition is the single source for geometry,
  typography, artwork, borders, shadows, controls, and bottom navigation.
- At 320 and 360, the canvas uses the contract's locked `320 / 390` and
  `360 / 390` scales. This removes the former independent compact reductions
  that shortened each 320 offer card by approximately 24-27 logical pixels.
- At 390, the canvas is 1:1. At 430, 600, 768, and 1024, the unchanged
  390-wide composition is centered rather than enlarged.
- Default/Medium keeps the approved horizontal rows without wrapping or
  stacking. Any external text scale above 1.0 bypasses screenshot locking and
  uses the existing wrap, stack, grow, scroll, and reachable-action behavior.
- The selected app `TextScaler` remains active. Font sizes are not calculated
  fluidly from viewport width.

## Preserved Behavior

- Existing wording, callbacks, state transitions, and extracted approved assets
  are unchanged.
- Item inspection and payment remain offline outside Hocalist. No checkout,
  escrow, shipping, inventory, payout, or in-app item-payment behavior was
  introduced.
- The Chats navigation callback and selected state are unchanged. This lane
  does not route the Chats tab directly to the individual conversation.

## Final Navigation And Chat Delta

- The owned buyer navigation now matches the global buyer navigation at 55
  logical pixels on the 390 reference canvas and tablets. The replica transform
  produces 45.13 pixels at 320.
- Indicator, icon, padding, label, and radius geometry now uses the global
  buyer-navigation reference values while retaining the approved Offers/Chat
  raster assets and each page's selected accent.
- Default/Medium chat inserts an 18 pixel locked spacer between the final
  received message and safety notice. It scales proportionally at 320.
- The spacer resolves to zero under Large/XL text scaling, preserving intrinsic
  reflow and scroll behavior.

## Focused Proof

- Added default viewport coverage at 320x693, 360, 390x844, 430, 600, 768,
  and 1024 logical pixels for every owned page.
- Added assertions that default tablet surfaces remain centered at 390 and
  that narrow surfaces use the contract width.
- Added a 390-to-320 geometry regression around the second offer card and
  secure/private notice. It checks the exact contract scale and guards against
  the excess blank-space regression above navigation.
- Kept the 320 horizontal-composition and non-truncation assertions.
- Added Large/XL action-reachability coverage at 1.3, 1.6, and 2.0 text scale,
  plus a centered 768-wide XL case.
- Callback coverage and the opt-in actual-Nunito raster captures remain.
- Direct-SDK focused proof passed for navigation height/no-overlap at 320, 390,
  and tablet across Offers, Offer Details, and Chat.
- Direct-SDK focused proof passed for 390/320 chat rhythm, the 18 pixel locked
  spacer, 8 pixel safety-to-composer spacing, 8-24 pixel composer-to-navigation
  clearance, and zero Large/XL spacer height.

## Ambiguity And Integration

- `chats-current-320x693.png` is the Chats inbox/list, while the only approved
  chat source supplied here is an individual seller conversation. No approved
  chat-inbox source exists under the named approved directories, so this lane
  stopped short of inventing that design or changing its route.
- The request-detail screenshot belongs to another implementation surface;
  there is no request-detail widget in this owned file. It was not edited.
- Integration must continue to provide the existing callbacks and must not wrap
  these pages in duplicate headers or bottom navigation.
- Android route-level rendering remains an integration gate. iOS safe-area and
  keyboard proof remains unavailable on this Windows host.

## Consolidated Proof Update - 2026-08-03

- The Offers dashboard uses the screenshot-sampled `#0f0b7a` accent while
  Offer Details and Chat retain their approved `#1117e8` controls.
- Offers/Chat focused proof passed 17 active tests with 1 intentional
  screenshot-writer skip, including 320/390/tablet geometry, 55px buyer
  navigation, chat lower-block rhythm, no navigation overlap, and Large/XL
  reachability.
- Fresh captures include
  `output/playwright/replica-final-offers-rebuilt-390x844.png` and
  `output/playwright/replica-final-compare-chat-rebuilt-390.png`.
- Full repository suite, analyze, web build, and Android debug APK build passed.

Final result: passed for local responsive implementation and rendered web QA;
native Android/iOS rendered-device proof remains pending.
