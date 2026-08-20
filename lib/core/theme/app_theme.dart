
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(primary: AppColors.primary, secondary: AppColors.secondary, surface: AppColors.surfaceLight, background: AppColors.lightBg),
    textTheme: GoogleFonts.tajawalTextTheme(ThemeData.light().textTheme),
    cardTheme: CardTheme(color: AppColors.surfaceLight, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
  );
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(primary: AppColors.primary, secondary: AppColors.secondary, surface: AppColors.surfaceDark, background: AppColors.darkBg),
    textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardTheme(color: AppColors.surfaceDark, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
  );
}
