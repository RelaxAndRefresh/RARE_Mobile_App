import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

class OptimizeShelfScreen extends StatelessWidget {
  const OptimizeShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Optimize My Shelf')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            RareCard(
              child: Column(
                children: [
                  const Text(
                    'CONTEXTUAL REVEAL',
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Would you like to optimize your shelf with a Barrier Repair Serum?',
                    style: TextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Yes, show me',
                    onPressed: () {
                      context.go(RouteNames.bookingWebview);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.circle, size: 7, color: AppColors.grey),
                  SizedBox(width: 6),
                  Icon(Icons.circle, size: 7, color: AppColors.grey),
                  SizedBox(width: 6),
                  Text('relaxedandrefresh.com',
                      style: TextStyle(fontSize: 9, color: AppColors.grey)),
                ],
              ),
            ),
            RareCard(
              child: Column(
                children: [
                  Text(
                    'Anonymous-user intercept: "To buy this, you\'ll need to connect your RARE account first." → [Connect Account] / [Cancel]',
                    style: TextStyles.bodySmall,
                  ),
                  const Divider(color: AppColors.divider),
                  Text(
                    'Offline intercept: "The RARE shop needs a connection to browse. Let\'s try again in a moment."',
                    style: TextStyles.bodySmall,
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
