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

    // Reset per-user data whenever the signed-in identity changes
    // (logout or a different account logging in), so one account never
    // sees another account's cached data.
    ref.listen(authProvider, (previous, next) {
      if (previous?.user?.id != next.user?.id) {
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
