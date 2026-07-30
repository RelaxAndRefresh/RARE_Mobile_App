import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class RAREOutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const RAREOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<RAREOutlineButton> createState() => _RAREOutlineButtonState();
}

class _RAREOutlineButtonState extends State<RAREOutlineButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = _isHovered ? AppColors.primaryAccent : AppColors.luxuryDetail;
    final textColor = _isHovered ? AppColors.primaryAccent : AppColors.darkMocha;

    return FocusableActionDetector(
      onShowHoverHighlight: (hovered) => setState(() => _isHovered = hovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: const Cubic(0.23, 1, 0.32, 1),
        constraints: const BoxConstraints(minHeight: 44),
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13), // Adjusted horizontal padding to 24 to allow text room to breathe
            side: BorderSide(color: activeColor, width: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text.toUpperCase(),
            textAlign: TextAlign.center, // <-- Added explicit center alignment
            style: AppTypography.buttonText.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}