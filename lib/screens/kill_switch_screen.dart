// 27

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';


class KillSwitchScreen extends StatelessWidget {
  const KillSwitchScreen({super.key});

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
              // Heading
              Text(
                'The Kill Switch',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'One clear, confirmed action — DPDP Right to Be Forgotten.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // Confirmation card
              const _DeleteConfirmationCard(),
              const SizedBox(height: 24),

              // Footnote
              Text(
                "After deletion: \"To fully revoke RARE's access to your Apple Health / "
                    "Google Fit data, turn it off in your phone's Privacy settings.\"",
                style: GoogleFonts.jost(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteConfirmationCard extends StatelessWidget {
  const _DeleteConfirmationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Trash icon — luxury detail line usage
          Icon(
            Icons.delete_outline,
            size: 28,
            color: AppColors.luxuryDetail,
          ),
          const SizedBox(height: 16),
          Text(
            'Delete all app data?',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: AppColors.darkMocha,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "This deletes wellness logs, insights, and Aura state. It does not "
                "cancel bookings or delete website orders — you'll need to manage "
                "those separately.",
            textAlign: TextAlign.center,
            style: GoogleFonts.jost(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              height: 1.6,
              color: AppColors.bodyMauve,
            ),
          ),
          const SizedBox(height: 24),
          _DeleteEverythingButton(
            onTap: () {
              HapticFeedback.selectionClick();
              // TODO: wire up destructive delete-all-data action
            },
          ),
          const SizedBox(height: 12),
          _CancelButton(
            onTap: () {
              HapticFeedback.selectionClick();
              // TODO: wire up cancel / dismiss action
            },
          ),
        ],
      ),
    );
  }
}

/// Primary destructive button: bg #2E1A1A, text #FAF4EE, hover bg #A4594A.
class _DeleteEverythingButton extends StatefulWidget {
  final VoidCallback onTap;

  const _DeleteEverythingButton({required this.onTap});

  @override
  State<_DeleteEverythingButton> createState() =>
      _DeleteEverythingButtonState();
}

class _DeleteEverythingButtonState extends State<_DeleteEverythingButton> {
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
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 48),
          alignment: Alignment.center,
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
            'YES, DELETE EVERYTHING',
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

/// Ghost button: border #C9897A 1px, text #C9897A |
/// hover: bg rgba(201,137,122,0.1).
class _CancelButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CancelButton({required this.onTap});

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 48),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isHovering
                ? AppColors.primaryAccent.withOpacity(0.1)
                : Colors.transparent,
            border: Border.all(color: AppColors.primaryAccent, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'CANCEL',
            style: GoogleFonts.jost(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
              color: AppColors.primaryAccent,
            ),
          ),
        ),
      ),
    );
  }
}