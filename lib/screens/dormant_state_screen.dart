// 29

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class WelcomeBackCheckInScreen extends StatefulWidget {
  const WelcomeBackCheckInScreen({super.key});

  @override
  State<WelcomeBackCheckInScreen> createState() =>
      _WelcomeBackCheckInScreenState();
}

class _WelcomeBackCheckInScreenState extends State<WelcomeBackCheckInScreen> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 56),

              // Ambient Aura circle
              const _AuraCircle(),
              const SizedBox(height: 56),

              // Quote — Cormorant Garamond Light Italic, Dusty Rose
              Text(
                'Welcome back.\nThe garden missed the sun.',
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                  color: AppColors.primaryAccent,
                ),
              ),
              const SizedBox(height: 24),

              // Body copy — never Dark Mocha
              Text(
                "Let's breathe together.",
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 40),

              // Primary CTA
              _CheckInButton(
                isHovering: _isHovering,
                isPressed: _isPressed,
                onHoverChanged: (v) => setState(() => _isHovering = v),
                onPressedChanged: (v) => setState(() => _isPressed = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ambient radial-gradient circle using AppColors.circleGradient.
class _AuraCircle extends StatelessWidget {
  const _AuraCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: AppColors.circleGradient,
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkMocha.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
    );
  }
}

/// Primary button per spec: bg #2E1A1A, text #FAF4EE, hover bg #A4594A.
class _CheckInButton extends StatelessWidget {
  final bool isHovering;
  final bool isPressed;
  final ValueChanged<bool> onHoverChanged;
  final ValueChanged<bool> onPressedChanged;

  const _CheckInButton({
    required this.isHovering,
    required this.isPressed,
    required this.onHoverChanged,
    required this.onPressedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg =
    isHovering ? AppColors.hoverTerracotta : AppColors.darkMocha;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        onTapDown: (_) => onPressedChanged(true),
        onTapUp: (_) => onPressedChanged(false),
        onTapCancel: () => onPressedChanged(false),
        onTap: () {
          HapticFeedback.selectionClick();
          // TODO: wire up check-in action
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 48),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isHovering
                ? [
              BoxShadow(
                color: AppColors.darkMocha.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
                : [],
          ),
          child: Text(
            'CHECK IN',
            style: GoogleFonts.jost(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
              color: AppColors.background,
            ),
          ),
        ),
      ),
    );
  }
}