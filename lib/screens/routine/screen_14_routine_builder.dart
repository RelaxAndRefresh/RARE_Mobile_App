import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/chip_tag.dart';
import 'package:go_router/go_router.dart';

class RoutineBuilderScreen extends StatelessWidget {
  const RoutineBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Routine Builder')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            _stepTile('Cleanse'),
            _stepTile('Treat'),
            _stepTile('Moisturize'),
            _stepTile('SPF'),
            const SizedBox(height: 16),
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NOT A RARE PRODUCT?',
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gold, width: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'e.g. "Cetaphil Cleanser"',
                      style: TextStyle(fontSize: 12, color: AppColors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Save My Routine',
              onPressed: () {
                context.go(RouteNames.home);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepTile(String step) {
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.grey,
              )),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text(
                'Select product…',
                style: TextStyle(fontSize: 13, color: AppColors.mocha),
              ),
              const Spacer(),
              ChipTag(label: 'AM · PM · Both', selected: true),
            ],
          ),
        ],
      ),
    );
  }
}
