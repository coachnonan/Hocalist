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

  Future<void> tapHomeRole(WidgetTester tester, int index) async {
    final cards = find.byType(HomeRoleActionCard);
    expect(cards, findsNWidgets(2));
    await tester.ensureVisible(cards.at(index));
    await tester.pumpAndSettle();
    await tester.tap(cards.at(index));
    await tester.pumpAndSettle();
  }

  testWidgets('approved home renders supplied logo and interactive FAQ', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    expect(find.byType(NoAccountHomeHeader), findsOneWidget);
    expect(find.byType(HomeRoleActionCard), findsNWidgets(2));
    expect(
      find.bySemanticsLabel(
        'I am buying. Get Paid To Buy And\nGet The Best Offers',
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(
        'I am selling. Target Real Customers\n& Beat The Competition.',
      ),
      findsOneWidget,
    );
    expect(find.text('See How Hocalist Works'), findsOneWidget);
    expect(find.text('Frequently Asked Questions'), findsOneWidget);
    expect(find.text('Create Free Account'), findsOneWidget);
    final image = tester.widget<Image>(
      find.descendant(
        of: find.byType(NoAccountHomeHeader),
        matching: find.byType(Image),
      ),
    );
    expect(image.image, isA<AssetImage>());
    expect(
      (image.image as AssetImage).assetName,
      'assets/brand/hocalist-wordmark.png',
    );
    expect(
      find.text(
        'Hocalist is a reverse marketplace where buyers post what they need and sellers compete for the opportunity to earn your business.',
      ),
      findsOneWidget,
    );
    await tapVisible(tester, 'Does Hocalist sell the items I buy?');
    expect(
      find.text(
        'No. Buyers choose sellers and arrange the item handoff directly after selection.',
      ),
      findsOneWidget,
    );
    final expandedFaqHeight = tester.getSize(find.byType(HomeFaqList)).height;
    await tapVisible(tester, 'Does Hocalist sell the items I buy?');
    expect(
      tester.getSize(find.byType(HomeFaqList)).height,
      lessThan(expandedFaqHeight),
    );
    await tapVisible(tester, 'View all');
    expect(find.text('Collapse all'), findsOneWidget);
    expect(
      find.text(
        'Sellers can target real buyers who are actively looking instead of spending broadly on ads.',
      ),
      findsOneWidget,
    );
    await tapVisible(tester, 'Collapse all');
    expect(find.text('View all'), findsOneWidget);
  });

  testWidgets('home create account opens the approved account screen', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    await tapVisible(tester, 'Create Free Account');

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('I am buying'), findsOneWidget);
    expect(find.text('How will you use Hocalist?'), findsNothing);
  });

  testWidgets(
    'signed-in buyer dashboard renders the supplied Hocalist wordmark',
    (tester) async {
      useTallMobileViewport(tester);
      await tester.pumpWidget(const HocalistApp());
      await tester.pumpAndSettle();

      await tapHomeRole(tester, 0);
      await tapVisible(tester, 'Create account');
      await tapVisible(tester, 'Jump to dashboard');

      expect(find.textContaining('Good morning, Maya'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/brand/hocalist-wordmark.png',
        ),
        findsOneWidget,
      );
      expect(find.byTooltip('Total rewards earned info'), findsOneWidget);
      await tester.tap(find.byTooltip('Total rewards earned info'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('total reward amount you have earned'),
        findsOneWidget,
      );
      await tapVisible(tester, 'Done');
      await tester.tap(find.byTooltip('Pending rewards info'));
      await tester.pumpAndSettle();
      expect(find.textContaining('not ready for payout yet'), findsOneWidget);
    },
  );

  testWidgets('account screen switches role and login mode in place', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    await tapHomeRole(tester, 0);
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('I am buying'), findsOneWidget);
    expect(find.bySemanticsLabel('Upload profile image'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    for (final asset in [
      'assets/auth/social-google.png',
      'assets/auth/social-apple.png',
      'assets/auth/social-facebook.png',
    ]) {
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName == asset,
        ),
        findsOneWidget,
      );
    }

    await tapVisible(tester, 'I am selling');
    expect(find.bySemanticsLabel('Upload profile image'), findsOneWidget);
    expect(find.text('Store or seller name'), findsOneWidget);
    expect(find.text('I am selling'), findsOneWidget);

    await tapVisible(tester, 'Log in');
    expect(find.text('Log in to your account'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.text('Store or seller name'), findsNothing);

    await tapVisible(tester, 'Log in');
    expect(find.text('Northside Tech'), findsOneWidget);
  });

  testWidgets('buyer signup opens benefit onboarding before dashboard', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');

    expect(find.textContaining('Welcome,'), findsOneWidget);
    expect(find.text('As a buyer, you will:'), findsOneWidget);
    expect(find.text('Earn rewards on every purchase'), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Mileage logic for less driving'),
      180,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 12,
    );
    expect(find.text('Jump to dashboard'), findsOneWidget);

    await tapVisible(tester, 'Jump to dashboard');
    expect(find.textContaining('Good morning, Maya'), findsOneWidget);
    expect(find.text('My active request'), findsNWidgets(4));
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
    expect(HocalistTheme.roleSurface, const Color(0xffeeedff));
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

    expect(find.byType(HomeRoleActionCard), findsNWidgets(2));

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await tapVisible(tester, 'Jump to dashboard');

    expect(find.textContaining('Good morning, Maya'), findsOneWidget);

    await tapVisible(tester, 'Post a new request');
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

    await tapHomeRole(tester, 1);
    await tapVisible(tester, 'Create account');
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

    expect(find.byType(HomeRoleActionCard), findsNWidgets(2));
    final homeCardSize = tester.getSize(find.byType(HomeRoleActionCard).first);
    expect(homeCardSize.width, greaterThan(800));
    expect(homeCardSize.height, lessThan(540));
    expect(
      homeCardSize.width / homeCardSize.height,
      moreOrLessEquals(1.71, epsilon: 0.02),
    );

    await tapHomeRole(tester, 1);
    await tapVisible(tester, 'Create account');
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

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await tapVisible(tester, 'Jump to dashboard');

    await tester.tap(find.text('More'));
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

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await tapVisible(tester, 'Jump to dashboard');

    await tester.tap(find.text('More'));
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

    await tapHomeRole(tester, 1);
    await tapVisible(tester, 'Create account');
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
