import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';

/// Screen 42 – Practitioner Login
/// Phase 4: Sovereign B2B OS.
/// Credentialed esthetician access – temporary, read-only client summary.
/// Wiped from tablet storage the moment the appointment is marked complete.
class PractitionerLoginScreen extends StatelessWidget {
  const PractitionerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Practitioner View'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client summary card
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CLIENT SUMMARY — APPOINTMENT IN 40 MIN',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Priya S.',
                    style: TextStyles.displayMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Skin type: Combination · Recent tags: Tight, Reactive · No active pauses.',
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  // Quick stats row
                  Row(
                    children: [
                      _statChip('3 visits', AppColors.rose),
                      const SizedBox(width: 8),
                      _statChip('2 insights', AppColors.gold),
                      const SizedBox(width: 8),
                      _statChip('4 logs', AppColors.terracotta),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Data available note
            Text(
              'Client data is available for review. '
              'All data is read-only and session-limited.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Practitioner actions
            RareCard(
              child: Column(
                children: [
                  const Text(
                    'ACTIONS',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Start Appointment',
                    onPressed: () {
                      // Mark appointment as started
                      // In a real app, this would start the timer
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Appointment session started.'),
                          backgroundColor: AppColors.mocha,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  GhostButton(
                    label: 'View Full Profile',
                    onPressed: () {
                      // Navigate to read-only profile view
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening read-only profile...'),
                          backgroundColor: AppColors.mocha,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Security notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                border: Border.all(color: AppColors.gold, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: AppColors.gold,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'SECURE SESSION',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 2,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Wiped from tablet storage the moment the appointment is marked complete.',
                    style: TextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
        ),
      ),
    );
  }
}
