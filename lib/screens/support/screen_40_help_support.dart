import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/tiles/list_tile.dart';

/// Screen 40 – Help & Support
/// Accessed from the Profile Hub.
/// A simple directory, not a ticketing system:
/// • Manage Bookings
/// • Report a Data Issue (firewalled – staff see only flagged insight + note)
/// • Contact Concierge
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // Manage Bookings
            ListTileWidget(
              title: 'Manage Bookings',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.rose,
              ),
              onTap: () {
                // Deep-link to webview for booking management
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening booking management...'),
                    backgroundColor: AppColors.mocha,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

            // Report a Data Issue (firewalled)
            ListTileWidget(
              title: 'Report a Data Issue',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.rose,
              ),
              onTap: () {
                // Show a dialog explaining what is shared
                _showReportIssueDialog(context);
              },
            ),

            // Contact Concierge
            ListTileWidget(
              title: 'Contact Concierge',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.rose,
              ),
              onTap: () {
                // Open email or WhatsApp
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening concierge contact...'),
                    backgroundColor: AppColors.mocha,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Firewall note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Text(
                'Report a Data Issue is firewalled: staff see only '
                'the flagged insight and her note, never raw biometric logs.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: const Text(
          'Report a Data Issue',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            color: AppColors.mocha,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please describe the issue you\'re experiencing with your data.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.rose),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Staff will see only your flagged insight and this note. '
              'Your raw biometric data is never shared.',
              style: TextStyles.bodySmall,
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your report has been submitted.'),
                  backgroundColor: AppColors.mocha,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Submit',
              style: TextStyle(color: AppColors.rose),
            ),
          ),
        ],
      ),
    );
  }
}
