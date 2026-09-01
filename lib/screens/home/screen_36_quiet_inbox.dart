import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../widgets/tiles/list_tile.dart';
import '../../providers/notification_provider.dart';
import 'package:intl/intl.dart';

class QuietInboxScreen extends ConsumerStatefulWidget {
  const QuietInboxScreen({super.key});

  @override
  ConsumerState<QuietInboxScreen> createState() => _QuietInboxScreenState();
}

class _QuietInboxScreenState extends ConsumerState<QuietInboxScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(notificationProvider.notifier).loadNotifications();
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'skin_log':
        return Icons.eco;
      case 'routine':
        return Icons.settings;
      case 'insight':
        return Icons.nights_stay;
      case 'checkin':
        return Icons.favorite;
      default:
        return Icons.circle_outlined;
    }
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final notifState = ref.watch(notificationProvider);
    final notifications = notifState.notifications;
    final isLoading = notifState.isLoading;
    final error = notifState.error;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Quiet Inbox'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            Expanded(
              child: isLoading && notifications.isEmpty
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
                                    .read(notificationProvider.notifier)
                                    .loadNotifications(),
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
                      : notifications.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.mark_email_read_outlined,
                                      size: 48, color: AppColors.grey),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Nothing waiting for you.\nWe\'ll let you know when something needs your attention.',
                                    style: TextStyles.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final notif = notifications[index];
                                return ListTileWidget(
                                  leading: Icon(
                                    _getIconForType(notif.type),
                                    size: 16,
                                    color: notif.read
                                        ? AppColors.grey
                                        : AppColors.rose,
                                  ),
                                  title: notif.title,
                                  subtitle: _timeAgo(notif.createdAt),
                                  onTap: () {
                                    if (!notif.read) {
                                      ref
                                          .read(notificationProvider.notifier)
                                          .markAsRead(notif.id);
                                    }
                                  },
                                );
                              },
                            ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Items auto‑clear as they are read or expire — no badge counts, no pressure.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
