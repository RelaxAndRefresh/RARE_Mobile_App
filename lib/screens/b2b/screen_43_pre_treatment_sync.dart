import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/practitioner_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/inputs/toggle_row.dart';

class PreTreatmentSyncScreen extends ConsumerStatefulWidget {
  const PreTreatmentSyncScreen({super.key});

  @override
  ConsumerState<PreTreatmentSyncScreen> createState() =>
      _PreTreatmentSyncScreenState();
}

class _PreTreatmentSyncScreenState
    extends ConsumerState<PreTreatmentSyncScreen> {
  @override
  Widget build(BuildContext context) {
    final consentState = ref.watch(preTreatmentConsentProvider);
    final clientState = ref.watch(clientSummaryProvider);
    final practitionerName = clientState.client?.userName ?? 'your practitioner';

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
            RareCard(
              child: Column(
                children: [
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
            const Text(
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
              value: consentState.shareSkinLogs,
              onChanged: (_) =>
                  ref.read(preTreatmentConsentProvider.notifier).toggleSkinLogs(),
            ),
            ToggleRow(
              title: 'Recent insights',
              subtitle: 'Patterns and correlations from the Epistemic Ladder',
              value: consentState.shareInsights,
              onChanged: (_) =>
                  ref.read(preTreatmentConsentProvider.notifier).toggleInsights(),
            ),
            ToggleRow(
              title: 'Routine history',
              subtitle: 'Your current Baseline Routine and product usage',
              value: consentState.shareRoutine,
              onChanged: (_) =>
                  ref.read(preTreatmentConsentProvider.notifier).toggleRoutine(),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                border: Border.all(color: AppColors.divider, width: 0.5),
              ),
              child: const Row(
                children: [
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
            PrimaryButton(
              label: 'Share Selected',
              isLoading: consentState.isLoading,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Selected data will be shared with $practitionerName.',
                    ),
                    backgroundColor: AppColors.mocha,
                    duration: const Duration(seconds: 2),
                  ),
                );
                context.go(RouteNames.postTreatmentProtocol);
              },
            ),
            const SizedBox(height: 8),
            GhostButton(
              label: 'Skip This Step',
              onPressed: () {
                context.go(RouteNames.postTreatmentProtocol);
              },
            ),
          ],
        ),
      ),
    );
  }
}
