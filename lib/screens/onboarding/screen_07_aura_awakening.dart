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

class AuraAwakeningScreen extends ConsumerWidget {
  const AuraAwakeningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuraWidget(isBreathing: true, opacity: 0.6),
              const SizedBox(height: 30),
              Text(
                'Meet your Aura.',
                style: TextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Right now, it\'s resting. Let\'s wake it up.',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Begin Your First Check-in',
                isLoading: onboardingState.isLoading,
                onPressed: onboardingState.isLoading
                    ? null
                    : () async {
                        await ref
                            .read(onboardingProvider.notifier)
                            .updateStep(7, data: {
                          'onboarding_completed': true,
                        });
                        if (context.mounted) {
                          context.go(RouteNames.amCheckin);
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
