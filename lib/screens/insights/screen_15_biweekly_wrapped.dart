import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/confidence_meter.dart';

class BiweeklyWrappedScreen extends StatelessWidget {
  const BiweeklyWrappedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Biweekly Wrapped')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CORRELATION',
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'There\'s a pattern forming between late coffees and restless mornings.',
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  const ConfidenceMeter(filledSegments: 2),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.mocha,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RARE PULSE',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '4,200 women with your Precision Profile restocked this serum this month.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.cream,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
