import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hocalist/features/approved/approved_replica_metrics.dart';
import 'package:hocalist/features/approved/offers_chat_pages.dart';

import 'test_fonts.dart';

final _captureKey = GlobalKey();
final _assetBundle = _WorkspaceAssetBundle();
const _writeOffersChatProof = bool.fromEnvironment(
  'HOCALIST_WRITE_OFFERS_CHAT_PROOF',
);

class _WorkspaceAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) {
    final bytes = File(key).readAsBytesSync();
    return SynchronousFuture(ByteData.sublistView(Uint8List.fromList(bytes)));
  }
}

class _Calls {
  int back = 0;
  int notifications = 0;
  int viewOffer = 0;
  int chat = 0;
  int filter = 0;
  int select = 0;
  int profile = 0;
  int primary = 0;
  int call = 0;
  int more = 0;
  int requestChange = 0;
  int changeLocation = 0;
  int attach = 0;
  int learnMore = 0;
  String? sent;

  late final navigation = ApprovedBuyerNavigation(
    onHome: () {},
    onHocatrends: () {},
    onOffers: () {},
    onChats: () {},
    onMore: () {},
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(loadHocalistTestFonts);

  tearDown(() {
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.clearAllTestValues();
  });

  group('approved offers and chat responsive proof', () {
    const defaultViewports = <(double, double)>[
      (320, 693),
      (360, 800),
      (390, 844),
      (430, 844),
      (600, 900),
      (768, 1024),
      (1024, 1366),
    ];
    for (final viewport in defaultViewports) {
      testWidgets('${viewport.$1.toInt()}x${viewport.$2.toInt()} fits', (
        tester,
      ) async {
        final calls = _Calls();
        for (final page in _pages(calls)) {
          await _pumpPage(
            tester,
            page,
            width: viewport.$1,
            height: viewport.$2,
            textScale: 1,
          );
          expect(tester.takeException(), isNull, reason: '$page at $viewport');
          _expectReplicaWidth(tester, viewport.$1);
        }
      });
    }

    testWidgets('320 default preserves approved horizontal composition', (
      tester,
    ) async {
      final calls = _Calls();

      await _pumpPage(tester, _offers(calls), width: 320, height: 693);
      _expectSameRow(tester, 'Northside Tech', '\$420');
      _expectSameRow(tester, 'Verified', '1.2 mi away');
      _expectSameRow(tester, 'View offer details', 'Chat after selection');
      _expectNoTruncatedText(tester);

      await _pumpPage(tester, _viewOffer(calls), width: 320, height: 693);
      _expectSameRow(tester, 'Identity verified', '1.2 mi away');
      _expectSameRow(tester, 'You have 7 days left', 'Est. rewards');
      _expectSameRow(
        tester,
        'Seller PIN for your rewards',
        '15230',
        tolerance: 32,
      );
      await _assertReachable(tester, const Key('approved-view-profile'));
      _expectSameRow(tester, 'About the Seller', 'View profile', tolerance: 24);
      _expectNoTruncatedText(tester);

      await _pumpPage(tester, _chat(calls), width: 320, height: 693);
      _expectSameRow(tester, 'John D.', 'Verified Seller');
      _expectSameRow(tester, 'Seller\'s Final Offer', 'Tap to close details');
      _expectSameRow(tester, 'Price', 'Pickup Location');
      _expectSameRow(tester, 'Request Change', 'Change Location');
      await _assertReachable(tester, const Key('approved-safety-learn-more'));
      _expectSameRow(
        tester,
        'Always be safe, meet in public crowded places with the person you expect.',
        'Learn more',
      );
      _expectNoTruncatedText(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('320 offers retain the approved scaled vertical density', (
      tester,
    ) async {
      final calls = _Calls();

      await _pumpPage(tester, _offers(calls), width: 390, height: 844);
      final referenceCard = tester.getRect(
        find.byKey(const Key('approved-offer-card-LR')),
      );
      final referenceNotice = tester.getRect(
        find.byKey(const Key('approved-secure-private-notice')),
      );

      await _pumpPage(tester, _offers(calls), width: 320, height: 693);
      final narrowCard = tester.getRect(
        find.byKey(const Key('approved-offer-card-LR')),
      );
      final narrowNotice = tester.getRect(
        find.byKey(const Key('approved-secure-private-notice')),
      );

      expect(
        narrowCard.height,
        closeTo(referenceCard.height * ApprovedReplicaMetrics.narrowScale, 1),
      );
      expect(
        narrowNotice.top,
        closeTo(referenceNotice.top * ApprovedReplicaMetrics.narrowScale, 2),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'owned buyer navigation matches global height without overlap',
      (tester) async {
        final calls = _Calls();
        final cases = <(double, double, double)>[
          (320, 693, 55 * ApprovedReplicaMetrics.narrowScale),
          (390, 844, 55),
          (600, 900, 55),
        ];
        final pages = <(Widget Function(), Key)>[
          (() => _offers(calls), const Key('approved-secure-private-notice')),
          (() => _viewOffer(calls), const Key('approved-select-seller')),
          (() => _chat(calls), const Key('approved-chat-message')),
        ];

        for (final dimensions in cases) {
          for (final page in pages) {
            await _pumpPage(
              tester,
              page.$1(),
              width: dimensions.$1,
              height: dimensions.$2,
            );
            final navigation = tester.getRect(
              find.byKey(const Key('approved-bottom-navigation')),
            );
            final finalContent = tester.getRect(find.byKey(page.$2));

            expect(navigation.height, closeTo(dimensions.$3, 0.1));
            expect(
              navigation.top - finalContent.bottom,
              greaterThanOrEqualTo(0),
              reason: '${page.$2} must not overlap navigation at $dimensions',
            );
            expect(tester.takeException(), isNull);
          }
        }
      },
    );

    testWidgets('chat messages keep approved default vertical rhythm', (
      tester,
    ) async {
      final calls = _Calls();

      await _pumpPage(tester, _chat(calls), width: 390, height: 844);
      final firstIncoming = tester.getRect(
        find.byKey(const Key('approved-chat-message-incoming-1')),
      );
      final outgoing = tester.getRect(
        find.byKey(const Key('approved-chat-message-outgoing-1')),
      );
      final secondIncoming = tester.getRect(
        find.byKey(const Key('approved-chat-message-incoming-2')),
      );
      final composer = tester.getRect(
        find.byKey(const Key('approved-chat-message')),
      );
      final safety = tester.getRect(
        find.byKey(const Key('approved-chat-safety-notice')),
      );
      final navigation = tester.getRect(
        find.byKey(const Key('approved-nav-home')),
      );
      final lockedSpacer = tester.getSize(
        find.byKey(const Key('approved-chat-locked-lower-spacer')),
      );
      expect(outgoing.top - firstIncoming.bottom, closeTo(6, 0.5));
      expect(secondIncoming.top - outgoing.bottom, closeTo(6, 0.5));
      expect(lockedSpacer.height, 18);
      expect(composer.top - safety.bottom, closeTo(8, 0.5));
      expect(navigation.top - composer.bottom, inInclusiveRange(8, 24));
      expect(navigation.top - safety.bottom, greaterThan(0));
      expect(tester.takeException(), isNull);

      await _pumpPage(tester, _chat(calls), width: 320, height: 693);
      final narrowFirst = tester.getRect(
        find.byKey(const Key('approved-chat-message-incoming-1')),
      );
      final narrowOutgoing = tester.getRect(
        find.byKey(const Key('approved-chat-message-outgoing-1')),
      );
      final narrowSecond = tester.getRect(
        find.byKey(const Key('approved-chat-message-incoming-2')),
      );
      final scaledGap = 6 * ApprovedReplicaMetrics.narrowScale;

      expect(narrowOutgoing.top - narrowFirst.bottom, closeTo(scaledGap, 1));
      expect(narrowSecond.top - narrowOutgoing.bottom, closeTo(scaledGap, 1));
      expect(
        tester
            .getRect(find.byKey(const Key('approved-chat-locked-lower-spacer')))
            .height,
        closeTo(18 * ApprovedReplicaMetrics.narrowScale, 1),
      );
      expect(tester.takeException(), isNull);

      await _pumpPage(
        tester,
        _chat(calls),
        width: 390,
        height: 844,
        textScale: 1.6,
      );
      await _assertReachable(tester, const Key('approved-chat-message'));
      expect(
        tester
            .getSize(find.byKey(const Key('approved-chat-locked-lower-spacer')))
            .height,
        0,
      );
      expect(tester.takeException(), isNull);
    });

    for (final scale in [1.3, 1.6, 2.0]) {
      testWidgets('all pages preserve actions at 320 and $scale text scale', (
        tester,
      ) async {
        final calls = _Calls();

        await _pumpPage(
          tester,
          _offers(calls),
          width: 320,
          height: 693,
          textScale: scale,
        );
        await _assertReachable(tester, const Key('approved-view-offer-NT'));
        await _assertReachable(tester, const Key('approved-chat-after-LR'));

        await _pumpPage(
          tester,
          _viewOffer(calls),
          width: 320,
          height: 693,
          textScale: scale,
        );
        await _assertReachable(tester, const Key('approved-view-profile'));
        await _assertReachable(tester, const Key('approved-select-seller'));

        await _pumpPage(
          tester,
          _chat(calls),
          width: 320,
          height: 693,
          textScale: scale,
        );
        await _assertReachable(tester, const Key('approved-request-change'));
        await _assertReachable(tester, const Key('approved-change-location'));
        await _assertReachable(tester, const Key('approved-chat-send'));
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('XL text remains operable on a centered tablet surface', (
      tester,
    ) async {
      final calls = _Calls();
      for (final page in _pages(calls)) {
        await _pumpPage(tester, page, width: 768, height: 1024, textScale: 2);
        expect(tester.takeException(), isNull);
        expect(
          tester
              .getSize(find.byKey(const Key('approved-replica-viewport')))
              .width,
          430,
        );
      }
    });
  });

  testWidgets('approved offer callbacks preserve the current route behavior', (
    tester,
  ) async {
    final calls = _Calls();

    await _pumpPage(tester, _offers(calls), width: 390);
    await _tapReachable(tester, const Key('approved-notifications'));
    await _tapReachable(tester, const Key('approved-offers-filter'));
    await _tapReachable(tester, const Key('approved-view-offer-NT'));
    await _tapReachable(tester, const Key('approved-chat-after-NT'));
    expect(calls.notifications, 1);
    expect(calls.filter, 1);
    expect(calls.viewOffer, 1);
    expect(calls.chat, 1);

    await _pumpPage(tester, _viewOffer(calls), width: 390);
    await _tapReachable(tester, const Key('approved-view-profile'));
    await _tapReachable(tester, const Key('approved-select-seller'));
    expect(calls.profile, 1);
    expect(calls.select, 1);

    await _pumpPage(tester, _chat(calls), width: 390);
    await _tapReachable(tester, const Key('approved-call-seller'));
    await _tapReachable(tester, const Key('approved-chat-more'));
    await _tapReachable(tester, const Key('approved-request-change'));
    await _tapReachable(tester, const Key('approved-change-location'));
    await _tapReachable(tester, const Key('approved-accept-to-meet'));
    await _tapReachable(tester, const Key('approved-chat-attach'));
    await tester.enterText(
      find.byKey(const Key('approved-chat-message')),
      'Meet in the public lobby.',
    );
    await _tapReachable(tester, const Key('approved-chat-send'));
    expect(calls.call, 1);
    expect(calls.more, 1);
    expect(calls.requestChange, 1);
    expect(calls.changeLocation, 1);
    expect(calls.primary, 1);
    expect(calls.attach, 1);
    expect(calls.sent, 'Meet in the public lobby.');
  });

  testWidgets('offers dashboard uses its approved isolated accent', (
    tester,
  ) async {
    const offersAccent = Color(0xff0f0b7a);
    const detailAndChatAccent = Color(0xff1117e8);
    final calls = _Calls();

    await _pumpPage(tester, _offers(calls), width: 390, height: 844);
    expect(_textColor(tester, '\$0.40'), offersAccent);
    expect(_textColor(tester, '\$420'), offersAccent);
    expect(_textColor(tester, 'Offers'), offersAccent);
    expect(
      _filledButtonColor(tester, const Key('approved-view-offer-NT')),
      offersAccent,
    );

    await _pumpPage(tester, _viewOffer(calls), width: 390, height: 844);
    expect(_textColor(tester, 'Offers'), detailAndChatAccent);
    expect(_textColor(tester, '15230'), detailAndChatAccent);
    expect(
      _filledButtonColor(tester, const Key('approved-select-seller')),
      detailAndChatAccent,
    );

    await _pumpPage(tester, _chat(calls), width: 390, height: 844);
    expect(_textColor(tester, 'Chats'), detailAndChatAccent);
    expect(
      _filledButtonColor(tester, const Key('approved-accept-to-meet')),
      detailAndChatAccent,
    );
  });

  testWidgets('captures actual-font comparison renders', (tester) async {
    final calls = _Calls();
    final captures = <String, Widget>{
      'actual-offers-426.png': _offers(calls),
      'actual-view-offer-426.png': _viewOffer(calls),
      'actual-chat-426.png': _chat(calls),
    };

    for (final entry in captures.entries) {
      await _pumpPage(tester, entry.value, width: 426, height: 900);
      expect(
        find.byType(Image),
        findsWidgets,
        reason: '${entry.key} must render decoded approved rasters',
      );
      await expectLater(
        find.byKey(_captureKey),
        matchesGoldenFile('../assets/approved_offers_chat/${entry.key}'),
      );
    }
  }, skip: !_writeOffersChatProof);
}

List<Widget> _pages(_Calls calls) => [
  _offers(calls),
  _viewOffer(calls),
  _chat(calls),
];

Widget _offers(_Calls calls) {
  return ApprovedOffersReceivedPage(
    onBack: () => calls.back++,
    onNotifications: () => calls.notifications++,
    onViewOffer: () => calls.viewOffer++,
    onChat: () => calls.chat++,
    onFilter: () => calls.filter++,
    navigation: calls.navigation,
  );
}

Widget _viewOffer(_Calls calls) {
  return ApprovedViewOfferPage(
    onBack: () => calls.back++,
    onNotifications: () => calls.notifications++,
    onSelectSeller: () => calls.select++,
    onViewProfile: () => calls.profile++,
    navigation: calls.navigation,
  );
}

Widget _chat(_Calls calls) {
  return ApprovedBuyerChatPage(
    onBack: () => calls.back++,
    onPrimary: () => calls.primary++,
    onCall: () => calls.call++,
    onMore: () => calls.more++,
    onRequestChange: () => calls.requestChange++,
    onChangeLocation: () => calls.changeLocation++,
    onAttach: () => calls.attach++,
    onSend: (text) => calls.sent = text,
    onLearnMore: () => calls.learnMore++,
    navigation: calls.navigation,
  );
}

Future<void> _pumpPage(
  WidgetTester tester,
  Widget page, {
  required double width,
  double height = 824,
  double textScale = 1,
}) async {
  final binding = TestWidgetsFlutterBinding.instance;
  binding.platformDispatcher.views.first.physicalSize = Size(width, height);
  binding.platformDispatcher.views.first.devicePixelRatio = 1;

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff080b62)),
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.white,
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return DefaultAssetBundle(
          bundle: _assetBundle,
          child: MediaQuery(
            data: media.copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
        );
      },
      home: RepaintBoundary(key: _captureKey, child: page),
    ),
  );
  await tester.pumpAndSettle();
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 80)),
  );
  await tester.pumpAndSettle();
}

Future<void> _assertReachable(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      280,
      scrollable: find.byType(Scrollable).first,
    );
  }
  expect(finder, findsOneWidget);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull, reason: '$key must remain reachable');
}

Future<void> _tapReachable(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      280,
      scrollable: find.byType(Scrollable).first,
    );
  }
  expect(finder, findsOneWidget);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();
}

void _expectSameRow(
  WidgetTester tester,
  String left,
  String right, {
  double tolerance = 18,
}) {
  final leftMatches = find.text(left);
  final rightMatches = find.text(right);
  expect(leftMatches, findsWidgets);
  expect(rightMatches, findsWidgets);
  final leftFinder = leftMatches.first;
  final rightFinder = rightMatches.first;
  expect(
    (tester.getCenter(leftFinder).dy - tester.getCenter(rightFinder).dy).abs(),
    lessThanOrEqualTo(tolerance),
    reason: '"$left" and "$right" must keep the approved horizontal row',
  );
}

void _expectNoTruncatedText(WidgetTester tester) {
  for (final element in find.byType(RichText).evaluate()) {
    final renderObject = element.renderObject;
    if (renderObject is RenderParagraph) {
      expect(
        renderObject.didExceedMaxLines,
        isFalse,
        reason: '320 default must not truncate rendered text',
      );
    }
  }
}

void _expectReplicaWidth(WidgetTester tester, double viewportWidth) {
  final rect = tester.getRect(
    find.byKey(const Key('approved-replica-viewport')),
  );
  final expectedWidth = viewportWidth.clamp(
    0,
    ApprovedReplicaMetrics.referenceCanvasWidth,
  );
  expect(rect.width, closeTo(expectedWidth, 0.01));
  expect(rect.center.dx, closeTo(viewportWidth / 2, 0.01));
}

Color? _textColor(WidgetTester tester, String value) {
  return tester.widget<Text>(find.text(value)).style?.color;
}

Color? _filledButtonColor(WidgetTester tester, Key key) {
  final button = tester.widget<FilledButton>(
    find.descendant(of: find.byKey(key), matching: find.byType(FilledButton)),
  );
  return button.style?.backgroundColor?.resolve(const <WidgetState>{});
}
