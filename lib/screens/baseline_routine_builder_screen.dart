// 14

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';

class BaselineRoutineBuilderScreen extends StatefulWidget {
  const BaselineRoutineBuilderScreen({super.key});

  @override
  State<BaselineRoutineBuilderScreen> createState() =>
      _BaselineRoutineBuilderScreenState();
}

class _BaselineRoutineBuilderScreenState
    extends State<BaselineRoutineBuilderScreen> {
  final TextEditingController customProductController =
  TextEditingController();

  @override
  void dispose() {
    customProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Title
              Text(
                'Baseline Routine Builder',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                'Maps her real steps to real products, including anything bought elsewhere.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              const RoutineStepCard(title: 'CLEANSE'),

              const SizedBox(height: 20),

              const RoutineStepCard(title: 'TREAT'),

              const SizedBox(height: 20),

              const RoutineStepCard(title: 'MOISTURIZE'),

              const SizedBox(height: 20),

              const RoutineStepCard(title: 'SPF'),

              const SizedBox(height: 20),

              /// Custom Product Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOT A RARE PRODUCT?',
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: customProductController,
                      decoration: InputDecoration(
                        hintText: 'e.g. "Cetaphil Cleanser"',
                        hintStyle: AppTypography.body.copyWith(
                          color: AppColors.warmGrey,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.primaryAccent.withOpacity(.4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'SAVE MY ROUTINE',
                onPressed: () {
                  // TODO: Save routine
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class RoutineStepCard extends StatelessWidget {
  final String title;

  const RoutineStepCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.caption,
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Select product...',
                  style: AppTypography.h3,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryAccent.withOpacity(.35),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'AM · PM · Both',
                  style: AppTypography.body,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}