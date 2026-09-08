import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/aura_widget.dart';

/// Screen 37 – Splash & Returning User Login
/// Checks for an existing session token on launch.
/// Two re-auth paths: OAuth for linked accounts, Local Biometric Auth for
/// anonymous users. New device → Create Account.
class SplashReturningScreen extends ConsumerStatefulWidget {
  const SplashReturningScreen({super.key});

  @override
  ConsumerState<SplashReturningScreen> createState() =>
      _SplashReturningScreenState();
}

class _SplashReturningScreenState extends ConsumerState<SplashReturningScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(RouteNames.home);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: authState.status == AuthStatus.loading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuraWidget(isBreathing: true, opacity: 0.5, scale: 0.8),
                    SizedBox(height: 24),
                    CircularProgressIndicator(color: AppColors.rose),
                    SizedBox(height: 16),
                    Text('Checking your session...'),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuraWidget(
                      isBreathing: false,
                      opacity: 0.5,
                      scale: 0.8,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome back',
                      style: TextStyles.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in with your email to continue.',
                      style: TextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Sign In',
                      onPressed: () {
                        _showLoginDialog(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'New here? Create an account to get started.',
                      style: TextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    GhostButton(
                      label: 'Create Account',
                      onPressed: () {
                        context.go(RouteNames.welcome);
                      },
                    ),
                    if (authState.error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        authState.error!,
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.terracotta,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          title: const Text(
            'Sign In',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 18,
              color: AppColors.mocha,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      borderSide: const BorderSide(color: AppColors.rose),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: AppColors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      borderSide: const BorderSide(color: AppColors.rose),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text;
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter email and password'),
                            backgroundColor: AppColors.terracotta,
                          ),
                        );
                        return;
                      }
                      setDialogState(() => isLoading = true);
                      await ref.read(authProvider.notifier).login(
                            email: email,
                            password: password,
                          );
                      if (context.mounted) Navigator.pop(context);
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Sign In',
                      style: TextStyle(color: AppColors.rose),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
