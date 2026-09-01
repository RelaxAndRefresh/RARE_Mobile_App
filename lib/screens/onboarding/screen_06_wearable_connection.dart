import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';

class WearableConnectionScreen extends ConsumerWidget {
  const WearableConnectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    ref.listen<OnboardingState>(onboardingProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Wearable Connection')),
      body: onboardingState.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.rose),
                  SizedBox(height: 16),
                  Text('Connecting device...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pair your devices.', style: TextStyles.displayMedium),
                  const SizedBox(height: 8),
                  Text(
                    'No wearable? RARE works just as well without one.',
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  RareCard(
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: AppColors.rose),
                        const SizedBox(width: 8),
                        const Text(
                          'Apple Health',
                          style:
                              TextStyle(fontSize: 13, color: AppColors.mocha),
                        ),
                        const Spacer(),
                        GhostButton(
                          label: 'Connect',
                          onPressed: () async {
                            await ref
                                .read(onboardingProvider.notifier)
                                .connectWearable(
                              provider: 'apple_health',
                              deviceId: 'apple_health_device',
                            );
                            if (context.mounted) {
                              context.go(RouteNames.auraAwakening);
                            }
                          },
                          width: null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RareCard(
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: AppColors.rose),
                        const SizedBox(width: 8),
                        const Text(
                          'Google Fit',
                          style:
                              TextStyle(fontSize: 13, color: AppColors.mocha),
                        ),
                        const Spacer(),
                        GhostButton(
                          label: 'Connect',
                          onPressed: () async {
                            await ref
                                .read(onboardingProvider.notifier)
                                .connectWearable(
                              provider: 'google_fit',
                              deviceId: 'google_fit_device',
                            );
                            if (context.mounted) {
                              context.go(RouteNames.auraAwakening);
                            }
                          },
                          width: null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No wearable? Totally fine — manual logging covers everything RARE needs.',
                    style: TextStyles.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  GhostButton(
                    label: 'Skip for now',
                    onPressed: () async {
                      await ref
                          .read(onboardingProvider.notifier)
                          .updateStep(6, data: {
                        'wearable_skipped': true,
                      });
                      if (context.mounted) {
                        context.go(RouteNames.auraAwakening);
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
