import 'package:flutter/material.dart';
import 'monthly_synthesis_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class InsightsBiweekScreen extends StatelessWidget {
  const InsightsBiweekScreen({super.key});

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
                    "Biweekly Wrapped",
                    style: AppTypography.h1,
                  ),

                  const SizedBox(height: 22),

                  Text(
                    "14-day summary — staged epistemics, Pulse kept\nvisually separate.",
                    style: AppTypography.body,
                  ),

                  const SizedBox(height: 36),

                  /// Correlation Card
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
                          "CORRELATION",
                          style: AppTypography.eyebrow.copyWith(
                            color: AppColors.primaryAccent,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          "There's a pattern forming between\nlate coffees and restless mornings.",
                          style: AppTypography.h1.copyWith(
                            fontSize: 22,
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: 26),

                        Row(
                          children: List.generate(
                            3,
                                (index) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 30,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.luxuryDetail,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Pulse Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.darkMocha,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RARE PULSE",
                          style: AppTypography.eyebrow.copyWith(
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "4,200 women with your Precision Profile restocked this serum this month.",
                          style: AppTypography.body.copyWith(
                            color: Colors.white,
                            height: 1.6,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Floating Next Button
            Positioned(
              bottom: 24,
              right: 24,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MonthlySynthesisScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.darkMocha,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}