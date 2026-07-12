import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hocalist/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  void useTallMobileViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> tapVisible(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.scrollUntilVisible(
      finder,
      180,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 12,
    );
    await tester.ensureVisible(finder.last);
    await tester.pumpAndSettle();
    await tester.tap(finder.last);
    await tester.pumpAndSettle();
  }

  testWidgets('app bar renders the supplied Hocalist wordmark', (tester) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    expect(find.byType(HocalistBrandTitle), findsOneWidget);
    final image = tester.widget<Image>(
      find.descendant(
        of: find.byType(HocalistBrandTitle),
        matching: find.byType(Image),
      ),
    );
    expect(image.image, isA<AssetImage>());
    expect(
      (image.image as AssetImage).assetName,
      'assets/brand/hocalist-wordmark.png',
    );
    final brandZone = tester.widget<Container>(
      find.descendant(
        of: find.byType(HocalistBrandTitle),
        matching: find.byType(Container),
      ),
    );
    expect(brandZone.constraints?.maxWidth, 132);
    expect(brandZone.constraints?.minHeight, 38);
  });

  test('navy owns primary, actions, focus, and selected navigation', () {
    const navy = Color(0xff00036c);
    expect(HocalistTheme.primary, navy);
    expect(HocalistTheme.light.colorScheme.primary, navy);
    expect(HocalistTheme.dark.colorScheme.primary, navy);
    expect(
      HocalistTheme.light.inputDecorationTheme.focusedBorder,
      isA<OutlineInputBorder>().having(
        (border) => border.borderSide.color,
        'focus color',
        navy,
      ),
    );
    expect(HocalistTheme.buyer, navy);
    expect(HocalistTheme.seller, navy);
    expect(HocalistTheme.darkBuyer, const Color(0xffbec2ff));
    expect(HocalistTheme.darkSeller, const Color(0xffbec2ff));
    expect(HocalistTheme.roleSurface, const Color(0xffeef4ff));
  });

  testWidgets('filled actions stay brand navy when given a role accent', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Seller action',
            icon: Icons.storefront_outlined,
            color: HocalistTheme.seller,
            onPressed: () {},
          ),
        ),
      ),
    );
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(
      button.style?.backgroundColor?.resolve(<WidgetState>{}),
      HocalistTheme.primary,
    );
  });

  testWidgets('buyer can move through signup and deal flow', (tester) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());

    expect(
      find.text('Post what you want. Let sellers compete.'),
      findsOneWidget,
    );

    await tapVisible(tester, 'Get started');
    await tapVisible(tester, 'Buyer');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Go to buyer dashboard');

    expect(find.textContaining('Hi Maya'), findsOneWidget);

    await tester.tap(find.text('Post'));
    await tester.pumpAndSettle();
    await tapVisible(tester, 'Post request');
    expect(find.text('Request saved on this device.'), findsOneWidget);
    await tapVisible(tester, 'View request');
    await tapVisible(tester, 'Review 2 offers');
    await tapVisible(tester, 'Select Northside Tech');

    expect(find.text('Chat with Northside Tech'), findsOneWidget);
    expect(
      find.textContaining('Offline payment reminder'),
      findsAtLeastNWidgets(1),
    );
    expect(find.text('Suggested meetup area'), findsOneWidget);
    expect(find.text('Seller selected. Chatroom opened.'), findsOneWidget);

    await tapVisible(tester, 'Finalize deal');
    expect(find.text('Meetup location to confirm'), findsOneWidget);
    await tapVisible(tester, 'Add meeting details');
    expect(find.text('Meeting place'), findsOneWidget);
    expect(find.text('City, area, address, or map pin'), findsOneWidget);
    expect(find.byTooltip('Map options'), findsWidgets);
    await tapVisible(tester, 'Confirm meeting');
    await tapVisible(tester, 'Deal failed or seller unavailable');
    expect(find.text('Recover deal'), findsOneWidget);
    expect(find.text('Compare backup offers'), findsOneWidget);
    await tapVisible(tester, 'Compare backup offers');
    expect(find.text('Backup offers restored for comparison.'), findsOneWidget);
  });

  testWidgets('seller can move from signup to marketplace', (tester) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());

    await tapVisible(tester, 'I am selling');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Start verification');
    await tapVisible(tester, 'Enter seller dashboard');

    expect(find.text('Northside Tech'), findsOneWidget);

    await tapVisible(tester, 'Browse buyer requests');

    expect(find.text('Request marketplace'), findsOneWidget);
    expect(find.text('Search by location'), findsOneWidget);
    expect(find.text('City, area, address, or map pin'), findsOneWidget);
    await tester.tap(find.byTooltip('Map options').first);
    await tester.pumpAndSettle();
    expect(find.text('Google Maps preview placeholder'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Looking for a used iPad Air'), findsOneWidget);
    expect(find.text('No requests found nearby'), findsOneWidget);
  });

  testWidgets('welcome journey and marketplace cards adapt for tablet', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    expect(find.text('Meet and pay offline'), findsOneWidget);
    final journeyCards = find.descendant(
      of: find.byType(ProcessStrip),
      matching: find.byType(AppCard),
    );
    expect(journeyCards, findsNWidgets(4));
    expect(tester.getSize(journeyCards.first).width, lessThan(430));

    await tapVisible(tester, 'I am selling');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Start verification');
    await tapVisible(tester, 'Enter seller dashboard');
    await tapVisible(tester, 'Browse buyer requests');

    final requestCard = find
        .ancestor(
          of: find.text('Looking for a used iPad Air'),
          matching: find.byType(AppCard),
        )
        .first;
    final emptyCard = find
        .ancestor(
          of: find.text('No requests found nearby'),
          matching: find.byType(AppCard),
        )
        .first;
    expect(tester.getSize(requestCard).width, lessThan(430));
    expect(tester.getSize(emptyCard).width, lessThan(430));
    expect(tester.takeException(), isNull);
  });

  testWidgets('buyer support exposes notifications safety reports and states', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());

    await tapVisible(tester, 'Get started');
    await tapVisible(tester, 'Buyer');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Go to buyer dashboard');

    await tester.tap(find.text('Help'));
    await tester.pumpAndSettle();

    expect(find.text('Support and safety'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Saved favorites and requests'), findsOneWidget);
    expect(find.text('Safety guide'), findsOneWidget);
    expect(find.text('Report user or deal'), findsOneWidget);

    await tapVisible(tester, 'Notifications');
    expect(find.text('Notification center ready'), findsOneWidget);
  });

  testWidgets('buyer can review designed account settings', (tester) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());

    await tapVisible(tester, 'Get started');
    await tapVisible(tester, 'Buyer');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Go to buyer dashboard');

    await tester.tap(find.text('Help'));
    await tester.pumpAndSettle();
    await tapVisible(tester, 'Account settings');

    expect(find.text('Profile and access'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Privacy and safety'), findsOneWidget);
    expect(find.text('Local data'), findsOneWidget);
    expect(find.text('Account removal is not live'), findsOneWidget);
    expect(find.text('Light mode'), findsOneWidget);

    await tapVisible(tester, 'Edit buyer profile');
    expect(find.text('Preferred request categories'), findsOneWidget);
    await tapVisible(tester, 'Save profile edits');

    await tester.ensureVisible(find.byType(Switch).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(find.text('Dark mode enabled.'), findsOneWidget);

    await tapVisible(tester, 'Save mock preferences');
    expect(find.text('Mock settings saved for review.'), findsOneWidget);
  });

  testWidgets('seller settings expose seller-specific Phase 1 controls', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());

    await tapVisible(tester, 'I am selling');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Start verification');
    await tapVisible(tester, 'Enter seller dashboard');

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tapVisible(tester, 'Account settings');

    expect(find.text('Seller profile controls'), findsOneWidget);
    expect(find.text('Service area and meetup radius'), findsOneWidget);
    expect(find.text('Plan and credit visibility'), findsOneWidget);
  });
}
