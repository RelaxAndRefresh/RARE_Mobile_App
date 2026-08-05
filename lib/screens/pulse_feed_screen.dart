//17

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class RarePulseFeedScreen extends StatelessWidget {
  const RarePulseFeedScreen({super.key});

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
                'RARE Pulse Feed',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                'Aggregate market data only — never a personal diagnosis.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              const _PulseCard(
                text:
                '4,200 women with your Precision Profile restocked this serum.',
              ),

              const SizedBox(height: 20),

              const _PulseCard(
                text:
                'Trending across RARE members this month — barrier-repair rituals.',
              ),

              const SizedBox(height: 24),

              Text(
                'Below the 100-user segment threshold, profile-specific cards are suppressed in favor of broader trends — a lone "1 woman like you" number would isolate rather than reassure.',
                style: AppTypography.caption,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulseCard extends StatelessWidget {
  final String text;

  const _PulseCard({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTypography.h3,
      ),
    );
  }
}