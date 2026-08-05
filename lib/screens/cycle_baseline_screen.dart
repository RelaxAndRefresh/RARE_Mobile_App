//5

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/outline_button.dart';
import '../widgets/primary_button.dart';
import 'wearable_connection.dart';

class CycleBaselineScreen extends StatefulWidget {
  const CycleBaselineScreen({super.key});

  @override
  State<CycleBaselineScreen> createState() => _CycleBaselineScreenState();
}

class _CycleBaselineScreenState extends State<CycleBaselineScreen> {
  // Day 12 is selected by default as per the prototype screenshot
  int selectedDay = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 1. Page Title
              Text(
                'Cycle Baseline Setup',
                style: AppTypography.h1,
              ),
              const SizedBox(height: 16),

              // 2. Subtitle / Description
              Text(
                'Optional — editable later from the Cycle Calendar.',
                style: AppTypography.body,
              ),
              const SizedBox(height: 32),

              // 3. Calendar Selection Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface, // Blush Linen (#F2DDD5)
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LAST PERIOD START DATE',
                      style: AppTypography.eyebrow.copyWith(
                        color: AppColors.bodyMauve,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Custom 7-Column Date Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 28,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        final dayNumber = index + 1;
                        final isSelected = dayNumber == selectedDay;
                        // Day 14 has a soft border highlight in the spec
                        final isHighlighted = dayNumber == 14;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDay = dayNumber;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryAccent // Filled Dusty Rose
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryAccent
                                    : (isHighlighted
                                    ? AppColors.primaryAccent
                                    : Colors.transparent),
                                width: 1.0,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$dayNumber',
                              style: AppTypography.body.copyWith(
                                fontSize: 13,
                                color: isSelected
                                    ? AppColors.background
                                    : AppColors.darkMocha,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 5. Primary CTA
              PrimaryButton(
                text: 'Save Baseline',
                onPressed: () {
                  // TODO: Save cycle baseline date and proceed
                },
              ),

              const SizedBox(height: 16),

              // 6. Secondary Action
              RAREOutlineButton(
                text: "Skip — I'll Set This Up Later",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WearableConnectionScreen(),
                    ),
                  );
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