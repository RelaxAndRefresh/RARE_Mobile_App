import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

class CycleBaselineScreen extends StatelessWidget {
  const CycleBaselineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Cycle Baseline')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you\'d like, this helps us notice patterns tied to your cycle.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LAST PERIOD START DATE',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemCount: 28,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final isMarked = day == 12;
                      final isToday = day == 14;
                      return Container(
                        decoration: BoxDecoration(
                          color: isMarked ? AppColors.rose : AppColors.linen,
                          borderRadius: BorderRadius.circular(6),
                          border: isToday
                              ? Border.all(color: AppColors.terracotta)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  isMarked ? AppColors.cream : AppColors.mauve,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Save Baseline',
              onPressed: () {
                context.go(RouteNames.wearableConnection);
              },
            ),
            const SizedBox(height: 8),
            GhostButton(
              label: 'Skip — I\'ll set this up later',
              onPressed: () {
                context.go(RouteNames.wearableConnection);
              },
            ),
          ],
        ),
      ),
    );
  }
}
