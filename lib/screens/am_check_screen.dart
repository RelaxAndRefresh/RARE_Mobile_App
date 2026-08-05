// 09

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/outline_button.dart';
import '../widgets/primary_button.dart';

class AMCheckInScreen extends StatefulWidget {
  const AMCheckInScreen({super.key});

  @override
  State<AMCheckInScreen> createState() => _AMCheckInScreenState();
}

class _AMCheckInScreenState extends State<AMCheckInScreen> {
  double mood = 0.8;

  final List<String> contexts = [
    'Sick',
    'Travel',
    'Stress',
  ];

  final Set<String> selectedContexts = {};

  bool sleepConfirmed = true;

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

              Text(
                'AM Check-in',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              Text(
                'A 3-second flow — the shortest possible distance to logged.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              /// Sleep Card
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
                      'SLEEP — INFERRED FROM PHONE STILLNESS',
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      '7h 12m — sound about right?',
                      style: AppTypography.h2,
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: RAREOutlineButton(
                            text: 'YES',
                            onPressed: () {
                              setState(() {
                                sleepConfirmed = true;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: RAREOutlineButton(
                            text: 'ADJUST',
                            onPressed: () {
                              setState(() {
                                sleepConfirmed = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Mood Card
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
                      'MOOD',
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 24),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                        ),
                        overlayShape: SliderComponentShape.noOverlay,
                        activeTrackColor: AppColors.primaryAccent,
                        inactiveTrackColor:
                        AppColors.primaryAccent.withOpacity(.25),
                        thumbColor: AppColors.background,
                      ),
                      child: Slider(
                        value: mood,
                        onChanged: (value) {
                          setState(() {
                            mood = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Context Card
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
                      'CONTEXT (OPTIONAL)',
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: contexts.map((contextItem) {
                        final selected =
                        selectedContexts.contains(contextItem);

                        return ChoiceChip(
                          label: Text(
                            contextItem,
                            style: AppTypography.body.copyWith(
                              color: selected
                                  ? Colors.white
                                  : AppColors.bodyMauve,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              if (selected) {
                                selectedContexts.remove(contextItem);
                              } else {
                                selectedContexts.add(contextItem);
                              }
                            });
                          },
                          backgroundColor: AppColors.cardSurface,
                          selectedColor: AppColors.primaryAccent,
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: AppColors.primaryAccent,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'SAVE & RETURN TO HOME',
                onPressed: () {
                  // TODO: Save check-in
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