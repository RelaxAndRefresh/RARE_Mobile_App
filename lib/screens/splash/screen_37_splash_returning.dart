import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/common/aura_widget.dart';
import 'package:go_router/go_router.dart';

/// Screen 37 – Splash & Returning User Login
/// Checks for an existing session token on launch.
/// Two re‑auth paths: OAuth for linked accounts, Local Biometric Auth for
/// anonymous users. New device → Create Account.
class SplashReturningScreen extends StatelessWidget {
  const SplashReturningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Aura – dim and small
              const AuraWidget(
                isBreathing: false,
                opacity: 0.5,
                scale: 0.8,
              ),
              const SizedBox(height: 24),

              // Welcome back heading
              Text(
                'Welcome back',
                style: TextStyles.displayMedium,
              ),
              const SizedBox(height: 8),

              // Web-linked account path
              Text(
                'Web-linked account → OAuth webview bridge.',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // OAuth button
              PrimaryButton(
                label: 'Continue with OAuth',
                onPressed: () {
                  // Navigate to home (simulate successful auth)
                  context.go(RouteNames.home);
                },
              ),
              const SizedBox(height: 20),

              // Anonymous user path
              Text(
                'Anonymous user → Local Biometric Auth (FaceID / TouchID) instead.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Biometric button
              GhostButton(
                label: 'Unlock with Face ID',
                onPressed: () {
                  // Simulate biometric success
                  context.go(RouteNames.home);
                },
              ),
              const SizedBox(height: 20),

              // New device path
              Text(
                'New device, no local profile → ',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Create Account button
              GhostButton(
                label: 'Create Account',
                onPressed: () {
                  // Navigate to onboarding welcome (Screen 1)
                  context.go(RouteNames.welcome);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
