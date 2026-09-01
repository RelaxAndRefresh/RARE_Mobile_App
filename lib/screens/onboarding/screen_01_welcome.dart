import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/aura_widget.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuraWidget(isBreathing: false, opacity: 0.3, scale: 0.9),
              const SizedBox(height: 36),
              Text(
                'A new way\nof being known.',
                style: TextStyles.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Text(
                'A note left on a pillow.',
                style: TextStyles.quote,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              PrimaryButton(
                label: 'Begin →',
                isLoading: onboardingState.isLoading,
                onPressed: onboardingState.isLoading
                    ? null
                    : () async {
                        await ref
                            .read(onboardingProvider.notifier)
                            .updateStep(1);
                        if (context.mounted) {
                          context.go(RouteNames.softScan);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
