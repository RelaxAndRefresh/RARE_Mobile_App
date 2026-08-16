import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/aura_widget.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuraWidget(isBreathing: false, opacity: 0.3, scale: 0.9),
              const SizedBox(height: 36),
              Text(
                'A new way\nof being known.',
                style: TextStyles.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Text(
                'A note left on a pillow.',
                style: TextStyles.quote,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              PrimaryButton(
                label: 'Begin →',
                onPressed: () {
                  context.go(RouteNames.softScan);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
