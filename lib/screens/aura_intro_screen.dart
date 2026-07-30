import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';
import 'home_checkin_screen.dart';

class AuraIntroScreen extends StatelessWidget {
  const AuraIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Soft Gradient Orb / Aura Sphere
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE2A89B).withOpacity(0.9), // Darker center
                      const Color(0xFFF3D2C9).withOpacity(0.6), // Soft mid tone
                      AppColors.background.withOpacity(0.0),    // Blends into background
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title: "She's awake."
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTypography.h1.copyWith(
                    fontSize: 26,
                    color: AppColors.darkMocha,
                  ),
                  children: const [
                    TextSpan(text: "She's "),
                    TextSpan(
                      text: "awake.",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFFC08B7E), // Soft terracotta accent
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Description Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Your Aura reflects how you're really doing — no streaks, no pressure, just a quiet mirror.",
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.bodyMauve,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Primary Action CTA
              PrimaryButton(
                text: 'BEGIN YOUR FIRST CHECK-IN',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeCheckinScreen(),
                    ),
                  );
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}