import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  // Background colors
  static const bg = Color(0xFF121212);
  static const surface = Color(0xFF1E1E1E);
  static const surfaceHigh = Color(0xFF2A2A2A);
  static const border = Color(0xFF333333);

  // Primary colors
  static const primary = Color(0xFF00C853);
  static const primaryLight = Color(0xFF69F0AE);

  // Accent
  static const accent = Color(0xFF2979FF);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B0);
  static const textMuted = Color(0xFF808080);

  // Status colors
  static const success = Color(0xFF00E676);
  static const danger = Color(0xFFFF5252);

  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFF00C853), // 0 - Makan        → Hijau
    Color(0xFF2979FF), // 1 - Transport     → Biru
    Color(0xFFFFC107), // 2 - Belanja       → Kuning
    Color(0xFFFF5252), // 3 - Hiburan       → Merah
    Color(0xFF00BCD4), // 4 - Kesehatan     → Cyan
    Color(0xFF8BC34A), // 5 - Tagihan       → Hijau Muda
    Color(0xFF9C27B0), // 6 - Pendidikan    → Ungu
    Color(0xFFFF9800), // 7 - Bensin        → Orange
    Color(0xFF03A9F4), // 8 - Game          → Biru Muda
    Color(0xFFE91E63), // 9 - Lainnya       → Pink
  ];

  // Warna tetap berdasarkan nama kategori (tidak berubah tiap bulan)
  static Color getCategoryColor(String category, List<String> allCategories) {
    final idx = allCategories.indexOf(category);
    if (idx < 0) return chartColors[0];
    return chartColors[idx % chartColors.length];
  }

  static Color categoryColor(String cat, int index) {
    final colors = chartColors;
    return colors[index % colors.length];
  }

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        primaryColor: primary,

        colorScheme: const ColorScheme.dark(
          primary: primary,
          surface: surface,
          background: bg,
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
        ),

        cardTheme: CardThemeData(
          color: surface,
          elevation: 2,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceHigh,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: border),
          ),
        ),
      );
}

class AppIcons {
  static const categoryIcons = {
    'Makan': 'assets/icons/food.png',
    'Transport': 'assets/icons/transport.png',
    'Belanja': 'assets/icons/shopping.png',
    'Hiburan': 'assets/icons/entertainment.png',
    'Kesehatan': 'assets/icons/health.png',
    'Tagihan': 'assets/icons/bill.png',
    'Pendidikan': 'assets/icons/education.png',
    'Bensin': 'assets/icons/fuel.png',
    'Game': 'assets/icons/game.png',
    'Lainnya': 'assets/icons/other.png',
  };

  static String getIcon(String category) {
    return categoryIcons[category] ?? 'assets/icons/cateogory.png';
  }
}