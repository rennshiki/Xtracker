import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  // Background & Surface (Obsidian Deep)
  static const bg           = Color(0xFF080A0F);
  static const surface      = Color(0xFF0E1118);
  static const surfaceHigh  = Color(0xFF141820);
  static const surfaceGlass = Color(0xFF1A2030);
  static const border       = Color(0xFF1F2535);
  static const borderGlow   = Color(0xFF2E3A52);

  // Primary: Gold / Amber (luxury accent)
  static const primary      = Color(0xFFE8B84B);
  static const primaryLight = Color(0xFFF5D07A);
  static const primaryDim   = Color(0xFF3D3010);

  // Accent: Emerald Teal
  static const accent    = Color(0xFF00D4AA);
  static const accentDim = Color(0xFF0D2E28);

  // Text
  static const textPrimary   = Color(0xFFF0F2F8);
  static const textSecondary = Color(0xFF7D8BA8);
  static const textMuted     = Color(0xFF3D4560);

  // Status
  static const success = Color(0xFF22D3A5);
  static const danger  = Color(0xFFFF5F6D);
  static const warning = Color(0xFFFFB341);

  // Total Card Gradient
  static const cardGradientStart = Color(0xFF141022);
  static const cardGradientEnd   = Color(0xFF080A0F);
  static const cardGradientMid   = Color(0xFF0F1428);
  static const cardBorder        = Color(0xFF2A2048);
  static const cardGoldBorder    = Color(0xFF5A4210);

  // Category chart colors
  static const List<Color> chartColors = [
    Color(0xFFE8B84B), // 0 - Makan
    Color(0xFF00D4AA), // 1 - Transport
    Color(0xFFFF7B54), // 2 - Belanja
    Color(0xFFAD7BFF), // 3 - Hiburan
    Color(0xFF54AEFF), // 4 - Kesehatan
    Color(0xFF3DE0A4), // 5 - Tagihan
    Color(0xFFF06292), // 6 - Pendidikan
    Color(0xFFFFB341), // 7 - Bensin
    Color(0xFF64B5F6), // 8 - Game
    Color(0xFFFF8A65), // 9 - Lainnya
  ];

  static Color getCategoryColor(String category, List<String> allCategories) {
    final idx = allCategories.indexOf(category);
    if (idx < 0) return chartColors[0];
    return chartColors[idx % chartColors.length];
  }

  static Color categoryColor(String cat, int index) {
    return chartColors[index % chartColors.length];
  }

  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: surface,
      background: bg,
      error: danger,
    ),
    textTheme: GoogleFonts.soraTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: surface,
      foregroundColor: textPrimary,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: surfaceHigh,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: border, width: 1),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.black,
      elevation: 12,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceGlass,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textSecondary),
      hintStyle: const TextStyle(color: textMuted),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textMuted,
    ),
    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 1,
    ),
  );
}

class AppIcons {
  static const categoryIcons = {
    'Makan'      : 'assets/icons/food.png',
    'Transport'  : 'assets/icons/transport.png',
    'Belanja'    : 'assets/icons/shopping.png',
    'Hiburan'    : 'assets/icons/entertainment.png',
    'Kesehatan'  : 'assets/icons/health.png',
    'Tagihan'    : 'assets/icons/bill.png',
    'Pendidikan' : 'assets/icons/education.png',
    'Bensin'     : 'assets/icons/fuel.png',
    'Game'       : 'assets/icons/game.png',
    'Lainnya'    : 'assets/icons/other.png',
  };

  static String getIcon(String category) {
    return categoryIcons[category] ?? 'assets/icons/category.png';
  }
}
