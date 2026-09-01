import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/chip_tag.dart';
import '../../providers/skin_provider.dart';
import 'package:go_router/go_router.dart';

class SkinLogScreen extends ConsumerStatefulWidget {
  const SkinLogScreen({super.key});

  @override
  ConsumerState<SkinLogScreen> createState() => _SkinLogScreenState();
}

class _SkinLogScreenState extends ConsumerState<SkinLogScreen> {
  final List<String> selectedTags = [];
  final List<String> availableTags = ['Tight', 'Dry', 'Oily', 'Sensitive', 'Calm', 'Dull'];

  @override
  Widget build(BuildContext context) {
    final skinState = ref.watch(skinProvider);
    final isSubmitting = skinState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Skin Log')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How does your skin feel today?',
                  style: TextStyles.displayMedium,
                ),
                const SizedBox(height: 16),
                RareCard(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableTags.map((tag) {
                      return ChipTag(
                        label: tag,
                        selected: selectedTags.contains(tag),
                        onTap: () {
                          setState(() {
                            if (selectedTags.contains(tag)) {
                              selectedTags.remove(tag);
                            } else {
                              selectedTags.add(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                RareCard(
                  child: Column(
                    children: [
                      const Icon(Icons.camera_alt,
                          size: 32, color: AppColors.rose),
                      const SizedBox(height: 8),
                      Text(
                        'Optional — add a photo to your Progress Timeline',
                        style: TextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      GhostButton(
                        label: 'Add Photo',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Photo upload coming soon. Add image_picker to pubspec.yaml to enable.',
                              ),
                              backgroundColor: AppColors.mocha,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: isSubmitting ? 'Saving...' : 'Save Skin Log',
                  onPressed: isSubmitting || selectedTags.isEmpty
                      ? null
                      : () async {
                          await ref.read(skinProvider.notifier).createLog({
                            'tags': selectedTags,
                            'condition': selectedTags.first,
                          });
                          if (!mounted) return;
                          final error = ref.read(skinProvider).error;
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not save. Please try again.'),
                                backgroundColor: AppColors.terracotta,
                              ),
                            );
                            ref.read(skinProvider.notifier).clearError();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Skin log saved.'),
                                backgroundColor: AppColors.mocha,
                              ),
                            );
                            context.go(RouteNames.home);
                          }
                        },
                ),
              ],
            ),
          ),
          if (isSubmitting)
            Container(
              color: AppColors.cream.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.rose),
              ),
            ),
        ],
      ),
    );
  }
}
