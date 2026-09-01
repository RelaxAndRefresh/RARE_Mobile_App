import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/shelf_provider.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';

class ShelfScreen extends ConsumerStatefulWidget {
  const ShelfScreen({super.key});

  @override
  ConsumerState<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends ConsumerState<ShelfScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(shelfProvider.notifier).loadShelf());
  }

  @override
  Widget build(BuildContext context) {
    final shelfState = ref.watch(shelfProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('The Shelf')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: _buildBody(shelfState),
      ),
    );
  }

  Widget _buildBody(ShelfState shelfState) {
    if (shelfState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mocha),
      );
    }

    if (shelfState.error != null) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Something went wrong',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                shelfState.error!,
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    ref.read(shelfProvider.notifier).loadShelf(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (shelfState.shelfItems.isEmpty) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 48, color: AppColors.gold),
              const SizedBox(height: 12),
              Text(
                'Your shelf is empty',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Add products to start tracking your skincare journey.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: [
        ...shelfState.shelfItems.map((item) => _productTile(item)),
        const SizedBox(height: 16),
        RareCard(
          child: Text(
            'Tap any product to see why it\'s Armed or Depleted — the Contextual Reveal explains the reasoning in plain language.',
            style: TextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _productTile(dynamic item) {
    final String status = _getStatus(item);
    Color dotColor;
    if (status == 'Standard')
      dotColor = AppColors.rose;
    else if (status == 'Armed')
      dotColor = AppColors.terracotta;
    else
      dotColor = AppColors.grey;

    return ListTileWidget(
      leading: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dotColor,
        ),
      ),
      title: item.name,
      subtitle: status,
      onTap: () {
        context.push(
          '${RouteNames.depletionConfirmation}?itemId=${item.id}',
        );
      },
    );
  }

  String _getStatus(dynamic item) {
    if (item.estimatedDaysLeft == null) return 'Standard';
    if (item.estimatedDaysLeft! <= 0) return 'Depleted';
    if (item.estimatedDaysLeft! <= 7) return 'Armed';
    return 'Standard';
  }
}
