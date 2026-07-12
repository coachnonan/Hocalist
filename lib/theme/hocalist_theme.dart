part of '../main.dart';

class HocalistTheme {
  static const primary = Color(0xff00036c);
  static const primaryContainer = Color(0xff20258f);
  static const buyer = primary;
  static const seller = primary;
  static const background = Color(0xfff7f8fc);
  static const surface = Color(0xffffffff);
  static const softSurface = Color(0xffeef0ff);
  static const roleSurface = Color(0xffeef4ff);
  static const text = Color(0xff17182b);
  static const muted = Color(0xff55586d);
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

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: buyer,
        tertiary: seller,
        surface: surface,
        error: danger,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: text,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          color: text,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          color: text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          color: text,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(color: text, fontSize: 16, letterSpacing: 0),
        bodyMedium: TextStyle(color: text, fontSize: 14, letterSpacing: 0),
        labelLarge: TextStyle(
          color: text,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        labelSmall: TextStyle(
          color: muted,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
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
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: darkText,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          color: darkText,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          color: darkText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(color: darkText, fontSize: 16, letterSpacing: 0),
        bodyMedium: TextStyle(color: darkText, fontSize: 14, letterSpacing: 0),
        labelLarge: TextStyle(
          color: darkText,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        labelSmall: TextStyle(
          color: darkMuted,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
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
