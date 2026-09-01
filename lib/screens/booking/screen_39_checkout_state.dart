import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/commerce_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';

class CheckoutStateScreen extends ConsumerWidget {
  final bool isSuccess;

  const CheckoutStateScreen({
    super.key,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commerceState = ref.watch(commerceProvider);
    final bookingState = ref.watch(bookingProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSuccess) ...[
                _buildSuccessContent(context, ref),
              ] else ...[
                _buildFailureContent(context, ref),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context, WidgetRef ref) {
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
            ref.read(commerceProvider.notifier).clearError();
            ref.read(bookingProvider.notifier).clearError();
            context.go(RouteNames.home);
          },
        ),
      ],
    );
  }

  Widget _buildFailureContent(BuildContext context, WidgetRef ref) {
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
                    ref.read(bookingProvider.notifier).clearError();
                    ref.read(commerceProvider.notifier).clearError();
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GhostButton(
                  label: 'Back to Wellness',
                  onPressed: () {
                    ref.read(bookingProvider.notifier).clearError();
                    ref.read(commerceProvider.notifier).clearError();
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
