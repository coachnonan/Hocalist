import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hocalist/features/approved/approved_replica_metrics.dart';
import 'package:hocalist/features/approved/trends_notifications_pages.dart';
import 'package:hocalist/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_fonts.dart';

const _writeProof = bool.fromEnvironment(
  'HOCALIST_WRITE_TRENDS_NOTIFICATIONS_PROOF',
);

class _ProjectFileAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

Future<void> _pumpApprovedSurface(
  WidgetTester tester,
  Widget child, {
  required double width,
  double textScale = 1,
  double height = 2600,
  GlobalKey? boundaryKey,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;

  final content = ColoredBox(
    color: HocalistTheme.background,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: KeyedSubtree(
        key: const ValueKey('approved-surface'),
        child: child,
      ),
    ),
  );

  await tester.pumpWidget(
    DefaultAssetBundle(
      bundle: _ProjectFileAssetBundle(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: HocalistTheme.light,
        builder: (context, appChild) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(textScaler: TextScaler.linear(textScale)),
            child: appChild ?? const SizedBox.shrink(),
          );
        },
        home: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: boundaryKey == null
                  ? content
                  : RepaintBoundary(key: boundaryKey, child: content),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadHocalistTestFonts);

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.clearAllTestValues();
  });

  testWidgets('approved pages inherit the actual app font family', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpApprovedSurface(
      tester,
      ApprovedHocatrendsPage(
        accent: HocalistTheme.actionBlue,
        onSeeSellers: () {},
      ),
      width: 390,
    );

    final saving = tester.widget<Text>(find.text('Saving'));
    expect(saving.style?.fontFamily, HocalistTheme.appFontFamily);
    expect(
      find.text('Skip the Rewards & save on current offers'),
      findsOneWidget,
    );
  });

  testWidgets('Hocatrends header logo override preserves normal defaults', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    HocalistGlobalHeader header({double? logoSlotReferenceWidth}) {
      return HocalistGlobalHeader(
        role: UserRole.buyer,
        accent: HocalistTheme.actionBlue,
        logoSlotReferenceWidth: logoSlotReferenceWidth,
        onNotifications: () {},
      );
    }

    await _pumpApprovedSurface(
      tester,
      header(logoSlotReferenceWidth: 89.0),
      width: 390,
      height: 160,
    );
    expect(
      tester
          .getSize(
            find.byKey(const ValueKey('hocalist-global-header-logo-slot')),
          )
          .width,
      closeTo(89, 0.001),
    );

    await _pumpApprovedSurface(
      tester,
      header(logoSlotReferenceWidth: 89.0),
      width: 320,
      height: 160,
    );
    final narrowLogoSize = tester.getSize(
      find.byKey(const ValueKey('hocalist-global-header-logo-slot')),
    );
    expect(narrowLogoSize.width, closeTo(89 * 320 / 390, 0.001));
    expect(narrowLogoSize.height, 62);

    await _pumpApprovedSurface(tester, header(), width: 390, height: 160);
    final defaultLogoSize = tester.getSize(
      find.byKey(const ValueKey('hocalist-global-header-logo-slot')),
    );
    expect(defaultLogoSize.width, 138);
    expect(defaultLogoSize.height, 62);

    await _pumpApprovedSurface(
      tester,
      header(logoSlotReferenceWidth: 89.0),
      width: 600,
      height: 160,
    );
    expect(
      tester
          .getSize(
            find.byKey(const ValueKey('hocalist-global-header-logo-slot')),
          )
          .width,
      89,
    );

    await _pumpApprovedSurface(tester, header(), width: 600, height: 160);
    final defaultTabletLogoSize = tester.getSize(
      find.byKey(const ValueKey('hocalist-global-header-logo-slot')),
    );
    expect(defaultTabletLogoSize.width, 126);
    expect(defaultTabletLogoSize.height, 60);
  });

  testWidgets('global buyer navigation matches approved replica geometry', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> pumpSignedIn({
      required String role,
      required String page,
      required double width,
      required double height,
    }) async {
      SharedPreferences.setMockInitialValues({
        'hocalist.hasSession': true,
        'hocalist.role': role,
        'hocalist.page': page,
      });
      tester.view.physicalSize = Size(width, height);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(HocalistPrototype(key: UniqueKey()));
      await tester.pumpAndSettle();
    }

    const buyerNavKey = ValueKey('global-buyer-bottom-navigation');
    const buyerNavContentKey = ValueKey(
      'global-buyer-bottom-navigation-content',
    );
    const trendsHeaderContentKey = ValueKey('hocatrends-global-header-content');

    await pumpSignedIn(
      role: 'buyer',
      page: 'hocatrends',
      width: 390,
      height: 844,
    );
    expect(find.byKey(buyerNavKey), findsOneWidget);
    expect(tester.getSize(find.byKey(buyerNavKey)).height, closeTo(55, 0.01));
    expect(find.text('See Sellers'), findsNWidgets(5));
    expect(
      tester
          .getBottomLeft(find.byKey(const ValueKey('approved-trend-card-5')))
          .dy,
      lessThanOrEqualTo(tester.getTopLeft(find.byKey(buyerNavKey)).dy),
    );
    expect(tester.takeException(), isNull);

    await pumpSignedIn(
      role: 'buyer',
      page: 'hocatrends',
      width: 320,
      height: 693,
    );
    expect(
      tester.getSize(find.byKey(buyerNavKey)).height,
      closeTo(55 * 320 / 390, 0.01),
    );
    expect(tester.getSize(find.byKey(buyerNavContentKey)).width, 320);
    expect(tester.takeException(), isNull);

    await pumpSignedIn(
      role: 'buyer',
      page: 'hocatrends',
      width: 600,
      height: 1000,
    );
    expect(tester.getSize(find.byKey(buyerNavKey)).height, closeTo(55, 0.01));
    expect(tester.getSize(find.byKey(buyerNavContentKey)).width, 390);
    expect(tester.getCenter(find.byKey(buyerNavContentKey)).dx, 300);
    expect(tester.getSize(find.byKey(trendsHeaderContentKey)).width, 390);
    expect(tester.getCenter(find.byKey(trendsHeaderContentKey)).dx, 300);
    expect(tester.takeException(), isNull);

    await pumpSignedIn(
      role: 'buyer',
      page: 'hocatrends',
      width: 768,
      height: 1024,
    );
    expect(tester.getSize(find.byKey(trendsHeaderContentKey)).width, 390);
    expect(tester.getCenter(find.byKey(trendsHeaderContentKey)).dx, 384);
    expect(tester.takeException(), isNull);

    await pumpSignedIn(
      role: 'seller',
      page: 'sellerDashboard',
      width: 390,
      height: 844,
    );
    final sellerNavigation = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(sellerNavigation.height, 72);
    expect(find.byKey(buyerNavKey), findsNothing);
    expect(find.byKey(trendsHeaderContentKey), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('390 layouts match approved vertical density', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpApprovedSurface(
      tester,
      ApprovedHocatrendsPage(
        accent: HocalistTheme.actionBlue,
        onSeeSellers: () {},
      ),
      width: 390,
      height: 844,
    );

    expect(find.text('See Sellers'), findsNWidgets(5));
    expect(
      tester
          .getSize(find.byKey(const ValueKey('approved-trend-card-1')))
          .height,
      inInclusiveRange(83, 85),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('approved-surface'))).height,
      lessThan(710),
    );
    expect(
      tester.getBottomRight(find.text('See Sellers').last).dy,
      lessThan(800),
    );
    expect(tester.widget<Text>(find.text('Saving')).style?.fontSize, 20);
    expect(tester.takeException(), isNull);

    await _pumpApprovedSurface(
      tester,
      ApprovedBuyerNotificationsPage(onBack: () {}),
      width: 390,
      height: 844,
    );

    expect(find.text('Rewards will be paid on May 13'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('approved-surface'))).height,
      lessThan(710),
    );
    expect(
      tester.getBottomRight(find.text('Rewards will be paid on May 13')).dy,
      lessThan(800),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('default replica metrics hold across phone and tablet widths', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final scales = <double, double>{
      320: ApprovedReplicaMetrics.narrowScale,
      360: ApprovedReplicaMetrics.compactScale,
      390: 1,
      430: 1,
      600: 1,
      768: 1,
      1024: 1,
    };

    for (final entry in scales.entries) {
      final width = entry.key;
      final expectedScale = entry.value;
      await _pumpApprovedSurface(
        tester,
        ApprovedHocatrendsPage(
          accent: HocalistTheme.actionBlue,
          onSeeSellers: () {},
        ),
        width: width,
      );
      expect(
        tester.widget<Text>(find.text('Saving')).style?.fontSize,
        closeTo(20 * expectedScale, 0.001),
      );
      expect(
        tester.widget<Text>(find.text('Saving')).style?.fontWeight,
        FontWeight.w800,
      );
      expect(
        (tester.getTopLeft(find.text('Saving')).dy -
                tester.getTopLeft(find.text('Opportunities')).dy)
            .abs(),
        lessThan(2),
      );
      if (width == 320) {
        expect(
          tester
              .getSize(find.byKey(const ValueKey('approved-trend-card-1')))
              .height,
          inInclusiveRange(68, 70),
        );
      }
      if (width >= 430) {
        expect(
          tester
              .getSize(find.byKey(const ValueKey('approved-replica-content')))
              .width,
          closeTo(390, 0.001),
        );
      }
      expect(
        tester.takeException(),
        isNull,
        reason: 'Hocatrends at $width logical pixels',
      );

      await _pumpApprovedSurface(
        tester,
        ApprovedHocatrendsPickedSellersPage(onBack: () {}, onChatSeller: () {}),
        width: width,
        height: 3200,
      );
      expect(
        tester.widget<Text>(find.text('Northside Tech')).style?.fontSize,
        closeTo(16 * expectedScale, 0.001),
      );
      expect(
        tester.widget<Text>(find.text('Northside Tech')).style?.fontWeight,
        FontWeight.w800,
      );
      final controlsY = <double>[
        tester.getCenter(find.text('Filters')).dy,
        tester.getCenter(find.text('Sort by: Best deal')).dy,
        tester.getCenter(find.byTooltip('List view')).dy,
      ];
      expect(
        controlsY.reduce((a, b) => a > b ? a : b) -
            controlsY.reduce((a, b) => a < b ? a : b),
        lessThan(3),
      );
      if (width >= 430) {
        expect(
          tester
              .getSize(find.byKey(const ValueKey('approved-replica-content')))
              .width,
          closeTo(390, 0.001),
        );
      }
      expect(
        tester.takeException(),
        isNull,
        reason: 'picked sellers at $width logical pixels',
      );

      await _pumpApprovedSurface(
        tester,
        ApprovedBuyerNotificationsPage(onBack: () {}),
        width: width,
      );
      expect(
        tester.widget<Text>(find.text('Recent activity')).style?.fontSize,
        closeTo(16 * expectedScale, 0.001),
      );
      expect(
        tester.widget<Text>(find.text('Recent activity')).style?.fontWeight,
        FontWeight.w800,
      );
      expect(
        (tester.getCenter(find.text('All')).dy -
                tester.getCenter(find.text('Payouts')).dy)
            .abs(),
        lessThan(2),
      );
      if (width >= 430) {
        expect(
          tester
              .getSize(find.byKey(const ValueKey('approved-replica-content')))
              .width,
          closeTo(390, 0.001),
        );
      }
      expect(
        tester.takeException(),
        isNull,
        reason: 'buyer notifications at $width logical pixels',
      );
    }
  });

  testWidgets('320 default keeps the approved compact composition', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpApprovedSurface(
      tester,
      ApprovedHocatrendsPage(
        accent: HocalistTheme.actionBlue,
        onSeeSellers: () {},
      ),
      width: 320,
      height: 693,
    );

    expect(find.text('See Sellers'), findsNWidgets(5));
    expect(
      (tester.getTopLeft(find.text('Saving')).dy -
              tester.getTopLeft(find.text('Opportunities')).dy)
          .abs(),
      lessThan(2),
    );
    for (final button in find.text('See Sellers').evaluate()) {
      expect(tester.getSize(find.byWidget(button.widget)).height, lessThan(20));
    }
    expect(
      tester.getBottomRight(find.text('See Sellers').last).dy,
      lessThan(650),
    );
    expect(tester.takeException(), isNull);

    await _pumpApprovedSurface(
      tester,
      ApprovedHocatrendsPickedSellersPage(onBack: () {}, onChatSeller: () {}),
      width: 320,
      height: 693,
    );

    expect(find.text('Chat Seller'), findsNWidgets(5));
    expect(find.text('Digital Depot'), findsOneWidget);
    final controlsY = <double>[
      tester.getCenter(find.text('Filters')).dy,
      tester.getCenter(find.text('Sort by: Best deal')).dy,
      tester.getCenter(find.byTooltip('List view')).dy,
    ];
    expect(
      controlsY.reduce((a, b) => a > b ? a : b) -
          controlsY.reduce((a, b) => a < b ? a : b),
      lessThan(3),
    );
    expect(
      tester.getCenter(find.text('Chat Seller').first).dy -
          tester.getCenter(find.text('Northside Tech')).dy,
      lessThanOrEqualTo(34),
    );
    expect(tester.takeException(), isNull);

    await _pumpApprovedSurface(
      tester,
      ApprovedBuyerNotificationsPage(onBack: () {}),
      width: 320,
      height: 693,
    );

    expect(find.text('Payouts'), findsOneWidget);
    expect(
      (tester.getCenter(find.text('All')).dy -
              tester.getCenter(find.text('Payouts')).dy)
          .abs(),
      lessThan(2),
    );
    expect(tester.getTopRight(find.text('Payouts')).dx, lessThan(304));
    expect(find.text('Rewards will be paid on May 13'), findsOneWidget);
    expect(
      tester.getBottomRight(find.text('Rewards will be paid on May 13')).dy,
      lessThan(650),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Large XL and external text scales reflow without overflow', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final pages = <Widget>[
      ApprovedHocatrendsPage(
        accent: HocalistTheme.actionBlue,
        onSeeSellers: () {},
      ),
      ApprovedHocatrendsPickedSellersPage(onBack: () {}, onChatSeller: () {}),
      ApprovedBuyerNotificationsPage(onBack: () {}),
    ];

    final cases = <({double width, double scale, String label})>[
      (width: 320, scale: 1.15, label: 'Large narrow'),
      (width: 320, scale: 1.3, label: 'XL narrow'),
      (width: 390, scale: 1.15, label: 'Large reference'),
      (width: 390, scale: 1.3, label: 'XL reference'),
      (width: 360, scale: 1.6, label: 'external 1.6'),
    ];

    for (final testCase in cases) {
      for (final page in pages) {
        await _pumpApprovedSurface(
          tester,
          page,
          width: testCase.width,
          height: 6000,
          textScale: testCase.scale,
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '${page.runtimeType} at ${testCase.label}',
        );
      }
    }
  });

  testWidgets('approved callbacks and filters preserve current behavior', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var seeSellers = 0;
    await _pumpApprovedSurface(
      tester,
      ApprovedHocatrendsPage(
        accent: HocalistTheme.actionBlue,
        onSeeSellers: () => seeSellers++,
      ),
      width: 390,
    );
    await tester.tap(find.text('See Sellers').first);
    await tester.pump();
    expect(seeSellers, 1);

    var back = 0;
    var chat = 0;
    await _pumpApprovedSurface(
      tester,
      ApprovedHocatrendsPickedSellersPage(
        onBack: () => back++,
        onChatSeller: () => chat++,
      ),
      width: 390,
      height: 3200,
    );
    await tester.tap(find.byTooltip('Back to Hocatrends'));
    await tester.tap(find.text('Chat Seller').first);
    await tester.tap(find.text('Filters'));
    await tester.pump();
    expect(back, 1);
    expect(chat, 1);
    expect(find.text('Verified sellers'), findsOneWidget);

    await _pumpApprovedSurface(
      tester,
      ApprovedBuyerNotificationsPage(onBack: () => back++),
      width: 390,
    );
    await tester.tap(find.byTooltip('Back to home'));
    await tester.tap(find.text('Reviews'));
    await tester.pump();
    expect(back, 2);
    expect(find.text('You earned a new review'), findsNWidgets(2));
    expect(find.text('Northside Tech sent you a new offer'), findsNothing);
  });

  testWidgets('write approved page proof renders', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final output = Directory(
      '${Directory.systemTemp.path}\\hocalist-trends-notifications-proof',
    );
    await output.create(recursive: true);

    final pages = <String, Widget>{
      'hocatrends-render.png': ApprovedHocatrendsPage(
        accent: HocalistTheme.actionBlue,
        onSeeSellers: () {},
      ),
      'picked-sellers-render.png': ApprovedHocatrendsPickedSellersPage(
        onBack: () {},
        onChatSeller: () {},
      ),
      'buyer-notifications-render.png': ApprovedBuyerNotificationsPage(
        onBack: () {},
      ),
    };

    for (final entry in pages.entries) {
      final boundaryKey = GlobalKey();
      await _pumpApprovedSurface(
        tester,
        entry.value,
        width: 426,
        height: 2800,
        boundaryKey: boundaryKey,
      );
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await File(
        '${output.path}\\${entry.key}',
      ).writeAsBytes(bytes!.buffer.asUint8List());
    }
  }, skip: !_writeProof);
}
