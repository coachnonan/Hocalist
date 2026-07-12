# Hocalist

Hocalist is a mobile-first reverse marketplace prototype. Buyers post what they
want to buy, nearby sellers respond with offers, the buyer compares those
offers, selects a seller, and then private chat opens so both sides can confirm
handoff details.

Item payment is arranged outside Hocalist. The current prototype does not
process buyer-to-seller item payments, hold funds, ship items, manage inventory,
or provide escrow.

## Current Phase

Phase 1 is a reviewable Flutter mobile prototype with mock data and placeholder
states. Backend, database, live maps, live chat transport, seller billing, and
admin-managed configuration are deferred to later phases.

Current prototype coverage includes:

- buyer onboarding and request creation
- seller onboarding and request browsing
- location and map-ready placeholder UI
- offer comparison and seller selection
- selected-seller chat and meeting details
- deal completion, report, and recovery paths
- buyer and seller settings surfaces
- support, safety, notifications, saved states, and mock billing placeholders

## Development

Install Flutter, then run:

```powershell
flutter pub get
flutter analyze
flutter test
```

On this Windows workspace, if `dart format` hangs through the wrapper, use the
direct SDK executable:

```powershell
C:\Users\USER\dev\flutter\bin\cache\dart-sdk\bin\dart.exe format lib\main.dart test\widget_test.dart
```

## Release Notes

Android and iOS are both required mobile targets. Android may be proved first
when local tooling makes that practical, but iOS compatibility and release
readiness remain part of the product scope.
