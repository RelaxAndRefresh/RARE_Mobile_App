import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/inputs/toggle_row.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';

/// Screen 28 – Cycle Calendar View
/// Full predictive/logged cycle calendar with pause toggle.
class CycleCalendarScreen extends StatefulWidget {
  const CycleCalendarScreen({super.key});

  @override
  State<CycleCalendarScreen> createState() => _CycleCalendarScreenState();
}

class _CycleCalendarScreenState extends State<CycleCalendarScreen> {
  bool _isPaused = false;
  final int _currentMonth = 7; // July (0-indexed, 0=January)
  final int _currentYear = 2026;

  // Simulated marked days (index 10-14 are marked, day 15 is today)
  final List<int> _markedDays = [10, 11, 12, 13, 14];
  final int _today = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Cycle Calendar'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // Month and year header
            Center(
              child: Text(
                '${_monthName(_currentMonth)} ${_currentYear}',
                style: TextStyles.headlineMedium,
              ),
            ),
            const SizedBox(height: 16),

            // Calendar grid
            RareCard(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: 28, // Simulated 28-day cycle
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isMarked = _markedDays.contains(day);
                  final isToday = day == _today;

                  return Container(
                    decoration: BoxDecoration(
                      color: isMarked ? AppColors.rose : AppColors.linen,
                      borderRadius: BorderRadius.circular(6),
                      border: isToday
                          ? Border.all(color: AppColors.terracotta, width: 1.5)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 10,
                          color: isMarked ? AppColors.cream : AppColors.mauve,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Pause toggle
            ToggleRow(
              title: 'Pause Cycle Tracking',
              subtitle:
                  'For pregnancy, postpartum, PCOS, or any reason a regular cycle isn\'t active — pausing disables cycle-based correlations entirely.',
              value: _isPaused,
              onChanged: (val) {
                setState(() {
                  _isPaused = val;
                });
                // In a real app, persist the state and update the synthesis engine.
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

            // Resume button (only shown when paused)
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
                        // In a real app, persist the state.
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

            // Legend
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
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
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
