import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/toggle_row.dart';
import '../../widgets/cards/rare_card.dart';

/// Screen 25 – Settings & Notification Cadence
/// User-adjustable check-in timing, non-punitive mute/snooze.
/// Includes push permission fallback.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool amReminder = true;
  bool pmReminder = true;
  bool insightNudges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // AM toggle
            ToggleRow(
              title: 'AM Check-in reminder',
              value: amReminder,
              onChanged: (val) => setState(() => amReminder = val),
            ),
            // PM toggle
            ToggleRow(
              title: 'PM Check-in reminder',
              value: pmReminder,
              onChanged: (val) => setState(() => pmReminder = val),
            ),
            // Insight nudges toggle
            ToggleRow(
              title: 'Insight-ready nudges',
              value: insightNudges,
              onChanged: (val) => setState(() => insightNudges = val),
            ),
            const SizedBox(height: 20),
            // Push permission fallback card
            RareCard(
              child: Column(
                children: [
                  Text(
                    'Push permission was denied at the OS level.',
                    style: TextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Enable Push Notifications',
                    onPressed: () {
                      // Deep-link to OS settings – platform-specific.
                      // For now, show a snackbar or navigate to system settings.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Open system settings to enable notifications.'),
                          backgroundColor: AppColors.mocha,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
