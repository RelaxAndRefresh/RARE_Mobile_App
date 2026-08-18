import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';

/// Screen 38 – Legal Documents Viewer
/// Native text renderer for Privacy Policy / Terms of Service.
/// Warm Cream background, Jost 300 Light body copy.
class LegalDocumentsScreen extends StatelessWidget {
  const LegalDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Privacy Policy',
                style: TextStyles.headlineMedium,
              ),
              const SizedBox(height: 16),

              // Last updated
              Text(
                'Last updated: July 2026',
                style: TextStyles.bodySmall,
              ),
              const SizedBox(height: 24),

              // Body text
              _buildSection(
                'Introduction',
                'RARE collects only what\'s needed to personalize your wellness experience, governed under India\'s DPDP framework. This policy explains how we collect, use, and protect your data.',
              ),
              _buildSection(
                'What We Collect',
                '• Phone activity (sleep inference)\n'
                    '• Pin code (environmental data)\n'
                    '• Cycle tracking (if you choose to share)\n'
                    '• Skin photo storage (with your consent)\n'
                    '• Purchase history (Shelf / Auto-Swap)\n'
                    '• Wearable & health data (Apple Health / Google Fit)',
              ),
              _buildSection(
                'How We Use It',
                'All data is used solely for personalizing your RARE experience. We do not sell or share your data with third parties for advertising. Aggregated, anonymized data may be used for research to improve our Precision Engine.',
              ),
              _buildSection(
                'Your Rights (DPDP)',
                '• Right to Access: Download your data at any time.\n'
                    '• Right to Correction: Edit your logs and profile.\n'
                    '• Right to Erasure: Use the Kill Switch to delete all app data.\n'
                    '• Right to Withdraw Consent: Toggle permissions off anytime in Privacy Dashboard.',
              ),
              _buildSection(
                'Data Security',
                'We use industry-standard encryption for data at rest and in transit. Access to personal data is strictly limited to essential service provision.',
              ),
              _buildSection(
                'Contact',
                'For any privacy-related questions, please contact us through the Help & Support section.',
              ),
              const SizedBox(height: 32),
              // Footer
              Text(
                'RARE — Unified Wellness Atmosphere',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.grey,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String heading, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyles.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyles.bodyMedium.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
