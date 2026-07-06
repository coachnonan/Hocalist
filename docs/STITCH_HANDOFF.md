# Stitch Handoff

## Source

The Stitch export is stored at:

`.codex-local/stitch/stitch_hocalist_reverse_marketplace_ui/`

This folder is local-only and ignored by Git.

Each screen folder usually contains:

- `screen.png` for visual reference
- `code.html` for layout/style clues

The export also includes design summaries:

- `hocalist/DESIGN.md`
- `hocalist_mobile_framework/DESIGN.md`
- `hocalist_admin/DESIGN.md`

## Implementation Rule

Do not paste Stitch HTML into Flutter. Use the export as design reference and translate it into native Flutter tokens, widgets, and screens.

Build the design system first. The owner may change colors, spacing, typography, or component styling later, so implementation must make redesigns easy by updating shared tokens/components rather than many individual screens.

## Mobile Design Tokens

From `hocalist_mobile_framework/DESIGN.md`:

- Primary: `#005c86`
- Primary container: `#0e76a8`
- Secondary buyer accent: `#006c53`
- Tertiary seller accent: `#745000`
- Background: `#f8f9ff`
- Surface: `#ffffff` / soft blue surface layers
- Text: `#0b1c30`
- Font: Inter
- Mobile margin: 16px
- Gutter: 12px
- Standard spacing: 8px, 16px, 24px
- Buttons/inputs: 8px radius
- Cards/bottom sheets: 16px radius
- Badges/chips: pill radius

## Mobile Screen Groups

Buyer/seller mobile app screens include:

- splash
- buyer signup
- seller signup
- buyer onboarding
- buyer dashboard
- seller dashboard
- post buying request
- request success
- buyer request detail
- seller request detail view
- offers received
- send offer
- offer success
- seller offer detail
- seller offer history
- chatroom
- finalize deal
- deal details/meeting
- buyer confirmation
- buyer review
- buyer wallet/commission
- withdrawal request
- seller billing
- seller payment method
- subscription/payment setup
- buyer profile
- seller profile
- seller profile setup
- seller public profile
- seller verification
- notifications
- safety guide
- help/support
- report user/deal
- saved favorites
- saved buyer requests
- account settings

## Design System Screens

Use these as component references:

- `ds_typography`
- `ds_colors`
- `ds_buttons`
- `ds_form_fields`
- `ds_cards`
- `ds_alerts_toasts`
- `ds_popups_modals`
- `ds_badges_status_tags`
- `ds_navigation_components`
- `ds_chat_components`
- `ds_empty_states`
- `ds_loading_error_states`
- `ds_admin_table_components`

## Flutter Component Mapping

Create shared Flutter components for repeated design patterns:

- buttons: primary, secondary, outline, ghost, danger, disabled, loading
- fields: text, password, search, dropdown, location, budget, date/time, upload, textarea
- cards: buyer request, seller offer, profile, deal summary, chat preview, wallet, billing, review
- feedback: alerts, toasts, offline payment notices, loading, empty, error
- overlays: confirm dialog, report user/deal, finalize deal, withdrawal, logout
- badges: active, pending, completed, verified, reported, paid, suspended
- navigation: buyer bottom nav, seller bottom nav, top app bar, tabs, filters
- chat: message bubbles, image message, system message, message input, deal header

Avoid duplicating these patterns inside individual screens.

## Admin Reference

Admin screens exist in the export, but admin implementation is later web work:

- admin login
- admin dashboard
- admin settings
- manage users
- manage buyers
- manage sellers
- manage buyer requests
- manage seller offers
- commission management
- seller billing management
- reports/disputes
- category management
- safety rules/settings
- admin settings

Admin uses a separate denser design system from `hocalist_admin/DESIGN.md`.

Relevant admin configuration designs already exist in the Stitch export:

- `category_management`
- `admin_settings`
- `seller_billing_management`
- `commission_management`
- `safety_rules_settings`

These should guide later admin UI for dynamic launch locations, categories, seller plans, credit rules, commission rules, withdrawal rules, safety content, and report reasons.

## Open Design Inputs

Still needed:

- final logo/icon file
- app icon treatment
- splash asset decision
- final app name casing
- launch categories
- empty-state illustration policy, if any
