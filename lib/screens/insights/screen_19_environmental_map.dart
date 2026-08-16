import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/cards/rare_card.dart';

class EnvironmentalMapScreen extends StatelessWidget {
  const EnvironmentalMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Environmental Map')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            RareCard(
              child: SizedBox(
                height: 120,
                child: Center(
                  child: Icon(Icons.map, size: 48, color: AppColors.gold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'AQI history for your pin code, plotted against logged skin states.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            RareCard(
              child: Text(
                'Air quality data isn\'t available for your specific area. We\'re keeping an eye on the wider region.',
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
