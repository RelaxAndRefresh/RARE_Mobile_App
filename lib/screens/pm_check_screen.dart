// 10

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';

class PMCheckInScreen extends StatefulWidget {
  const PMCheckInScreen({super.key});

  @override
  State<PMCheckInScreen> createState() => _PMCheckInScreenState();
}

class _PMCheckInScreenState extends State<PMCheckInScreen> {
  double stressLevel = 0.45;

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
                'PM Check-in',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                'A 2-second reflective close to the day.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              /// Ambient Circle
              Center(
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryAccent.withOpacity(.45),
                        AppColors.cardSurface,
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// Stress Card
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
                      'STRESS TODAY',
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 28),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                        ),
                        overlayShape:
                        SliderComponentShape.noOverlay,
                        activeTrackColor:
                        AppColors.primaryAccent,
                        inactiveTrackColor:
                        AppColors.primaryAccent.withOpacity(.25),
                        thumbColor: AppColors.background,
                      ),
                      child: Slider(
                        value: stressLevel,
                        onChanged: (value) {
                          setState(() {
                            stressLevel = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'LOG & REST',
                onPressed: () {
                  // TODO: Save PM Check-in
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