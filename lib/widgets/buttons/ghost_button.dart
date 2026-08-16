import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;

  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: AppColors.gold, width: 0.5),
          foregroundColor: AppColors.mocha,
          textStyle: const TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.w400,
            fontSize: 10,
            letterSpacing: 3,
          ),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
        ),
        child: Text(label.toUpperCase()),
      ),
    );
  }
}
