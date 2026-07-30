import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowHoverHighlight: (hovered) => setState(() => _isHovered = hovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: const Cubic(0.23, 1, 0.32, 1),
        constraints: const BoxConstraints(minHeight: 44),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered ? AppColors.hoverTerracotta : AppColors.darkMocha,
            foregroundColor: AppColors.background,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text.toUpperCase(),
            style: AppTypography.buttonText.copyWith(color: AppColors.background),
          ),
        ),
      ),
    );
  }
}