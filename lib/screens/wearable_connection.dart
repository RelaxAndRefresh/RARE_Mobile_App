// 6

import 'package:flutter/material.dart';
import 'aura_intro_screen.dart';

class WearableConnectionScreen extends StatelessWidget {
  const WearableConnectionScreen({Key? key}) : super(key: key);

  // Color Palette Definitions
  static const Color backgroundColor = Color(0xFFFAF5EF);
  static const Color cardColor = Color(0xFFF3E6DF);
  static const Color primaryTextColor = Color(0xFF2A1D17);
  static const Color secondaryTextColor = Color(0xFF8C7A6B);
  static const Color borderOutlineColor = Color(0xFF8C7A6B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title Header
              const Text(
                'Wearable Connection',
                style: TextStyle(
                  fontFamily: 'Serif', // Ensure a serif font like Playfair Display is configured in pubspec.yaml
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle Description
              const Text(
                'OS-level only — Apple Health & Google Fit. Most Indian wearables already sync there.',
                style: TextStyle(
                  fontSize: 13,
                  color: secondaryTextColor,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // Apple Health Integration Card
              _buildWearableCard(
                title: 'Apple Health',
                onConnectPressed: () {
                  // Connect to Apple Health logic
                },
              ),

              const SizedBox(height: 16),

              // Google Fit Integration Card
              _buildWearableCard(
                title: 'Google Fit',
                onConnectPressed: () {
                  // Connect to Google Fit logic
                },
              ),

              const Spacer(),

              // Bottom Disclaimer Text
              const Text(
                'No wearable? Totally fine — manual logging covers everything RARE needs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: secondaryTextColor,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Skip For Now Button
              // Skip For Now Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuraIntroScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: borderOutlineColor, width: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: const Text(
                    'SKIP FOR NOW',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Card Widget for Apple Health & Google Fit
  Widget _buildWearableCard({
    required String title,
    required VoidCallback onConnectPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          // Outline Heart Icon
          const Icon(
            Icons.favorite_border_rounded,
            color: secondaryTextColor,
            size: 26,
          ),
          const SizedBox(width: 12),

          // Platform Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: primaryTextColor,
              ),
            ),
          ),

          // Connect Action Button
          SizedBox(
            height: 36,
            child: OutlinedButton(
              onPressed: onConnectPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: borderOutlineColor, width: 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
              ),
              child: const Text(
                'CONNECT',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}