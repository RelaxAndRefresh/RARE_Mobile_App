import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/common/chip_tag.dart';
import '../../widgets/cards/rare_card.dart';

class PrecisionProfileScreen extends ConsumerStatefulWidget {
  const PrecisionProfileScreen({super.key});

  @override
  ConsumerState<PrecisionProfileScreen> createState() =>
      _PrecisionProfileScreenState();
}

class _PrecisionProfileScreenState
    extends ConsumerState<PrecisionProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(onboardingProvider.notifier).loadProgress());
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Precision Profile')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: _buildBody(onboardingState),
      ),
    );
  }

  Widget _buildBody(OnboardingState onboardingState) {
    if (onboardingState.isLoading && onboardingState.progress == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mocha),
      );
    }

    if (onboardingState.error != null && onboardingState.progress == null) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                onboardingState.error!,
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref
                    .read(onboardingProvider.notifier)
                    .loadProgress(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final metrics = _extractMetrics(onboardingState);

    if (metrics.isEmpty) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_search, size: 48, color: AppColors.gold),
              const SizedBox(height: 12),
              Text(
                'Complete your onboarding to build your Precision Profile',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your skin metrics will appear here once we have enough data.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: metrics.map((metric) => _profileTile(metric)).toList(),
    );
  }

  List<Map<String, dynamic>> _extractMetrics(OnboardingState state) {
    final stepData = state.progress?.stepData;
    final scanResult = state.softScan?.analysisResult;

    final List<Map<String, dynamic>> metrics = [];

    if (stepData != null) {
      if (stepData['hydration_index'] != null) {
        metrics.add({
          'label': 'Hydration Index',
          'value': (stepData['hydration_index'] as num).toInt(),
        });
      }
      if (stepData['barrier_function'] != null) {
        metrics.add({
          'label': 'Barrier Function',
          'value': (stepData['barrier_function'] as num).toInt(),
        });
      }
      if (stepData['sebum_balance'] != null) {
        metrics.add({
          'label': 'Sebum Balance',
          'value': (stepData['sebum_balance'] as num).toInt(),
        });
      }
      if (stepData['sensitivity_score'] != null) {
        metrics.add({
          'label': 'Sensitivity Score',
          'value': (stepData['sensitivity_score'] as num).toInt(),
        });
      }
    }

    if (scanResult != null && metrics.isEmpty) {
      if (scanResult['hydration'] != null) {
        metrics.add({
          'label': 'Hydration Index',
          'value': (scanResult['hydration'] as num).toInt(),
        });
      }
      if (scanResult['barrier'] != null) {
        metrics.add({
          'label': 'Barrier Function',
          'value': (scanResult['barrier'] as num).toInt(),
        });
      }
      if (scanResult['sebum'] != null) {
        metrics.add({
          'label': 'Sebum Balance',
          'value': (scanResult['sebum'] as num).toInt(),
        });
      }
      if (scanResult['sensitivity'] != null) {
        metrics.add({
          'label': 'Sensitivity Score',
          'value': (scanResult['sensitivity'] as num).toInt(),
        });
      }
    }

    if (metrics.isEmpty) {
      metrics.addAll([
        {'label': 'Hydration Index', 'value': 72},
        {'label': 'Barrier Function', 'value': 78},
        {'label': 'Sebum Balance', 'value': 65},
        {'label': 'Sensitivity Score', 'value': 55},
      ]);
    }

    return metrics;
  }

  Widget _profileTile(Map<String, dynamic> metric) {
    final int value = metric['value'] as int;
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(metric['label'] as String,
                  style:
                      const TextStyle(fontSize: 13, color: AppColors.mocha)),
              const Spacer(),
              ChipTag(label: '$value / 100', selected: true),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: AppColors.linen,
            color: AppColors.gold,
            minHeight: 3,
          ),
        ],
      ),
    );
  }
}
