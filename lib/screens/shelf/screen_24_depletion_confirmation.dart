import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/shelf_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';

class DepletionConfirmationScreen extends ConsumerStatefulWidget {
  final String? itemId;

  const DepletionConfirmationScreen({super.key, this.itemId});

  @override
  ConsumerState<DepletionConfirmationScreen> createState() =>
      _DepletionConfirmationScreenState();
}

class _DepletionConfirmationScreenState
    extends ConsumerState<DepletionConfirmationScreen> {
  String _productName = 'your product';

  @override
  void initState() {
    super.initState();
    _loadShelfItem();
  }

  void _loadShelfItem() {
    final shelfState = ref.read(shelfProvider);
    if (shelfState.shelfItems.isEmpty) {
      ref.read(shelfProvider.notifier).loadShelf();
    }
    _resolveProductName();
  }

  void _resolveProductName() {
    final shelfState = ref.read(shelfProvider);
    if (widget.itemId != null) {
      final item = shelfState.shelfItems
          .where((i) => i.id == widget.itemId)
          .toList();
      if (item.isNotEmpty) {
        setState(() {
          _productName = item.first.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shelfState = ref.watch(shelfProvider);
    final isLoading = shelfState.isLoading;

    if (shelfState.shelfItems.isNotEmpty && _productName == 'your product') {
      _resolveProductName();
    }

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
                  'Still have some of your $_productName?',
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
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (widget.itemId != null) {
                                  await ref
                                      .read(shelfProvider.notifier)
                                      .confirmDepletion(
                                          widget.itemId!, true);
                                }
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Need to restock',
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (widget.itemId != null) {
                                  await ref
                                      .read(shelfProvider.notifier)
                                      .confirmDepletion(
                                          widget.itemId!, false);
                                }
                                if (context.mounted) {
                                  context.go(RouteNames.optimizeShelf);
                                }
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
