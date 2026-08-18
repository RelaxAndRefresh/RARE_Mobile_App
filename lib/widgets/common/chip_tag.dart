import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ChipTag extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const ChipTag({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        margin: const EdgeInsets.only(right: 5, bottom: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.rose : AppColors.rose,
          ),
          color: selected ? AppColors.rose : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: selected ? AppColors.cream : AppColors.rose,
          ),
        ),
      ),
    );
  }
}
