import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';
import 'package:go_router/go_router.dart';

class ProfileHubScreen extends ConsumerStatefulWidget {
  const ProfileHubScreen({super.key});

  @override
  ConsumerState<ProfileHubScreen> createState() => _ProfileHubScreenState();
}

class _ProfileHubScreenState extends ConsumerState<ProfileHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.user;
    final isLoading = profileState.isLoading;
    final error = profileState.error;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.rose),
                    )
                  : error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Failed to load profile.',
                                style: TextStyles.bodyMedium.copyWith(
                                  color: AppColors.terracotta,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GhostButton(
                                label: 'Retry',
                                onPressed: () =>
                                    ref.read(profileProvider.notifier).loadAll(),
                                width: null,
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          children: [
                            if (user != null) ...[
                              RareCard(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.linen,
                                      child: Text(
                                        user.name.isNotEmpty
                                            ? user.name[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: AppColors.mocha,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: AppColors.mocha,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            user.email,
                                            style: TextStyles.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            ListTileWidget(
                              title: 'Settings',
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.rose),
                              onTap: () => context.go(RouteNames.settings),
                            ),
                            ListTileWidget(
                              title: 'Privacy Dashboard',
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.rose),
                              onTap: () =>
                                  context.go(RouteNames.privacyDashboard),
                            ),
                            ListTileWidget(
                              title: 'Cycle Calendar',
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.rose),
                              onTap: () =>
                                  context.go(RouteNames.cycleCalendar),
                            ),
                            ListTileWidget(
                              title: 'Order & Booking History',
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.rose),
                              onTap: () => context.go(RouteNames.orderHistory),
                            ),
                            ListTileWidget(
                              title: 'Credits Ledger',
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.rose),
                              onTap: () =>
                                  context.go(RouteNames.creditsLedger),
                            ),
                            ListTileWidget(
                              title: 'Account Details',
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.rose),
                              onTap: () =>
                                  context.go(RouteNames.accountDetails),
                            ),
                            ListTileWidget(
                              title: 'The Kill Switch',
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.rose),
                              onTap: () => context.go(RouteNames.killSwitch),
                            ),
                          ],
                        ),
            ),
            if (user != null && user.email.isEmpty)
              RareCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Connected as ${user.name}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.mocha,
                      ),
                    ),
                    GhostButton(
                      label: 'Connect RARE Account',
                      onPressed: () {
                        context.go(RouteNames.accountSync);
                      },
                      width: null,
                    ),
                  ],
                ),
              ),
            if (user == null && !isLoading)
              RareCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Connected as anon_profile',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mocha,
                      ),
                    ),
                    GhostButton(
                      label: 'Connect RARE Account',
                      onPressed: () {
                        context.go(RouteNames.accountSync);
                      },
                      width: null,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
