import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/inputs/toggle_row.dart';
import 'package:go_router/go_router.dart';

/// Screen 43 – Pre-Treatment Data Sync
/// Phase 4: Sovereign B2B OS.
/// Triggered after booking is confirmed, never during checkout.
/// Granular per-category consent with "heads-up, not prerequisite" framing.
class PreTreatmentSyncScreen extends StatefulWidget {
  const PreTreatmentSyncScreen({super.key});

  @override
  State<PreTreatmentSyncScreen> createState() => _PreTreatmentSyncScreenState();
}

class _PreTreatmentSyncScreenState extends State<PreTreatmentSyncScreen> {
  // Granular consent toggles
  bool shareSkinLogs = true;
  bool shareInsights = true;
  bool shareRoutine = true;

  // Practitioner name (simulated from booking data)
  final String practitionerName = 'Anjali';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Share Data for Appointment'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Heads-up, not prerequisite" framing card
            RareCard(
              child: Column(
                children: [
                  // Header icon
                  const Icon(
                    Icons.people_outline,
                    size: 32,
                    color: AppColors.rose,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'RARE treatments are always fully tailored to your skin in the room.',
                    style: TextStyles.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sharing your app data simply gives $practitionerName a head start. '
                    'Choose what to share, or skip this step.',
                    style: TextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Granular consent toggles
            Text(
              'WHAT TO SHARE',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),

            ToggleRow(
              title: 'Skin logs',
              subtitle: 'Recent skin condition logs and photos',
              value: shareSkinLogs,
              onChanged: (val) => setState(() => shareSkinLogs = val),
            ),
            ToggleRow(
              title: 'Recent insights',
              subtitle: 'Patterns and correlations from the Epistemic Ladder',
              value: shareInsights,
              onChanged: (val) => setState(() => shareInsights = val),
            ),
            ToggleRow(
              title: 'Routine history',
              subtitle: 'Your current Baseline Routine and product usage',
              value: shareRoutine,
              onChanged: (val) => setState(() => shareRoutine = val),
            ),

            const SizedBox(height: 8),

            // Privacy assurance note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                border: Border.all(color: AppColors.divider, width: 0.5),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: AppColors.gold,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Shared data is read-only, session-limited, and wiped after your appointment.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.mauve,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Action buttons
            PrimaryButton(
              label: 'Share Selected',
              onPressed: () {
                // In a real app, save consent preferences
                // and navigate to the next screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Selected data will be shared with $practitionerName.',
                    ),
                    backgroundColor: AppColors.mocha,
                    duration: const Duration(seconds: 2),
                  ),
                );
                // Navigate to post-treatment protocol (Screen 44)
                context.go(RouteNames.postTreatmentProtocol);
              },
            ),
            const SizedBox(height: 8),
            GhostButton(
              label: 'Skip This Step',
              onPressed: () {
                // Skip data sharing entirely
                // The practitioner will work with in-room assessment only
                context.go(RouteNames.postTreatmentProtocol);
              },
            ),
          ],
        ),
      ),
    );
  }
}
