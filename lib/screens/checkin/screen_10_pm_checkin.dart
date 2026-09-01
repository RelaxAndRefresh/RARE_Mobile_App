import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../providers/checkin_provider.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/aura_widget.dart';

class PMCheckinScreen extends ConsumerStatefulWidget {
  const PMCheckinScreen({super.key});

  @override
  ConsumerState<PMCheckinScreen> createState() => _PMCheckinScreenState();
}

class _PMCheckinScreenState extends ConsumerState<PMCheckinScreen> {
  double stress = 0.35;

  @override
  Widget build(BuildContext context) {
    final checkinState = ref.watch(checkinProvider);
    final isSubmitting = checkinState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Take a breath')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: AuraWidget(
                    isBreathing: false,
                    opacity: 0.6,
                    scale: 0.8,
                  ),
                ),
                const SizedBox(height: 16),
                RareCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'STRESS TODAY',
                        style: TextStyle(fontSize: 11, color: AppColors.grey),
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: stress,
                        onChanged: (val) => setState(() => stress = val),
                        activeColor: AppColors.rose,
                        inactiveColor: AppColors.linen,
                      ),
                      Text(
                        stress < 0.3
                            ? 'Calm'
                            : stress < 0.6
                                ? 'Moderate'
                                : stress < 0.85
                                    ? 'Elevated'
                                    : 'High',
                        style: TextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: isSubmitting ? 'Logging...' : 'Log & Rest',
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final data = {
                            'checkin_type': 'pm',
                            'stress': (stress * 10).round(),
                            'mood': (stress * 10).round(),
                            'energy': 0,
                            'sleep': 0,
                          };
                          await ref
                              .read(checkinProvider.notifier)
                              .submitPMCheckin(data);
                          if (!mounted) return;
                          final error = ref.read(checkinProvider).error;
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not save. Try again in a moment.'),
                                backgroundColor: AppColors.terracotta,
                              ),
                            );
                            ref.read(checkinProvider.notifier).clearError();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Evening log saved. Rest well.'),
                                backgroundColor: AppColors.mocha,
                              ),
                            );
                            context.go(RouteNames.home);
                          }
                        },
                ),
              ],
            ),
          ),
          if (isSubmitting)
            Container(
              color: AppColors.cream.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.rose),
              ),
            ),
        ],
      ),
    );
  }
}
