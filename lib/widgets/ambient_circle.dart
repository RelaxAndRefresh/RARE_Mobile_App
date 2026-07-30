import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AmbientCircle extends StatelessWidget {
  final double size;

  const AmbientCircle({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: AppColors.circleGradient,
          stops: [0.3, 1.0],
        ),
      ),
    );
  }
}