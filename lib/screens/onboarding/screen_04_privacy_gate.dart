import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/toggle_row.dart';

class PrivacyGateScreen extends ConsumerStatefulWidget {
  const PrivacyGateScreen({super.key});

  @override
  ConsumerState<PrivacyGateScreen> createState() => _PrivacyGateScreenState();
}

class _PrivacyGateScreenState extends ConsumerState<PrivacyGateScreen> {
  final Map<String, bool> toggles = {
    'Phone activity (sleep inference)': false,
    'Pin code (environmental data)': false,
    'Cycle tracking': false,
    'Skin photo storage': false,
    'Purchase history (Shelf / Auto-Swap)': false,
    'Wearable & health data (Apple Health / Google Fit)': false,
  };

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    ref.listen<OnboardingState>(onboardingProvider, (previous, next) {
      if (next.error == null && previous?.isLoading == true && !next.isLoading) {
        context.go(RouteNames.cycleBaseline);
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Privacy Consent')),
      body: onboardingState.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.rose),
                  SizedBox(height: 16),
                  Text('Saving your preferences...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your data, your terms.',
                    style: TextStyles.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: toggles.entries.map((entry) {
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
                    ),
                  ),
                  PrimaryButton(
                    label: 'Continue',
                    onPressed: () async {
                      await ref
                          .read(onboardingProvider.notifier)
                          .savePrivacyConsent({
                        'analytics_consent': toggles.values.any((v) => v),
                        'marketing_consent':
                            toggles['Purchase history (Shelf / Auto-Swap)'] ??
                                false,
                        'third_party_sharing': false,
                        'data_collection':
                            toggles.values.any((v) => v),
                        'consent_details': Map<String, bool>.from(toggles),
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
