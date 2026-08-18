import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/confidence_meter.dart';

class MonthlySynthesisScreen extends StatelessWidget {
  const MonthlySynthesisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Monthly Synthesis')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HIGH-CONFIDENCE',
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'On mornings after coffee past 2pm, you\'ve rated your sleep lower about 70% of the time.',
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Though your cycle also starts tomorrow, which might be a factor.',
                    style: TextStyles.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  const ConfidenceMeter(filledSegments: 3),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RareCard(
              child: Text(
                'No deep patterns surfaced this month. Sometimes that\'s the answer — your variables aren\'t strongly connected right now. We\'ll keep watching.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
