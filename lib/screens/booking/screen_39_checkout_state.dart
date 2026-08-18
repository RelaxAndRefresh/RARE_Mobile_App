import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

/// Screen 39 – Checkout Success / Failure State
/// Transitional overlay shown after a purchase or booking.
/// Displays success confirmation or honest failure with retry option.
class CheckoutStateScreen extends StatelessWidget {
  final bool isSuccess;

  const CheckoutStateScreen({
    super.key,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSuccess) ...[
                _buildSuccessContent(context),
              ] else ...[
                _buildFailureContent(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          size: 64,
          color: AppColors.rose,
        ),
        const SizedBox(height: 16),
        Text(
          'Your ritual is booked for Thursday.',
          style: TextStyles.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        GhostButton(
          label: 'Return to Wellness',
          onPressed: () {
            // Navigate back to home
            context.go(RouteNames.home);
          },
        ),
      ],
    );
  }

  Widget _buildFailureContent(BuildContext context) {
    return RareCard(
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.terracotta,
          ),
          const SizedBox(height: 8),
          const Text(
            'FAILURE STATE',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Something went wrong with that payment. The slot wasn\'t held. Want to try again?',
            style: TextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Retry',
                  onPressed: () {
                    // Go back to the booking screen to retry
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GhostButton(
                  label: 'Back to Wellness',
                  onPressed: () {
                    context.go(RouteNames.home);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
