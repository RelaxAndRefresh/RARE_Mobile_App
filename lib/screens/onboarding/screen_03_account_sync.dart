import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';

class AccountSyncScreen extends ConsumerWidget {
  const AccountSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final onboardingState = ref.watch(onboardingProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        ref.read(onboardingProvider.notifier).updateStep(3, data: {
          'synced': true,
        });
        context.go(RouteNames.privacyGate);
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'Authentication failed')),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Account Sync')),
      body: onboardingState.isLoading || authState.status == AuthStatus.loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.rose),
                  SizedBox(height: 16),
                  Text('Connecting your account...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect your shelf.',
                    style: TextStyles.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To let your app and your shelf talk to each other, we\'ll sync this to your RARE account.',
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  RareCard(
                    child: Column(
                      children: [
                        const Icon(Icons.person,
                            size: 48, color: AppColors.rose),
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
                          onPressed: () async {
                            await ref
                                .read(authProvider.notifier)
                                .login(email: '', password: '');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GhostButton(
                    label: 'Skip for now — start anonymously',
                    onPressed: () async {
                      await ref
                          .read(onboardingProvider.notifier)
                          .updateStep(3, data: {
                        'synced': false,
                        'anonymous': true,
                      });
                      if (context.mounted) {
                        context.go(RouteNames.privacyGate);
                      }
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
