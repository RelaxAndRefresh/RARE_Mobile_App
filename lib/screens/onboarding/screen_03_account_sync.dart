import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/cards/rare_card.dart';

class AccountSyncScreen extends StatelessWidget {
  const AccountSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Account Sync')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connect your shelf.', style: TextStyles.displayMedium),
            const SizedBox(height: 8),
            Text(
              'To let your app and your shelf talk to each other, we\'ll sync this to your RARE account.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            RareCard(
              child: Column(
                children: [
                  const Icon(Icons.person, size: 48, color: AppColors.rose),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome back, in one tap',
                    style: TextStyles.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Securely bridges to your existing RARE account via OAuth.',
                    style: TextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: 'Connect My Account',
                    onPressed: () {
                      context.go(RouteNames.privacyGate);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GhostButton(
              label: 'Skip for now — start anonymously',
              onPressed: () {
                context.go(RouteNames.privacyGate);
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Skipping creates a local, anonymous profile. Your Shelf stays empty and Auto‑Swap stays dormant until you connect later from Profile Hub.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
