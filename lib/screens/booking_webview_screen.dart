// 22

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';



class BookingWebviewScreen extends StatelessWidget {
  const BookingWebviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Eyebrow label

              const SizedBox(height: 16),

              // Heading with single italic accent word
              RichText(
                text: TextSpan(
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 34,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkMocha,
                  ),
                  children: [
                    const TextSpan(text: 'Booking '),
                    TextSpan(
                      text: 'Webview',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 34,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'Pre-loaded with her existing credentials and payment method.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // Card / webview mock
              _BookingWebviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingWebviewCard extends StatefulWidget {
  @override
  State<_BookingWebviewCard> createState() => _BookingWebviewCardState();
}

class _BookingWebviewCardState extends State<_BookingWebviewCard> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: const Cubic(0.23, 1, 0.32, 1),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fake browser chrome
          Row(
            children: [
              _dot(),
              const SizedBox(width: 6),
              _dot(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'relaxedandrefresh.com/book',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.jost(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: AppColors.warmGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Booking details "web content"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THURSDAY · 3:30 PM',
                  style: GoogleFonts.jost(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3,
                    color: AppColors.warmGrey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Restorative Facial — 60 min',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkMocha,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Same anonymous-user and offline pre-flight checks as Screen 21 apply here.',
                  style: GoogleFonts.jost(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    height: 1.5,
                    color: AppColors.bodyMauve,
                  ),
                ),
                const SizedBox(height: 24),
                _ConfirmAndPayButton(
                  isHovering: _isHovering,
                  isPressed: _isPressed,
                  onHoverChanged: (v) => setState(() => _isHovering = v),
                  onPressedChanged: (v) => setState(() => _isPressed = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.warmGrey,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Primary button per spec: bg #2E1A1A, text #FAF4EE, hover bg #A4594A.
class _ConfirmAndPayButton extends StatelessWidget {
  final bool isHovering;
  final bool isPressed;
  final ValueChanged<bool> onHoverChanged;
  final ValueChanged<bool> onPressedChanged;

  const _ConfirmAndPayButton({
    required this.isHovering,
    required this.isPressed,
    required this.onHoverChanged,
    required this.onPressedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isHovering ? AppColors.hoverTerracotta : AppColors.darkMocha;

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
          // TODO: wire up confirm & pay action
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: 48, // >= 44px min touch target
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
            'CONFIRM & PAY',
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