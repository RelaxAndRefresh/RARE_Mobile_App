// 2

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/permission_card.dart';
import 'account_sync_screen.dart';

class SoftScanScreen extends StatelessWidget {
  const SoftScanScreen({super.key});

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

              // H1 Heading
              Text(
                'The Soft Scan',
                style: AppTypography.h1,
              ),
              const SizedBox(height: 16),

              // Paragraph Body
              Text(
                'Camera permission is requested before any viewfinder renders.',
                style: AppTypography.body,
              ),
              const SizedBox(height: 32),

              // Permission Card
              PermissionCard(
                iconData: Icons.camera_alt_outlined,
                title: 'RARE needs your camera to scan your skin.',
                bodyText:
                'We’ll use the existing 47-variable engine to read tone, texture and hydration — nothing is stored without your consent.',
                primaryButtonText: 'Allow Camera',
                onPrimaryPressed: () {
                  // Camera logic...
                },
                secondaryButtonText: 'Skip Scan',
                onSecondaryPressed: () {
                  // Navigate to Screen 03 on tap:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSyncScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Champagne Gold Accent Line (1 of max 3 uses)
              const Divider(color: AppColors.luxuryDetail, thickness: 0.5),
              const SizedBox(height: 24),

              // Fallback Quote Text
              Text.rich(
                TextSpan(
                  style: AppTypography.body,
                  children: [
                    const TextSpan(text: 'Fallback if scan fails twice: '),
                    TextSpan(
                      text:
                      '"We couldn\'t quite get a clear read in this light. No worries — you can enter your skin type manually for now."',
                      style: AppTypography.quote.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Manual Selection Panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SKIN TYPE',
                      style: AppTypography.eyebrow.copyWith(color: AppColors.bodyMauve),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: const [
                        _SkinTypeChip(label: 'Dry', isSelected: true),
                        _SkinTypeChip(label: 'Oily', isSelected: false),
                        _SkinTypeChip(label: 'Combo', isSelected: false),
                        _SkinTypeChip(label: 'Sensitive', isSelected: false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkinTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _SkinTypeChip({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryAccent,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: isSelected ? AppColors.background : AppColors.primaryAccent,
        ),
      ),
    );
  }
}