import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';
import 'package:go_router/go_router.dart';

/// Screen 44 – Post-Treatment Protocol
/// Phase 4: Sovereign B2B OS.
/// Practitioner recommendations follow the same Defensive/Offensive split
/// as the algorithm. Pauses apply immediately; new products go to queue.
class PostTreatmentProtocolScreen extends StatefulWidget {
  const PostTreatmentProtocolScreen({super.key});

  @override
  State<PostTreatmentProtocolScreen> createState() =>
      _PostTreatmentProtocolScreenState();
}

class _PostTreatmentProtocolScreenState
    extends State<PostTreatmentProtocolScreen> {
  // Track which Offensive suggestions have been "accepted" (viewed)
  final Map<String, bool> _offensiveViewed = {
    'SPF 50 Recommended': false,
    'Barrier Recovery Mask': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Post-Treatment Protocol'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // Defensive suggestions section
            const Text(
              'DEFENSIVE SUGGESTIONS',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),

            // Defensive suggestion – auto-applied
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.rose,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'PROFESSIONAL ASSESSMENT',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Pause your current exfoliant for 5 days.',
                    style: TextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This pause has been applied to your routine automatically.',
                    style: TextStyles.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rose.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.rose.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: const Text(
                      'APPLIED',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.rose,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Offensive suggestions section (Practitioner Suggestions Queue)
            const Text(
              'PRACTITIONER SUGGESTIONS QUEUE',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),

            // Offensive suggestion 1
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NEW SUGGESTION',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.gold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'SPF 50 Recommended',
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on today\'s assessment, a higher SPF would benefit your skin.',
                    style: TextStyles.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Review on My Shelf',
                          onPressed: () {
                            setState(() {
                              _offensiveViewed['SPF 50 Recommended'] = true;
                            });
                            // Navigate to Shelf (Screen 13)
                            context.go(RouteNames.shelf);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_offensiveViewed['SPF 50 Recommended'] == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '✓ Added to your Shelf for review.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.rose,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Offensive suggestion 2
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NEW SUGGESTION',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.gold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Barrier Recovery Mask',
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Recommended for post-treatment recovery and soothing.',
                    style: TextStyles.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Review on My Shelf',
                          onPressed: () {
                            setState(() {
                              _offensiveViewed['Barrier Recovery Mask'] = true;
                            });
                            context.go(RouteNames.shelf);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_offensiveViewed['Barrier Recovery Mask'] == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '✓ Added to your Shelf for review.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.rose,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Audit trail note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                border: Border.all(color: AppColors.divider, width: 0.5),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.history,
                    size: 14,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Practitioner judgment is logged in the unified audit trail, '
                      'clearly labeled by source.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.mauve,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
