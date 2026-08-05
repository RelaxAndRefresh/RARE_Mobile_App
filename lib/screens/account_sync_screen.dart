//3

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/outline_button.dart';
import '../widgets/primary_button.dart';
import 'privacy_consent_screen.dart';

class AccountSyncScreen extends StatelessWidget {
  const AccountSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),


              // 2. Page Title
              Text(
                'Account Sync',
                style: AppTypography.h1,
              ),
              const SizedBox(height: 16),

              // 3. Description
              Text(
                'Connect your relaxedandrefresh.com account — never a raw password field.',
                style: AppTypography.body,
              ),
              const SizedBox(height: 32),

              // 4. Account Connection Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface, // Blush Linen (#F2DDD5)
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Line Icon (Person outline in Dusty Rose / Champagne Gold)
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 32,
                      color: AppColors.primaryAccent,
                    ),
                    const SizedBox(height: 20),

                    // Card Title
                    Text(
                      'Welcome back, in one tap',
                      textAlign: TextAlign.center,
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: 12),

                    // Subtitle Body Text
                    Text(
                      'Securely bridges to your existing RARE account via OAuth.',
                      textAlign: TextAlign.center,
                      style: AppTypography.body,
                    ),
                    const SizedBox(height: 28),

                    // Primary CTA
                    PrimaryButton(
                      text: 'Connect My Account',
                      onPressed: () {
                        // TODO: OAuth connection flow
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 5. Outline Secondary Button
              RAREOutlineButton(
                text: 'Skip For Now — Start Anonymously',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacyConsentScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 6. Explanatory Note (Caption style)
              Text(
                'Skipping creates a local, anonymous profile. Your Shelf stays empty and Auto-Swap stays dormant until you connect later from Profile Hub.',
                style: AppTypography.caption,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}