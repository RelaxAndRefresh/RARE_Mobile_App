import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/insight_provider.dart';
import '../../widgets/cards/rare_card.dart';

class PulseFeedScreen extends ConsumerStatefulWidget {
  const PulseFeedScreen({super.key});

  @override
  ConsumerState<PulseFeedScreen> createState() => _PulseFeedScreenState();
}

class _PulseFeedScreenState extends ConsumerState<PulseFeedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(insightProvider.notifier).loadPulseFeed());
  }

  @override
  Widget build(BuildContext context) {
    final insightState = ref.watch(insightProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('RARE Pulse')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: _buildBody(insightState),
      ),
    );
  }

  Widget _buildBody(InsightState insightState) {
    if (insightState.isLoading && insightState.pulseFeed.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mocha),
      );
    }

    if (insightState.error != null && insightState.pulseFeed.isEmpty) {
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
                onPressed: () =>
                    ref.read(insightProvider.notifier).loadPulseFeed(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (insightState.pulseFeed.isEmpty) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, size: 48, color: AppColors.gold),
              const SizedBox(height: 12),
              Text(
                'No pulse data yet',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'As more members contribute data, you\'ll see anonymized trends here.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: [
        ...insightState.pulseFeed.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyles.bodyMedium,
                  ),
                  if (item.body != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.body!,
                      style: TextStyles.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Below the 100-user segment threshold, profile-specific cards are suppressed in favor of broader trends — a lone "1 woman like you" number would isolate rather than reassure.',
          style: TextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
