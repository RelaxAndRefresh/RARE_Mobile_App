import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('The Shelf')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            _productTile('Barrier Repair Serum', 'Standard'),
            _productTile('Vitamin C Elixir', 'Armed'),
            _productTile('Gentle Exfoliant', 'Depleted'),
            const SizedBox(height: 16),
            RareCard(
              child: Text(
                'Tap any product to see why it\'s Armed or Depleted — the Contextual Reveal explains the reasoning in plain language.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productTile(String name, String status) {
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
      title: name,
      subtitle: status,
      onTap: () {
        // Contextual Reveal
      },
    );
  }
}
