import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/toggle_row.dart';
import 'package:go_router/go_router.dart';

class PrivacyGateScreen extends StatefulWidget {
  const PrivacyGateScreen({super.key});

  @override
  State<PrivacyGateScreen> createState() => _PrivacyGateScreenState();
}

class _PrivacyGateScreenState extends State<PrivacyGateScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Privacy Consent')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your data, your terms.', style: TextStyles.displayMedium),
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
              onPressed: () {
                context.go(RouteNames.cycleBaseline);
              },
            ),
          ],
        ),
      ),
    );
  }
}
