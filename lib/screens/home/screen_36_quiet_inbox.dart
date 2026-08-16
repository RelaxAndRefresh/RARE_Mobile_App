import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/tiles/list_tile.dart';

/// Screen 36 – The Quiet Inbox
/// Reached via the leaf icon on Home.
/// Displays a timeline of missed passive nudges, auto‑clearing
/// as items are read or expired.
class QuietInboxScreen extends StatelessWidget {
  const QuietInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Quiet Inbox'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            // List of nudges
            Expanded(
              child: ListView(
                children: const [
                  ListTileWidget(
                    leading: Icon(
                      Icons.eco,
                      size: 16,
                      color: AppColors.rose,
                    ),
                    title: 'Your skin log is ready to add today',
                    subtitle: '2h ago',
                  ),
                  ListTileWidget(
                    leading: Icon(
                      Icons.settings,
                      size: 16,
                      color: AppColors.rose,
                    ),
                    title: 'Your routine has been prepared',
                    subtitle: '1d ago',
                  ),
                  ListTileWidget(
                    leading: Icon(
                      Icons.nights_stay,
                      size: 16,
                      color: AppColors.rose,
                    ),
                    title: 'A new insight is ready to view',
                    subtitle: '2d ago',
                  ),
                ],
              ),
            ),
            // Footer note
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Items auto‑clear as they are read or expire — no badge counts, no pressure.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
