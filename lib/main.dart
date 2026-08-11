import 'package:flutter/material.dart';
import 'package:rare_mobile_app/screens/am_check_screen.dart';
import 'package:rare_mobile_app/screens/baseline_routine_builder_screen.dart';
import 'package:rare_mobile_app/screens/booking_webview_screen.dart';
import 'package:rare_mobile_app/screens/depletion_completion_screen.dart';
import 'package:rare_mobile_app/screens/environmental_map_screen.dart';
import 'package:rare_mobile_app/screens/kill_switch_screen.dart';
import 'package:rare_mobile_app/screens/optimize_shelf_screen.dart';
import 'package:rare_mobile_app/screens/plan_relief_screen.dart';
import 'package:rare_mobile_app/screens/pm_check_screen.dart';
import 'package:rare_mobile_app/screens/precision_profile_screen.dart';
import 'package:rare_mobile_app/screens/privacy_dashboard_screen.dart';
import 'package:rare_mobile_app/screens/routine_intervention_creen.dart';
import 'package:rare_mobile_app/screens/settings_notification_cadence_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_colors.dart';
import 'screens/pulse_feed_screen.dart';

void main() {
  runApp(const RareApp());
}

class RareApp extends StatelessWidget {
  const RareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RARE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const KillSwitchScreen(),
    );
  }
}