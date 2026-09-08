import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/aura_widget.dart';
import 'package:go_router/go_router.dart';

class DormantStateScreen extends ConsumerWidget {
  const DormantStateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuraWidget(
                isBreathing: false,
                isDormant: true,
                opacity: 0.18,
                scale: 0.6,
              ),
              const SizedBox(height: 26),
              Text(
                'Welcome back.\nThe garden missed the sun.',
                style: TextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                'Let\'s breathe together.',
                style: TextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Check In',
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
