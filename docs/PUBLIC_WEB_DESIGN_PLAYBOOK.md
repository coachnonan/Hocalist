# Public Web Design Playbook

This is the training source for Hocalist public website design agents.

Use it for the public homepage, pricing, how-it-works, safety, support, download, privacy, terms, refund/cancellation, Vercel-facing polish, and Stripe website-readiness pages.

Public web work is not the admin dashboard. Admin Web Desk can help with existing Next.js structure, shared web components, routing, build behavior, and deployment constraints. Public Web Design Desk owns public-facing visual quality, page rhythm, art direction, and Stripe/domain page polish.

## Taste Reference

The owner likes the Jobi homepage family, especially:

- generous spacing and breathing room
- smooth section transitions and restrained reveal motion
- consistent cards and component rhythm
- built-up hero graphics with people/photos, floating cards, stats, tags, and shapes
- high-quality image choices that feel integrated into the layout
- alternating section background colors that still feel like one brand
- balanced color use, especially green supported by white, black, soft mint, brown, photo bands, and neutrals
- neat typography, strong heading scale, and clean supporting copy
- pages that feel designed from top to bottom, not just a nice hero followed by plain content

Working Jobi reference URLs checked visually:

- `https://html.creativegigstf.com/jobi/jobi/index-2.html`
- `https://html.creativegigstf.com/jobi/jobi/index-3.html`
- `https://html.creativegigstf.com/jobi/jobi/index-4.html`
- `https://html.creativegigstf.com/jobi/jobi/index-5.html`
- `https://html.creativegigstf.com/jobi/jobi/index-6.html`
- `https://html.creativegigstf.com/jobi/jobi/index-7.html`

`index-1.html` and `index-8.html` showed "This Page Does Not Exist" during the 2026-07-08 visual pass and should not be used as design references unless they become live again.

Do not copy Jobi. Extract the logic and adapt it to Hocalist.

## Core Design Logic

Every public page should begin with a visual concept before implementation:

- What is the first impression?
- What is the primary task?
- What composed visual proves the product?
- What sections does the page need?
- How do section backgrounds create rhythm?
- What cards, chips, stats, screenshots, or photos carry the story?
- What motion helps the user understand the page without distracting them?
- What Stripe/legal/safety boundaries must be visible?

Do not build public pages as stacked boxes. Build a visual system: section rhythm, composed graphics, card hierarchy, image direction, motion behavior, and responsive proof.

## Hocalist Public Site Shape

Hocalist is a mobile-first reverse marketplace:

- buyers post what they want
- sellers send offers
- the buyer chooses a seller
- chat opens
- details are finalized
- item payment happens offline outside Hocalist

The public website should teach that model quickly. It must not imply checkout, escrow, shipping, inventory, purchase protection, seller payouts, or buyer-to-seller item payment processing.

Stripe is only for seller subscriptions, credits, platform access, targeting fees, promoted visibility, or seller tools.

## Page Rhythm

Use section rhythm to keep long pages alive:

- composed hero with clear headline, support copy, primary action, secondary action, and product visual
- marketplace proof strip or trust stat band
- buyer request / seller offer examples
- how-it-works steps
- popular categories or local demand section
- seller value section
- pricing/seller billing boundary section
- safety/offline payment boundary section
- FAQ / support / legal clarity section
- final CTA and full footer

Alternate surfaces deliberately:

- white/open section for clarity
- soft mint or pale marketplace tint for product cards
- dark or photo-backed band for trust, testimonials, or CTA
- warm neutral/brown accent when a section needs depth
- green accent only where action or status should stand out

Avoid one-note color themes. Hocalist should feel green-led, not green-only.

Think of the homepage as a section journey, not one continuous background:

- hero can have the strongest atmosphere and composed product visual
- early body sections can open up with white or warm paper surfaces for clarity
- marketplace/category/request sections can use soft tint, pattern, or framed bands to feel active
- seller/pricing/safety sections can shift into darker, warmer, or photo-supported moments
- FAQ/legal/support areas can return to calmer readable surfaces
- final CTA can feel more cinematic or grounded than the body, while staying trustworthy

Section transitions should be visible but graceful. Use background bands, soft dividers, overlap, angled/patterned edges, image-backed moments, card clusters, or motion between sections so the visitor feels a designed progression. Do not make every section the same card-on-same-background treatment.

## Pricing Page References

This section is only for the public pricing / seller plans page. Do not use it to reinterpret the homepage. Homepage work should continue to follow the `Taste Reference`, `Page Rhythm`, and `Hero Standard` sections above.

Pricing references checked on 2026-07-08:

- `https://www.hyperline.co/pricing?ref=saaspo.com`
- `https://fingerprint.com/pricing/?ref=saaspo.com`
- `https://reducto.ai/pricing?ref=saaspo.com`
- `https://www.merge.dev/pricing/unified`
- `https://www.trustkeith.co/pricing?ref=saaspo.com`

Extract the pricing-page logic, not the brand:

- Hyperline: clean three-card pricing, strong feature bullets, proof/case studies below, FAQ, and final CTA.
- Fingerprint: usage-volume selector, Free / Pro / Enterprise cards, and a detailed compare-all-features section.
- Reducto: premium editorial typography, soft tinted pricing cards, most-popular badge, feature comparison, and FAQ.
- Merge: strong scale-focused pricing hero, segmented product tabs, tall plan cards, and demo/contact enterprise flow.
- Trust Keith: trust-heavy pricing with logos, testimonials, what-is-included sections, objection handling, and expert/support positioning.

Hocalist pricing page structure should be:

- pricing hero that clearly says the page is for seller plans, seller credits, seller tools, or seller visibility
- immediate pricing cards such as Starter, Pro Seller, and Local Business when owner-approved prices are available
- a visible billing boundary notice: Stripe is for seller subscriptions, credits, promoted visibility, platform access, or seller tools only
- a visible item-payment boundary notice: Hocalist does not process buyer-to-seller item payments, escrow, checkout, shipping, seller payouts, or inventory purchases
- feature comparison for seller-facing value: monthly offers, request visibility, seller profile tools, verification/badge eligibility, promoted placement, support, team/business profile, and analytics/reporting only when approved
- trust/proof section explaining seller billing clarity, offline item payment, support, cancellation/refund policy, and marketplace scope
- FAQ covering what sellers pay for, whether buyers pay through Hocalist, cancellation, refunds, credits, trial/waitlist status, and contact/support path
- final CTA for seller waitlist, seller billing, or contact support depending on launch readiness

Avoid on Hocalist pricing:

- usage sliders unless the exact seller billing model is approved
- exact seller plan prices, limits, credits, commissions, or launch discounts unless the owner has confirmed them
- wording that implies checkout, escrow, shipping, buyer-to-seller item payment, purchase protection, seller payouts, or item refunds inside Hocalist
- enterprise/security claims, compliance claims, or guaranteed support levels that are not approved
- pricing cards that look like ecommerce product checkout cards

## Hero Standard

The hero must be a first-viewport brand and product signal.

Good Hocalist hero ingredients:

- a literal Hocalist/request-marketplace headline
- buyer request composer or request card
- seller offer card
- location/category/budget chips
- small trust stat or seller count
- offline item payment boundary chip
- high-quality local marketplace photo or generated/approved visual
- calm decorative shapes or surface layers when they support the composition

Avoid:

- generic split text plus plain card
- marketing copy with no product signal
- dark blurred stock photos where the product cannot be understood
- checkout/payment visuals
- huge hero height that hides the next section on common viewports

## Cards And Components

Cards must feel designed, not default:

- one clear job per card
- strong spacing inside the card
- visible hierarchy: status, title, meta, action
- consistent radius, borders, and shadows
- hover lift only when useful
- stable dimensions so hover/state changes do not shift layout

Useful public-site card families:

- buyer request cards
- seller offer cards
- category cards
- how-it-works cards
- pricing cards
- safety/offline-payment notices
- support contact cards
- FAQ rows
- policy summary cards
- testimonial/trust cards
- download/platform readiness cards

If a card pattern appears twice, promote it into a reusable public web component.

## Images And Graphics

Images should look like they belong to Hocalist:

- local shops
- real people buying/selling
- phones/items/home goods/local services
- marketplace coordination
- chat/request/seller-offer UI overlays

Use images as part of a composition, not as filler rectangles. Crop deliberately. Pair photos with cards, chips, stats, or UI panels.

Remote image URLs are acceptable only as temporary review assets. Before production/Vercel deployment, use approved local assets or controlled CDN assets, verify licensing, alt text, crop behavior, mobile load, and brand fit.

## Typography

Use clear hierarchy:

- display heading: confident, premium, and sparse
- section heading: strong but smaller than hero
- card heading: compact and readable
- body copy: soft gray, high line-height, not too wide
- policy/legal text: readable, scan-friendly, and structured

Do not use hero-scale type inside cards, dashboards, legal policy bodies, or compact controls.

No negative letter spacing. Do not scale font size directly with viewport width.

## Motion

Motion should communicate, not perform.

Allowed motion patterns:

- scroll reveal with slight rise/fade
- hover lift on cards/buttons
- gentle image scale on hover
- logo/category marquee when non-essential and pausable/reduced-motion safe
- accordion open/close
- loading/skeleton state

Motion rules:

- keep durations short and calm
- use stagger sparingly
- support `prefers-reduced-motion`
- never use constant distracting animation near primary text
- never let motion hide, delay, or move the primary CTA in a confusing way
- do not be afraid of motion when it adds premium feel, hierarchy, or section-to-section flow
- default public homepage design should include at least a small purposeful motion system unless the owner asks for a static page
- vary motion by role: hero elements can settle in, cards can lift, images can breathe on hover, category/proof strips can move gently, and form fields/buttons can respond tactfully
- verify that motion does not create layout shift, horizontal overflow, jank, or mobile distraction

## Stripe And Public Trust Readiness

Public pages should make Stripe/domain review easy:

- clear service description
- seller pricing and currency when prices are public
- support contact methods
- privacy policy
- terms
- refund/cancellation policy
- security/payment handling language
- seller billing boundary
- offline item payment boundary

Do not invent business address, phone, legal claims, seller prices, launch markets, app-store availability, or live billing promises. Ask Po Desk for owner approval.

## Legal And Support Pages

Legal and support pages must still feel designed:

- strong but restrained hero
- last-updated date where relevant
- table of contents or section navigation
- readable max-width
- policy cards or section panels
- support contact cards
- links between related policy pages
- clear offline item payment and seller billing boundary

Do not make legal pages plain walls of text unless the owner explicitly requests a stripped-down legal style.

## Accessibility And UX Rules

Public Web Design Desk must design for:

- clear headings and page titles
- readable contrast
- keyboard/focus-visible states
- alt text for meaningful images
- decorative images hidden from assistive tech where appropriate
- non-color status cues
- no horizontal overflow
- mobile tap targets
- text scaling resilience
- reduced-motion support
- meaningful link/button labels

UX Review Desk must review final rendered public pages after implementation.

## Proof Standard

Before public web work is called ready:

- run the relevant build/lint/type check where available
- start or refresh local preview cleanly
- verify the URL returns successfully
- capture desktop, tablet, and mobile screenshots
- check `scrollWidth <= clientWidth`
- inspect first viewport quality
- check text fit, CTA visibility, image crop, and card spacing
- check legal/support/pricing clarity
- state any mock-only content, remote images, legal placeholders, Stripe placeholders, or deployment blockers

Proof/Release Desk owns final proof. Po Desk owns final owner-facing status.
