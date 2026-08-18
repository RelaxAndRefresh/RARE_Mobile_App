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

class SkinLogScreen extends StatefulWidget {
  const SkinLogScreen({super.key});

  @override
  State<SkinLogScreen> createState() => _SkinLogScreenState();
}

class _SkinLogScreenState extends State<SkinLogScreen> {
  final List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Skin Log')),
      body: Padding(
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
                children: ['Tight', 'Dry', 'Oily', 'Sensitive', 'Calm', 'Dull']
                    .map((tag) {
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
                  const Icon(Icons.camera_alt, size: 32, color: AppColors.rose),
                  const SizedBox(height: 8),
                  Text(
                    'Optional — add a photo to your Progress Timeline',
                    style: TextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  GhostButton(
                    label: 'Add Photo',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Save Skin Log',
              onPressed: () {
                context.go(RouteNames.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
