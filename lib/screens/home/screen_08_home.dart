import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/common/aura_widget.dart';
import '../../widgets/common/hydration_vessel.dart';
import '../../widgets/cards/rare_card.dart';
import '../../core/utils/helpers.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getFormattedDate(),
                    style: TextStyles.eyebrow,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.circle_outlined,
                            color: AppColors.rose),
                        onPressed: () {
                          context.go(RouteNames.quietInbox);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.nights_stay,
                            color: AppColors.rose),
                        onPressed: () {
                          context.go(RouteNames.biweeklyWrapped);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag,
                            color: AppColors.rose),
                        onPressed: () {
                          context.go(RouteNames.optimizeShelf);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Center(
                child: AuraWidget(isBreathing: true, opacity: 0.9),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Soft mornings\nmake honest days.',
                  style: TextStyles.quote,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 22),
              RareCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HYDRATION VESSEL',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const HydrationVessel(fillPercentage: 0.55),
                    const SizedBox(height: 8),
                    Text(
                      '4 of 8 taps today — tap to fill',
                      style: TextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon(Icons.shopping_basket, 'Shelf', () {
                    context.go(RouteNames.shelf);
                  }),
                  _navIcon(Icons.eco, 'Quick Log', () {
                    context.go(RouteNames.quickLog);
                  }),
                  _navIcon(Icons.nights_stay, 'Insights', () {
                    context.go(RouteNames.biweeklyWrapped);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.rose),
          const SizedBox(height: 4),
          Text(label, style: TextStyles.bodySmall),
        ],
      ),
    );
  }
}
