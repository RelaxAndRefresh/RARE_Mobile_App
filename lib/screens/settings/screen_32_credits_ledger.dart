import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';

/// Screen 32 – Credits Ledger
/// A plain running balance and transaction history for the credits system.
class CreditsLedgerScreen extends StatelessWidget {
  const CreditsLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Credits Ledger'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // Balance card
            RareCard(
              child: Column(
                children: [
                  const Text(
                    'CURRENT BALANCE',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹340',
                    style: TextStyles.displayMedium.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1 Credit = ₹1',
                    style: TextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Transaction history
            const _TransactionItem(
              icon: Icons.add,
              title: '+10 · AM Check-in',
              subtitle: 'Today',
              isCredit: true,
            ),
            const _TransactionItem(
              icon: Icons.add,
              title: '+15 · 14-Day Resonance',
              subtitle: '3 days ago',
              isCredit: true,
            ),
            const _TransactionItem(
              icon: Icons.add,
              title: '+50 · Refund: Reflexology',
              subtitle: '1 week ago',
              isCredit: true,
            ),
            const _TransactionItem(
              icon: Icons.remove,
              title: '−120 · Ritual Spend',
              subtitle: '2 weeks ago',
              isCredit: false,
            ),
            const _TransactionItem(
              icon: Icons.add,
              title: '+8 · Ritual Completed',
              subtitle: '3 weeks ago',
              isCredit: true,
            ),

            const SizedBox(height: 16),

            // Footer
            Text(
              'Credits apply automatically at checkout on the web.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// A single transaction row with icon, description, and date.
class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isCredit;

  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCredit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileWidget(
      leading: Icon(
        icon,
        color: isCredit ? AppColors.rose : AppColors.rose,
        size: 16,
      ),
      title: title,
      subtitle: subtitle,
    );
  }
}
