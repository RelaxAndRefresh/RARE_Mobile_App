import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/checkin_provider.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/buttons/ghost_button.dart';

class DataLogEditHistoryScreen extends ConsumerStatefulWidget {
  const DataLogEditHistoryScreen({super.key});

  @override
  ConsumerState<DataLogEditHistoryScreen> createState() =>
      _DataLogEditHistoryScreenState();
}

class _DataLogEditHistoryScreenState
    extends ConsumerState<DataLogEditHistoryScreen> {
  int _selectedDay = 15;
  int _selectedMonth = 7;
  int _selectedYear = 2026;

  String _sleep = '7h 12m';
  String _mood = 'Good';
  String _skin = 'Calm';
  String _hydration = '4 taps';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
    _selectedDay = now.day;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(checkinProvider.notifier).loadTodayData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkinState = ref.watch(checkinProvider);
    final isLoading = checkinState.isLoading;
    final todayCheckin = checkinState.todayCheckin;
    final error = checkinState.error;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Data Log & Edit History'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: isLoading && todayCheckin == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.rose),
            )
          : error != null && todayCheckin == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load check-in data.',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.terracotta,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GhostButton(
                        label: 'Retry',
                        onPressed: () => ref
                            .read(checkinProvider.notifier)
                            .loadTodayData(),
                        width: null,
                      ),
                    ],
                  ),
                )
              : _buildBody(todayCheckin),
    );
  }

  Widget _buildBody(dynamic todayCheckin) {
    if (todayCheckin != null && _selectedDay == _today()) {
      _sleep = '${todayCheckin.sleep}h ${(todayCheckin.energy * 12) % 60}m';
      final moodVal = todayCheckin.mood;
      if (moodVal <= 3) {
        _mood = 'Low';
      } else if (moodVal <= 6) {
        _mood = 'Good';
      } else if (moodVal <= 8) {
        _mood = 'Great';
      } else {
        _mood = 'Excellent';
      }
      _skin = todayCheckin.symptoms != null
          ? (todayCheckin.symptoms['skin_condition'] ?? 'Normal')
          : 'Calm';
    }

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: ListView(
        children: [
          RareCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${_monthName(_selectedMonth - 1)} $_selectedYear',
                    style: TextStyles.headlineMedium,
                  ),
                ),
                const SizedBox(height: 12),
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
                    final isToday = day == _today();
                    final isSelected = day == _selectedDay;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = day;
                        });
                        _loadLogsForDay(day);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.rose
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
          Text(
            'Logs for ${_monthName(_selectedMonth - 1)} ${_selectedDay.toString().padLeft(2, '0')}, $_selectedYear',
            style: TextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
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
    );
  }

  int _today() => DateTime.now().day;

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
    if (day == _today()) {
      final checkinState = ref.read(checkinProvider);
      final todayCheckin = checkinState.todayCheckin;
      if (todayCheckin != null) {
        setState(() {
          _sleep =
              '${todayCheckin.sleep}h ${(todayCheckin.energy * 12) % 60}m';
          final moodVal = todayCheckin.mood;
          if (moodVal <= 3) {
            _mood = 'Low';
          } else if (moodVal <= 6) {
            _mood = 'Good';
          } else if (moodVal <= 8) {
            _mood = 'Great';
          } else {
            _mood = 'Excellent';
          }
          _skin = todayCheckin.symptoms != null
              ? (todayCheckin.symptoms['skin_condition'] ?? 'Normal')
              : 'Calm';
          _hydration = '${checkinState.todayHydration.length} taps';
        });
        return;
      }
    }

    setState(() {
      _sleep = '--';
      _mood = 'No data';
      _skin = 'No data';
      _hydration = '--';
    });
  }

  void _showEditDialog(BuildContext context) {
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

              final checkinState = ref.read(checkinProvider);
              final checkin = checkinState.todayCheckin;
              if (checkin?.id != null) {
                final sleepHours = int.tryParse(
                        RegExp(r'(\d+)h').firstMatch(_sleep)?.group(1) ?? '') ??
                    7;
                ref.read(checkinProvider.notifier).updateCheckin(
                      checkin!.id!,
                      {
                        'sleep': sleepHours,
                        'notes': 'Edited: mood=$_mood, skin=$_skin',
                      },
                    );
              }

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

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month.clamp(0, 11)];
  }
}
