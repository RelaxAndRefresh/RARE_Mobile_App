import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.cream,
      primaryColor: AppColors.rose,
      hintColor: AppColors.gold,
      colorScheme: const ColorScheme.light(
        primary: AppColors.rose,
        secondary: AppColors.gold,
        background: AppColors.cream,
        surface: AppColors.linen,
        error: AppColors.error,
      ),
      fontFamily: 'Jost',
      textTheme: TextTheme(
        displayLarge: TextStyles.displayLarge,
        displayMedium: TextStyles.displayMedium,
        displaySmall: TextStyles.displaySmall,
        headlineMedium: TextStyles.headlineMedium,
        titleLarge: TextStyles.titleLarge,
        bodyMedium: TextStyles.bodyMedium,
        bodySmall: TextStyles.bodySmall,
        labelSmall: TextStyles.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.mocha,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyles.headlineMedium,
        iconTheme: const IconThemeData(color: AppColors.mocha),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mocha,
          foregroundColor: AppColors.cream,
          textStyle: const TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.w400,
            fontSize: 10,
            letterSpacing: 3,
          ),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mocha,
          side: const BorderSide(color: AppColors.gold, width: 0.5),
          textStyle: const TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.w400,
            fontSize: 10,
            letterSpacing: 3,
          ),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: const BorderSide(color: AppColors.rose),
        ),
        hintStyle: TextStyles.bodySmall.copyWith(color: AppColors.grey),
      ),
    );
  }
}
