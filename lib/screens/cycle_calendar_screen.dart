// 28

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';


class CycleCalendarScreen extends StatefulWidget {
  const CycleCalendarScreen({super.key});

  @override
  State<CycleCalendarScreen> createState() => _CycleCalendarScreenState();
}

class _CycleCalendarScreenState extends State<CycleCalendarScreen> {
  bool _pauseTracking = false;

  // Logged/predicted period days.
  static const Set<int> _periodDays = {10, 11, 12, 13, 14};
  // "Today" marker.
  static const int _todayDay = 16;
  static const int _daysInGrid = 28;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                'Cycle Calendar View',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'Full predictive / logged cycle calendar.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // Calendar card
              _CalendarCard(
                periodDays: _periodDays,
                todayDay: _todayDay,
                daysInGrid: _daysInGrid,
              ),
              const SizedBox(height: 32),

              // Pause tracking row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Pause Cycle Tracking',
                      style: GoogleFonts.jost(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkMocha,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _BrandSwitch(
                    value: _pauseTracking,
                    onChanged: (v) => setState(() => _pauseTracking = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                color: AppColors.warmGrey.withOpacity(0.3),
                height: 1,
                thickness: 0.5,
              ),
              const SizedBox(height: 16),

              // Footnote
              Text(
                "For pregnancy, postpartum, PCOS, or any reason a regular cycle "
                    "isn't active — pausing disables cycle-based correlations entirely.",
                style: GoogleFonts.jost(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.warmGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final Set<int> periodDays;
  final int todayDay;
  final int daysInGrid;

  const _CalendarCard({
    required this.periodDays,
    required this.todayDay,
    required this.daysInGrid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: daysInGrid,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 12,
          crossAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final day = index + 1;
          return _DayCell(
            day: day,
            isPeriodDay: periodDays.contains(day),
            isToday: day == todayDay,
          );
        },
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isPeriodDay;
  final bool isToday;

  const _DayCell({
    required this.day,
    required this.isPeriodDay,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final Color? bgColor = isPeriodDay ? AppColors.primaryAccent : null;
    final Color textColor =
    isPeriodDay ? AppColors.background : AppColors.darkMocha;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: AppColors.hoverTerracotta, width: 1)
            : null,
      ),
      child: Text(
        '$day',
        style: GoogleFonts.jost(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: textColor,
        ),
      ),
    );
  }
}

/// Custom switch matching the brand palette: ON = Dusty Rose track,
/// OFF = Warm Grey track, white thumb, smooth 0.3s ease slide.
class _BrandSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BrandSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColors.primaryAccent : AppColors.warmGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}