import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';

class CycleBaselineScreen extends ConsumerStatefulWidget {
  const CycleBaselineScreen({super.key});

  @override
  ConsumerState<CycleBaselineScreen> createState() =>
      _CycleBaselineScreenState();
}

class _CycleBaselineScreenState extends ConsumerState<CycleBaselineScreen> {
  int? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    ref.listen<OnboardingState>(onboardingProvider, (previous, next) {
      if (next.error == null && previous?.isLoading == true && !next.isLoading) {
        context.go(RouteNames.wearableConnection);
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Cycle Baseline')),
      body: onboardingState.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.rose),
                  SizedBox(height: 16),
                  Text('Saving your baseline...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'If you\'d like, this helps us notice patterns tied to your cycle.',
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  RareCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LAST PERIOD START DATE',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: 28,
                          itemBuilder: (context, index) {
                            final day = index + 1;
                            final isSelected = _selectedDay == day;
                            final isToday = day == 14;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedDay = day);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isSelected ? AppColors.rose : AppColors.linen,
                                  borderRadius: BorderRadius.circular(6),
                                  border: isToday
                                      ? Border.all(color: AppColors.terracotta)
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? AppColors.cream
                                          : AppColors.mauve,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Save Baseline',
                    onPressed: _selectedDay == null
                        ? null
                        : () async {
                            final now = DateTime.now();
                            final selectedDate =
                                DateTime(now.year, now.month, _selectedDay!);
                            await ref
                                .read(onboardingProvider.notifier)
                                .saveCycleBaseline({
                              'last_period_start':
                                  selectedDate.toIso8601String(),
                              'cycle_length': 28,
                              'period_length': 5,
                            });
                          },
                  ),
                  const SizedBox(height: 8),
                  GhostButton(
                    label: 'Skip — I\'ll set this up later',
                    onPressed: () async {
                      await ref
                          .read(onboardingProvider.notifier)
                          .updateStep(5, data: {
                        'cycle_baseline_skipped': true,
                      });
                      if (context.mounted) {
                        context.go(RouteNames.wearableConnection);
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
