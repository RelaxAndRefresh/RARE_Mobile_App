import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/chip_tag.dart';
import 'package:go_router/go_router.dart';

class SoftScanScreen extends StatefulWidget {
  const SoftScanScreen({super.key});

  @override
  State<SoftScanScreen> createState() => _SoftScanScreenState();
}

class _SoftScanScreenState extends State<SoftScanScreen> {
  bool scanFailed = false;
  String selectedSkinType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Soft Scan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Let\'s see you.', style: TextStyles.displayMedium),
            const SizedBox(height: 4),
            Text(
              'This is the last time you\'ll need to tell us everything.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            if (!scanFailed) ...[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.linen,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.gold, width: 1),
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 48,
                    color: AppColors.gold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Allow Camera',
                onPressed: () {
                  // Simulate success
                  context.go(RouteNames.accountSync);
                },
              ),
              const SizedBox(height: 8),
              GhostButton(
                label: 'Skip Scan',
                onPressed: () {
                  setState(() => scanFailed = true);
                },
              ),
            ] else ...[
              RareCard(
                child: Column(
                  children: [
                    Text(
                      'We couldn\'t quite get a clear read in this light. No worries — you can enter your skin type manually for now, and we\'ll refine it later.',
                      style: TextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SKIN TYPE',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          ['Dry', 'Oily', 'Combo', 'Sensitive'].map((type) {
                        return ChipTag(
                          label: type,
                          selected: selectedSkinType == type,
                          onTap: () {
                            setState(() => selectedSkinType = type);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Continue',
                onPressed: selectedSkinType.isEmpty
                    ? null
                    : () {
                        context.go(RouteNames.accountSync);
                      },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
