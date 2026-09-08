import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/skin_provider.dart';
import '../../data/models/api_models.dart';
import 'package:intl/intl.dart';

class SkinProgressTimelineScreen extends ConsumerStatefulWidget {
  const SkinProgressTimelineScreen({super.key});

  @override
  ConsumerState<SkinProgressTimelineScreen> createState() =>
      _SkinProgressTimelineScreenState();
}

class _SkinProgressTimelineScreenState
    extends ConsumerState<SkinProgressTimelineScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(skinProvider.notifier).loadTimeline();
  }

  @override
  Widget build(BuildContext context) {
    final skinState = ref.watch(skinProvider);
    final timeline = skinState.timeline;
    final isLoading = skinState.isLoading;
    final error = skinState.error;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Skin Progress'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your skin journey',
              style: TextStyles.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap any photo to view details. Long-press to delete.',
              style: TextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading && timeline.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.rose),
                    )
                  : error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_off,
                                  size: 48, color: AppColors.grey),
                              const SizedBox(height: 12),
                              Text(
                                'Something feels off. Let\'s try again in a moment.',
                                style: TextStyles.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () => ref
                                    .read(skinProvider.notifier)
                                    .loadTimeline(),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(
                                    color: AppColors.rose,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : timeline.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.photo_library_outlined,
                                      size: 48, color: AppColors.grey),
                                  const SizedBox(height: 12),
                                  Text(
                                    'We are listening. Keep checking in.',
                                    style: TextStyles.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: timeline.length,
                              itemBuilder: (context, index) {
                                final entry = timeline[index];
                                return _buildPhotoCard(entry, index);
                              },
                            ),
            ),
            const SizedBox(height: 16),
            Text(
              'Long-press or tap the trash icon to delete a blurry or badly lit photo — it\'s flagged ignored, never trained on.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(SkinTimelineEntry entry, int index) {
    final log = entry.log;
    final photo = entry.photo;
    final tags = log?.tags ?? [];
    final dateStr = DateFormat('MMM d').format(entry.date);
    final hasImage = photo?.imageUrl != null && photo!.imageUrl.isNotEmpty;

    Color cardColor;
    if (tags.contains('Tight') || tags.contains('Reactive')) {
      cardColor = AppColors.rose;
    } else if (tags.contains('Calm') || tags.contains('Bright')) {
      cardColor = AppColors.linen;
    } else if (tags.contains('Sensitive')) {
      cardColor = AppColors.terracotta;
    } else {
      cardColor = AppColors.gold;
    }

    return GestureDetector(
      onLongPress: () => _showDeleteConfirmation(context, entry),
      child: Container(
        width: 120,
        height: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Stack(
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                child: Image.network(
                  photo!.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildGradientPlaceholder(cardColor),
                ),
              )
            else
              _buildGradientPlaceholder(cardColor),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mocha.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 8,
                            color: AppColors.cream,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.cream,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () => _showDeleteConfirmation(context, entry),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.mocha.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 14,
                    color: AppColors.cream,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientPlaceholder(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.6),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SkinTimelineEntry entry) {
    final logId = entry.log?.id;
    if (logId == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: const Text(
          'Delete Photo?',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            color: AppColors.mocha,
          ),
        ),
        content: Text(
          'This photo will be removed from your timeline and flagged as ignored. It will not be used for training.',
          style: TextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(skinProvider.notifier).deleteLog(logId);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo deleted and flagged ignored.'),
                  backgroundColor: AppColors.mocha,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.terracotta),
            ),
          ),
        ],
      ),
    );
  }
}
