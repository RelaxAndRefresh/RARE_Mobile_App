import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

class PlanMyReliefScreen extends StatelessWidget {
  const PlanMyReliefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Plan My Relief')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Center(
          child: RareCard(
            child: Column(
              children: [
                Text(
                  'Would a guided facial help with what you\'ve been feeling?',
                  style: TextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Based on your recent skin logs — no pressure, only if it feels right.',
                  style: TextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'See Available Slots',
                  onPressed: () {
                    context.go(RouteNames.bookingWebview);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
