import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/aura_widget.dart';
import 'package:go_router/go_router.dart';

/// Screen 29 – Dormant State
/// The Resilience Loop's visual expression on the Home screen
/// after missed check-ins.
class DormantStateScreen extends StatelessWidget {
  const DormantStateScreen({super.key});

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
              // Aura in dormant state – dim, small, non‑breathing
              const AuraWidget(
                isBreathing: false,
                isDormant: true,
                opacity: 0.18,
                scale: 0.6,
              ),
              const SizedBox(height: 26),

              // Warm, forgiving copy
              Text(
                'Welcome back.\nThe garden missed the sun.',
                style: TextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              Text(
                'Let\'s breathe together.',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Call to action
              PrimaryButton(
                label: 'Check In',
                onPressed: () {
                  // Navigate to AM Check-in (Screen 9)
                  context.go(RouteNames.amCheckin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
