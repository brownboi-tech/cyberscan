// THEME LOCK: dark — source: domain signal (cybersecurity ops/monitoring)
// Scaffold.backgroundColor = AppTheme.background — ALL screens

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary cyber green
  static const Color primary = Color(0xFF00FF88);
  static const Color primaryMuted = Color(0x4000FF88);
  static const Color primaryContainer = Color(0xFF003D20);

  // Severity colors
  static const Color critical = Color(0xFFFF3B30);
  static const Color criticalMuted = Color(0x33FF3B30);
  static const Color high = Color(0xFFFF6B35);
  static const Color highMuted = Color(0x33FF6B35);
  static const Color medium = Color(0xFFFFB800);
  static const Color mediumMuted = Color(0x33FFB800);
  static const Color low = Color(0xFF3B82F6);
  static const Color lowMuted = Color(0x333B82F6);

  // Surface system — dark
  static const Color background = Color(0xFF080B12);
  static const Color surfaceDark = Color(0xFF0D1117);
  static const Color surfaceCard = Color(0xCC1A1F2E);
  static const Color surfaceVariant = Color(0xFF242938);
  static const Color surfaceElevated = Color(0xFF1E2433);

  // Text
  static const Color textPrimary = Color(0xFFE8EDF5);
  static const Color textSecondary = Color(0xFF8B95A8);
  static const Color textMuted = Color(0xFF4A5568);

  // Accent
  static const Color accent = Color(0xFFFFB800);
  static const Color accentBlue = Color(0xFF3B82F6);

  static ThemeData get lightTheme => darkTheme; // App is dark-only

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      onPrimary: Color(0xFF001A0D),
      primaryContainer: primaryContainer,
      onPrimaryContainer: primary,
      secondary: accent,
      onSecondary: Color(0xFF1A1200),
      surface: surfaceDark,
      onSurface: textPrimary,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: textSecondary,
      error: critical,
      onError: Colors.white,
      outline: Color(0xFF2D3548),
      outlineVariant: Color(0xFF1E2433),
      inverseSurface: textPrimary,
      onInverseSurface: background,
    ),
    textTheme: GoogleFonts.ibmPlexSansTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        labelMedium: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          color: textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
      ),
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'IBM Plex Sans',
      ),
      iconTheme: IconThemeData(color: textSecondary),
    ),
    cardTheme: CardThemeData(
      color: surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF2D3548), width: 0.5),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariant,
      selectedColor: primaryMuted,
      labelStyle: const TextStyle(
        color: textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      side: const BorderSide(color: Color(0xFF2D3548), width: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'IBM Plex Sans',
          );
        }
        return const TextStyle(
          color: textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'IBM Plex Sans',
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primary, size: 22);
        }
        return const IconThemeData(color: textMuted, size: 22);
      }),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF1E2433),
      thickness: 0.5,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Color(0xFF001A0D),
      elevation: 4,
      shape: CircleBorder(),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: surfaceCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2D3548), width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2D3548), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
      hintStyle: const TextStyle(color: textMuted, fontSize: 13),
    ),
  );

  // Helper: get severity color
  static Color severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return critical;
      case 'high':
        return high;
      case 'medium':
        return medium;
      case 'low':
        return low;
      default:
        return textMuted;
    }
  }

  static Color severityMutedColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return criticalMuted;
      case 'high':
        return highMuted;
      case 'medium':
        return mediumMuted;
      case 'low':
        return lowMuted;
      default:
        return const Color(0x334A5568);
    }
  }
}
