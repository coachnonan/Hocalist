import 'dart:math' as math;

import 'package:flutter/widgets.dart';

enum ApprovedReplicaWidthClass { narrow320, compact360, reference, tablet }

@immutable
class ApprovedReplicaMetrics {
  const ApprovedReplicaMetrics._({
    required this.availableWidth,
    required this.textScale,
    required this.widthClass,
    required this.geometryScale,
    required this.typographyScale,
    required this.contentMaxWidth,
    required this.accessibilityReflow,
  });

  static const double referenceCanvasWidth = 390;
  static const double referencePhoneMaxWidth = 430;
  static const double tabletBreakpoint = 600;
  static const double narrowScale = 320 / referenceCanvasWidth;
  static const double compactScale = 360 / referenceCanvasWidth;

  factory ApprovedReplicaMetrics.resolve({
    required double availableWidth,
    required TextScaler textScaler,
  }) {
    assert(availableWidth >= 0);
    final textScale = textScaler.scale(1);
    final accessibilityReflow = textScale > 1.0;
    final widthClass = switch (availableWidth) {
      < 340 => ApprovedReplicaWidthClass.narrow320,
      < 390 => ApprovedReplicaWidthClass.compact360,
      < tabletBreakpoint => ApprovedReplicaWidthClass.reference,
      _ => ApprovedReplicaWidthClass.tablet,
    };
    final lockedScale = switch (widthClass) {
      ApprovedReplicaWidthClass.narrow320 => narrowScale,
      ApprovedReplicaWidthClass.compact360 => compactScale,
      ApprovedReplicaWidthClass.reference ||
      ApprovedReplicaWidthClass.tablet => 1.0,
    };
    final tokenScale = accessibilityReflow ? 1.0 : lockedScale;
    final contentMaxWidth = accessibilityReflow
        ? math.min(availableWidth, referencePhoneMaxWidth)
        : math.min(availableWidth, referenceCanvasWidth);

    return ApprovedReplicaMetrics._(
      availableWidth: availableWidth,
      textScale: textScale,
      widthClass: widthClass,
      geometryScale: tokenScale,
      typographyScale: tokenScale,
      contentMaxWidth: contentMaxWidth,
      accessibilityReflow: accessibilityReflow,
    );
  }

  final double availableWidth;
  final double textScale;
  final ApprovedReplicaWidthClass widthClass;
  final double geometryScale;
  final double typographyScale;
  final double contentMaxWidth;
  final bool accessibilityReflow;

  bool get screenshotLocked => !accessibilityReflow;
  bool get isNarrow => widthClass == ApprovedReplicaWidthClass.narrow320;
  bool get isCompact => widthClass == ApprovedReplicaWidthClass.compact360;
  bool get isTablet => widthClass == ApprovedReplicaWidthClass.tablet;

  double geometry(double referencePixels) => referencePixels * geometryScale;

  double fontSize(double referencePixels) => referencePixels * typographyScale;

  double lineHeight({
    required double referenceFontSize,
    required double referenceLineHeight,
  }) => referenceLineHeight / referenceFontSize;

  EdgeInsets geometryInsets(EdgeInsets referenceInsets) {
    return EdgeInsets.fromLTRB(
      geometry(referenceInsets.left),
      geometry(referenceInsets.top),
      geometry(referenceInsets.right),
      geometry(referenceInsets.bottom),
    );
  }

  Size geometrySize(Size referenceSize) {
    return Size(geometry(referenceSize.width), geometry(referenceSize.height));
  }

  double innerContentMaxWidth({required double referenceHorizontalInset}) {
    return math.max(
      0,
      contentMaxWidth - (geometry(referenceHorizontalInset) * 2),
    );
  }
}

class ApprovedReplicaScope extends InheritedWidget {
  const ApprovedReplicaScope({
    required this.metrics,
    required super.child,
    super.key,
  });

  final ApprovedReplicaMetrics metrics;

  static ApprovedReplicaMetrics of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ApprovedReplicaScope>();
    assert(scope != null, 'ApprovedReplicaScope is missing above this widget.');
    return scope!.metrics;
  }

  static ApprovedReplicaMetrics? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ApprovedReplicaScope>()
        ?.metrics;
  }

  @override
  bool updateShouldNotify(ApprovedReplicaScope oldWidget) {
    return metrics.availableWidth != oldWidget.metrics.availableWidth ||
        metrics.textScale != oldWidget.metrics.textScale ||
        metrics.widthClass != oldWidget.metrics.widthClass;
  }
}
