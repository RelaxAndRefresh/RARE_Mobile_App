import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';
import '../../widgets/common/chip_tag.dart';

class RoutineInterventionLogScreen extends ConsumerStatefulWidget {
  const RoutineInterventionLogScreen({super.key});

  @override
  ConsumerState<RoutineInterventionLogScreen> createState() =>
      _RoutineInterventionLogScreenState();
}

class _RoutineInterventionLogScreenState
    extends ConsumerState<RoutineInterventionLogScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(routineProvider.notifier).loadInterventions());
  }

  @override
  Widget build(BuildContext context) {
    final routineState = ref.watch(routineProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Intervention Log')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: _buildBody(routineState),
      ),
    );
  }

  Widget _buildBody(RoutineState routineState) {
    if (routineState.isLoading && routineState.interventions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.mocha),
      );
    }

    if (routineState.error != null && routineState.interventions.isEmpty) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                routineState.error!,
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref
                    .read(routineProvider.notifier)
                    .loadInterventions(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (routineState.interventions.isEmpty) {
      return Center(
        child: RareCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history, size: 48, color: AppColors.gold),
              const SizedBox(height: 12),
              Text(
                'No interventions yet',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'When the algorithm or your practitioner makes adjustments, they\'ll appear here.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(routineProvider.notifier).loadInterventions(),
      child: ListView.builder(
        itemCount: routineState.interventions.length,
        itemBuilder: (context, index) {
          final intervention = routineState.interventions[index];
          return ListTileWidget(
            leading: ChipTag(
              label: _getTypeLabel(intervention.type),
              selected: true,
            ),
            title: intervention.title,
            subtitle: _formatDate(intervention.createdAt),
          );
        },
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'ALGORITHM':
        return 'ALGORITHM';
      case 'AUTO_SWAP':
        return 'AUTO_SWAP';
      case 'PRACTITIONER':
        return 'PRACTITIONER';
      case 'MANUAL_EDIT':
        return 'MANUAL_EDIT';
      default:
        return type.toUpperCase();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 7) return '${(diff.inDays / 7).floor()} week(s) ago';
    if (diff.inDays > 0) return '${diff.inDays} day(s) ago';
    if (diff.inHours > 0) return '${diff.inHours} hour(s) ago';
    return 'Just now';
  }
}
