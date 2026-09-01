import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/cards/rare_card.dart';
import '../../providers/checkin_provider.dart';
import '../../providers/skin_provider.dart';
import '../../providers/notification_provider.dart';

class ErrorEmptyScreen extends ConsumerWidget {
  const ErrorEmptyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkinState = ref.watch(checkinProvider);
    final skinState = ref.watch(skinProvider);
    final notifState = ref.watch(notificationProvider);

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
          children: [
            if (checkinState.error != null)
              _StateCard(
                label: 'ERROR',
                message: 'Something feels off. Let\'s try again in a moment.',
              ),
            const _StateCard(
              label: 'ENVIRONMENT',
              message:
                  'We couldn\'t check the air in your area today. We\'ll keep trying.',
            ),
            _StateCard(
              label: 'EARLY DAYS',
              message: checkinState.todayCheckin == null
                  ? 'We are listening. Keep checking in.'
                  : 'You\'ve started. Keep the rhythm going.',
            ),
            _StateCard(
              label: 'EMPTY SHELF',
              message:
                  'Your shelf is quiet for now. When you bring RARE into your routine, it will appear here to be tracked.',
            ),
            _StateCard(
              label: 'QUIET INBOX',
              message: notifState.notifications.isEmpty
                  ? 'Nothing waiting for you. We\'ll let you know when something needs your attention.'
                  : '${notifState.unreadCount} unread notification${notifState.unreadCount == 1 ? '' : 's'} waiting for you.',
            ),
            const _StateCard(
              label: 'NO INTERVENTIONS',
              message:
                  'No changes to your routine yet. When we adjust something, you\'ll see it here.',
            ),
            const _StateCard(
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
