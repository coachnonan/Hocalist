part of '../../main.dart';

enum AccessibilityFontStyle { standard, friendly, highContrast }

enum AccessibilityButtonStyle { rounded, highContrast }

@immutable
class AccessibilityPreferences {
  const AccessibilityPreferences({
    required this.textSize,
    required this.fontStyle,
    required this.buttonStyle,
  });

  static const defaults = AccessibilityPreferences(
    textSize: AppTextSize.medium,
    fontStyle: AccessibilityFontStyle.standard,
    buttonStyle: AccessibilityButtonStyle.rounded,
  );

  final AppTextSize textSize;
  final AccessibilityFontStyle fontStyle;
  final AccessibilityButtonStyle buttonStyle;

  String get fontFamily => switch (fontStyle) {
    AccessibilityFontStyle.standard => 'Nunito',
    AccessibilityFontStyle.friendly => 'Lexend',
    AccessibilityFontStyle.highContrast => 'Archivo',
  };

  String get fontLabel => switch (fontStyle) {
    AccessibilityFontStyle.standard => 'Default',
    AccessibilityFontStyle.friendly => 'Friendly',
    AccessibilityFontStyle.highContrast => 'High Contrast',
  };

  String get buttonLabel => switch (buttonStyle) {
    AccessibilityButtonStyle.rounded => 'Rounded',
    AccessibilityButtonStyle.highContrast => 'High Contrast',
  };

  AccessibilityPreferences copyWith({
    AppTextSize? textSize,
    AccessibilityFontStyle? fontStyle,
    AccessibilityButtonStyle? buttonStyle,
  }) {
    return AccessibilityPreferences(
      textSize: textSize ?? this.textSize,
      fontStyle: fontStyle ?? this.fontStyle,
      buttonStyle: buttonStyle ?? this.buttonStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccessibilityPreferences &&
        other.textSize == textSize &&
        other.fontStyle == fontStyle &&
        other.buttonStyle == buttonStyle;
  }

  @override
  int get hashCode => Object.hash(textSize, fontStyle, buttonStyle);
}
