import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';

/// Screen 35 – Skin Progress Timeline
/// A horizontal scroll of logged Skin Log photos, overlaid with
/// tags selected that day. Users can delete blurry or unwanted photos.
class SkinProgressTimelineScreen extends StatefulWidget {
  const SkinProgressTimelineScreen({super.key});

  @override
  State<SkinProgressTimelineScreen> createState() =>
      _SkinProgressTimelineScreenState();
}

class _SkinProgressTimelineScreenState
    extends State<SkinProgressTimelineScreen> {
  // Simulated photo entries with tags
  final List<_SkinPhotoEntry> _photos = [
    _SkinPhotoEntry(
      tags: ['Tight', 'Dry'],
      date: 'Jul 22',
      color: AppColors.rose,
    ),
    _SkinPhotoEntry(
      tags: ['Calm'],
      date: 'Jul 20',
      color: AppColors.linen,
    ),
    _SkinPhotoEntry(
      tags: ['Reactive', 'Sensitive'],
      date: 'Jul 18',
      color: AppColors.terracotta,
    ),
    _SkinPhotoEntry(
      tags: ['Bright', 'Calm'],
      date: 'Jul 15',
      color: AppColors.gold,
    ),
    _SkinPhotoEntry(
      tags: ['Calm'],
      date: 'Jul 12',
      color: AppColors.linen,
    ),
    _SkinPhotoEntry(
      tags: ['Tight', 'Reactive'],
      date: 'Jul 10',
      color: AppColors.rose,
    ),
    _SkinPhotoEntry(
      tags: ['Dull'],
      date: 'Jul 8',
      color: AppColors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            // Horizontal scroll of photos
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  return _buildPhotoCard(_photos[index], index);
                },
              ),
            ),
            const SizedBox(height: 16),
            // Footer note
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

  Widget _buildPhotoCard(_SkinPhotoEntry entry, int index) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteConfirmation(context, index);
      },
      child: Container(
        width: 120,
        height: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: entry.color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Stack(
          children: [
            // Photo placeholder with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    entry.color.withOpacity(0.6),
                    entry.color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
            ),
            // Tags overlay at bottom
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
                    children: entry.tags.map((tag) {
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
                    entry.date,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.cream,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Delete icon (top-right)
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () {
                  _showDeleteConfirmation(context, index);
                },
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

  void _showDeleteConfirmation(BuildContext context, int index) {
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
            onPressed: () {
              setState(() {
                _photos.removeAt(index);
              });
              Navigator.pop(context);
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

/// Data class for a skin photo entry.
class _SkinPhotoEntry {
  final List<String> tags;
  final String date;
  final Color color;

  _SkinPhotoEntry({
    required this.tags,
    required this.date,
    required this.color,
  });
}
