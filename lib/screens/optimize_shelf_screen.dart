// 21

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';

class OptimizeShelfScreen extends StatelessWidget {
  const OptimizeShelfScreen({super.key});

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
                'Optimize My Shelf',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                'Reached only via an explicit Contextual Reveal tap — never pushed.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              /// Contextual Reveal Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'CONTEXTUAL REVEAL',
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Would you like to optimize your shelf with a\nBarrier Repair Serum?',
                      textAlign: TextAlign.center,
                      style: AppTypography.h3,
                    ),

                    const SizedBox(height: 36),

                    PrimaryButton(
                      text: 'YES, SHOW ME',
                      onPressed: () {
                        // TODO: Navigate to optimized shelf
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Browser Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Browser Header
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 5,
                          backgroundColor: AppColors.warmGrey,
                        ),
                        const SizedBox(width: 6),
                        const CircleAvatar(
                          radius: 5,
                          backgroundColor: AppColors.warmGrey,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'relaxedandrefresh.com',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Text(
                      'Anonymous-user intercept: '
                          '"To buy this, you\'ll need to connect your RARE account first." '
                          '→ [Connect Account] / [Cancel]',
                      style: AppTypography.body,
                    ),

                    const SizedBox(height: 24),

                    Divider(
                      color: AppColors.primaryAccent.withOpacity(.20),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Offline intercept: '
                          '"The RARE shop needs a connection to browse. '
                          'Let\'s try again in a moment."',
                      style: AppTypography.body,
                    ),
                  ],
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