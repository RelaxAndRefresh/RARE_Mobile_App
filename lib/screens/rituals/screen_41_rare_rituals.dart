import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/aura_widget.dart';
import '../../widgets/tiles/list_tile.dart';

/// Screen 41 – RARE Rituals
/// A dedicated screen for daily native content:
/// guided breathwork, audio essays, and reflection prompts.
/// Includes a library of past rituals tagged by purpose.
class RareRitualsScreen extends StatelessWidget {
  const RareRitualsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('RARE Rituals'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // Featured Ritual – Guided Breathwork
            RareCard(
              child: Column(
                children: [
                  const Text(
                    'GUIDED BREATHWORK',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Morning Calm',
                    style: TextStyles.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  // Aura that pulses with breathwork
                  const AuraWidget(
                    isBreathing: true,
                    opacity: 0.7,
                    scale: 0.7,
                  ),
                  const SizedBox(height: 14),
                  // Progress bar (simulated)
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.linen,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 0.4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Playback controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.replay_10,
                          size: 20,
                          color: AppColors.mocha,
                        ),
                        onPressed: () {
                          // Restart / rewind 10 seconds
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildPlayButton(),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(
                          Icons.forward_10,
                          size: 20,
                          color: AppColors.mocha,
                        ),
                        onPressed: () {
                          // Forward 10 seconds
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '4:12 / 10:30',
                    style: TextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Library header
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'LIBRARY',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 3,
                  color: AppColors.terracotta,
                ),
              ),
            ),

            // Library items
            _libraryItem(
              title: 'Ingredient Science: Niacinamide',
              subtitle: '4 min',
              tag: 'Education',
              onTap: () {
                // Load this ritual
              },
            ),
            _libraryItem(
              title: 'Barrier Recovery Reflection',
              subtitle: '5 min',
              tag: 'Reflection',
              onTap: () {
                // Load this ritual
              },
            ),
            _libraryItem(
              title: 'Morning Gratitude Practice',
              subtitle: '3 min',
              tag: 'Morning Calm',
              onTap: () {
                // Load this ritual
              },
            ),
            _libraryItem(
              title: 'Evening Wind-Down',
              subtitle: '6 min',
              tag: 'Evening',
              onTap: () {
                // Load this ritual
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    // Stateful play/pause – simplified for demonstration
    // In a real app, this would track audio playback state
    return GestureDetector(
      onTap: () {
        // Toggle play/pause
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.mocha,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.play_arrow,
          color: AppColors.cream,
          size: 28,
        ),
      ),
    );
  }

  Widget _libraryItem({
    required String title,
    required String subtitle,
    required String tag,
    required VoidCallback onTap,
  }) {
    return ListTileWidget(
      title: title,
      subtitle: subtitle,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.linen,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.mauve,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
