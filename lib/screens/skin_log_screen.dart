// 11

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';

class SkinLogScreen extends StatefulWidget {
  const SkinLogScreen({super.key});

  @override
  State<SkinLogScreen> createState() => _SkinLogScreenState();
}

class _SkinLogScreenState extends State<SkinLogScreen> {
  final List<String> tags = [
    'Tight',
    'Reactive',
    'Calm',
    'Raw',
    'Bright',
  ];

  final Set<String> selectedTags = {
    'Tight',
    'Reactive',
  };

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
                'Skin Log',
                style: AppTypography.h1,
              ),

              const SizedBox(height: 16),

              /// Subtitle
              Text(
                'Multi-tag, not a single scalar score — reflecting real skin.',
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              /// Skin Feel Card
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
                      'HOW DOES YOUR SKIN FEEL?',
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 24),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: tags.map((tag) {
                        final selected = selectedTags.contains(tag);

                        return ChoiceChip(
                          label: Text(
                            tag,
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
                                selectedTags.remove(tag);
                              } else {
                                selectedTags.add(tag);
                              }
                            });
                          },
                          selectedColor: AppColors.primaryAccent,
                          backgroundColor: AppColors.cardSurface,
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

              /// Photo Upload Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 34,
                      color: AppColors.primaryAccent,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Optional — add a photo to your Progress Timeline',
                      textAlign: TextAlign.center,
                      style: AppTypography.caption,
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Pick image
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          side: BorderSide(
                            color: AppColors.primaryAccent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'ADD PHOTO',
                          style: AppTypography.body.copyWith(
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'SAVE SKIN LOG',
                onPressed: () {
                  // TODO: Save skin log
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