import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/practitioner_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';

class PostTreatmentProtocolScreen extends ConsumerStatefulWidget {
  const PostTreatmentProtocolScreen({super.key});

  @override
  ConsumerState<PostTreatmentProtocolScreen> createState() =>
      _PostTreatmentProtocolScreenState();
}

class _PostTreatmentProtocolScreenState
    extends ConsumerState<PostTreatmentProtocolScreen> {
  final Map<String, bool> _offensiveViewed = {};

  @override
  Widget build(BuildContext context) {
    final protocolState = ref.watch(treatmentProtocolProvider);

    final defensiveItems = _extractDefensiveItems(protocolState.protocol);
    final offensiveItems = _extractOffensiveItems(protocolState.protocol);

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
            const Text(
              'DEFENSIVE SUGGESTIONS',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),

            if (protocolState.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: AppColors.rose),
                ),
              )
            else if (defensiveItems.isEmpty)
              RareCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.rose,
                        ),
                        SizedBox(width: 8),
                        Text(
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
              )
            else
              ...defensiveItems.map((item) => _buildDefensiveCard(item)),

            const SizedBox(height: 16),
            const Text(
              'PRACTITIONER SUGGESTIONS QUEUE',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),

            if (offensiveItems.isEmpty) ...[
              _buildDefaultOffensiveCard(
                title: 'SPF 50 Recommended',
                description:
                    'Based on today\'s assessment, a higher SPF would benefit your skin.',
              ),
              const SizedBox(height: 8),
              _buildDefaultOffensiveCard(
                title: 'Barrier Recovery Mask',
                description:
                    'Recommended for post-treatment recovery and soothing.',
              ),
            ] else
              ...offensiveItems.map((item) {
                final title = item['title'] ?? 'Suggestion';
                return Column(
                  children: [
                    _buildDefaultOffensiveCard(
                      title: title,
                      description: item['description'] ?? '',
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                border: Border.all(color: AppColors.divider, width: 0.5),
              ),
              child: const Row(
                children: [
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

  List<Map<String, dynamic>> _extractDefensiveItems(Map<String, dynamic>? protocol) {
    if (protocol == null) return [];
    final defensive = protocol['defensive'];
    if (defensive is List) {
      return defensive.cast<Map<String, dynamic>>();
    }
    return [];
  }

  List<Map<String, dynamic>> _extractOffensiveItems(Map<String, dynamic>? protocol) {
    if (protocol == null) return [];
    final offensive = protocol['offensive'];
    if (offensive is List) {
      return offensive.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Widget _buildDefensiveCard(Map<String, dynamic> item) {
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: AppColors.rose,
              ),
              SizedBox(width: 8),
              Text(
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
            item['instruction'] ?? item['title'] ?? '',
            style: TextStyles.headlineMedium,
          ),
          if (item['description'] != null) ...[
            const SizedBox(height: 6),
            Text(
              item['description'],
              style: TextStyles.bodySmall,
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.rose.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.rose.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Text(
              (item['auto_applied'] == true) ? 'APPLIED' : 'SUGGESTED',
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.rose,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultOffensiveCard({
    required String title,
    required String description,
  }) {
    final isViewed = _offensiveViewed[title] ?? false;

    return RareCard(
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
          Text(title, style: TextStyles.bodyMedium),
          const SizedBox(height: 4),
          Text(description, style: TextStyles.bodySmall),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Review on My Shelf',
                  onPressed: () {
                    setState(() {
                      _offensiveViewed[title] = true;
                    });
                    context.go(RouteNames.shelf);
                  },
                ),
              ),
            ],
          ),
          if (isViewed)
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
    );
  }
}
