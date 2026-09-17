import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../providers/skin_provider.dart';

class QuickLogScreen extends ConsumerStatefulWidget {
  const QuickLogScreen({super.key});

  @override
  ConsumerState<QuickLogScreen> createState() => _QuickLogScreenState();
}

class _QuickLogScreenState extends ConsumerState<QuickLogScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(skinProvider.notifier).checkQuickLogStatus();
    });
  }

  void _logItem(String type) async {
    await ref.read(skinProvider.notifier).createLog({
      'tags': [type],
      'condition': type,
      'quick_log': true,
    });
    if (!mounted) return;
    final error = ref.read(skinProvider).error;
    if (error != null) {
      final alreadyLogged = error.contains('already logged');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(alreadyLogged ? 'Already logged today. One quick log per day.' : 'Could not log. Try again.'),
          backgroundColor: alreadyLogged ? AppColors.mocha : AppColors.terracotta,
        ),
      );
      ref.read(skinProvider.notifier).clearError();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$type logged.'),
          backgroundColor: AppColors.mocha,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final skinState = ref.watch(skinProvider);
    final isLogging = skinState.isLoading;
    final loggedToday = skinState.hasQuickLoggedToday;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Quick Log')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('One-tap log', style: TextStyles.displayMedium),
            const SizedBox(height: 16),
            _buildLogItem(
              icon: Icons.water_drop,
              label: 'Caffeine',
              isLogged: loggedToday,
              isLogging: isLogging,
            ),
            _buildLogItem(
              icon: Icons.water_drop,
              label: 'Alcohol',
              isLogged: loggedToday,
              isLogging: isLogging,
            ),
            _buildLogItem(
              icon: Icons.show_chart,
              label: 'Energy',
              isLogged: loggedToday,
              isLogging: isLogging,
            ),
            const SizedBox(height: 16),
            Text(
              loggedToday
                  ? 'You have already logged today. Come back tomorrow.'
                  : 'Time is inferred automatically — tap the entry again to adjust.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem({
    required IconData icon,
    required String label,
    required bool isLogged,
    required bool isLogging,
  }) {
    return RareCard(
      child: Row(
        children: [
          Icon(icon, color: AppColors.rose),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          if (isLogged)
            const Icon(Icons.check_circle, color: AppColors.mocha, size: 20)
          else
            GhostButton(
              label: 'Log',
              onPressed: isLogging ? null : () => _logItem(label),
              width: null,
            ),
        ],
      ),
    );
  }
}
