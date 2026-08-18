import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class AuraWidget extends StatefulWidget {
  final double opacity;
  final double scale;
  final bool isBreathing;
  final bool isDormant;

  const AuraWidget({
    super.key,
    this.opacity = 1.0,
    this.scale = 1.0,
    this.isBreathing = true,
    this.isDormant = false,
  });

  @override
  State<AuraWidget> createState() => _AuraWidgetState();
}

class _AuraWidgetState extends State<AuraWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseOpacity = widget.isDormant ? 0.18 : widget.opacity;
    final baseScale = widget.isDormant ? 0.6 : widget.scale;

    if (!widget.isBreathing) {
      return _buildStaticAura(baseOpacity, baseScale);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _buildStaticAura(
          baseOpacity * _opacityAnimation.value,
          baseScale * _scaleAnimation.value,
        );
      },
    );
  }

  Widget _buildStaticAura(double opacity, double scale) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(0.4, 0.35),
            colors: [
              AppColors.rose.withOpacity(0.8 * opacity),
              AppColors.rose.withOpacity(0.15 * opacity),
            ],
            stops: const [0.3, 1.0],
          ),
        ),
      ),
    );
  }
}
