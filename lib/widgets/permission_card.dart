import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'outline_button.dart';
import 'primary_button.dart';

class PermissionCard extends StatelessWidget {
  final IconData? iconData;
  final String title;
  final String bodyText;
  final String primaryButtonText;
  final VoidCallback onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  const PermissionCard({
    super.key,
    this.iconData,
    required this.title,
    required this.bodyText,
    required this.primaryButtonText,
    required this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardSurface, // Blush Linen
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null) ...[
            Icon(
              iconData,
              size: 32,
              color: AppColors.luxuryDetail, // Champagne Gold line icon
            ),
            const SizedBox(height: 24),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.h3,
          ),
          const SizedBox(height: 16),
          Text(
            bodyText,
            textAlign: TextAlign.center,
            style: AppTypography.body,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: primaryButtonText,
            onPressed: onPrimaryPressed,
          ),
          if (secondaryButtonText != null && onSecondaryPressed != null) ...[
            const SizedBox(height: 16),
            RAREOutlineButton(
              text: secondaryButtonText!,
              onPressed: onSecondaryPressed!,
            ),
          ],
        ],
      ),
    );
  }
}