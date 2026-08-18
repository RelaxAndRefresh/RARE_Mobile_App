import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';

/// Screen 23 – Booking Webview
/// Displays an embedded webview (simulated) with booking details
/// and a confirmation action.
class BookingWebviewScreen extends StatelessWidget {
  const BookingWebviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            // Webview chrome (simulated)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.circle,
                    size: 7,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.circle,
                    size: 7,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'relaxedandrefresh.com/book',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Booking details card
            RareCard(
              backgroundColor: AppColors.cream,
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THURSDAY · 3:30 PM',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Restorative Facial — 60 min',
                    style: TextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Same anonymous-user and offline pre‑flight checks '
                    'as Screen 21 apply here.',
                    style: TextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Confirm & Pay',
                    onPressed: () {
                      // Navigate to checkout success / failure
                      // In a real app, this would trigger the payment flow.
                      // For now, go to a success state placeholder.
                      // Since Screen 39 is not yet implemented, we can just go back
                      // or show a snackbar. We'll route to a temporary success page
                      // if available, otherwise pop.
                      // We'll just go to home for demonstration.
                      // This will be replaced when Screen 39 is built.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment flow would start here.'),
                          backgroundColor: AppColors.mocha,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  GhostButton(
                    label: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
