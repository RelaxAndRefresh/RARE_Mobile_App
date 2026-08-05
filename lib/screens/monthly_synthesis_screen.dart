// 16

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class MonthlySynthesisScreen extends StatelessWidget {
  const MonthlySynthesisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 18),

                  Text(
                    "Monthly Synthesis",
                    style: AppTypography.h1,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Deeper N:N correlations — extra-cautious copy given\nhigher spurious-correlation risk.",
                    style: AppTypography.body,
                  ),

                  const SizedBox(height: 36),

                  /// High Confidence Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HIGH·CONFIDENCE",
                          style: AppTypography.eyebrow.copyWith(
                            color: AppColors.primaryAccent,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          "On mornings after coffee past 2pm,\nyou've rated your sleep lower about\n70% of the time.",
                          style: AppTypography.h1.copyWith(
                            fontSize: 21,
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Though your cycle also starts tomorrow, which might be a factor.",
                          style: AppTypography.body.copyWith(
                            color: AppColors.bodyMauve,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: List.generate(
                            5,
                                (index) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 28,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.luxuryDetail,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Empty State Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'Empty state: "No deep patterns surfaced this month. Sometimes that\'s the answer — your variables aren\'t strongly connected right now. We\'ll keep watching."',
                      style: AppTypography.body.copyWith(
                        color: AppColors.bodyMauve,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Bottom-right Next Button

          ],
        ),
      ),
    );
  }
}