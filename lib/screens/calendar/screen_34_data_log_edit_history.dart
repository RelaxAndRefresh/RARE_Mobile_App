import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/buttons/ghost_button.dart';

/// Screen 34 – Data Log & Edit History
/// Calendar view where users can tap any past day to see and edit
/// what was logged (sleep, mood, skin, hydration).
/// Edits are recorded as Edited events in the Routine Intervention Log.
class DataLogEditHistoryScreen extends StatefulWidget {
  const DataLogEditHistoryScreen({super.key});

  @override
  State<DataLogEditHistoryScreen> createState() =>
      _DataLogEditHistoryScreenState();
}

class _DataLogEditHistoryScreenState extends State<DataLogEditHistoryScreen> {
  // Simulated selected date
  int _selectedDay = 22;
  int _selectedMonth = 7; // July
  int _selectedYear = 2026;

  // Simulated log data for the selected day
  String _sleep = '7h 12m';
  String _mood = 'Good';
  String _skin = 'Calm';
  String _hydration = '4 taps';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Data Log & Edit History'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // Calendar grid
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month and year header
                  Center(
                    child: Text(
                      'July 2026',
                      style: TextStyles.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Calendar grid
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
                      final isToday = day == 15;
                      final isSelected = day == _selectedDay;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = day;
                          });
                          // In a real app, fetch logs for this day
                          _loadLogsForDay(day);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.rose
                                : isToday
                                    ? AppColors.linen
                                    : AppColors.linen,
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
                                color: isSelected
                                    ? AppColors.cream
                                    : AppColors.mauve,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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

            // Log details for selected day
            Text(
              'Logs for July ${_selectedDay.toString().padLeft(2, '0')}, 2026',
              style: TextStyles.headlineMedium,
            ),
            const SizedBox(height: 8),

            // Log entries
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _logRow('Sleep', _sleep),
                  const Divider(color: AppColors.divider),
                  _logRow('Mood', _mood),
                  const Divider(color: AppColors.divider),
                  _logRow('Skin', _skin),
                  const Divider(color: AppColors.divider),
                  _logRow('Hydration', _hydration),
                  const SizedBox(height: 8),
                  // Edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GhostButton(
                        label: 'Edit',
                        onPressed: () {
                          _showEditDialog(context);
                        },
                        width: null,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text(
              'Corrections are never silent — logged as an Edited event, original value preserved.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.mocha,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.mauve,
            ),
          ),
        ],
      ),
    );
  }

  void _loadLogsForDay(int day) {
    // In a real app, fetch logs from database
    // Simulate different data for different days
    setState(() {
      // Just update with some sample data based on the day
      final random = day % 3;
      switch (random) {
        case 0:
          _sleep = '6h 45m';
          _mood = 'Tired';
          _skin = 'Reactive';
          _hydration = '3 taps';
          break;
        case 1:
          _sleep = '8h 10m';
          _mood = 'Great';
          _skin = 'Calm';
          _hydration = '6 taps';
          break;
        default:
          _sleep = '7h 0m';
          _mood = 'Good';
          _skin = 'Dull';
          _hydration = '4 taps';
          break;
      }
    });
  }

  void _showEditDialog(BuildContext context) {
    // Simple edit dialog – in real app, this would have proper inputs
    TextEditingController sleepController = TextEditingController(text: _sleep);
    TextEditingController moodController = TextEditingController(text: _mood);
    TextEditingController skinController = TextEditingController(text: _skin);
    TextEditingController hydrationController =
        TextEditingController(text: _hydration);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: const Text(
          'Edit Logs',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            color: AppColors.mocha,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _editField('Sleep', sleepController),
              _editField('Mood', moodController),
              _editField('Skin', skinController),
              _editField('Hydration', hydrationController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _sleep = sleepController.text;
                _mood = moodController.text;
                _skin = skinController.text;
                _hydration = hydrationController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Logs updated. Edited event recorded in Intervention Log.'),
                  backgroundColor: AppColors.mocha,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppColors.rose),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            borderSide: const BorderSide(color: AppColors.rose),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
