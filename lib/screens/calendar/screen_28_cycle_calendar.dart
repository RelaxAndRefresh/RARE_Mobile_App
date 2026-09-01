import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/inputs/toggle_row.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';

class CycleCalendarScreen extends ConsumerStatefulWidget {
  const CycleCalendarScreen({super.key});

  @override
  ConsumerState<CycleCalendarScreen> createState() =>
      _CycleCalendarScreenState();
}

class _CycleCalendarScreenState extends ConsumerState<CycleCalendarScreen> {
  bool _isPaused = false;
  late int _currentMonth;
  late int _currentYear;
  List<int> _markedDays = [];
  int _today = 15;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = now.month - 1;
    _currentYear = now.year;
    _today = now.day;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider.notifier).loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final isLoading = onboardingState.isLoading;
    final error = onboardingState.error;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Cycle Calendar'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.rose),
            )
          : error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load cycle data.',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.terracotta,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GhostButton(
                        label: 'Retry',
                        onPressed: () =>
                            ref.read(onboardingProvider.notifier).loadProgress(),
                        width: null,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          '${_monthName(_currentMonth)} $_currentYear',
                          style: TextStyles.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RareCard(
                        child: GridView.builder(
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
                            final isMarked = _markedDays.contains(day);
                            final isToday = day == _today;

                            return Container(
                              decoration: BoxDecoration(
                                color: isMarked ? AppColors.rose : AppColors.linen,
                                borderRadius: BorderRadius.circular(6),
                                border: isToday
                                    ? Border.all(
                                        color: AppColors.terracotta, width: 1.5)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '$day',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMarked
                                        ? AppColors.cream
                                        : AppColors.mauve,
                                    fontWeight: isToday
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ToggleRow(
                        title: 'Pause Cycle Tracking',
                        subtitle:
                            'For pregnancy, postpartum, PCOS, or any reason a regular cycle isn\'t active — pausing disables cycle-based correlations entirely.',
                        value: _isPaused,
                        onChanged: (val) {
                          setState(() {
                            _isPaused = val;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isPaused
                                    ? 'Cycle tracking paused. We\'ll stop predicting and pattern-matching.'
                                    : 'Cycle tracking resumed.',
                              ),
                              backgroundColor: AppColors.mocha,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      if (_isPaused) ...[
                        const SizedBox(height: 12),
                        RareCard(
                          backgroundColor: AppColors.linen,
                          child: Column(
                            children: [
                              Text(
                                'Cycle tracking is paused. We\'ll stop predicting and pattern-matching until you resume.',
                                style: TextStyles.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              GhostButton(
                                label: 'Resume',
                                onPressed: () {
                                  setState(() {
                                    _isPaused = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Cycle tracking resumed.'),
                                      backgroundColor: AppColors.mocha,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _legendItem('Predicted / Logged', AppColors.rose),
                          const SizedBox(width: 16),
                          _legendItem('Today', AppColors.terracotta),
                          const SizedBox(width: 16),
                          _legendItem('Regular', AppColors.linen),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month.clamp(0, 11)];
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: color == AppColors.terracotta
                ? Border.all(color: AppColors.terracotta, width: 1.5)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyles.bodySmall.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
