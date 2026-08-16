import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class TextStyles {
  static final displayLarge = GoogleFonts.playfairDisplay(
    fontSize: AppSizes.fontDisplay,
    fontWeight: FontWeight.w300,
    color: AppColors.mocha,
    height: 1.15,
  );

  static final displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w400,
    color: AppColors.mocha,
    height: 1.2,
  );

  static final displaySmall = GoogleFonts.playfairDisplay(
    fontSize: 21,
    fontWeight: FontWeight.w300,
    color: AppColors.mocha,
    height: 1.25,
  );

  static final headlineMedium = GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.mocha,
    height: 1.3,
  );

  static final titleLarge = GoogleFonts.playfairDisplay(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.mocha,
    height: 1.3,
  );

  static final bodyMedium = GoogleFonts.jost(
    fontSize: AppSizes.fontBody,
    fontWeight: FontWeight.w300,
    color: AppColors.mauve,
    height: 1.55,
  );

  static final bodySmall = GoogleFonts.jost(
    fontSize: AppSizes.fontSmall,
    fontWeight: FontWeight.w300,
    color: AppColors.grey,
    height: 1.5,
  );

  static final labelSmall = GoogleFonts.jost(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 5,
    color: AppColors.gold,
    height: 1.4,
  );

  static final quote = GoogleFonts.cormorantGaramond(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: AppColors.rose,
    height: 1.4,
  );

  static final eyebrow = GoogleFonts.jost(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 5,
    color: AppColors.gold,
  );
}
