import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';
import 'package:go_router/go_router.dart';

/// Screen 33 – Profile Hub
/// A central account directory, not a decorative profile page.
/// Houses links to settings, privacy, and account management.
class ProfileHubScreen extends StatelessWidget {
  const ProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            // Main list of links
            Expanded(
              child: ListView(
                children: const [
                  ListTileWidget(
                    title: 'Settings',
                    trailing: Icon(Icons.chevron_right, color: AppColors.rose),
                  ),
                  ListTileWidget(
                    title: 'Privacy Dashboard',
                    trailing: Icon(Icons.chevron_right, color: AppColors.rose),
                  ),
                  ListTileWidget(
                    title: 'Cycle Calendar',
                    trailing: Icon(Icons.chevron_right, color: AppColors.rose),
                  ),
                  ListTileWidget(
                    title: 'Order & Booking History',
                    trailing: Icon(Icons.chevron_right, color: AppColors.rose),
                  ),
                  ListTileWidget(
                    title: 'Credits Ledger',
                    trailing: Icon(Icons.chevron_right, color: AppColors.rose),
                  ),
                  ListTileWidget(
                    title: 'Account Details',
                    trailing: Icon(Icons.chevron_right, color: AppColors.rose),
                  ),
                  ListTileWidget(
                    title: 'The Kill Switch',
                    trailing: Icon(Icons.chevron_right, color: AppColors.rose),
                  ),
                ],
              ),
            ),
            // Bottom card – Connect RARE Account (for anonymous users)
            RareCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Connected as anon_profile',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mocha,
                    ),
                  ),
                  GhostButton(
                    label: 'Connect RARE Account',
                    onPressed: () {
                      // Navigate to Account Sync (Screen 3)
                      context.go(RouteNames.accountSync);
                    },
                    width: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
