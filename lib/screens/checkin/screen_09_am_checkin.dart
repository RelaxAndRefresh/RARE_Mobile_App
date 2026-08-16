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

class AMCheckinScreen extends StatefulWidget {
  const AMCheckinScreen({super.key});

  @override
  State<AMCheckinScreen> createState() => _AMCheckinScreenState();
}

class _AMCheckinScreenState extends State<AMCheckinScreen> {
  double mood = 0.65;
  final List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Good morning')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SLEEP — INFERRED FROM PHONE STILLNESS',
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '7h 12m — sound about right?',
                    style: TextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GhostButton(
                          label: 'Yes',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GhostButton(
                          label: 'Adjust',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MOOD',
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: mood,
                    onChanged: (val) => setState(() => mood = val),
                    activeColor: AppColors.rose,
                    inactiveColor: AppColors.linen,
                  ),
                ],
              ),
            ),
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CONTEXT (OPTIONAL)',
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    children: ['Sick', 'Travel', 'Stress'].map((tag) {
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Save & Return to Home',
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
