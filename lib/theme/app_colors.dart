import 'package:flutter/material.dart';

/// RARE Brand Bible — Color System
class AppColors {
  // Dominant & Surface
  static const Color background = Color(0xFFFAF4EE); // Warm Cream (75% dominant)
  static const Color cardSurface = Color(0xFFF2DDD5); // Blush Linen

  // Primary Accents & Depth
  static const Color primaryAccent = Color(0xFFC9897A); // Dusty Rose
  static const Color luxuryDetail = Color(0xFFD4AF7A); // Champagne Gold (Max 3 uses per page)
  static const Color hoverTerracotta = Color(0xFFA4594A); // Terracotta (Hover & Focus)

  // Typography Palette
  static const Color darkMocha = Color(0xFF2E1A1A); // Headings, Footer, Primary Button BG
  static const Color bodyMauve = Color(0xFF7A4A4A); // Paragraph Body Copy (NEVER Dark Mocha)
  static const Color warmGrey = Color(0xFFB09080); // Captions & Small Labels

  // Ambient Circle Radial Gradient
  static const List<Color> circleGradient = [
    Color(0xFFF2DDD5),
    Color(0xFFFAF4EE),
  ];
}