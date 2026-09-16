import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/common/aura_widget.dart';
import '../../widgets/common/hydration_vessel.dart';
import '../../widgets/cards/rare_card.dart';
import '../../core/utils/helpers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/checkin_provider.dart';
import '../../providers/notification_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(checkinProvider.notifier).loadTodayData();
    ref.read(notificationProvider.notifier).loadUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        ref.read(checkinProvider.notifier).loadTodayData();
        ref.read(notificationProvider.notifier).loadUnreadCount();
      }
    });

    final checkinState = ref.watch(checkinProvider);
    final notificationState = ref.watch(notificationProvider);

    final bool hasCheckedIn = checkinState.todayCheckin != null;
    final double hydrationPercent =
        checkinState.totalHydrationMl > 0
            ? (checkinState.totalHydrationMl / 2000).clamp(0.0, 1.0)
            : 0.0;
    final int tapsCount = checkinState.todayHydration.length;
    final int totalTapsGoal = 8;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getFormattedDate(),
                    style: TextStyles.eyebrow,
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.circle_outlined,
                                color: AppColors.rose),
                            onPressed: () {
                              context.go(RouteNames.quietInbox);
                            },
                          ),
                          if (notificationState.unreadCount > 0)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.terracotta,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${notificationState.unreadCount}',
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: AppColors.cream,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.nights_stay,
                            color: AppColors.rose),
                        onPressed: () {
                          context.go(RouteNames.biweeklyWrapped);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag,
                            color: AppColors.rose),
                        onPressed: () {
                          context.go(RouteNames.optimizeShelf);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout,
                            color: AppColors.rose),
                        onPressed: () async {
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) {
                            context.go(RouteNames.splashReturning);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Center(
                child: AuraWidget(isBreathing: true, opacity: 0.9),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  hasCheckedIn
                      ? 'You checked in today.\nKeep the rhythm.'
                      : 'Soft mornings\nmake honest days.',
                  style: TextStyles.quote,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 22),
              RareCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HYDRATION VESSEL',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    HydrationVessel(
                      fillPercentage: hydrationPercent,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$tapsCount of $totalTapsGoal taps today — tap to fill',
                      style: TextStyles.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        final isMaxed = checkinState.todayHydration.length >= 8;
                        return GestureDetector(
                          onTap: isMaxed ? null : () {
                            ref.read(checkinProvider.notifier).logHydration(250);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isMaxed ? AppColors.grey : AppColors.rose,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isMaxed ? 'Max taps reached for today' : '+ Tap to log 250ml',
                              style: TextStyle(
                                fontSize: 12,
                                color: isMaxed ? AppColors.grey : AppColors.rose,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon(Icons.shopping_basket, 'Shelf', () {
                    context.go(RouteNames.shelf);
                  }),
                  _navIcon(Icons.eco, 'Quick Log', () {
                    context.go(RouteNames.quickLog);
                  }),
                  _navIcon(Icons.nights_stay, 'Insights', () {
                    context.go(RouteNames.biweeklyWrapped);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.rose),
          const SizedBox(height: 4),
          Text(label, style: TextStyles.bodySmall),
        ],
      ),
    );
  }
}
