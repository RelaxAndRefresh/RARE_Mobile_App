import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/environmental_provider.dart';
import '../../widgets/cards/rare_card.dart';

class EnvironmentalMapScreen extends ConsumerStatefulWidget {
  const EnvironmentalMapScreen({super.key});

  @override
  ConsumerState<EnvironmentalMapScreen> createState() =>
      _EnvironmentalMapScreenState();
}

class _EnvironmentalMapScreenState
    extends ConsumerState<EnvironmentalMapScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(environmentalProvider.notifier).loadCurrentData();
      ref.read(environmentalProvider.notifier).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final envState = ref.watch(environmentalProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Environmental Map')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: _buildBody(envState),
      ),
    );
  }

  Widget _buildBody(EnvironmentalState envState) {
    if (envState.isLoading && envState.currentData == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mocha),
      );
    }

    if (envState.error != null && envState.currentData == null) {
      return Column(
        children: [
          RareCard(
            child: SizedBox(
              height: 120,
              child: Center(
                child:
                    Icon(Icons.map, size: 48, color: AppColors.gold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'AQI history for your pin code, plotted against logged skin states.',
            style: TextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          RareCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  envState.error ??
                      'Air quality data isn\'t available for your specific area. We\'re keeping an eye on the wider region.',
                  style: TextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    ref
                        .read(environmentalProvider.notifier)
                        .loadCurrentData();
                    ref
                        .read(environmentalProvider.notifier)
                        .loadHistory();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final data = envState.currentData;
    if (data == null) {
      return Column(
        children: [
          RareCard(
            child: SizedBox(
              height: 120,
              child: Center(
                child:
                    Icon(Icons.map, size: 48, color: AppColors.gold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'AQI history for your pin code, plotted against logged skin states.',
            style: TextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          RareCard(
            child: Text(
              'Air quality data isn\'t available for your specific area. We\'re keeping an eye on the wider region.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        RareCard(
          child: SizedBox(
            height: 120,
            child: Center(
              child: Icon(Icons.map, size: 48, color: AppColors.gold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'AQI history for your pin code, plotted against logged skin states.',
          style: TextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (data.airQuality != null)
          RareCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _envMetric('Air Quality', data.airQuality!),
                if (data.uvIndex != null)
                  _envMetric('UV Index', data.uvIndex!.toStringAsFixed(1)),
                if (data.humidity != null)
                  _envMetric('Humidity', '${data.humidity}%'),
              ],
            ),
          )
        else
          RareCard(
            child: Text(
              'Air quality data isn\'t available for your specific area. We\'re keeping an eye on the wider region.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        if (data.temperature != null) ...[
          const SizedBox(height: 12),
          RareCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _envMetric(
                    'Temperature', '${data.temperature!.toStringAsFixed(1)}°C'),
                if (data.pollenCount != null)
                  _envMetric('Pollen', data.pollenCount!),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _envMetric(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.mocha,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.grey),
        ),
      ],
    );
  }
}
