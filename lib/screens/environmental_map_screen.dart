// 19

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class EnvironmentalMapScreen extends StatelessWidget {
  const EnvironmentalMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Title
              Text(
                'Environmental Map',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                "Lets her verify the app's environmental claims herself.",
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              /// Map Placeholder
              Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.map_outlined,
                    size: 36,
                    color: AppColors.luxuryDetail,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Caption
              Text(
                'AQI history for your pin code, plotted against logged skin states.',
                style: AppTypography.caption,
              ),

              const SizedBox(height: 24),

              /// Information Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Degraded state: "We don\'t have reliable air quality monitoring for your area yet, so we\'ve paused AQI-based insights rather than guess."',
                  style: AppTypography.body,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}