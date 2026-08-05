// 18

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class RoutineInterventionLogScreen extends StatelessWidget {
  const RoutineInterventionLogScreen({super.key});

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
              const SizedBox(height: 16),

              /// Title
              Text(
                'Routine Intervention Log',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                'Unified audit trail — algorithmic and human changes, logged the same way.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 36),

              const InterventionLogItem(
                tag: 'ALGORITHM',
                title: 'Paused Retinol',
                time: '2 days ago',
              ),

              const InterventionLogItem(
                tag: 'AUTO_SWAP',
                title: 'Swapped to Barrier\nSerum',
                time: '5 days\nago',
              ),

              const InterventionLogItem(
                tag: 'PRACTITIONER',
                title: 'Recommended SPF\nincrease — Prof. Assessment',
                time: '1 week\nago',
              ),

              const InterventionLogItem(
                tag: 'MANUAL_EDIT',
                title: 'Corrected Sleep to 6h',
                time: '1 week ago',
                showDivider: false,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class InterventionLogItem extends StatelessWidget {
  final String tag;
  final String title;
  final String time;
  final bool showDivider;

  const InterventionLogItem({
    super.key,
    required this.tag,
    required this.title,
    required this.time,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Tag
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.primaryAccent.withOpacity(.35),
                ),
              ),
              child: Text(
                tag,
                style: AppTypography.caption.copyWith(
                  color: AppColors.darkMocha,
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// Description
            Expanded(
              child: Text(
                title,
                style: AppTypography.h3,
              ),
            ),

            const SizedBox(width: 12),

            /// Time
            SizedBox(
              width: 70,
              child: Text(
                time,
                textAlign: TextAlign.right,
                style: AppTypography.caption,
              ),
            ),
          ],
        ),

        if (showDivider) ...[
          const SizedBox(height: 24),
          Divider(
            color: AppColors.primaryAccent.withOpacity(.15),
            thickness: 1,
          ),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}