import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Luxury dark theme configuration for VELINA.
class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryBackground,
      primaryColor: AppColors.luxuryGold,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.luxuryGold,
        secondary: AppColors.luxuryGold,
        surface: AppColors.darkCharcoal,
        onPrimary: AppColors.primaryBackground,
        onSurface: AppColors.pureWhite,
      ),
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.luxuryGold),
      ),
    );
  }
}
