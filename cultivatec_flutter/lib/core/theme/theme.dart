import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // === Design System (Ultra Modern Gamified) ===

  // Primary
  static const Color primaryBlue = Color(0xFF3B82F6); // Brighter blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF60A5FA);

  // Accents (Neon & Vibrant)
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);

  // Backgrounds
  static const Color bgPrimary = Color(0xFFF0F4F8); // Softer blue-gray
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFE2E8F0);
  static const Color bgTertiary = Color(0xFFDBEAFE);

  // Legacy aliases
  static const Color bgLight = bgPrimary;
  static const Color bgCard = bgSurface;

  // Text
  static const Color textPrimary = Color(0xFF0F172A); // Almost black
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFFCBD5E1);

  // Borders & Dividers
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderFocus = primaryBlue;

  // Rarities
  static const Color rarityCommon = Color(0xFF64748B);
  static const Color rarityRare = Color(0xFF06B6D4);
  static const Color rarityEpic = Color(0xFF8B5CF6);
  static const Color rarityLegendary = Color(0xFFF59E0B);

  // Shadows - Deeper and more dynamic
  static List<BoxShadow> get shadowSm => [
        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 14, offset: const Offset(0, 6)),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(color: primaryBlue.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6)),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(color: primaryBlue.withValues(alpha: 0.12), blurRadius: 24, offset: const Offset(0, 12)),
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4)),
      ];
      
  static List<BoxShadow> get shadowGlow => [
        BoxShadow(color: primaryBlue.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 4)),
      ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF6366F1)], // Blue to Indigo
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)], // Purple to Fuchsia
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [bgSurface, Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animVerySlow = Duration(milliseconds: 800);

  // Rounded corners
  static const double radiusSm = 14.0;
  static const double radiusMd = 18.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: Brightness.light,
          surface: bgSurface,
        ),
        scaffoldBackgroundColor: bgPrimary,
        textTheme: GoogleFonts.outfitTextTheme().copyWith(
          // Outfit font gives a very modern tech/gaming vibe
          displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.w900),
          titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w800),
          bodyLarge: GoogleFonts.inter(), // Inter for readability on small text
          bodyMedium: GoogleFonts.inter(),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: textPrimary,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: primaryBlue.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusXl),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryBlue,
            side: const BorderSide(color: primaryBlue, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusXl),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
          filled: true,
          fillColor: bgSurface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: bgSurface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: bgSurface,
          selectedItemColor: primaryBlue,
          unselectedItemColor: textMuted,
          elevation: 0,
        ),
        dividerTheme: const DividerThemeData(
          color: borderColor,
          thickness: 1.5,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          },
        ),
      );

  /// Smooth slide+fade page route for manual navigation
  static Route<T> smoothRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: animNormal,
      reverseTransitionDuration: animNormal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(curved),
          child: FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
        );
      },
    );
  }
}

