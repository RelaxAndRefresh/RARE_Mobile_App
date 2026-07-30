import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// RARE Brand Bible — Typography System
class AppTypography {
  // Display: Playfair Display 300 Light (62-72px)
  static TextStyle display = GoogleFonts.playfairDisplay(
    fontSize: 64,
    fontWeight: FontWeight.w300,
    color: AppColors.darkMocha,
    height: 1.1,
  );

  // H1: Playfair Display 400 Regular (48-54px)
  static TextStyle h1 = GoogleFonts.playfairDisplay(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: AppColors.darkMocha,
    height: 1.15,
  );

  // H2: Playfair Display 300 Light (36-42px)
  static TextStyle h2 = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w300,
    color: AppColors.darkMocha,
    height: 1.2,
  );

  // H3: Playfair Display 400 Regular (24-28px)
  static TextStyle h3 = GoogleFonts.playfairDisplay(
    fontSize: 26,
    fontWeight: FontWeight.w400,
    color: AppColors.darkMocha,
    height: 1.25,
  );

  // Eyebrow: Jost 400 Regular, 9px, ALL CAPS, +5px letter-spacing
  static TextStyle eyebrow = GoogleFonts.jost(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    letterSpacing: 5.0,
    color: AppColors.luxuryDetail,
  );

  // Body: Jost 300 Light, 13-15px, #7A4A4A (Mauve)
  static TextStyle body = GoogleFonts.jost(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.bodyMauve,
    height: 1.5,
  );

  // Caption: Jost 300 Light, 11px, #B09080
  static TextStyle caption = GoogleFonts.jost(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: AppColors.warmGrey,
  );

  // Quote: Cormorant Garamond 300 Italic, 22-26px, #C9897A
  static TextStyle quote = GoogleFonts.cormorantGaramond(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: AppColors.primaryAccent,
    height: 1.3,
  );

  // Button Typography Base Rules
  static TextStyle buttonText = GoogleFonts.jost(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 3.0,
  );
}