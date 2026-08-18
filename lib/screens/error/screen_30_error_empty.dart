import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/cards/rare_card.dart';

/// Screen 30 – Error/Empty States
/// Displays a collection of calm, brand-voiced empty and error state
/// examples as specified in Section 7.1 of the Master Document.
class ErrorEmptyScreen extends StatelessWidget {
  const ErrorEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Empty & Error States'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: const [
            // Network/connection error
            _StateCard(
              label: 'ERROR',
              message: 'Something feels off. Let\'s try again in a moment.',
            ),
            // Environmental data fetch failure
            _StateCard(
              label: 'ENVIRONMENT',
              message:
                  'We couldn\'t check the air in your area today. We\'ll keep trying.',
            ),
            // Home screen, Day 1-2 (no data yet)
            _StateCard(
              label: 'EARLY DAYS',
              message: 'We are listening. Keep checking in.',
            ),
            // The Shelf, before purchases
            _StateCard(
              label: 'EMPTY SHELF',
              message:
                  'Your shelf is quiet for now. When you bring RARE into your routine, it will appear here to be tracked.',
            ),
            // The Quiet Inbox, no missed nudges
            _StateCard(
              label: 'QUIET INBOX',
              message:
                  'Nothing waiting for you. We\'ll let you know when something needs your attention.',
            ),
            // Routine Intervention Log, no interventions yet
            _StateCard(
              label: 'NO INTERVENTIONS',
              message:
                  'No changes to your routine yet. When we adjust something, you\'ll see it here.',
            ),
            // Credits Ledger, early days
            _StateCard(
              label: 'EARLY CREDITS',
              message:
                  'Your balance is building. Keep checking in — credits accumulate with every ritual.',
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable card for displaying an empty/error state.
class _StateCard extends StatelessWidget {
  final String label;
  final String message;

  const _StateCard({
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.mocha,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
