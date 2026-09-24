import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/checkin_provider.dart';
import 'providers/notification_provider.dart';

class RAREApp extends ConsumerWidget {
  const RAREApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    // Reset per-user data on logout or account switch, so one account never
    // sees another account's cached data. Do NOT reset on a fresh login —
    // that would wipe today's hydration/notification count back to 0.
    ref.listen(authProvider, (previous, next) {
      final prevId = previous?.user?.id;
      final nextId = next.user?.id;
      final loggedOut = prevId != null && next.user == null;
      final switchedAccount = prevId != null && nextId != null && prevId != nextId;
      if (loggedOut || switchedAccount) {
        ref.read(checkinProvider.notifier).reset();
        ref.read(notificationProvider.notifier).reset();
      }
    });

    return MaterialApp.router(
      title: 'RARE',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
