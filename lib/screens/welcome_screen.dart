// 1


import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/ambient_circle.dart';
import '../widgets/primary_button.dart';
import 'soft_scan_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const AmbientCircle(size: 180),
              const SizedBox(height: 48),

              // Quote Style
              Text(
                'A new way\nof being known.',
                textAlign: TextAlign.center,
                style: AppTypography.quote,
              ),
              const SizedBox(height: 24),

              // Body Copy in Mauve
              Text(
                'No forms. No urgency. Just a quiet place\nto be understood, one day at a time.',
                textAlign: TextAlign.center,
                style: AppTypography.body,
              ),
              const SizedBox(height: 48),

              PrimaryButton(
                text: 'Begin',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SoftScanScreen(),
                    ),
                  );
                },
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}