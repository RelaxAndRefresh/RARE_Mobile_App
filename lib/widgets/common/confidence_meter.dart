import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ConfidenceMeter extends StatelessWidget {
  final int filledSegments; // 0, 1, 2, 3

  const ConfidenceMeter({super.key, required this.filledSegments});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 16,
          height: 5,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: index < filledSegments ? AppColors.gold : AppColors.linen,
          ),
        );
      }),
    );
  }
}
