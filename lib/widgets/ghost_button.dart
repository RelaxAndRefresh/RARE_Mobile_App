import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class RAREGhostButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const RAREGhostButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<RAREGhostButton> createState() => _RAREGhostButtonState();
}

class _RAREGhostButtonState extends State<RAREGhostButton> {
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
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: _isHovered ? AppColors.primaryAccent.withOpacity(0.1) : Colors.transparent,
            foregroundColor: AppColors.primaryAccent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 13),
            side: const BorderSide(color: AppColors.primaryAccent, width: 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text.toUpperCase(),
            style: AppTypography.buttonText.copyWith(color: AppColors.primaryAccent),
          ),
        ),
      ),
    );
  }
}