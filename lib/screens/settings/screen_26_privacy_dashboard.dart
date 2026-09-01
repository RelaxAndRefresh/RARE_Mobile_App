import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/privacy_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/inputs/toggle_row.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';
import 'package:go_router/go_router.dart';

class PrivacyDashboardScreen extends ConsumerStatefulWidget {
  const PrivacyDashboardScreen({super.key});

  @override
  ConsumerState<PrivacyDashboardScreen> createState() =>
      _PrivacyDashboardScreenState();
}

class _PrivacyDashboardScreenState
    extends ConsumerState<PrivacyDashboardScreen> {
  final TextEditingController pinCodeController =
      TextEditingController(text: '411001 — Pune');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(privacyProvider.notifier).loadConsents();
    });
  }

  @override
  void dispose() {
    pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final privacyState = ref.watch(privacyProvider);
    final consents = privacyState.consents;
    final isLoading = privacyState.isLoading;
    final error = privacyState.error;
    final successMessage = privacyState.successMessage;

    final toggles = {
      'Phone activity': consents?.dataCollection ?? true,
      'Pin code': true,
      'Cycle tracking': consents?.analyticsConsent ?? false,
      'Skin photos': consents?.marketingConsent ?? true,
      'Purchase history': consents?.thirdPartySharing ?? true,
      'Wearable data': false,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: AppColors.mocha,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(privacyProvider.notifier).clearSuccess();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Privacy Dashboard'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: isLoading && consents == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.rose),
            )
          : error != null && consents == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load privacy settings.',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.terracotta,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GhostButton(
                        label: 'Retry',
                        onPressed: () =>
                            ref.read(privacyProvider.notifier).loadConsents(),
                        width: null,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  child: ListView(
                    children: [
                      ...toggles.entries.map((entry) {
                        return ToggleRow(
                          title: entry.key,
                          subtitle: 'Used only for the feature it names.',
                          value: entry.value,
                          onChanged: (val) {
                            _updateConsent(entry.key, val);
                          },
                        );
                      }).toList(),
                      const SizedBox(height: 16),
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

  void _updateConsent(String category, bool value) {
    final categoryMap = {
      'Phone activity': 'data_collection',
      'Pin code': 'pin_code',
      'Cycle tracking': 'analytics_consent',
      'Skin photos': 'marketing_consent',
      'Purchase history': 'third_party_sharing',
      'Wearable data': 'wearable_data',
    };
    final apiCategory = categoryMap[category] ?? category;
    ref.read(privacyProvider.notifier).updateConsent(
          category: apiCategory,
          consented: value,
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
              ref.read(privacyProvider.notifier).requestDataExport();
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
