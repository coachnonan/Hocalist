import 'package:flutter/material.dart';

/// Shared input geometry for Hocalist.
///
/// Screen-specific replicas may scale these values for narrow phones, but no
/// standard input should fall back to Material's cramped dense defaults.
abstract final class HocalistInputTokens {
  static const double minimumHeight = 48;
  static const double compactMinimumHeight = 44;
  static const double relatedFieldSpacing = 8;
  static const double horizontalPadding = 14;
  static const double verticalPadding = 12;
  static const double compactHorizontalPadding = 12;
  static const double compactVerticalPadding = 10;

  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: horizontalPadding,
    vertical: verticalPadding,
  );

  static const EdgeInsets compactContentPadding = EdgeInsets.symmetric(
    horizontal: compactHorizontalPadding,
    vertical: compactVerticalPadding,
  );
}
