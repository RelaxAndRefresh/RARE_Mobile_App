import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/insight_provider.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/confidence_meter.dart';

class BiweeklyWrappedScreen extends ConsumerStatefulWidget {
  const BiweeklyWrappedScreen({super.key});

  @override
  ConsumerState<BiweeklyWrappedScreen> createState() =>
      _BiweeklyWrappedScreenState();
}

class _BiweeklyWrappedScreenState
    extends ConsumerState<BiweeklyWrappedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(insightProvider.notifier).loadBiweeklyInsights());
  }

  @override
  Widget build(BuildContext context) {
    final insightState = ref.watch(insightProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Biweekly Wrapped')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: _buildBody(insightState),
      ),
    );
  }

  Widget _buildBody(InsightState insightState) {
    if (insightState.isLoading && insightState.biweeklyInsights.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mocha),
      );
    }

    if (insightState.error != null && insightState.biweeklyInsights.isEmpty) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                insightState.error!,
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref
                    .read(insightProvider.notifier)
                    .loadBiweeklyInsights(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (insightState.biweeklyInsights.isEmpty) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insights, size: 48, color: AppColors.gold),
              const SizedBox(height: 12),
              Text(
                'No biweekly insights yet',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Keep logging your data and we\'ll surface patterns every two weeks.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final latestInsight = insightState.biweeklyInsights.first;
    final confidence = _extractConfidence(latestInsight.data);

    return ListView(
      children: [
        RareCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CORRELATION',
                style: TextStyle(fontSize: 11, color: AppColors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                latestInsight.summary ??
                    latestInsight.title,
                style: TextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              ConfidenceMeter(filledSegments: confidence),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (insightState.pulseFeed.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mocha,
              borderRadius:
                  BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RARE PULSE',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  insightState.pulseFeed.first.body ??
                      insightState.pulseFeed.first.title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.cream,
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mocha,
              borderRadius:
                  BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RARE PULSE',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Loading social proof data...',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.cream.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  int _extractConfidence(Map<String, dynamic>? data) {
    if (data == null) return 1;
    final confidence = data['confidence'];
    if (confidence == null) return 1;
    if (confidence is num) {
      if (confidence >= 0.8) return 3;
      if (confidence >= 0.5) return 2;
      return 1;
    }
    return 1;
  }
}
