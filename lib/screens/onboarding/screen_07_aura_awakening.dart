import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/aura_widget.dart';
import 'package:go_router/go_router.dart';

class AuraAwakeningScreen extends StatelessWidget {
  const AuraAwakeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuraWidget(isBreathing: true, opacity: 0.6),
              const SizedBox(height: 30),
              Text(
                'Meet your Aura.',
                style: TextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Right now, it\'s resting. Let\'s wake it up.',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Begin Your First Check-in',
                onPressed: () {
                  context.go(RouteNames.amCheckin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
