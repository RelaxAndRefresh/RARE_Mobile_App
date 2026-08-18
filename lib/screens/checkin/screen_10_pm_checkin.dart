import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/aura_widget.dart';

class PMCheckinScreen extends StatefulWidget {
  const PMCheckinScreen({super.key});

  @override
  State<PMCheckinScreen> createState() => _PMCheckinScreenState();
}

class _PMCheckinScreenState extends State<PMCheckinScreen> {
  double stress = 0.35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Take a breath')),
      body: Padding(
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Log & Rest',
              onPressed: () {
                context.go(RouteNames.home);
              },
            ),
          ],
        ),
      ),
    );
  }
}
