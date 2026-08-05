// 22

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';

class PlanMyReliefScreen extends StatelessWidget {
  const PlanMyReliefScreen({super.key});

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
                'Plan My Relief',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                'The unhurried booking trigger — reached only via a diagnostic insight tap.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              /// Booking Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 36,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Would a guided facial help with what you've been feeling?",
                      textAlign: TextAlign.center,
                      style: AppTypography.h2,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Based on your recent skin logs — no pressure, only if it feels right.",
                      textAlign: TextAlign.center,
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 32),

                    PrimaryButton(
                      text: 'SEE AVAILABLE SLOTS',
                      onPressed: () {
                        // TODO: Navigate to booking screen
                      },
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