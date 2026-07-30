import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class QuickLogScreen extends StatelessWidget {
  const QuickLogScreen({super.key});

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


              const SizedBox(height: 14),

              Text(
                "Quick Log",
                style: AppTypography.h1,
              ),

              const SizedBox(height: 18),

              Text(
                "True 1-tap chips — tap again for optional precision.",
                style: AppTypography.body,
              ),

              const SizedBox(height: 36),

              const _QuickLogCard(
                icon: Icons.water_drop_outlined,
                title: "Caffeine",
              ),

              const SizedBox(height: 24),

              const _QuickLogCard(
                icon: Icons.water_drop_outlined,
                title: "Alcohol",
              ),

              const SizedBox(height: 24),

              const _QuickLogCard(
                icon: Icons.bar_chart,
                title: "Energy",
              ),

              const SizedBox(height: 28),

              Text(
                "Time is inferred automatically — tap the entry again to adjust.",
                style: AppTypography.caption.copyWith(
                  color: AppColors.bodyMauve,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLogCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _QuickLogCard({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryAccent,
                  size: 30,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: AppTypography.h1.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Open detailed logging bottom sheet
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.primaryAccent.withOpacity(.7),
                    width: .8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "LOG",
                  style: AppTypography.buttonText.copyWith(
                    color: AppColors.darkMocha,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}