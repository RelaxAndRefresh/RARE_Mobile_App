import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/toggle_row.dart';
import '../../widgets/cards/rare_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool amReminder = true;
  bool pmReminder = true;
  bool insightNudges = false;
  bool _pushPermissionGranted = true;

  @override
  void initState() {
    super.initState();
    _checkPushPermission();
  }

  Future<void> _checkPushPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _pushPermissionGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);

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
            ToggleRow(
              title: 'AM Check-in reminder',
              value: amReminder,
              onChanged: (val) => setState(() => amReminder = val),
            ),
            ToggleRow(
              title: 'PM Check-in reminder',
              value: pmReminder,
              onChanged: (val) => setState(() => pmReminder = val),
            ),
            ToggleRow(
              title: 'Insight-ready nudges',
              value: insightNudges,
              onChanged: (val) => setState(() => insightNudges = val),
            ),
            const SizedBox(height: 20),
            if (!_pushPermissionGranted)
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
                      onPressed: () async {
                        final status = await Permission.notification.request();
                        setState(() {
                          _pushPermissionGranted = status.isGranted;
                        });
                        if (status.isPermanentlyDenied) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enable notifications in system settings.',
                                ),
                                backgroundColor: AppColors.mocha,
                              ),
                            );
                          }
                        }
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
