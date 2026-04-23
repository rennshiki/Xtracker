import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  // Background & Surface
  // Sebelum: #121212 (pure black)
  static const bg          = Color(0xFF0D0F14);
  // Sebelum: #1E1E1E
  static const surface     = Color(0xFF161A23);
  // Sebelum: #2A2A2A
  static const surfaceHigh = Color(0xFF1E2330);
  // Sebelum: #333333
  static const border      = Color(0xFF252B3B);

  // Primary
  // Sebelum: #00C853 (hijau neon)
  static const primary      = Color(0xFF7C6FF7);
  // Sebelum: #69F0AE (hijau muda)
  static const primaryLight = Color(0xFFAFA6FC);

  // Accent
  // Sebelum: #2979FF (biru terang)
  static const accent = Color(0xFF38C7B0);

  // Text
  // Sebelum: #FFFFFF (pure white)
  static const textPrimary   = Color(0xFFF0F2F8);
  // Sebelum: #B0B0B0
  static const textSecondary = Color(0xFF8B93A8);
  // Sebelum: #808080
  static const textMuted     = Color(0xFF4E5568);

  // Status
  // Sebelum: #00E676 (neon green)
  static const success = Color(0xFF34D399);
  // Sebelum: #FF5252 (merah terang)
  static const danger  = Color(0xFFF87171);

  // Gradient kartu total pengeluaran
  // Sebelum: hardcoded di dashboard_screen.dart sebagai Color(0xFF2D1F6E) & Color(0xFF1A1230)
  static const cardGradientStart = Color(0xFF1E1852);
  static const cardGradientEnd   = Color(0xFF0F0D2E);
  // Sebelum: hardcoded Color(0xFF3D2A8A)
  static const cardBorder        = Color(0xFF342D7A);

  // Warna chart per kategori
  // Sebelum: semua warna neon (hijau, biru terang, kuning keras, dll)
  static const List<Color> chartColors = [
    Color(0xFF7C6FF7), // 0 - Makan        → Violet
    Color(0xFF38C7B0), // 1 - Transport     → Teal
    Color(0xFFF5A623), // 2 - Belanja       → Amber
    Color(0xFFF87171), // 3 - Hiburan       → Coral
    Color(0xFF60AFFE), // 4 - Kesehatan     → Sky blue
    Color(0xFF34D399), // 5 - Tagihan       → Emerald
    Color(0xFFB17AF7), // 6 - Pendidikan    → Lavender
    Color(0xFFFB923C), // 7 - Bensin        → Orange
    Color(0xFF4DB8E8), // 8 - Game          → Cerulean Fang
    Color(0xFFF472B6), // 9 - Lainnya       → Soft pink
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

    textTheme: GoogleFonts.dmSansTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),

    useMaterial3: true,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: surface,
      foregroundColor: textPrimary,
      surfaceTintColor: Colors.transparent,
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: border, width: 1),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 8,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceHigh,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
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
    return categoryIcons[category] ?? 'assets/icons/cateogory.png';
  }
}