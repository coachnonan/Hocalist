part of '../main.dart';

class HocalistTheme {
  static const primary = Color(0xff00036c);
  static const primaryContainer = Color(0xff20258f);
  static const actionBlue = Color(0xff1400c8);
  static const sellerGreen = Color(0xff078b2d);
  static const giftPurple = Color(0xff8d10ca);
  static const rewardGold = Color(0xffffb331);
  static const buyer = primary;
  static const seller = primary;
  static const background = Color(0xfff8f9ff);
  static const surface = Color(0xffffffff);
  static const softSurface = Color(0xfff1f0ff);
  static const roleSurface = Color(0xffeeedff);
  static const sellerSurface = Color(0xffeefaf2);
  static const text = Color(0xff0c123d);
  static const muted = Color(0xff5e657f);
  static const outline = Color(0xffc7c9d8);
  static const danger = Color(0xffb42318);
  static const success = Color(0xff08765f);
  static const warning = Color(0xff9a5b00);
  static const focus = Color(0xff5b63e8);
  static const darkBackground = Color(0xff0b0c1f);
  static const darkSurface = Color(0xff15172d);
  static const darkSoftSurface = Color(0xff202344);
  static const darkText = Color(0xfff3f3ff);
  static const darkMuted = Color(0xffc4c5d6);
  static const darkOutline = Color(0xff454867);
  static const darkBuyer = Color(0xffbec2ff);
  static const darkSeller = Color(0xffbec2ff);
  static const darkPrimary = primary;
  static const appFontFallback = ['Arial', 'Roboto', 'Helvetica', 'sans-serif'];
  static const displaySize = 30.0;
  static const pageTitleSize = 28.0;
  static const sectionTitleSize = 20.0;
  static const titleSize = 16.0;
  static const prominentTitleSize = 18.0;
  static const bodySize = 15.0;
  static const captionSize = 13.0;
  static const smallSize = 12.0;
  static const buttonSize = 17.0;
  static const metricSize = 26.0;

  static TextTheme _textTheme({
    required Color primaryText,
    required Color mutedText,
    FontWeight titleWeight = FontWeight.w800,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        color: primaryText,
        fontSize: displaySize,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      displayMedium: TextStyle(
        color: primaryText,
        fontSize: pageTitleSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        color: primaryText,
        fontSize: pageTitleSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        color: primaryText,
        fontSize: pageTitleSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        color: primaryText,
        fontSize: sectionTitleSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        color: primaryText,
        fontSize: sectionTitleSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        color: primaryText,
        fontSize: prominentTitleSize,
        fontWeight: titleWeight,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        color: primaryText,
        fontSize: titleSize,
        fontWeight: titleWeight,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        color: primaryText,
        fontSize: bodySize,
        fontWeight: titleWeight,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        color: primaryText,
        fontSize: bodySize,
        letterSpacing: 0,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        color: primaryText,
        fontSize: captionSize,
        letterSpacing: 0,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        color: mutedText,
        fontSize: smallSize,
        letterSpacing: 0,
        height: 1.35,
      ),
      labelLarge: TextStyle(
        color: primaryText,
        fontSize: captionSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        color: mutedText,
        fontSize: smallSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        color: mutedText,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamilyFallback: appFontFallback,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: buyer,
        tertiary: seller,
        surface: surface,
        error: danger,
      ),
      textTheme: _textTheme(primaryText: text, mutedText: muted),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xffdbe5ef)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamilyFallback: appFontFallback,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: darkPrimary,
        primary: darkPrimary,
        onPrimary: Colors.white,
        secondary: darkBuyer,
        tertiary: darkSeller,
        surface: darkSurface,
        error: Color(0xffffb4ab),
      ),
      textTheme: _textTheme(
        primaryText: darkText,
        mutedText: darkMuted,
        titleWeight: FontWeight.w700,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkOutline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: primary.withValues(alpha: 0.42),
      ),
    );
  }
}
