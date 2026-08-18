import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/common/chip_tag.dart';
import '../../widgets/cards/rare_card.dart';

class PrecisionProfileScreen extends StatelessWidget {
  const PrecisionProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Precision Profile')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            _profileTile('Hydration Index', 72),
            _profileTile('Barrier Function', 78),
            _profileTile('Sebum Balance', 65),
            _profileTile('Sensitivity Score', 55),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(String label, int value) {
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 13, color: AppColors.mocha)),
              const Spacer(),
              const ChipTag(label: '72 / 100', selected: true),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: AppColors.linen,
            color: AppColors.gold,
            minHeight: 3,
          ),
        ],
      ),
    );
  }
}
