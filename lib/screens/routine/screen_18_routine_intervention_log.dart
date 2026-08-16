import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/tiles/list_tile.dart';
import '../../widgets/common/chip_tag.dart';

class RoutineInterventionLogScreen extends StatelessWidget {
  const RoutineInterventionLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Intervention Log')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: const [
            ListTileWidget(
              leading: ChipTag(label: 'ALGORITHM', selected: true),
              title: 'Paused Retinol',
              subtitle: '2 days ago',
            ),
            ListTileWidget(
              leading: ChipTag(label: 'AUTO_SWAP', selected: true),
              title: 'Swapped to Barrier Serum',
              subtitle: '5 days ago',
            ),
            ListTileWidget(
              leading: ChipTag(label: 'PRACTITIONER', selected: true),
              title: 'Recommended SPF increase — Prof. Assessment',
              subtitle: '1 week ago',
            ),
            ListTileWidget(
              leading: ChipTag(label: 'MANUAL_EDIT', selected: true),
              title: 'Corrected Sleep to 6h',
              subtitle: '1 week ago',
            ),
          ],
        ),
      ),
    );
  }
}
