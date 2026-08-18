import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

class WearableConnectionScreen extends StatelessWidget {
  const WearableConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Wearable Connection')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pair your devices.', style: TextStyles.displayMedium),
            const SizedBox(height: 8),
            Text(
              'No wearable? RARE works just as well without one.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            RareCard(
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: AppColors.rose),
                  const SizedBox(width: 8),
                  const Text(
                    'Apple Health',
                    style: TextStyle(fontSize: 13, color: AppColors.mocha),
                  ),
                  const Spacer(),
                  GhostButton(
                    label: 'Connect',
                    onPressed: () {},
                    width: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RareCard(
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: AppColors.rose),
                  const SizedBox(width: 8),
                  const Text(
                    'Google Fit',
                    style: TextStyle(fontSize: 13, color: AppColors.mocha),
                  ),
                  const Spacer(),
                  GhostButton(
                    label: 'Connect',
                    onPressed: () {},
                    width: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No wearable? Totally fine — manual logging covers everything RARE needs.',
              style: TextStyles.bodySmall,
            ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'Skip for now',
              onPressed: () {
                context.go(RouteNames.auraAwakening);
              },
            ),
          ],
        ),
      ),
    );
  }
}
