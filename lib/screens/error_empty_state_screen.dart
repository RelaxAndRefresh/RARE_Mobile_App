// 30

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class ErrorEmptyStatesScreen extends StatelessWidget {
  const ErrorEmptyStatesScreen({super.key});

  static const List<_StateEntry> _states = [
    _StateEntry(
      label: 'ERROR',
      message: "Something feels off. Let's try again.",
    ),
    _StateEntry(
      label: 'EMPTY CART',
      message: 'Your ritual awaits. Start here.',
    ),
    _StateEntry(
      label: 'OUT OF STOCK',
      message: 'This one is resting. Check back soon.',
    ),
    _StateEntry(
      label: 'CONFIRMATION',
      message: 'Your order is on its way to you.',
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
                'Error / Empty States',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'Every screen carries its own calm, brand-voice empty / error copy.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // State cards
              for (int i = 0; i < _states.length; i++) ...[
                _StateCard(entry: _states[i]),
                if (i != _states.length - 1) const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StateEntry {
  final String label;
  final String message;

  const _StateEntry({required this.label, required this.message});
}

class _StateCard extends StatelessWidget {
  final _StateEntry entry;

  const _StateCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.label,
            style: GoogleFonts.jost(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
              color: AppColors.warmGrey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            entry.message,
            style: GoogleFonts.jost(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.darkMocha,
            ),
          ),
        ],
      ),
    );
  }
}