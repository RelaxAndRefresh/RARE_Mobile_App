import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/inputs/toggle_row.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';
import 'package:go_router/go_router.dart';

/// Screen 26 – Privacy Dashboard
/// Independently revocable consent per category,
/// plain-language explanation of current data use.
class PrivacyDashboardScreen extends StatefulWidget {
  const PrivacyDashboardScreen({super.key});

  @override
  State<PrivacyDashboardScreen> createState() => _PrivacyDashboardScreenState();
}

class _PrivacyDashboardScreenState extends State<PrivacyDashboardScreen> {
  // Consent toggles – default values from prototype
  final Map<String, bool> toggles = {
    'Phone activity': true,
    'Pin code': true,
    'Cycle tracking': false,
    'Skin photos': true,
    'Purchase history': true,
    'Wearable data': false,
  };

  final TextEditingController pinCodeController =
      TextEditingController(text: '411001 — Pune');

  @override
  void dispose() {
    pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Privacy Dashboard'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // Toggle rows for each consent category
            ...toggles.entries.map((entry) {
              return ToggleRow(
                title: entry.key,
                subtitle: 'Used only for the feature it names.',
                value: entry.value,
                onChanged: (val) {
                  setState(() {
                    toggles[entry.key] = val;
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 16),

            // Update Pin Code card
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PIN CODE',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pinCodeController.text,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.mocha,
                          ),
                        ),
                      ),
                      GhostButton(
                        label: 'Update',
                        onPressed: () {
                          // Show dialog to update pin code
                          _showUpdatePinDialog(context);
                        },
                        width: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Updating your pin code refreshes the Environmental Map and AQI-based insights.',
                    style: TextStyles.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Download My Data
            ListTileWidget(
              leading: const Icon(
                Icons.download,
                color: AppColors.rose,
                size: 22,
              ),
              title: 'Download My Data',
              onTap: () {
                _showDownloadDataDialog(context);
              },
            ),

            const SizedBox(height: 16),

            // Legal documents link
            ListTileWidget(
              leading: const Icon(
                Icons.description,
                color: AppColors.rose,
                size: 22,
              ),
              title: 'Privacy Policy',
              onTap: () {
                context.go(RouteNames.legalDocuments);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdatePinDialog(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: pinCodeController.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: const Text(
          'Update Pin Code',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            color: AppColors.mocha,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your new pin code. This will update your environmental data and AQI insights.',
              style: TextStyles.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'e.g. 411001',
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
              ),
            ),
          ],
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
                pinCodeController.text = controller.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Pin code updated. Environmental data will refresh.'),
                  backgroundColor: AppColors.mocha,
                  duration: Duration(seconds: 2),
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

  void _showDownloadDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: const Text(
          'Download My Data',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            color: AppColors.mocha,
          ),
        ),
        content: Text(
          'We\'ll gather everything we\'ve learned about your wellness and send it to your email. This takes a few minutes.',
          style: TextStyles.bodyMedium,
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Your data export has been requested. You\'ll receive an email shortly.'),
                  backgroundColor: AppColors.mocha,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text(
              'Request Export',
              style: TextStyle(color: AppColors.rose),
            ),
          ),
        ],
      ),
    );
  }
}
