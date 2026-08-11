// 31

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class OrderBookingHistoryScreen extends StatelessWidget {
  const OrderBookingHistoryScreen({super.key});

  static const List<_HistoryEntry> _upcoming = [
    _HistoryEntry(title: 'Restorative Facial — Thu, 3:30pm'),
  ];

  static const List<_HistoryEntry> _past = [
    _HistoryEntry(title: 'Barrier Repair Serum — 12 Jul'),
    _HistoryEntry(title: 'Guided Reflexology — 2 Jul'),
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
                'Order & Booking History',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'Upcoming bookings separated from past orders — no buy buttons.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // UPCOMING section
              _SectionLabel(text: 'UPCOMING'),
              const SizedBox(height: 16),
              for (int i = 0; i < _upcoming.length; i++) ...[
                _HistoryRow(entry: _upcoming[i]),
                if (i != _upcoming.length - 1) _Divider(),
              ],
              const SizedBox(height: 8),
              _Divider(),
              const SizedBox(height: 24),

              // PAST section
              _SectionLabel(text: 'PAST'),
              const SizedBox(height: 16),
              for (int i = 0; i < _past.length; i++) ...[
                _HistoryRow(entry: _past[i]),
                if (i != _past.length - 1) _Divider(),
              ],
              const SizedBox(height: 8),
              _Divider(),
              const SizedBox(height: 24),

              // Footnote
              Text(
                '"Need to reschedule? We can help with that." → routes to the same '
                    'Manage Booking webview as Help & Support.',
                style: GoogleFonts.jost(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.warmGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryEntry {
  final String title;

  const _HistoryEntry({required this.title});
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jost(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 3,
        color: AppColors.primaryAccent,
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

class _HistoryRow extends StatefulWidget {
  final _HistoryEntry entry;

  const _HistoryRow({required this.entry});

  @override
  State<_HistoryRow> createState() => _HistoryRowState();
}

class _HistoryRowState extends State<_HistoryRow> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          // TODO: navigate to booking/order detail
        },
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
                  widget.entry.title,
                  style: GoogleFonts.jost(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: AppColors.darkMocha,
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