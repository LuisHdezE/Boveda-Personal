import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.wealth,
          brightness: Brightness.dark,
          surface: AppColors.surface,
          error: AppColors.expense,
        ).copyWith(
          primary: AppColors.wealth,
          secondary: AppColors.information,
          tertiary: AppColors.income,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          surfaceContainerLowest: AppColors.surfaceLowest,
          surfaceContainerLow: AppColors.surfaceLow,
          surfaceContainer: AppColors.surface,
          surfaceContainerHigh: AppColors.surfaceHigh,
          surfaceContainerHighest: AppColors.surfaceHighest,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 57,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.02 * 57,
          height: 64 / 57,
          color: AppColors.onSurface,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 40 / 32,
          color: AppColors.onSurface,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          height: 28 / 22,
          color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 24 / 16,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          color: AppColors.onSurface,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 20 / 14,
          color: AppColors.onSurface,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 16 / 12,
          color: AppColors.onSurface,
        ),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      visualDensity: VisualDensity.standard,
    );
  }
}
