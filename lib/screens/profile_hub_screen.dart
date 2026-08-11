// 33

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class ProfileHubScreen extends StatelessWidget {
  const ProfileHubScreen({super.key});

  static const List<String> _menuItems = [
    'Settings',
    'Privacy Dashboard',
    'Cycle Calendar',
    'Order & Booking History',
    'Credits Ledger',
    'Account Details',
    'The Kill Switch',
  ];

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
                'Profile Hub',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'A central directory — not a decorative profile page.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // Menu items
              for (int i = 0; i < _menuItems.length; i++) ...[
                _MenuRow(
                  label: _menuItems[i],
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // TODO: navigate to ${_menuItems[i]}
                  },
                ),
                _Divider(),
              ],
              const SizedBox(height: 24),

              // Connect account card
              const _ConnectAccountCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        color: AppColors.warmGrey.withOpacity(0.3),
        height: 1,
        thickness: 0.5,
      ),
    );
  }
}

class _MenuRow extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuRow({required this.label, required this.onTap});

  @override
  State<_MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<_MenuRow> {
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.jost(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: AppColors.bodyMauve,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: _isHovering
                    ? AppColors.primaryAccent
                    : AppColors.primaryAccent.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConnectAccountCard extends StatefulWidget {
  const _ConnectAccountCard();

  @override
  State<_ConnectAccountCard> createState() => _ConnectAccountCardState();
}

class _ConnectAccountCardState extends State<_ConnectAccountCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color lineColor =
    _isHovering ? AppColors.primaryAccent : AppColors.luxuryDetail;
    final Color textColor =
    _isHovering ? AppColors.primaryAccent : AppColors.darkMocha;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connected as anon_profile —',
            style: GoogleFonts.jost(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.warmGrey,
            ),
          ),
          const SizedBox(height: 20),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                // TODO: wire up RARE account connect flow
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 44),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: lineColor, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'CONNECT RARE ACCOUNT',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jost(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}