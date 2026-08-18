import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';

class QuickLogScreen extends StatelessWidget {
  const QuickLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Quick Log')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('One-tap log', style: TextStyles.displayMedium),
            const SizedBox(height: 16),
            RareCard(
              child: Row(
                children: [
                  const Icon(Icons.water_drop, color: AppColors.rose),
                  const SizedBox(width: 8),
                  const Text('Caffeine'),
                  const Spacer(),
                  GhostButton(
                    label: 'Log',
                    onPressed: () {},
                    width: null,
                  ),
                ],
              ),
            ),
            RareCard(
              child: Row(
                children: [
                  const Icon(Icons.water_drop, color: AppColors.rose),
                  const SizedBox(width: 8),
                  const Text('Alcohol'),
                  const Spacer(),
                  GhostButton(
                    label: 'Log',
                    onPressed: () {},
                    width: null,
                  ),
                ],
              ),
            ),
            RareCard(
              child: Row(
                children: [
                  const Icon(Icons.show_chart, color: AppColors.rose),
                  const SizedBox(width: 8),
                  const Text('Energy'),
                  const Spacer(),
                  GhostButton(
                    label: 'Log',
                    onPressed: () {},
                    width: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Time is inferred automatically — tap the entry again to adjust.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
