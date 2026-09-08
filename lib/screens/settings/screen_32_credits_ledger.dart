import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/credits_provider.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';

class CreditsLedgerScreen extends ConsumerStatefulWidget {
  const CreditsLedgerScreen({super.key});

  @override
  ConsumerState<CreditsLedgerScreen> createState() =>
      _CreditsLedgerScreenState();
}

class _CreditsLedgerScreenState extends ConsumerState<CreditsLedgerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(creditsProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final creditsState = ref.watch(creditsProvider);
    final balance = creditsState.balance;
    final transactions = creditsState.transactions;
    final isLoading = creditsState.isLoading;
    final error = creditsState.error;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Credits Ledger'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: isLoading && balance == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.rose),
            )
          : error != null && balance == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load credits.',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.terracotta,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GhostButton(
                        label: 'Retry',
                        onPressed: () =>
                            ref.read(creditsProvider.notifier).loadAll(),
                        width: null,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  child: ListView(
                    children: [
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
                              '${balance?.availableCredits ?? 0}',
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
                            if (balance != null &&
                                balance.pendingCredits > 0) ...[
                              const SizedBox(height: 6),
                              Text(
                                '${balance.pendingCredits} pending credits',
                                style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.gold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (transactions.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'No transactions yet.',
                              style: TextStyles.bodyMedium.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        ...transactions.map((tx) {
                          final isCredit = tx.amount > 0;
                          final prefix = isCredit ? '+' : '−';
                          final dateStr =
                              DateFormat('d MMM, y').format(tx.createdAt);
                          final timeAgo = _timeAgo(tx.createdAt);
                          return _TransactionItem(
                            icon: isCredit ? Icons.add : Icons.remove,
                            title:
                                '$prefix${tx.amount.abs()}${tx.description != null ? ' · ${tx.description}' : ''}',
                            subtitle: timeAgo,
                            isCredit: isCredit,
                          );
                        }),
                      const SizedBox(height: 16),
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

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return DateFormat('d MMM').format(dateTime);
  }
}

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
        color: AppColors.rose,
        size: 16,
      ),
      title: title,
      subtitle: subtitle,
    );
  }
}
