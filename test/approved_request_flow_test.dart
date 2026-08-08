import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hocalist/features/approved/request_flow_pages.dart';

import 'test_fonts.dart';

const _proofHeight = 844.0;
const _compactProofHeight = 693.0;
const _captureKey = Key('approved-request-capture');
const _writeRequestFlowProof = bool.fromEnvironment(
  'HOCALIST_WRITE_REQUEST_FLOW_PROOF',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(loadHocalistTestFonts);

  for (final width in <double>[320, 360, 390, 430, 600, 768, 1024]) {
    testWidgets('approved request states fit ${width.toInt()} logical pixels', (
      tester,
    ) async {
      for (final state in _ProofState.values) {
        await _pumpState(
          tester,
          state: state,
          width: width,
          height: width == 320 ? _compactProofHeight : _proofHeight,
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '${state.name} overflowed at ${width.toInt()}px',
        );
      }
    });
  }

  testWidgets('Medium uses discrete replica scaling and centered 390 canvas', (
    tester,
  ) async {
    await _pumpState(tester, state: _ProofState.product, width: 390);
    final referenceTitle = tester.widget<Text>(find.text('Post a new request'));
    final referenceKind = _ancestorRect(
      tester,
      find.text('Product'),
      '_ApprovedKindCard',
    )!;
    final referenceContinue = tester.getRect(
      find.ancestor(
        of: find.text('Continue'),
        matching: find.byType(FilledButton),
      ),
    );

    for (final width in <double>[320, 360]) {
      await _pumpState(
        tester,
        state: _ProofState.product,
        width: width,
        height: width == 320 ? _compactProofHeight : _proofHeight,
      );
      final scale = width / 390;
      final title = tester.widget<Text>(find.text('Post a new request'));
      final kind = _ancestorRect(
        tester,
        find.text('Product'),
        '_ApprovedKindCard',
      )!;
      final continueRect = tester.getRect(
        find.ancestor(
          of: find.text('Continue'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(
        title.style!.fontSize,
        closeTo(referenceTitle.style!.fontSize! * scale, 0.01),
      );
      expect(kind.height, closeTo(referenceKind.height * scale, 0.1));
      expect(
        continueRect.height,
        closeTo(referenceContinue.height * scale, 0.1),
      );
      expect(tester.takeException(), isNull);
    }

    for (final width in <double>[430, 600, 768, 1024]) {
      await _pumpState(tester, state: _ProofState.product, width: width);
      final kind = _ancestorRect(
        tester,
        find.text('Product'),
        '_ApprovedKindCard',
      )!;
      expect(kind.width, closeTo(referenceKind.width, 0.1));
      expect(kind.left, closeTo(referenceKind.left + (width - 390) / 2, 0.1));
      expect(
        tester.getCenter(find.text('Post a new request')).dx,
        closeTo(width / 2, 0.1),
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('320px default preserves approved single-row composition', (
    tester,
  ) async {
    await _pumpState(
      tester,
      state: _ProofState.product,
      width: 320,
      height: _compactProofHeight,
    );
    _expectSameRow(tester, 'Product', 'Service');
    _expectSameRow(tester, 'Condition', 'Budget');
    _expectSameRow(tester, 'Quantity', 'Willing to receive higher offers?');
    _expectSameRow(tester, 'Back', 'Continue');
    _expectSingleRenderedLine(tester, 'Post a new request');
    _expectSingleRenderedLine(tester, 'I want to buy a product');
    _expectSingleRenderedLine(tester, 'I need a service');
    _expectSingleRenderedLine(
      tester,
      'Tell us more about the product you need',
    );
    final continueButton = find.ancestor(
      of: find.text('Continue'),
      matching: find.byType(FilledButton),
    );
    final continueBottom = tester.getRect(continueButton).bottom;
    expect(
      continueBottom,
      inInclusiveRange(595, 625),
      reason:
          'The approved 320px source places Continue near the navigation after '
          'allowing for status-bar chrome; actual bottom: $continueBottom.',
    );
    expect(find.text('Continue').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _pumpState(
      tester,
      state: _ProofState.service,
      width: 320,
      height: _compactProofHeight,
    );
    _expectSameRow(tester, 'Service Type', 'Budget');
    _expectSameRow(tester, 'Category', 'Willing to receive higher offers?');
    _expectSingleRenderedLine(
      tester,
      'Tell us more about the service you need',
    );
    expect(find.text('Continue').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _pumpState(
      tester,
      state: _ProofState.location,
      width: 320,
      height: _compactProofHeight,
    );
    _expectSameRow(tester, 'City', 'State');
    _expectSameRow(tester, 'Country', 'ZIP code');
    _expectSameRow(tester, 'Back', 'Post request');
    expect(find.text('Post request').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _pumpState(
      tester,
      state: _ProofState.details,
      width: 320,
      height: _compactProofHeight,
    );
    _expectSameRow(tester, 'Condition', 'Budget (optional)');
    _expectSameRow(tester, 'Quantity', 'Willing to receive higher offers?');
    _expectSameRow(tester, 'Edit location', 'Current estimated rewards');
    _expectSingleRenderedLine(tester, 'iPad Air, 5th gen or newer');
    expect(
      find.byKey(const Key('save-request-changes')).hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('390 and 320 preserve approved form card and CTA heights', (
    tester,
  ) async {
    await _pumpState(tester, state: _ProofState.product, width: 390);
    final description390 = _ancestorRect(
      tester,
      find.text('Describe the product'),
      '_ApprovedSurface',
    )!;
    final quantity390 = _ancestorRect(
      tester,
      find.text('Quantity'),
      '_ApprovedSurface',
    )!;
    final higherOffers390 = _ancestorRect(
      tester,
      find.text('Willing to receive higher offers?'),
      '_ApprovedSurface',
    )!;
    final continue390 = tester.getRect(
      find.ancestor(
        of: find.text('Continue'),
        matching: find.byType(FilledButton),
      ),
    );

    expect(description390.height, closeTo(135, 3));
    expect(
      <double>[
        quantity390.height,
        higherOffers390.height,
      ].reduce((left, right) => left > right ? left : right),
      closeTo(100, 4),
    );
    expect(continue390.height, closeTo(30.47, 0.1));

    await _pumpState(
      tester,
      state: _ProofState.product,
      width: 320,
      height: _compactProofHeight,
    );
    const scale = 320 / 390;
    final description320 = _ancestorRect(
      tester,
      find.text('Describe the product'),
      '_ApprovedSurface',
    )!;
    final quantity320 = _ancestorRect(
      tester,
      find.text('Quantity'),
      '_ApprovedSurface',
    )!;
    final higherOffers320 = _ancestorRect(
      tester,
      find.text('Willing to receive higher offers?'),
      '_ApprovedSurface',
    )!;
    final continue320 = tester.getRect(
      find.ancestor(
        of: find.text('Continue'),
        matching: find.byType(FilledButton),
      ),
    );

    expect(description320.height, closeTo(description390.height * scale, 0.2));
    expect(description320.height, closeTo(135 * scale, 2.5));
    expect(quantity320.height, closeTo(quantity390.height * scale, 0.2));
    expect(
      higherOffers320.height,
      closeTo(higherOffers390.height * scale, 0.2),
    );
    expect(
      <double>[
        quantity320.height,
        higherOffers320.height,
      ].reduce((left, right) => left > right ? left : right),
      closeTo(100 * scale, 2.5),
    );
    expect(continue320.height, closeTo(30.47 * scale, 0.1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('390px normal scale keeps approved bottom actions in view', (
    tester,
  ) async {
    for (final state in _ProofState.values) {
      await _pumpState(tester, state: state, width: 390);
      final action = switch (state) {
        _ProofState.product || _ProofState.service => find.text('Continue'),
        _ProofState.location => find.text('Post request'),
        _ProofState.details => find.byKey(const Key('save-request-changes')),
      };
      expect(
        action.hitTestable(),
        findsOneWidget,
        reason: '${state.name} bottom action is below the 390x844 viewport',
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Large and XL text reflow and remain actionable', (tester) async {
    for (final scale in <double>[1.15, 1.3, 1.6]) {
      for (final state in _ProofState.values) {
        await _pumpState(
          tester,
          state: state,
          width: 320,
          height: _compactProofHeight,
          textScale: scale,
        );
        final action = switch (state) {
          _ProofState.product || _ProofState.service => find.text('Continue'),
          _ProofState.location => find.text('Post request'),
          _ProofState.details => find.byKey(const Key('save-request-changes')),
        };
        await tester.ensureVisible(action);
        await tester.pumpAndSettle();
        expect(action, findsOneWidget);
        expect(
          tester.takeException(),
          isNull,
          reason: '${state.name} failed at 320px with text scale $scale',
        );
      }
    }
  });

  testWidgets('request callbacks and local controls remain wired', (
    tester,
  ) async {
    var title = '';
    var budget = '';
    var submitted = false;
    var offersOpened = false;

    await _pumpWidget(
      tester,
      width: 390,
      child: ApprovedRequestFlowPage(
        accent: const Color(0xff1917ff),
        requestTitle: '',
        budget: '',
        onTitleChanged: (value) => title = value,
        onBudgetChanged: (value) => budget = value,
        onBack: () {},
        onNotifications: () {},
        onSubmit: () => submitted = true,
        includeAppChrome: true,
      ),
    );

    final titleField = find.byType(TextFormField).first;
    await tester.enterText(titleField, 'iPad Air');
    expect(title, 'iPad Air');

    await tester.ensureVisible(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Post request'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Post request'));
    expect(submitted, isTrue);
    expect(budget, isEmpty);

    await _pumpWidget(
      tester,
      width: 390,
      child: ApprovedBuyerRequestDetailsPage(
        accent: const Color(0xff1917ff),
        requestTitle: 'iPad Air, 5th gen or newer',
        budget: r'$350 - $480',
        onBack: () {},
        onNotifications: () {},
        onOffers: () => offersOpened = true,
        includeAppChrome: true,
      ),
    );
    await tester.ensureVisible(find.text('32 offers'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('32 offers'));
    expect(offersOpened, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'writes labelled approved request flow comparison sheet',
    (tester) async {
      final comparisons = <_Comparison>[];
      for (final state in _ProofState.values) {
        await _pumpState(tester, state: state, width: 390);
        final actual = await _capture(tester);
        final output = File(
          'assets/approved_request_flow/${state.name}-actual-390.png',
        );
        output.parent.createSync(recursive: true);
        await output.writeAsBytes(await _pngBytes(actual));
        comparisons.add(
          _Comparison(
            label: state.label,
            targetPath: state.targetPath,
            actual: actual,
          ),
        );
      }

      final contactSheet = await _contactSheet(comparisons);
      final output = File(
        'assets/approved_request_flow/request-flow-comparison-contact-sheet.png',
      );
      await output.writeAsBytes(await _pngBytes(contactSheet));

      expect(output.existsSync(), isTrue);
      expect(output.lengthSync(), greaterThan(1000));
    },
    skip: !_writeRequestFlowProof,
  );
}

enum _ProofState {
  product(
    'Product details',
    'approved resign/post-request-approved/4.2-post-new-request-products-approved.png',
  ),
  service(
    'Service details',
    'approved resign/post-request-approved/4.2.1-post-new-request-service-approved.png',
  ),
  location(
    'Service location',
    'approved resign/post-request-approved/4.2.2-post-new-request-location-approved.png',
  ),
  details(
    'Buyer request details',
    'approved resign/buyer-request-navigation-approved/4.3 Edit Request Details For Products-approved.png',
  );

  const _ProofState(this.label, this.targetPath);
  final String label;
  final String targetPath;
}

Future<void> _pumpState(
  WidgetTester tester, {
  required _ProofState state,
  required double width,
  double height = _proofHeight,
  double textScale = 1,
}) async {
  if (state == _ProofState.details) {
    await _pumpWidget(
      tester,
      width: width,
      height: height,
      textScale: textScale,
      child: ApprovedBuyerRequestDetailsPage(
        key: ValueKey('approved-request-${state.name}'),
        accent: const Color(0xff1917ff),
        requestTitle: 'iPad Air, 5th gen or newer',
        budget: r'$350 - $480',
        onBack: () {},
        onNotifications: () {},
        onOffers: () {},
        includeAppChrome: true,
      ),
    );
    return;
  }

  await _pumpWidget(
    tester,
    width: width,
    height: height,
    textScale: textScale,
    child: ApprovedRequestFlowPage(
      key: ValueKey('approved-request-${state.name}'),
      accent: const Color(0xff1917ff),
      requestTitle: '',
      budget: '',
      onTitleChanged: (_) {},
      onBudgetChanged: (_) {},
      onBack: () {},
      onNotifications: () {},
      onSubmit: () {},
      initialKind: state == _ProofState.product
          ? ApprovedRequestKind.product
          : ApprovedRequestKind.service,
      includeAppChrome: true,
    ),
  );

  if (state == _ProofState.location) {
    await tester.ensureVisible(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.fling(
      find.byKey(const Key('approved-request-scroll')),
      const Offset(0, 1600),
      2500,
    );
    await tester.pumpAndSettle();
  }
}

Future<void> _pumpWidget(
  WidgetTester tester, {
  required double width,
  required Widget child,
  double height = _proofHeight,
  double textScale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1917ff)),
      ),
      builder: (context, appChild) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(textScale)),
          child: RepaintBoundary(
            key: _captureKey,
            child: appChild ?? const SizedBox.shrink(),
          ),
        );
      },
      home: child,
    ),
  );
  await tester.pumpAndSettle();
}

void _expectSameRow(WidgetTester tester, String left, String right) {
  final leftFinder = find.text(left).first;
  final rightFinder = find.text(right).first;
  final leftCenter = tester.getCenter(leftFinder);
  final rightCenter = tester.getCenter(rightFinder);
  final leftText = tester.widget<Text>(leftFinder);
  final rightText = tester.widget<Text>(rightFinder);
  final media = MediaQuery.of(tester.element(leftFinder));
  final leftSurface = _ancestorRect(tester, leftFinder, '_ApprovedSurface');
  final rightSurface = _ancestorRect(tester, rightFinder, '_ApprovedSurface');
  expect(
    (leftCenter.dy - rightCenter.dy).abs(),
    lessThan(3),
    reason:
        'Expected "$left" and "$right" to retain one approved row. '
        'Centers: ${leftCenter.dy}, ${rightCenter.dy}; '
        'font sizes: ${leftText.style?.fontSize}, ${rightText.style?.fontSize}; '
        'surfaces: $leftSurface, $rightSurface; '
        'media: ${media.size}, scale: ${media.textScaler.scale(1)}.',
  );
}

Rect? _ancestorRect(WidgetTester tester, Finder finder, String typeName) {
  Element? match;
  tester.element(finder).visitAncestorElements((ancestor) {
    if (ancestor.widget.runtimeType.toString() == typeName) {
      match = ancestor;
      return false;
    }
    return true;
  });
  final renderBox = match?.renderObject as RenderBox?;
  return renderBox == null
      ? null
      : renderBox.localToGlobal(Offset.zero) & renderBox.size;
}

void _expectSingleRenderedLine(WidgetTester tester, String value) {
  final paragraph = tester.renderObject<RenderParagraph>(
    find.text(value).first,
  );
  final boxes = paragraph.getBoxesForSelection(
    TextSelection(baseOffset: 0, extentOffset: value.length),
  );
  final lineTops = boxes.map((box) => box.top.round()).toSet();
  expect(
    lineTops,
    hasLength(1),
    reason: 'Expected "$value" to remain a single approved line.',
  );
}

Future<ui.Image> _capture(WidgetTester tester) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_captureKey),
  );
  return boundary.toImage(pixelRatio: 1);
}

Future<List<int>> _pngBytes(ui.Image image) async {
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

class _Comparison {
  const _Comparison({
    required this.label,
    required this.targetPath,
    required this.actual,
  });

  final String label;
  final String targetPath;
  final ui.Image actual;
}

Future<ui.Image> _contactSheet(List<_Comparison> comparisons) async {
  const columnWidth = 390.0;
  const gutter = 24.0;
  const labelHeight = 42.0;
  const rowHeight = _proofHeight + labelHeight + 24;
  const sheetWidth = columnWidth * 2 + gutter * 3;
  final sheetHeight = rowHeight * comparisons.length + gutter;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawColor(Colors.white, BlendMode.src);

  _drawLabel(canvas, 'APPROVED TARGET', gutter, 8, columnWidth);
  _drawLabel(
    canvas,
    'FLUTTER IMPLEMENTATION',
    gutter * 2 + columnWidth,
    8,
    columnWidth,
  );

  for (var index = 0; index < comparisons.length; index++) {
    final comparison = comparisons[index];
    final rowTop = gutter + index * rowHeight;
    final target = await _decodeImage(File(comparison.targetPath));
    _drawLabel(
      canvas,
      comparison.label,
      gutter,
      rowTop + 16,
      sheetWidth - gutter * 2,
    );
    final imageTop = rowTop + labelHeight;
    _drawContainedImage(
      canvas,
      target,
      Rect.fromLTWH(gutter, imageTop, columnWidth, _proofHeight),
    );
    _drawContainedImage(
      canvas,
      comparison.actual,
      Rect.fromLTWH(
        gutter * 2 + columnWidth,
        imageTop,
        columnWidth,
        _proofHeight,
      ),
    );
  }

  final picture = recorder.endRecording();
  return picture.toImage(sheetWidth.ceil(), sheetHeight.ceil());
}

Future<ui.Image> _decodeImage(File file) async {
  final codec = await ui.instantiateImageCodec(await file.readAsBytes());
  final frame = await codec.getNextFrame();
  return frame.image;
}

void _drawContainedImage(Canvas canvas, ui.Image image, Rect bounds) {
  final scale = (bounds.width / image.width)
      .clamp(0, bounds.height / image.height)
      .toDouble();
  final width = image.width * scale;
  final height = image.height * scale;
  final destination = Rect.fromLTWH(
    bounds.left + (bounds.width - width) / 2,
    bounds.top,
    width,
    height,
  );
  canvas.drawRect(bounds, Paint()..color = const Color(0xfff3f4f8));
  canvas.drawImageRect(
    image,
    Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    destination,
    Paint()..filterQuality = FilterQuality.high,
  );
}

void _drawLabel(
  Canvas canvas,
  String text,
  double left,
  double top,
  double width,
) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(
        color: Color(0xff10145b),
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width);
  painter.paint(canvas, Offset(left, top));
}
