import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/chip_tag.dart';

class SoftScanScreen extends ConsumerStatefulWidget {
  const SoftScanScreen({super.key});

  @override
  ConsumerState<SoftScanScreen> createState() => _SoftScanScreenState();
}

class _SoftScanScreenState extends ConsumerState<SoftScanScreen> {
  bool scanFailed = false;
  String selectedSkinType = '';
  File? _capturedImage;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _capturedImage = File(picked.path));

    await ref.read(onboardingProvider.notifier).submitSoftScan({
      'face_image_path': picked.path,
      'scan_type': 'camera',
    });

    if (mounted) {
      context.go(RouteNames.accountSync);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    ref.listen<OnboardingState>(onboardingProvider, (previous, next) {
      if (next.error != null && !scanFailed) {
        setState(() => scanFailed = true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Soft Scan'),
      ),
      body: onboardingState.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.rose),
                  SizedBox(height: 16),
                  Text('Analyzing your skin...'),
                ],
              ),
            )
          : Padding(
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
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMedium),
                        border: Border.all(color: AppColors.gold, width: 1),
                      ),
                      child: _capturedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMedium),
                              child: Image.file(
                                _capturedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
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
                      onPressed: _takePhoto,
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
                            children: ['Dry', 'Oily', 'Combo', 'Sensitive']
                                .map((type) {
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
                          : () async {
                              await ref
                                  .read(onboardingProvider.notifier)
                                  .submitSoftScan({
                                'skin_type': selectedSkinType.toLowerCase(),
                                'scan_type': 'manual',
                              });
                              if (context.mounted) {
                                context.go(RouteNames.accountSync);
                              }
                            },
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
