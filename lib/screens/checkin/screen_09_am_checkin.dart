import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/chip_tag.dart';
import '../../providers/checkin_provider.dart';
import 'package:go_router/go_router.dart';

class AMCheckinScreen extends ConsumerStatefulWidget {
  const AMCheckinScreen({super.key});

  @override
  ConsumerState<AMCheckinScreen> createState() => _AMCheckinScreenState();
}

class _AMCheckinScreenState extends ConsumerState<AMCheckinScreen> {
  double mood = 0.65;
  double sleepHours = 7.2;
  bool sleepConfirmed = false;
  final List<String> selectedTags = [];
  final List<String> availableTags = ['Sick', 'Travel', 'Stress'];

  @override
  void initState() {
    super.initState();
    ref.read(checkinProvider.notifier).loadTodayData();
  }

  @override
  Widget build(BuildContext context) {
    final checkinState = ref.watch(checkinProvider);
    final isSubmitting = checkinState.isLoading;
    final hasCheckin = checkinState.todayCheckin != null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Good morning')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RareCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SLEEP — INFERRED FROM PHONE STILLNESS',
                        style: TextStyle(fontSize: 11, color: AppColors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hasCheckin
                            ? '${checkinState.todayCheckin!.sleep}h — sound about right?'
                            : '${sleepHours.toStringAsFixed(1)}h — sound about right?',
                        style: TextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GhostButton(
                              label: 'Yes',
                              onPressed: () {
                                setState(() => sleepConfirmed = true);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GhostButton(
                              label: 'Adjust',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                RareCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MOOD',
                        style: TextStyle(fontSize: 11, color: AppColors.grey),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: mood,
                        onChanged: (val) => setState(() => mood = val),
                        activeColor: AppColors.rose,
                        inactiveColor: AppColors.linen,
                      ),
                      Text(
                        mood < 0.3
                            ? 'Low'
                            : mood < 0.6
                                ? 'Okay'
                                : mood < 0.85
                                    ? 'Good'
                                    : 'Great',
                        style: TextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                RareCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CONTEXT (OPTIONAL)',
                        style: TextStyle(fontSize: 11, color: AppColors.grey),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        children: availableTags.map((tag) {
                          return ChipTag(
                            label: tag,
                            selected: selectedTags.contains(tag),
                            onTap: () {
                              setState(() {
                                if (selectedTags.contains(tag)) {
                                  selectedTags.remove(tag);
                                } else {
                                  selectedTags.add(tag);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: isSubmitting ? 'Saving...' : 'Save & Return to Home',
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final data = {
                            'checkin_type': 'am',
                            'mood': (mood * 10).round(),
                            'energy': (mood * 10).round(),
                            'sleep': sleepHours.round(),
                            'symptoms': {
                              'tags': selectedTags,
                              'sleep_confirmed': sleepConfirmed,
                            },
                          };
                          await ref
                              .read(checkinProvider.notifier)
                              .submitAMCheckin(data);
                          if (!mounted) return;
                          final error = ref.read(checkinProvider).error;
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Something went off. Please try again.'),
                                backgroundColor: AppColors.terracotta,
                              ),
                            );
                            ref.read(checkinProvider.notifier).clearError();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Check-in saved.'),
                                backgroundColor: AppColors.mocha,
                              ),
                            );
                            context.go(RouteNames.home);
                          }
                        },
                ),
              ],
            ),
          ),
          if (isSubmitting)
            Container(
              color: AppColors.cream.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.rose),
              ),
            ),
        ],
      ),
    );
  }
}
