import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/cards/rare_card.dart';

class PulseFeedScreen extends StatelessWidget {
  const PulseFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('RARE Pulse')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            RareCard(
              child: Text(
                '4,200 women with your Precision Profile restocked this serum.',
                style: TextStyles.bodyMedium,
              ),
            ),
            RareCard(
              child: Text(
                'Trending across RARE members this month — barrier-repair rituals.',
                style: TextStyles.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Below the 100-user segment threshold, profile-specific cards are suppressed in favor of broader trends — a lone "1 woman like you" number would isolate rather than reassure.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
