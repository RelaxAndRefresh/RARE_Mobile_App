// 24

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class DepletionConfirmationScreen extends StatelessWidget {
  const DepletionConfirmationScreen({super.key});

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

              // Heading
              Text(
                'Depletion Confirmation',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'The Honest Guess Protocol — restock flow.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // Card
              _DepletionCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DepletionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Still have some of your Vitamin C Elixir?',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              height: 1.3,
              color: AppColors.darkMocha,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'A gentle check-in, never a countdown.',
            textAlign: TextAlign.center,
            style: GoogleFonts.jost(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.warmGrey,
            ),
          ),
          const SizedBox(height: 24),

          // Two buttons side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _OutlineChoiceButton(
                  label: 'STILL\nHAVE\nSOME',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // TODO: wire up "still have some" action
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PrimaryChoiceButton(
                  label: 'NEED TO\nRESTOCK',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // TODO: wire up "need to restock" action
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Outline button per spec: border #D4AF7A 0.5px, text #2E1A1A |
/// hover: border+text #C9897A.
class _OutlineChoiceButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineChoiceButton({required this.label, required this.onTap});

  @override
  State<_OutlineChoiceButton> createState() => _OutlineChoiceButtonState();
}

class _OutlineChoiceButtonState extends State<_OutlineChoiceButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color lineColor =
    _isHovering ? AppColors.primaryAccent : AppColors.luxuryDetail;
    final Color textColor =
    _isHovering ? AppColors.primaryAccent : AppColors.darkMocha;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: lineColor, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.jost(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
              height: 1.6,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Primary button per spec: bg #2E1A1A, text #FAF4EE, hover bg #A4594A.
class _PrimaryChoiceButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryChoiceButton({required this.label, required this.onTap});

  @override
  State<_PrimaryChoiceButton> createState() => _PrimaryChoiceButtonState();
}

class _PrimaryChoiceButtonState extends State<_PrimaryChoiceButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color bg =
    _isHovering ? AppColors.hoverTerracotta : AppColors.darkMocha;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          constraints: const BoxConstraints(minHeight: 44),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isHovering
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
            widget.label,
            textAlign: TextAlign.center,
            style: GoogleFonts.jost(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
              height: 1.6,
              color: AppColors.background,
            ),
          ),
        ),
      ),
    );
  }
}