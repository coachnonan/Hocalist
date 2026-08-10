import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hocalist/features/approved/approved_replica_metrics.dart';
import 'package:hocalist/features/approved/onboarding_home_pages.dart';

import 'test_fonts.dart';

class _WorkspaceAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (!key.startsWith('assets/approved_onboarding_home/')) {
      return rootBundle.load(key);
    }
    final bytes = File(key).readAsBytesSync();
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(loadHocalistTestFonts);

  Future<void> pumpSurface(
    WidgetTester tester,
    Widget child, {
    required double width,
    double height = 920,
    double textScale = 1.6,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, height));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: _WorkspaceAssetBundle(),
        child: MaterialApp(
          key: ObjectKey(child),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Nunito',
            scaffoldBackgroundColor: Colors.white,
          ),
          home: MediaQuery(
            data: MediaQueryData(
              size: Size(width, height),
              textScaler: TextScaler.linear(textScale),
            ),
            child: child,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
  }

  double lockedScale(double width) {
    if (width < 390) return width / 390;
    return 1;
  }

  group('approved onboarding and home responsive layouts', () {
    for (final width in [360.0, 390.0, 426.0]) {
      testWidgets('$width account page fits at 1.6 text scale', (tester) async {
        await pumpSurface(
          tester,
          ApprovedAccountCreationPage(
            role: ApprovedAccountRole.buyer,
            name: 'Jonathan',
            onNameChanged: (_) {},
            onRoleChanged: (_) {},
            onClose: () {},
            onSignup: () {},
            onLogin: () {},
          ),
          width: width,
        );

        expect(find.text('Create your account'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$width benefits fit at 1.6 text scale', (tester) async {
        await pumpSurface(
          tester,
          ApprovedBuyerBenefitsPage(
            name: 'Jonathan',
            onClose: () {},
            onFinish: () {},
          ),
          width: width,
        );

        expect(find.text('As a buyer, you will:'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$width signed-out home fits at 1.6 text scale', (
        tester,
      ) async {
        await pumpSurface(
          tester,
          ApprovedNoAccountHomePage(
            onStart: () {},
            onBuyer: () {},
            onSeller: () {},
          ),
          width: width,
        );

        expect(find.text('We Are The Better Option'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('$width buyer home fits at 1.6 text scale', (tester) async {
        await pumpSurface(
          tester,
          ApprovedBuyerHomePage(
            name: 'Alex',
            requestTitle: 'iPad Air 5, 256GB',
            requestPosted: true,
            onCreate: () {},
            onRequestDetails: () {},
            onOffers: () {},
            onRecentActivity: () {},
            onWallet: () {},
          ),
          width: width,
        );

        expect(find.textContaining('Good morning, Alex!'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('dashboard replica width contract', () {
    for (final width in [304.0, 320.0, 360.0, 390.0, 430.0]) {
      testWidgets('$width default keeps the reward pair in one row', (
        tester,
      ) async {
        await pumpSurface(
          tester,
          ApprovedBuyerHomePage(
            name: 'Maya',
            requestTitle: 'iPad Air 5, 256GB',
            requestPosted: true,
            onCreate: () {},
            onRequestDetails: () {},
            onOffers: () {},
            onRecentActivity: () {},
            onWallet: () {},
          ),
          width: width,
          textScale: 1,
        );

        final earned = tester.getRect(
          find.byKey(const ValueKey('approved-total-rewards-card')),
        );
        final pending = tester.getRect(
          find.byKey(const ValueKey('approved-pending-rewards-card')),
        );
        final navigation = tester.getRect(
          find.byKey(const ValueKey('approved-bottom-navigation')),
        );

        expect((earned.top - pending.top).abs(), lessThan(1));
        expect(earned.height, closeTo(pending.height, 0.01));
        expect(earned.right, lessThan(pending.left));
        expect(navigation.width, closeTo(width, 0.01));
        expect(
          tester
              .getSize(
                find.byKey(
                  const ValueKey('approved-bottom-navigation-content'),
                ),
              )
              .width,
          closeTo(width, 0.01),
        );
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets(
      'reward pair keeps equal height and proportional 320 geometry',
      (tester) async {
        Future<List<Rect>> pumpRewardPair(double width, double height) async {
          await pumpSurface(
            tester,
            ApprovedBuyerHomePage(
              name: 'Maya',
              requestTitle: 'iPad Air 5, 256GB',
              requestPosted: true,
              onCreate: () {},
              onRequestDetails: () {},
              onOffers: () {},
              onRecentActivity: () {},
              onWallet: () {},
            ),
            width: width,
            height: height,
            textScale: 1,
          );
          return [
            tester.getRect(
              find.byKey(const ValueKey('approved-total-rewards-card')),
            ),
            tester.getRect(
              find.byKey(const ValueKey('approved-pending-rewards-card')),
            ),
          ];
        }

        final reference = await pumpRewardPair(390, 844);
        expect(reference[0].height, closeTo(reference[1].height, 0.01));

        final narrow = await pumpRewardPair(320, 693);
        expect(narrow[0].height, closeTo(narrow[1].height, 0.01));
        expect(
          narrow[1].height,
          closeTo(reference[1].height * lockedScale(320), 0.75),
        );
        expect(tester.takeException(), isNull);
      },
    );

    for (final width in [600.0, 768.0, 980.0]) {
      testWidgets('$width expands the Buyer composition within its cap', (
        tester,
      ) async {
        await pumpSurface(
          tester,
          ApprovedBuyerHomePage(
            name: 'Maya',
            requestTitle: 'iPad Air 5, 256GB',
            requestPosted: true,
            onCreate: () {},
            onRequestDetails: () {},
            onOffers: () {},
            onRecentActivity: () {},
            onWallet: () {},
          ),
          width: width,
          textScale: 1,
        );

        final earned = tester.getRect(
          find.byKey(const ValueKey('approved-total-rewards-card')),
        );
        final pending = tester.getRect(
          find.byKey(const ValueKey('approved-pending-rewards-card')),
        );
        final navigation = tester.getRect(
          find.byKey(const ValueKey('approved-bottom-navigation')),
        );
        final navigationContent = tester.getRect(
          find.byKey(const ValueKey('approved-bottom-navigation-content')),
        );

        expect((earned.top - pending.top).abs(), lessThan(1));
        expect(earned.right, lessThan(pending.left));
        expect(navigation.width, closeTo(width, 0.01));
        expect(navigationContent.width, greaterThan(390));
        expect(navigationContent.width, closeTo(width.clamp(0, 920), 0.01));
        expect(navigation.center.dx, closeTo(width / 2, 0.01));
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('onboarding and home measured reference geometry', () {
    for (final width in [320.0, 360.0, 390.0, 430.0, 600.0, 768.0, 980.0]) {
      testWidgets(
        '$width uses bounded-fluid account, benefits, and home content',
        (tester) async {
          final scale = lockedScale(width);
          final metrics = ApprovedReplicaMetrics.resolve(
            availableWidth: width,
            textScaler: TextScaler.noScaling,
          );
          final height = width == 320 ? 693.0 : 920.0;

          await pumpSurface(
            tester,
            ApprovedAccountCreationPage(
              role: ApprovedAccountRole.buyer,
              name: 'Maya Chen',
              onNameChanged: (_) {},
              onRoleChanged: (_) {},
              onClose: () {},
              onSignup: () {},
              onLogin: () {},
            ),
            width: width,
            height: height,
            textScale: 1,
          );

          final accountField = tester.getRect(
            find.byKey(const ValueKey('approved-account-name-field')),
          );
          expect(accountField.center.dx, closeTo(width / 2, 0.01));
          expect(
            accountField.width,
            closeTo(
              metrics.innerContentMaxWidth(referenceHorizontalInset: 22),
              0.75,
            ),
          );
          expect(accountField.height, closeTo(44 * scale, 0.75));
          expect(tester.takeException(), isNull);

          await pumpSurface(
            tester,
            ApprovedBuyerBenefitsPage(
              name: 'Maya Chen',
              onClose: () {},
              onFinish: () {},
            ),
            width: width,
            height: height,
            textScale: 1,
          );

          final benefit = tester.getRect(
            find.byKey(const ValueKey('approved-benefit-benefit-reward.png')),
          );
          expect(benefit.center.dx, closeTo(width / 2, 0.01));
          expect(
            benefit.width,
            closeTo(
              metrics.innerContentMaxWidth(referenceHorizontalInset: 26),
              0.75,
            ),
          );
          expect(benefit.height, greaterThanOrEqualTo((64 * scale) - 0.01));
          expect(tester.takeException(), isNull);

          await pumpSurface(
            tester,
            ApprovedNoAccountHomePage(
              onStart: () {},
              onBuyer: () {},
              onSeller: () {},
            ),
            width: width,
            height: height,
            textScale: 1,
          );

          final buyerCard = tester.getRect(
            find.byKey(const ValueKey('approved-home-home-buyer-card.png')),
          );
          expect(buyerCard.center.dx, closeTo(width / 2, 0.01));
          expect(
            buyerCard.width,
            closeTo(
              metrics.innerContentMaxWidth(referenceHorizontalInset: 16),
              0.75,
            ),
          );
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('390x844 account follows the measured vertical rhythm', (
      tester,
    ) async {
      await pumpSurface(
        tester,
        ApprovedAccountCreationPage(
          role: ApprovedAccountRole.buyer,
          name: 'Maya Chen',
          onNameChanged: (_) {},
          onRoleChanged: (_) {},
          onClose: () {},
          onSignup: () {},
          onLogin: () {},
        ),
        width: 390,
        height: 844,
        textScale: 1,
      );

      final fields = [
        'approved-account-name-field',
        'approved-account-email-field',
        'approved-account-phone-field',
        'approved-account-password-field',
        'approved-account-confirm-password-field',
      ].map((key) => tester.getRect(find.byKey(ValueKey(key)))).toList();
      final socials = [
        'approved-account-google-action',
        'approved-account-apple-action',
        'approved-account-facebook-action',
      ].map((key) => tester.getRect(find.byKey(ValueKey(key)))).toList();
      final modalHeader = tester.getRect(
        find.byKey(const ValueKey('approved-account-modal-header')),
      );
      final loginRow = tester.getRect(
        find.byKey(const ValueKey('approved-account-login-row')),
      );
      final eyeSuffixes = [
        'approved-account-password-eye',
        'approved-account-confirm-password-eye',
      ].map((key) => find.byKey(ValueKey(key))).toList();
      final eyeTapTargets = eyeSuffixes.map((suffix) {
        final action = find.descendant(
          of: suffix,
          matching: find.byType(InkWell),
        );
        return tester.getRect(action);
      }).toList();
      final eyeArtwork = eyeSuffixes.map((suffix) {
        final asset = find.descendant(of: suffix, matching: find.byType(Image));
        return tester.widget<Image>(asset);
      }).toList();

      expect(modalHeader.height, closeTo(103, 0.75));
      for (final field in fields) {
        expect(field.height, closeTo(44, 0.75));
      }
      for (final eyeTapTarget in eyeTapTargets) {
        expect(eyeTapTarget.width, closeTo(42, 0.01));
        expect(eyeTapTarget.height, closeTo(42, 0.01));
      }
      for (final eyeAsset in eyeArtwork) {
        expect(eyeAsset.width, 28);
        expect(eyeAsset.height, 28);
      }
      expect(find.bySemanticsLabel('Show password'), findsOneWidget);
      expect(find.bySemanticsLabel('Show confirm password'), findsOneWidget);
      for (var index = 1; index < fields.length; index++) {
        expect(fields[index].top - fields[index - 1].bottom, closeTo(9, 0.75));
      }
      for (final social in socials) {
        expect(social.height, greaterThanOrEqualTo(42));
      }
      expect(socials[1].top - socials[0].bottom, closeTo(5, 0.75));
      expect(socials[2].top - socials[1].bottom, closeTo(5, 0.75));
      expect(loginRow.top - socials[2].bottom, closeTo(8, 0.75));
      expect(tester.getBottomRight(find.text('Log in')).dy, lessThan(820));
      expect(tester.takeException(), isNull);
    });

    testWidgets('390x844 benefits restore source card and action dimensions', (
      tester,
    ) async {
      await pumpSurface(
        tester,
        ApprovedBuyerBenefitsPage(
          name: 'Maya Chen',
          onClose: () {},
          onFinish: () {},
        ),
        width: 390,
        height: 844,
        textScale: 1,
      );

      expect(
        tester
            .getRect(find.byKey(const ValueKey('approved-benefits-avatar')))
            .size,
        const Size(70, 70),
      );
      expect(
        tester
            .getRect(find.byKey(const ValueKey('approved-benefits-video')))
            .width,
        closeTo(272, 0.01),
      );
      for (final asset in [
        'benefit-reward.png',
        'benefit-tag.png',
        'benefit-shield.png',
        'benefit-chat.png',
        'benefit-location.png',
        'benefit-medal.png',
        'benefit-payment-shield.png',
        'benefit-review-dollar.png',
      ]) {
        expect(
          tester
              .getRect(find.byKey(ValueKey('approved-benefit-$asset')))
              .height,
          greaterThanOrEqualTo(64),
        );
      }
      await tester.scrollUntilVisible(
        find.text('Jump to dashboard'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        tester
            .getRect(find.byKey(const ValueKey('approved-benefits-primary')))
            .height,
        greaterThanOrEqualTo(54),
      );
      expect(find.text('Continue'), findsNothing);
      expect(find.text('Jump to dashboard').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Buyer welcome keeps the video fixed while benefits scroll', (
      tester,
    ) async {
      await pumpSurface(
        tester,
        ApprovedBuyerBenefitsPage(
          name: 'Maya Chen',
          onClose: () {},
          onFinish: () {},
        ),
        width: 390,
        height: 844,
        textScale: 1,
      );

      final video = find.byKey(const ValueKey('approved-benefits-video'));
      final scroll = find.byKey(const ValueKey('approved-benefits-scroll'));
      final firstBenefit = find.byKey(
        const ValueKey('approved-benefit-benefit-reward.png'),
      );
      final videoBefore = tester.getRect(video);
      final benefitBefore = tester.getRect(firstBenefit);

      await tester.drag(scroll, const Offset(0, -320));
      await tester.pump();

      final videoAfter = tester.getRect(video);
      final benefitAfter = tester.getRect(firstBenefit);
      expect(videoAfter.top, closeTo(videoBefore.top, 0.01));
      expect(videoAfter.bottom, closeTo(videoBefore.bottom, 0.01));
      expect(benefitAfter.top, lessThan(benefitBefore.top));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Buyer welcome advances to the second video preview', (
      tester,
    ) async {
      await pumpSurface(
        tester,
        ApprovedBuyerBenefitsPage(
          name: 'Maya Chen',
          onClose: () {},
          onFinish: () {},
        ),
        width: 390,
        height: 844,
        textScale: 1,
      );

      expect(
        find.bySemanticsLabel('Buyer welcome video 1 of 2 preview'),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 8));
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.bySemanticsLabel('Buyer welcome video 2 of 2 preview'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('390 Medium preserves source single-line labels', (
      tester,
    ) async {
      await pumpSurface(
        tester,
        ApprovedNoAccountHomePage(
          onStart: () {},
          onBuyer: () {},
          onSeller: () {},
        ),
        width: 390,
        height: 844,
        textScale: 1,
      );

      for (final label in [
        'Buyers Earn Commissions From Sellers Targeting',
        'Businesses Don\'t Waste Money On Ads Just To Reach People',
        'A System designed to give both sides & Better Outcome',
        'Safe, private, and in your control',
      ]) {
        expect(tester.getSize(find.text(label)).height, lessThan(16));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('signed-out Home CTA yields width to its copy first', (
      tester,
    ) async {
      for (final width in <double>[320, 360, 390]) {
        await pumpSurface(
          tester,
          ApprovedNoAccountHomePage(
            onStart: () {},
            onBuyer: () {},
            onSeller: () {},
          ),
          width: width,
          height: 844,
          textScale: 1,
        );
        final heading = find.text('Ready to start earning?');
        await tester.scrollUntilVisible(
          heading,
          300,
          scrollable: find.byType(Scrollable).first,
        );
        final button = find.ancestor(
          of: find.text('Create Free Account'),
          matching: find.byType(FilledButton),
        );
        final headingRect = tester.getRect(heading);
        final buttonRect = tester.getRect(button);
        final metrics = ApprovedReplicaMetrics.resolve(
          availableWidth: width,
          textScaler: TextScaler.noScaling,
        );
        expect(headingRect.width, greaterThan(buttonRect.width * 0.55));
        expect(
          headingRect.height,
          lessThan(metrics.fontSize(15) * 3.8),
          reason: 'Home CTA heading broke into too many short lines at $width.',
        );
        expect(buttonRect.height, greaterThanOrEqualTo(metrics.geometry(48)));
        expect(tester.takeException(), isNull);
      }
    });

    for (final textScale in [1.15, 1.3]) {
      testWidgets('320 Large/XL $textScale reflows account and dashboard', (
        tester,
      ) async {
        await pumpSurface(
          tester,
          ApprovedAccountCreationPage(
            role: ApprovedAccountRole.buyer,
            name: 'Maya Chen',
            onNameChanged: (_) {},
            onRoleChanged: (_) {},
            onClose: () {},
            onSignup: () {},
            onLogin: () {},
          ),
          width: 320,
          height: 693,
          textScale: textScale,
        );

        final buyerRole = tester.getRect(
          find.byKey(const ValueKey('approved-account-role-I am buying')),
        );
        final sellerRole = tester.getRect(
          find.byKey(const ValueKey('approved-account-role-I am selling')),
        );
        expect(sellerRole.top, greaterThan(buyerRole.bottom));
        expect(tester.takeException(), isNull);

        await pumpSurface(
          tester,
          ApprovedBuyerBenefitsPage(
            name: 'Maya Chen',
            onClose: () {},
            onFinish: () {},
          ),
          width: 320,
          height: 693,
          textScale: textScale,
        );

        final avatar = tester.getRect(
          find.byKey(const ValueKey('approved-benefits-avatar')),
        );
        final welcome = tester.getRect(find.textContaining('Welcome, Maya'));
        expect(welcome.top, greaterThan(avatar.bottom));
        expect(tester.takeException(), isNull);

        await pumpSurface(
          tester,
          ApprovedNoAccountHomePage(
            onStart: () {},
            onBuyer: () {},
            onSeller: () {},
          ),
          width: 320,
          height: 693,
          textScale: textScale,
        );

        expect(find.text('We Are The Better Option'), findsOneWidget);
        expect(tester.takeException(), isNull);

        await pumpSurface(
          tester,
          ApprovedBuyerHomePage(
            name: 'Maya',
            requestTitle: 'iPad Air 5, 256GB',
            requestPosted: true,
            onCreate: () {},
            onRequestDetails: () {},
            onOffers: () {},
            onRecentActivity: () {},
            onWallet: () {},
          ),
          width: 320,
          height: 693,
          textScale: textScale,
        );

        final earned = tester.getRect(
          find.byKey(const ValueKey('approved-total-rewards-card')),
        );
        final pending = tester.getRect(
          find.byKey(const ValueKey('approved-pending-rewards-card')),
        );
        expect(pending.top, greaterThan(earned.bottom));
        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('320x693 default dashboard preserves the approved composition', (
    tester,
  ) async {
    await pumpSurface(
      tester,
      ApprovedBuyerHomePage(
        name: 'Maya',
        requestTitle: 'iPad Air 5, 256GB',
        requestPosted: true,
        onCreate: () {},
        onRequestDetails: () {},
        onOffers: () {},
        onRecentActivity: () {},
        onWallet: () {},
      ),
      width: 320,
      height: 693,
      textScale: 1,
    );

    final earned = tester.getRect(
      find.byKey(const ValueKey('approved-total-rewards-card')),
    );
    final pending = tester.getRect(
      find.byKey(const ValueKey('approved-pending-rewards-card')),
    );
    final banner = tester.getRect(
      find.byKey(const ValueKey('approved-keep-earning-banner')),
    );
    final navigation = tester.getRect(
      find.byKey(const ValueKey('approved-bottom-navigation')),
    );

    expect((earned.top - pending.top).abs(), lessThan(1));
    expect(earned.height, closeTo(pending.height, 0.01));
    expect(earned.right, lessThan(pending.left));
    expect(earned.height, lessThanOrEqualTo(120));
    expect(pending.height, lessThanOrEqualTo(120));
    expect(
      earned.bottom -
          tester.getBottomRight(find.textContaining('View all rewards')).dy,
      lessThan(16),
    );
    expect(
      tester.getCenter(find.text('View offers  ›')).dx,
      greaterThan(tester.getCenter(find.text('iPad Air 5, 256GB')).dx),
    );
    expect(banner.bottom, lessThanOrEqualTo(navigation.top));
    expect(
      find.text('Keep earning more rewards').hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('320x693 dashboard remains resilient at 1.6 text scale', (
    tester,
  ) async {
    await pumpSurface(
      tester,
      ApprovedBuyerHomePage(
        name: 'Maya',
        requestTitle: 'iPad Air 5, 256GB',
        requestPosted: true,
        onCreate: () {},
        onRequestDetails: () {},
        onOffers: () {},
        onRecentActivity: () {},
        onWallet: () {},
      ),
      width: 320,
      height: 693,
      textScale: 1.6,
    );

    var earned = tester.getRect(
      find.byKey(const ValueKey('approved-total-rewards-card')),
    );
    var pending = tester.getRect(
      find.byKey(const ValueKey('approved-pending-rewards-card')),
    );
    expect(pending.top, greaterThan(earned.bottom));
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('approved-keep-earning-banner')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    earned = tester.getRect(
      find.byKey(const ValueKey('approved-total-rewards-card')),
    );
    pending = tester.getRect(
      find.byKey(const ValueKey('approved-pending-rewards-card')),
    );
    expect(pending.top, greaterThan(earned.bottom));
    expect(
      find.text('Keep earning more rewards').hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('390x844 account keeps every action in the first viewport', (
    tester,
  ) async {
    await pumpSurface(
      tester,
      ApprovedAccountCreationPage(
        role: ApprovedAccountRole.buyer,
        name: 'Maya Chen',
        onNameChanged: (_) {},
        onRoleChanged: (_) {},
        onClose: () {},
        onSignup: () {},
        onLogin: () {},
      ),
      width: 390,
      height: 844,
      textScale: 1,
    );

    expect(find.text('Continue with Facebook').hitTestable(), findsOneWidget);
    expect(tester.getBottomRight(find.text('Log in')).dy, lessThan(820));
    expect(find.text('Log in').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('390x844 keeps all Buyer benefits in one continuous page', (
    tester,
  ) async {
    await pumpSurface(
      tester,
      ApprovedBuyerBenefitsPage(
        name: 'Maya Chen',
        onClose: () {},
        onFinish: () {},
      ),
      width: 390,
      height: 844,
      textScale: 1,
    );

    expect(find.text('Earn rewards on every purchase'), findsOneWidget);
    expect(find.text('Mileage logic for less driving'), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Jump to dashboard'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Jump to dashboard').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('account and onboarding callbacks remain functional', (
    tester,
  ) async {
    var selectedRole = ApprovedAccountRole.buyer;
    var signupCount = 0;
    await pumpSurface(
      tester,
      ApprovedAccountCreationPage(
        role: ApprovedAccountRole.buyer,
        name: 'Jonathan',
        onNameChanged: (_) {},
        onRoleChanged: (role) => selectedRole = role,
        onClose: () {},
        onSignup: () => signupCount++,
        onLogin: () {},
      ),
      width: 390,
      textScale: 1,
    );

    await tester.tap(find.text('I am selling'));
    await tester.tap(find.text('Create account'));
    expect(selectedRole, ApprovedAccountRole.seller);
    expect(signupCount, 1);

    var finished = false;
    await pumpSurface(
      tester,
      ApprovedBuyerBenefitsPage(
        name: 'Jonathan',
        onClose: () {},
        onFinish: () => finished = true,
      ),
      width: 390,
      textScale: 1,
    );
    await tester.scrollUntilVisible(
      find.text('Jump to dashboard'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Jump to dashboard'));
    expect(finished, isTrue);
  });

  testWidgets('home and dashboard primary callbacks remain functional', (
    tester,
  ) async {
    var buyerCount = 0;
    await pumpSurface(
      tester,
      ApprovedNoAccountHomePage(
        onStart: () {},
        onBuyer: () => buyerCount++,
        onSeller: () {},
      ),
      width: 426,
      textScale: 1,
    );
    await tester.tap(
      find.bySemanticsLabel(
        'I am buying. Get paid to buy and get the best offers. Post a request.',
      ),
    );
    expect(buyerCount, 1);

    var createCount = 0;
    await pumpSurface(
      tester,
      ApprovedBuyerHomePage(
        name: 'Alex',
        requestTitle: 'iPad Air 5, 256GB',
        requestPosted: true,
        onCreate: () => createCount++,
        onRequestDetails: () {},
        onOffers: () {},
        onRecentActivity: () {},
        onWallet: () {},
      ),
      width: 426,
      textScale: 1,
    );
    await tester.tap(find.text('Post a new request'));
    expect(createCount, 1);
  });

  testWidgets(
    'signed-out home 426 rendered artifact after pubspec registration',
    (tester) async {
      await pumpSurface(
        tester,
        ApprovedNoAccountHomePage(
          onStart: () {},
          onBuyer: () {},
          onSeller: () {},
        ),
        width: 426,
        textScale: 1,
      );

      await expectLater(
        find.byType(ApprovedNoAccountHomePage),
        matchesGoldenFile(
          '../assets/approved_onboarding_home/rendered-no-account-home-426.png',
        ),
      );
    },
    skip: true,
  );
}
