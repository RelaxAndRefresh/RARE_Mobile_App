// 13

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Eyebrow


              const SizedBox(height: 16),

              /// Title
              Text(
                "The Shelf",
                style: AppTypography.h1,
              ),

              const SizedBox(height: 20),

              /// Subtitle
              Text(
                "A mirror, not a storefront — no buy buttons here.",
                style: AppTypography.body,
              ),

              const SizedBox(height: 36),

              const _ShelfItem(
                title: "Barrier Repair Serum",
                status: "Standard",
                color: Color(0xffCB8775),
              ),

              const _ShelfItem(
                title: "Vitamin C Elixir",
                status: "Armed",
                color: Color(0xffB0604C),
              ),

              const _ShelfItem(
                title: "Gentle Exfoliant",
                status: "Depleted",
                color: Color(0xffB89A85),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  "Tap any product to see why it's Armed or Depleted — the Contextual Reveal explains the reasoning in plain language.",
                  style: AppTypography.body.copyWith(
                    color: AppColors.bodyMauve,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShelfItem extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  const _ShelfItem({
    required this.title,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        // TODO:
        // Show Contextual Reveal bottom sheet.
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.h1.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Text(
                  status,
                  style: AppTypography.body.copyWith(
                    color: AppColors.bodyMauve,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Divider(
              color: AppColors.bodyMauve.withOpacity(.18),
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}