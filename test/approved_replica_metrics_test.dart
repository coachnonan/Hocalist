import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hocalist/features/approved/approved_replica_metrics.dart';

void main() {
  group('ApprovedReplicaMetrics width classes', () {
    final cases =
        <
          ({
            double width,
            ApprovedReplicaWidthClass widthClass,
            double scale,
            double contentMaxWidth,
          })
        >[
          (
            width: 320,
            widthClass: ApprovedReplicaWidthClass.narrow320,
            scale: 320 / 390,
            contentMaxWidth: 320,
          ),
          (
            width: 360,
            widthClass: ApprovedReplicaWidthClass.compact360,
            scale: 360 / 390,
            contentMaxWidth: 360,
          ),
          (
            width: 390,
            widthClass: ApprovedReplicaWidthClass.reference,
            scale: 1,
            contentMaxWidth: 390,
          ),
          (
            width: 430,
            widthClass: ApprovedReplicaWidthClass.reference,
            scale: 1,
            contentMaxWidth: 390,
          ),
          (
            width: 600,
            widthClass: ApprovedReplicaWidthClass.tablet,
            scale: 1,
            contentMaxWidth: 390,
          ),
          (
            width: 768,
            widthClass: ApprovedReplicaWidthClass.tablet,
            scale: 1,
            contentMaxWidth: 390,
          ),
          (
            width: 1024,
            widthClass: ApprovedReplicaWidthClass.tablet,
            scale: 1,
            contentMaxWidth: 390,
          ),
        ];

    for (final item in cases) {
      test('${item.width} resolves discrete replica tokens', () {
        final metrics = ApprovedReplicaMetrics.resolve(
          availableWidth: item.width,
          textScaler: TextScaler.noScaling,
        );

        expect(metrics.widthClass, item.widthClass);
        expect(metrics.geometryScale, closeTo(item.scale, 0.000001));
        expect(metrics.typographyScale, closeTo(item.scale, 0.000001));
        expect(metrics.contentMaxWidth, item.contentMaxWidth);
        expect(metrics.screenshotLocked, isTrue);
        expect(metrics.geometry(39), closeTo(39 * item.scale, 0.000001));
        expect(metrics.fontSize(13), closeTo(13 * item.scale, 0.000001));
      });
    }
  });

  test('Small and Medium retain screenshot lock', () {
    for (final scale in [0.9, 1.0]) {
      final metrics = ApprovedReplicaMetrics.resolve(
        availableWidth: 320,
        textScaler: TextScaler.linear(scale),
      );

      expect(metrics.screenshotLocked, isTrue);
      expect(metrics.accessibilityReflow, isFalse);
      expect(
        metrics.geometryScale,
        closeTo(ApprovedReplicaMetrics.narrowScale, 0.000001),
      );
    }
  });

  test('Large, XL, and external scaling bypass screenshot lock', () {
    for (final scale in [1.15, 1.3, 1.6]) {
      final metrics = ApprovedReplicaMetrics.resolve(
        availableWidth: 320,
        textScaler: TextScaler.linear(scale),
      );

      expect(metrics.screenshotLocked, isFalse);
      expect(metrics.accessibilityReflow, isTrue);
      expect(metrics.geometryScale, 1);
      expect(metrics.typographyScale, 1);
      expect(metrics.textScale, scale);
    }
  });

  test('accessibility reflow may use width up to the 430 tablet maximum', () {
    final metrics = ApprovedReplicaMetrics.resolve(
      availableWidth: 768,
      textScaler: TextScaler.linear(1.15),
    );

    expect(metrics.accessibilityReflow, isTrue);
    expect(metrics.contentMaxWidth, 430);
  });

  test('geometry helpers preserve reference ratios', () {
    final metrics = ApprovedReplicaMetrics.resolve(
      availableWidth: 360,
      textScaler: TextScaler.noScaling,
    );

    expect(
      metrics.geometryInsets(const EdgeInsets.fromLTRB(10, 20, 30, 40)),
      EdgeInsets.fromLTRB(
        10 * ApprovedReplicaMetrics.compactScale,
        20 * ApprovedReplicaMetrics.compactScale,
        30 * ApprovedReplicaMetrics.compactScale,
        40 * ApprovedReplicaMetrics.compactScale,
      ),
    );
    expect(metrics.geometrySize(const Size(39, 78)), const Size(36, 72));
    expect(
      metrics.innerContentMaxWidth(referenceHorizontalInset: 18),
      closeTo(360 - (36 * ApprovedReplicaMetrics.compactScale), 0.000001),
    );
    expect(
      metrics.lineHeight(referenceFontSize: 10, referenceLineHeight: 13),
      1.3,
    );
  });

  testWidgets('scope exposes resolved metrics to descendants', (tester) async {
    final metrics = ApprovedReplicaMetrics.resolve(
      availableWidth: 390,
      textScaler: TextScaler.noScaling,
    );
    late ApprovedReplicaMetrics resolved;

    await tester.pumpWidget(
      ApprovedReplicaScope(
        metrics: metrics,
        child: Builder(
          builder: (context) {
            resolved = ApprovedReplicaScope.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(identical(resolved, metrics), isTrue);
  });
}
