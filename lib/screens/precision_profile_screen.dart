// 20

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PrecisionProfileScreen extends StatelessWidget {
  const PrecisionProfileScreen({super.key});

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
                'The Precision Profile',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                'Read-only view of her original 47-variable scan.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              const PrecisionMetricCard(
                title: 'Hydration Index',
                score: 72,
              ),

              const SizedBox(height: 20),

              const PrecisionMetricCard(
                title: 'Barrier Function',
                score: 72,
              ),

              const SizedBox(height: 20),

              const PrecisionMetricCard(
                title: 'Sebum Balance',
                score: 72,
              ),

              const SizedBox(height: 20),

              const PrecisionMetricCard(
                title: 'Sensitivity Score',
                score: 72,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class PrecisionMetricCard extends StatelessWidget {
  final String title;
  final int score;

  const PrecisionMetricCard({
    super.key,
    required this.title,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    const double progress = 0.72;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.h3,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryAccent.withOpacity(.35),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '$score / 100',
                  style: AppTypography.body,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(
                AppColors.luxuryDetail,
              ),
            ),
          ),
        ],
      ),
    );
  }
}