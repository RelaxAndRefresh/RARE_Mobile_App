// 32

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CreditsLedgerScreen extends StatelessWidget {
  const CreditsLedgerScreen({super.key});

  static const int _currentBalance = 340;

  static const List<_LedgerEntry> _entries = [
    _LedgerEntry(
      amount: 10,
      label: 'AM Check-in',
      timestamp: 'Today',
    ),
    _LedgerEntry(
      amount: 15,
      label: 'Resonance Milestone',
      timestamp: '3 days ago',
    ),
    _LedgerEntry(
      amount: 50,
      label: 'Refund: Reflexology',
      timestamp: '1 week ago',
    ),
    _LedgerEntry(
      amount: -120,
      label: 'Ritual Spend',
      timestamp: '2 weeks ago',
    ),
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
                'Credits Ledger',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'A plain running balance — credits apply automatically at checkout.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // Balance card
              const _BalanceCard(balance: _currentBalance),
              const SizedBox(height: 24),

              // Ledger entries
              for (int i = 0; i < _entries.length; i++) ...[
                _LedgerRow(entry: _entries[i]),
                if (i != _entries.length - 1) _Divider(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final int balance;

  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'CURRENT BALANCE',
            style: GoogleFonts.jost(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
              color: AppColors.warmGrey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '₹$balance',
            style: GoogleFonts.playfairDisplay(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: AppColors.darkMocha,
            ),
          ),
        ],
      ),
    );
  }
}

class _LedgerEntry {
  final int amount;
  final String label;
  final String timestamp;

  const _LedgerEntry({
    required this.amount,
    required this.label,
    required this.timestamp,
  });

  bool get isPositive => amount >= 0;

  String get formattedAmount =>
      isPositive ? '+$amount' : '$amount'; // negative already has "-"
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

class _LedgerRow extends StatelessWidget {
  final _LedgerEntry entry;

  const _LedgerRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${entry.formattedAmount} · ${entry.label}',
              style: GoogleFonts.jost(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: AppColors.darkMocha,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            entry.timestamp,
            style: GoogleFonts.jost(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.warmGrey,
            ),
          ),
        ],
      ),
    );
  }
}