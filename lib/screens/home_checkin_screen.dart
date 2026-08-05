// 8

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'quick_log_screen.dart';
import 'shelf_screen.dart';
import 'insights_biweek_screen.dart';

class HomeCheckinScreen extends StatefulWidget {
  const HomeCheckinScreen({super.key});

  @override
  State<HomeCheckinScreen> createState() => _HomeCheckinScreenState();
}

class _HomeCheckinScreenState extends State<HomeCheckinScreen> {
  int hydrationCount = 4;
  final int totalHydration = 8;

  // Helper method to format today's date with spaced characters
  String _getFormattedDynamicDate() {
    final now = DateTime.now();
    // Formats date as: "TUESDAY, 28 JULY"
    final rawDate = DateFormat('EEEE, d MMMM').format(now).toUpperCase();

    // Inserts spacing between characters to match design typography
    return rawDate.split('').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Dynamic Date Header
              Text(
                _getFormattedDynamicDate(),
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkMocha.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 32),

              // Aura Orb / Soft Sphere
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFDCA092).withOpacity(0.9),
                      const Color(0xFFECC4B8).withOpacity(0.6),
                      AppColors.background.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.65, 1.0],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Quote / Affirmation Text
              Text(
                "Soft mornings\nmake honest days.",
                textAlign: TextAlign.center,
                style: AppTypography.h1.copyWith(
                  fontSize: 26,
                  height: 1.3,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  color: AppColors.darkMocha,
                ),
              ),

              const SizedBox(height: 36),

              // Hydration Vessel Card
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (hydrationCount < totalHydration) {
                      hydrationCount++;
                    } else {
                      hydrationCount = 0;
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E2DA).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "HYDRATION VESSEL",
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkMocha.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: hydrationCount / totalHydration,
                          minHeight: 14,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFD39B8E),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "$hydrationCount of $totalHydration taps today — tap to fill",
                        style: AppTypography.body.copyWith(
                          fontSize: 12,
                          color: AppColors.darkMocha.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Action Buttons Row (Shelf, Quick Log, Insights)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.shopping_bag_outlined,
                    label: "Shelf",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShelfScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.eco_outlined,
                    label: "Quick Log",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuickLogScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.nightlight_outlined,
                    label: "Insights",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InsightsBiweekScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: AppColors.darkMocha.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.darkMocha.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}