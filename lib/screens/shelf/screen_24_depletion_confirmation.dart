import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

/// Screen 24 – Depletion Confirmation
/// The "Honest Guess" restock flow.
/// Asks if the user still has the product and routes accordingly.
class DepletionConfirmationScreen extends StatelessWidget {
  const DepletionConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Depletion Check'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Center(
          child: RareCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Still have some of your Vitamin C Elixir?',
                  style: TextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'A gentle check-in, never a countdown.',
                  style: TextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GhostButton(
                        label: 'Still have some',
                        onPressed: () {
                          // User still has product – update usage rate and go home
                          // For now, just navigate back
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Need to restock',
                        onPressed: () {
                          // Route to Optimize My Shelf (Screen 21)
                          // or mark as depleted (for non-RARE products)
                          // For now, navigate to optimize shelf
                          context.go(RouteNames.optimizeShelf);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
