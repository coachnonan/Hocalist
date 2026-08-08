import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hocalist/features/approved/onboarding_home_pages.dart';
import 'package:hocalist/features/approved/trends_notifications_pages.dart';
import 'package:hocalist/main.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadHocalistTestFonts);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  void useTallMobileViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  void useAccessibleTextViewport(WidgetTester tester) {
    useTallMobileViewport(tester);
    tester.binding.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );
  }

  void useBossPhoneTextViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 900);
    tester.view.devicePixelRatio = 1;
    tester.binding.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );
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

  Future<void> revealInApprovedScroll(
    WidgetTester tester,
    Finder target,
    Key scrollKey,
  ) async {
    final scrollable = find
        .descendant(
          of: find.byKey(scrollKey),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      target,
      280,
      scrollable: scrollable,
      maxScrolls: 20,
    );
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    final rect = tester.getRect(target);
    final viewportHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final lowerLimit = viewportHeight - 110;
    if (rect.bottom > lowerLimit) {
      await tester.drag(
        find.byKey(scrollKey),
        Offset(0, -(rect.bottom - lowerLimit)),
      );
      await tester.pumpAndSettle();
    } else if (rect.top < 20) {
      await tester.drag(find.byKey(scrollKey), Offset(0, 20 - rect.top));
      await tester.pumpAndSettle();
    }
  }

  Future<void> tapHomeRole(WidgetTester tester, int index) async {
    final labels = [
      'I am buying. Get paid to buy and get the best offers. Post a request.',
      'I am selling. Target real customers and beat the competition. Browse requests.',
    ];
    final card = find.bySemanticsLabel(labels[index]);
    expect(card, findsOneWidget);
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();
  }

  Future<void> finishBuyerOnboarding(WidgetTester tester) async {
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Jump to dashboard');
  }

  Future<void> postBuyerRequest(WidgetTester tester) async {
    await tapVisible(tester, 'Post a new request');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Post request');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }

  Future<void> openBuyerDashboard(WidgetTester tester) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);
    await postBuyerRequest(tester);
    expect(find.textContaining('Good morning, Maya'), findsOneWidget);
  }

  Future<void> tapFirstIpadRequest(WidgetTester tester) async {
    final finder = find.textContaining('iPad Air').first;
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('approved home renders supplied logo and interactive FAQ', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    expect(find.byType(ApprovedNoAccountHomePage), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'I am buying. Get paid to buy and get the best offers. Post a request.',
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(
        'I am selling. Target real customers and beat the competition. Browse requests.',
      ),
      findsOneWidget,
    );
    expect(find.text('See How Hocalist Works'), findsOneWidget);
    expect(find.text('Frequently Asked Questions'), findsOneWidget);
    expect(find.text('Create Free Account'), findsOneWidget);
    final image = tester.widget<Image>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/approved_onboarding_home/wordmark.png',
      ),
    );
    expect(image.image, isA<AssetImage>());
    expect(
      (image.image as AssetImage).assetName,
      'assets/approved_onboarding_home/wordmark.png',
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
    await tapVisible(tester, 'Does Hocalist sell the items I buy?');
    expect(
      find.text(
        'No. Buyers choose sellers and arrange the item handoff directly after selection.',
      ),
      findsNothing,
    );
    await tapVisible(tester, 'View all');
    expect(
      find.text(
        'Sellers can target real buyers who are actively looking instead of spending broadly on ads.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('logged-out Hocatrends nav opens approved redesign', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hocatrends').last);
    await tester.pumpAndSettle();

    expect(find.text('Saving'), findsOneWidget);
    expect(
      find.text('Skip the Rewards & save on current offers'),
      findsOneWidget,
    );
    expect(find.text('Hocatrends preview is coming soon.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Hocatrends category cards tolerate common phone widths', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in <double>[344, 360, 390, 430]) {
      tester.view.physicalSize = Size(width, 1100);
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        MaterialApp(
          theme: HocalistTheme.light,
          home: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ApprovedHocatrendsPage(
                  accent: HocalistTheme.actionBlue,
                  onSeeSellers: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Most Competitive Categories'),
        findsOneWidget,
      );
      expect(find.textContaining('Today'), findsOneWidget);
      expect(find.text('Pressure Washing'), findsOneWidget);
      expect(find.text('Living Room Furniture'), findsOneWidget);
      expect(find.text('See Sellers'), findsNWidgets(5));
      final error = tester.takeException();
      if (error is FlutterError) {
        debugPrint('Hocatrends overflow diagnostics for width $width');
        debugPrint(error.toStringDeep());
        for (final diagnostic in error.diagnostics) {
          debugPrint(diagnostic.toStringDeep());
        }
      }
      expect(error, isNull, reason: 'width: $width');
    }
  });

  testWidgets('Hocatrends see sellers opens responsive seller list', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);
    await tapVisible(tester, 'Hocatrends');
    await tester.ensureVisible(find.text('See Sellers').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('See Sellers').first);
    await tester.pumpAndSettle();

    expect(find.text('iPad Air Sellers'), findsOneWidget);
    expect(find.text('23 sellers are offering deals'), findsOneWidget);
    expect(find.text('Northside Tech'), findsOneWidget);
    expect(find.text('Chat Seller'), findsWidgets);
    expect(tester.takeException(), isNull);
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
      await finishBuyerOnboarding(tester);

      expect(find.textContaining('Good morning, Maya'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/approved_onboarding_home/wordmark.png',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Total rewards earned'), findsOneWidget);
      expect(find.textContaining('Pending rewards'), findsOneWidget);
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
      'assets/approved_onboarding_home/social-google.png',
      'assets/approved_onboarding_home/social-apple.png',
      'assets/approved_onboarding_home/social-facebook.png',
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
    expect(find.text('Continue'), findsOneWidget);
    await tapVisible(tester, 'Continue');
    await tester.scrollUntilVisible(
      find.text('Mileage logic for less driving'),
      180,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 12,
    );
    expect(find.text('Jump to dashboard'), findsOneWidget);

    await tapVisible(tester, 'Jump to dashboard');
    expect(find.textContaining('Good morning, Maya'), findsOneWidget);
    expect(find.text('My active request'), findsNothing);
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

    expect(
      find.bySemanticsLabel(
        'I am buying. Get paid to buy and get the best offers. Post a request.',
      ),
      findsOneWidget,
    );

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);

    expect(find.textContaining('Good morning, Maya'), findsOneWidget);

    await tapVisible(tester, 'Post a new request');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Post request');
    expect(find.text('Request posted. You are back home.'), findsOneWidget);
    await tapFirstIpadRequest(tester);
    await tapVisible(tester, '32 offers');
    final firstOfferDetails = find.byKey(const Key('approved-view-offer-NT'));
    await revealInApprovedScroll(
      tester,
      firstOfferDetails,
      const Key('approved-offers-scroll'),
    );
    await tester.tap(firstOfferDetails);
    await tester.pumpAndSettle();
    await revealInApprovedScroll(
      tester,
      find.text('Select this seller'),
      const Key('approved-view-offer-scroll'),
    );
    await tapVisible(tester, 'Select this seller');

    expect(find.text('John D.'), findsOneWidget);
    expect(
      find.textContaining('Seller\'s Final Offer'),
      findsAtLeastNWidgets(1),
    );
    expect(find.text('Accept to meet'), findsOneWidget);
    expect(find.text('Seller selected. Chatroom opened.'), findsOneWidget);
    expect(find.text('Tap to close details'), findsOneWidget);
    expect(find.text('Request Change'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tapVisible(tester, 'Offers');
    final selectedChatButton = find.byKey(const Key('approved-chat-after-NT'));
    await tester.ensureVisible(selectedChatButton);
    await tester.pumpAndSettle();
    await tester.tap(selectedChatButton);
    await tester.pumpAndSettle();
    expect(find.text('John D.'), findsOneWidget);

    await tapVisible(tester, 'Tap to close details');
    expect(find.text('Tap to view details'), findsOneWidget);
    expect(find.text('Request Change'), findsNothing);

    await tapVisible(tester, 'Tap to view details');
    expect(find.text('Tap to close details'), findsOneWidget);
    expect(find.text('Request Change'), findsOneWidget);

    await tapVisible(tester, 'Accept to meet');
    expect(find.text('Meetup accepted'), findsOneWidget);
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

  testWidgets('buyer home active request body opens request details', (
    tester,
  ) async {
    await openBuyerDashboard(tester);

    await tapFirstIpadRequest(tester);

    expect(find.text('Request details'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(
      find.text('Review and edit your request information.'),
      findsOneWidget,
    );
    expect(find.text('Edit your request'), findsOneWidget);

    await tapVisible(tester, '32 offers');

    expect(find.text('Offers received'), findsOneWidget);
  });

  testWidgets('buyer home offer activity and offers tab open correct pages', (
    tester,
  ) async {
    await openBuyerDashboard(tester);

    await tester.ensureVisible(find.text('View offers  ›').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('View offers  ›').first);
    await tester.pumpAndSettle();

    expect(find.text('Offers received'), findsOneWidget);
    expect(find.text('Request details'), findsNothing);

    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Good morning, Maya'), findsOneWidget);

    await tester.tap(find.text('Offers').last);
    await tester.pumpAndSettle();

    expect(find.text('Offers received'), findsOneWidget);
    expect(find.text('Request details'), findsNothing);

    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.text('Northside Tech sent you a new offer'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Northside Tech sent you a new offer'));
    await tester.pumpAndSettle();

    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('Offers received'), findsNothing);
  });

  testWidgets('request details exposes editable controls and safe feedback', (
    tester,
  ) async {
    await openBuyerDashboard(tester);
    await tapFirstIpadRequest(tester);

    expect(find.byKey(const Key('request-title-field')), findsOneWidget);
    expect(find.byKey(const Key('request-description-field')), findsOneWidget);
    expect(find.text('Condition'), findsOneWidget);
    expect(find.text('Budget (optional)'), findsOneWidget);
    expect(find.byTooltip('Edit Condition'), findsOneWidget);
    expect(find.byTooltip('Edit Budget (optional)'), findsOneWidget);
    expect(find.text('Quantity'), findsOneWidget);
    expect(find.text('Willing to receive higher offers?'), findsOneWidget);
    expect(find.text('Current estimated rewards'), findsOneWidget);
    expect(find.text('32 offers'), findsOneWidget);

    final saveButton = find.byKey(const Key('save-request-changes'));
    await tester.drag(find.byType(ListView).first, const Offset(0, -2200));
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Request changes saved on this device.'), findsOneWidget);

    final deleteButton = find.byKey(const Key('delete-request'));
    await tester.drag(find.byType(ListView).first, const Offset(0, 2200));
    await tester.pumpAndSettle();
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    expect(find.text('Delete this request?'), findsOneWidget);
    await tapVisible(tester, 'Cancel');
    expect(find.text('Delete this request?'), findsNothing);
  });

  testWidgets('offers dashboard supports sort filter details and chat route', (
    tester,
  ) async {
    await openBuyerDashboard(tester);
    await tester.ensureVisible(find.text('View offers  ›').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('View offers  ›').first);
    await tester.pumpAndSettle();

    expect(find.text('Your total rewards'), findsOneWidget);
    expect(find.text('From 2 sellers'), findsOneWidget);
    expect(find.text('You earn when you buy'), findsOneWidget);
    expect(find.text('Buy from any seller within 5 days'), findsOneWidget);
    expect(find.text('Rewards are added after purchase'), findsOneWidget);
    expect(find.text('Northside Tech'), findsOneWidget);
    expect(find.byKey(const Key('approved-chat-after-NT')), findsOneWidget);

    await tapVisible(tester, 'Filter');
    expect(find.text('Offer filters opened.'), findsOneWidget);

    final offerDetails = find.byKey(const Key('approved-view-offer-NT'));
    await revealInApprovedScroll(
      tester,
      offerDetails,
      const Key('approved-offers-scroll'),
    );
    await tester.tap(offerDetails);
    await tester.pumpAndSettle();
    expect(find.text('Offer details'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    await revealInApprovedScroll(
      tester,
      find.text('Select this seller'),
      const Key('approved-view-offer-scroll'),
    );
    expect(find.text('Select this seller'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Offers').last);
    await tester.pumpAndSettle();
    final chatAfterSelection = find.byKey(const Key('approved-chat-after-NT'));
    await tester.ensureVisible(chatAfterSelection);
    await tester.pumpAndSettle();
    await tester.tap(chatAfterSelection);
    await tester.pumpAndSettle();
    expect(find.text('John D.'), findsOneWidget);
    expect(find.text('Seller selected. Chatroom opened.'), findsOneWidget);
  });

  testWidgets('request details renders without tablet layout exceptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(768, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const HocalistApp());
    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);
    await postBuyerRequest(tester);
    await tapFirstIpadRequest(tester);

    expect(find.text('Request details'), findsOneWidget);
    expect(find.text('Condition'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('buyer offer and chat tolerate larger system text', (
    tester,
  ) async {
    useAccessibleTextViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);
    await tapVisible(tester, 'Hocatrends');

    expect(
      find.text('Skip the Rewards & save on current offers'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tapVisible(tester, 'Home');
    await tapVisible(tester, 'Post a new request');
    await tapVisible(tester, 'Continue');
    await tapVisible(tester, 'Post request');
    expect(find.text('Request posted. You are back home.'), findsOneWidget);
    await tapFirstIpadRequest(tester);
    await tapVisible(tester, '32 offers');

    final offerDetails = find.byKey(const Key('approved-view-offer-NT'));
    await revealInApprovedScroll(
      tester,
      offerDetails,
      const Key('approved-offers-scroll'),
    );
    await tester.pumpAndSettle();
    await tester.tap(offerDetails);
    await tester.pumpAndSettle();

    expect(find.text('Offer details'), findsOneWidget);
    await revealInApprovedScroll(
      tester,
      find.text('Select this seller'),
      const Key('approved-view-offer-scroll'),
    );
    expect(find.text('Select this seller'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tapVisible(tester, 'Select this seller');

    expect(find.text('John D.'), findsOneWidget);
    expect(find.text('Accept to meet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('request details tolerate larger system text', (tester) async {
    useAccessibleTextViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);
    await postBuyerRequest(tester);
    await tapFirstIpadRequest(tester);

    expect(find.text('Request details'), findsOneWidget);
    expect(find.text('Edit your request'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(ListView).first, const Offset(0, -1600));
    await tester.pumpAndSettle();
    expect(find.text('Current estimated rewards'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bottom nav and offer details tolerate boss phone text scale', (
    tester,
  ) async {
    useBossPhoneTextViewport(tester);
    await tester.pumpWidget(const HocalistApp());
    await tester.pumpAndSettle();

    expect(find.text('Hocatrends'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);
    expect(tester.takeException(), isNull, reason: 'buyer dashboard');
    await tapVisible(tester, 'Post a new request');
    expect(tester.takeException(), isNull, reason: 'request editor');
    await tapVisible(tester, 'Continue');
    expect(tester.takeException(), isNull, reason: 'request review');
    await tapVisible(tester, 'Post request');
    expect(tester.takeException(), isNull, reason: 'posted dashboard');
    expect(find.text('Request posted. You are back home.'), findsOneWidget);
    await tapFirstIpadRequest(tester);
    expect(tester.takeException(), isNull, reason: 'request details');
    await tapVisible(tester, '32 offers');
    expect(tester.takeException(), isNull, reason: 'offers received');

    final offerDetails = find.byKey(const Key('approved-view-offer-NT'));
    await revealInApprovedScroll(
      tester,
      offerDetails,
      const Key('approved-offers-scroll'),
    );
    await tester.pumpAndSettle();
    await tester.tap(offerDetails);
    await tester.pumpAndSettle();

    expect(find.text('Offer details'), findsOneWidget);
    expect(find.text('Identity verified'), findsOneWidget);
    await revealInApprovedScroll(
      tester,
      find.text('Select this seller'),
      const Key('approved-view-offer-scroll'),
    );
    expect(find.text('Select this seller'), findsOneWidget);
    expect(find.text('Chats'), findsOneWidget);
    expect(tester.takeException(), isNull);
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

  testWidgets('buyer chats tab opens inbox before individual chat', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);

    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();

    expect(find.text('Chats'), findsWidgets);
    expect(find.byTooltip('Back'), findsNothing);
    expect(find.text('Northside Tech'), findsOneWidget);
    expect(find.text('Loop Resale'), findsOneWidget);
    expect(find.text('Selected seller'), findsOneWidget);

    await tapVisible(tester, 'Northside Tech');
    expect(find.text('Accept to meet'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
  });

  testWidgets('buyer chat action buttons open supporting UI popups', (
    tester,
  ) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);
    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();
    await tapVisible(tester, 'Northside Tech');

    await tester.tap(find.byTooltip('Call seller'));
    await tester.pumpAndSettle();
    expect(
      find.text('Calling is available after confirmation.'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Chat options'));
    await tester.pumpAndSettle();
    expect(find.text('Report user or deal'), findsOneWidget);
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

    final buyerCard = find.bySemanticsLabel(
      'I am buying. Get paid to buy and get the best offers. Post a request.',
    );
    expect(buyerCard, findsOneWidget);
    final homeCardSize = tester.getSize(buyerCard);
    expect(homeCardSize.width, lessThanOrEqualTo(426));
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
    await finishBuyerOnboarding(tester);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    expect(find.text('More'), findsWidgets);
    expect(find.text('Edit buyer profile'), findsOneWidget);
    expect(find.text('Account settings'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Saved favorites and requests'), findsOneWidget);
    expect(find.text('Safety guide'), findsOneWidget);
    expect(find.text('Help and support'), findsOneWidget);
    expect(find.text('Report user or deal'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);

    await tapVisible(tester, 'Notifications');
    expect(find.text('Notification center ready'), findsOneWidget);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tapVisible(tester, 'Log out');
    expect(find.text('See How Hocalist Works'), findsOneWidget);
  });

  testWidgets('buyer can review designed account settings', (tester) async {
    useTallMobileViewport(tester);
    await tester.pumpWidget(const HocalistApp());

    await tapHomeRole(tester, 0);
    await tapVisible(tester, 'Create account');
    await finishBuyerOnboarding(tester);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    await tapVisible(tester, 'Account settings');

    expect(find.text('Buyer request controls'), findsOneWidget);
    expect(find.text('Account access'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Privacy and local data'), findsOneWidget);
    expect(find.text('Account removal needs backend'), findsOneWidget);
    expect(find.text('Light mode'), findsOneWidget);
    expect(find.text('Accessibility'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.byType(Slider), findsNothing);
    expect(find.text('Log out'), findsNothing);

    await tapVisible(tester, 'Accessibility');
    expect(find.text('Customize Hocalist to fit your needs'), findsOneWidget);
    expect(find.text('1. Choose your text size'), findsOneWidget);

    await tester.tap(find.byKey(const Key('accessibility-back')));
    await tester.pumpAndSettle();
    expect(find.text('Account settings'), findsOneWidget);
    await tapVisible(tester, 'Accessibility');

    await tester.tap(find.byKey(const Key('text-size-extraLarge')));
    await tester.pumpAndSettle();
    expect(find.text('Accessibility preferences applied.'), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const Key('show-accessibility-preview')),
      220,
      scrollable: find.descendant(
        of: find.byKey(const Key('accessibility-page-scroll')),
        matching: find.byType(Scrollable),
      ),
      maxScrolls: 12,
    );
    await tester.ensureVisible(
      find.byKey(const Key('show-accessibility-preview')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('show-accessibility-preview')));
    await tester.pumpAndSettle();
    expect(find.text('Example request card'), findsOneWidget);

    await tapVisible(tester, 'Apply changes');
    expect(find.text('Accessibility preferences applied.'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString('hocalist.accessibility.textSize'),
      'extraLarge',
    );
    expect(
      preferences.getString('hocalist.accessibility.fontStyle'),
      'standard',
    );
    expect(
      preferences.getString('hocalist.accessibility.buttonStyle'),
      'rounded',
    );
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
