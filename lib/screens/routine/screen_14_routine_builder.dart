import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/routine_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/chip_tag.dart';

class RoutineBuilderScreen extends ConsumerStatefulWidget {
  const RoutineBuilderScreen({super.key});

  @override
  ConsumerState<RoutineBuilderScreen> createState() =>
      _RoutineBuilderScreenState();
}

class _RoutineBuilderScreenState extends ConsumerState<RoutineBuilderScreen> {
  final List<String> _stepNames = ['Cleanse', 'Treat', 'Moisturize', 'SPF'];
  final Map<String, String?> _selectedProducts = {};
  final Map<String, String> _selectedTiming = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(routineProvider.notifier).loadRoutines());
  }

  @override
  Widget build(BuildContext context) {
    final routineState = ref.watch(routineProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Routine Builder')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            if (routineState.isLoading && routineState.routines.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child:
                      CircularProgressIndicator(color: AppColors.mocha),
                ),
              )
            else if (routineState.error != null)
              RareCard(
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
                          .loadRoutines(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else ...[
              ...routineState.routines.map(
                (routine) => _existingRoutineTile(routine),
              ),
              ..._stepNames.map(
                (step) => _stepTile(step),
              ),
            ],
            const SizedBox(height: 16),
            RareCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NOT A RARE PRODUCT?',
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.gold, width: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'e.g. "Cetaphil Cleanser"',
                      style:
                          TextStyle(fontSize: 12, color: AppColors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Save My Routine',
              isLoading: _isSaving,
              onPressed: _isSaving ? null : _saveRoutine,
            ),
          ],
        ),
      ),
    );
  }

  Widget _existingRoutineTile(dynamic routine) {
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  routine.name,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mocha,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ChipTag(
                label: routine.isActive ? 'Active' : 'Paused',
                selected: routine.isActive,
              ),
            ],
          ),
          if (routine.steps.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...routine.steps.map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${step.name}',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.grey),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () => ref
                    .read(routineProvider.notifier)
                    .toggleRoutineActive(
                        routine.id, !routine.isActive),
                child: Text(
                  routine.isActive ? 'Pause' : 'Activate',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              TextButton(
                onPressed: () => _deleteRoutine(routine.id),
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 11, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepTile(String step) {
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.grey,
              )),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                _selectedProducts[step] ?? 'Select product…',
                style: TextStyle(
                  fontSize: 13,
                  color: _selectedProducts[step] != null
                      ? AppColors.mocha
                      : AppColors.mocha.withOpacity(0.5),
                ),
              ),
              const Spacer(),
              ChipTag(
                label: _selectedTiming[step] ?? 'AM · PM · Both',
                selected: _selectedTiming.containsKey(step),
                onTap: () => _cycleTiming(step),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _cycleTiming(String step) {
    final timings = ['AM', 'PM', 'Both'];
    final current = _selectedTiming[step];
    final nextIndex = current == null
        ? 0
        : (timings.indexOf(current) + 1) % timings.length;
    setState(() {
      _selectedTiming[step] = timings[nextIndex];
    });
  }

  Future<void> _saveRoutine() async {
    if (_isSaving) return;

    final steps = _stepNames
        .where((step) => _selectedProducts[step] != null)
        .toList();

    if (steps.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one product')),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    final routineData = {
      'name': 'My Routine',
      'steps': _stepNames
          .map((step) => {
                'name': step,
                'product_id': _selectedProducts[step],
                'time_of_day': _selectedTiming[step] ?? 'Both',
              })
          .toList(),
    };

    await ref.read(routineProvider.notifier).createRoutine(routineData);

    setState(() => _isSaving = false);

    if (mounted) {
      final routineState = ref.read(routineProvider);
      if (routineState.error == null) {
        context.go(RouteNames.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(routineState.error!)),
        );
      }
    }
  }

  Future<void> _deleteRoutine(String id) async {
    await ref.read(routineProvider.notifier).deleteRoutine(id);
  }
}
