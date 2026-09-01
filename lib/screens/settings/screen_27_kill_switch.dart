import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/privacy_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

class KillSwitchScreen extends ConsumerStatefulWidget {
  const KillSwitchScreen({super.key});

  @override
  ConsumerState<KillSwitchScreen> createState() => _KillSwitchScreenState();
}

class _KillSwitchScreenState extends ConsumerState<KillSwitchScreen> {
  bool _showConfirmation = false;
  bool _hasActiveBooking = true;

  @override
  Widget build(BuildContext context) {
    final privacyState = ref.watch(privacyProvider);
    final isDeleting = privacyState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Delete Data'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Center(
          child: RareCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline,
                  size: 48,
                  color: AppColors.gold,
                ),
                const SizedBox(height: 10),
                Text(
                  'Delete all app data?',
                  style: TextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                if (!_showConfirmation)
                  Text(
                    'This deletes wellness logs, insights, and Aura state. '
                    'It does not cancel bookings or delete website orders — '
                    'you\'ll need to manage those separately.',
                    style: TextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  )
                else
                  Column(
                    children: [
                      Text(
                        'Are you absolutely sure? This action cannot be undone.',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.terracotta,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (_hasActiveBooking)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.linen,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSmall),
                            border: Border.all(
                                color: AppColors.gold, width: 0.5),
                          ),
                          child: Text(
                            'You have a Ritual booked for Thursday. '
                            'Deleting your app data will not cancel your booking — '
                            'you\'ll need to manage that separately. Continue?',
                            style: TextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Apple Health / Google Fit permissions will remain active. '
                        'You\'ll need to revoke those separately in system settings.',
                        style: TextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                if (isDeleting)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppColors.rose),
                        SizedBox(height: 12),
                        Text(
                          'Deleting your data...',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.mocha,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (!_showConfirmation) ...[
                  PrimaryButton(
                    label: 'Yes, Delete Everything',
                    onPressed: () {
                      setState(() {
                        _showConfirmation = true;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  GhostButton(
                    label: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    width: null,
                  ),
                ] else ...[
                  PrimaryButton(
                    label: 'Confirm Deletion',
                    onPressed: () {
                      _performDeletion(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  GhostButton(
                    label: 'Go Back',
                    onPressed: () {
                      setState(() {
                        _showConfirmation = false;
                      });
                    },
                    width: null,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _performDeletion(BuildContext context) {
    ref.read(privacyProvider.notifier).requestAccountDeletion();

    ref.listen<PrivacyState>(privacyProvider, (prev, next) {
      if (!next.isLoading && next.error == null && next.successMessage != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.cream,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            title: const Text(
              'Data Deleted',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                color: AppColors.mocha,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 48,
                  color: AppColors.rose,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your app data has been deleted.',
                  style: TextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'To fully revoke RARE\'s access to your Apple Health / Google Fit data, '
                  'you\'ll need to turn it off in your phone\'s Privacy settings.',
                  style: TextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              PrimaryButton(
                label: 'OK',
                onPressed: () {
                  Navigator.pop(context);
                  context.go(RouteNames.splashReturning);
                },
                width: null,
              ),
            ],
          ),
        );
      }
    });
  }
}
