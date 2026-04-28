import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme centralizes every color, font size, and style used in the app.
/// Instead of hardcoding colors on every screen, we reference these constants.
/// This makes redesigning easy — change it here, it updates everywhere.
class AppTheme {
  // ─── Color Palette ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A1A2E);      // Deep navy — main brand color
  static const Color accent = Color(0xFFE94560);       // Vivid red — CTAs, highlights
  static const Color surface = Color(0xFF16213E);      // Slightly lighter navy — cards
  static const Color background = Color(0xFF0F3460);   // Mid-blue — page backgrounds
  static const Color cardBg = Color(0xFFFFFFFF);       // White — card surfaces
  static const Color textDark = Color(0xFF1A1A2E);     // Dark text on light backgrounds
  static const Color textLight = Color(0xFFF5F5F5);    // Light text on dark backgrounds
  static const Color textMuted = Color(0xFF8892A4);    // Grey — secondary info
  static const Color success = Color(0xFF4CAF50);      // Green — confirmations
  static const Color divider = Color(0xFFE0E0E0);      // Light grey — separators

  // ─── ThemeData ────────────────────────────────────────────────────────────
  /// Call this in MaterialApp(theme: AppTheme.theme) to apply globally.
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F8FC), // Off-white page bg
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: cardBg,
      ),

      // ── Typography ──────────────────────────────────────────────────────
      // Playfair Display for headings (elegant, editorial)
      // Lato for body text (clean, readable)
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32, fontWeight: FontWeight.w700, color: textDark,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 26, fontWeight: FontWeight.w700, color: textDark,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 20, fontWeight: FontWeight.w600, color: textDark,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 16, color: textDark,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 14, color: textMuted,
        ),
        labelLarge: GoogleFonts.lato(
          fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.2,
        ),
      ),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20, fontWeight: FontWeight.w700, color: textLight,
        ),
      ),

      // ── Buttons ─────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.lato(
            fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.0,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // ── Input Fields ────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F2F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // ── Cards ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),

      // ── Navigation Bar ──────────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primary,
        selectedItemColor: accent,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
      ),

      dividerTheme: const DividerThemeData(
        color: divider, thickness: 1, space: 1,
      ),
    );
  }
}
