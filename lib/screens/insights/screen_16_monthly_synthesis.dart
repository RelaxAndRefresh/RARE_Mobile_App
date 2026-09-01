import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/insight_provider.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/confidence_meter.dart';

class MonthlySynthesisScreen extends ConsumerStatefulWidget {
  const MonthlySynthesisScreen({super.key});

  @override
  ConsumerState<MonthlySynthesisScreen> createState() =>
      _MonthlySynthesisScreenState();
}

class _MonthlySynthesisScreenState
    extends ConsumerState<MonthlySynthesisScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(insightProvider.notifier).loadMonthlyInsights());
  }

  @override
  Widget build(BuildContext context) {
    final insightState = ref.watch(insightProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Monthly Synthesis')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: _buildBody(insightState),
      ),
    );
  }

  Widget _buildBody(InsightState insightState) {
    if (insightState.isLoading && insightState.monthlyInsights.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mocha),
      );
    }

    if (insightState.error != null &&
        insightState.monthlyInsights.isEmpty) {
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
                    .loadMonthlyInsights(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (insightState.monthlyInsights.isEmpty) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.analytics_outlined,
                  size: 48, color: AppColors.gold),
              const SizedBox(height: 12),
              Text(
                'No monthly synthesis yet',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'After a month of data, we\'ll surface your deep patterns.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final latestInsight = insightState.monthlyInsights.first;
    final confidence = _extractConfidence(latestInsight.data);
    final secondaryNote = latestInsight.data?['secondary_note'];

    return ListView(
      children: [
        RareCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'HIGH-CONFIDENCE',
                style: TextStyle(fontSize: 11, color: AppColors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                latestInsight.summary ??
                    latestInsight.title,
                style: TextStyles.bodyMedium,
              ),
              if (secondaryNote != null) ...[
                const SizedBox(height: 10),
                Text(
                  secondaryNote.toString(),
                  style: TextStyles.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              ConfidenceMeter(filledSegments: confidence),
            ],
          ),
        ),
        const SizedBox(height: 16),
        RareCard(
          child: Text(
            latestInsight.data?['no_patterns_message'] ??
                'No deep patterns surfaced this month. Sometimes that\'s the answer — your variables aren\'t strongly connected right now. We\'ll keep watching.',
            style: TextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
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
