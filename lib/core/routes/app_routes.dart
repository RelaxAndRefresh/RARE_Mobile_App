import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../providers/auth_provider.dart';
import '../../screens/splash/screen_37_splash_returning.dart';
import '../../screens/onboarding/screen_01_welcome.dart';
import '../../screens/onboarding/screen_02_soft_scan.dart';
import '../../screens/onboarding/screen_03_account_sync.dart';
import '../../screens/onboarding/screen_04_privacy_gate.dart';
import '../../screens/onboarding/screen_05_cycle_baseline.dart';
import '../../screens/onboarding/screen_06_wearable_connection.dart';
import '../../screens/onboarding/screen_07_aura_awakening.dart';
import '../../screens/home/screen_08_home.dart';
import '../../screens/home/screen_29_dormant_state.dart';
import '../../screens/home/screen_36_quiet_inbox.dart';
import '../../screens/checkin/screen_09_am_checkin.dart';
import '../../screens/checkin/screen_10_pm_checkin.dart';
import '../../screens/skin/screen_11_skin_log.dart';
import '../../screens/skin/screen_12_quick_log.dart';
import '../../screens/skin/screen_35_skin_progress_timeline.dart';
import '../../screens/shelf/screen_13_shelf.dart';
import '../../screens/shelf/screen_24_depletion_confirmation.dart';
import '../../screens/routine/screen_14_routine_builder.dart';
import '../../screens/routine/screen_18_routine_intervention_log.dart';
import '../../screens/insights/screen_15_biweekly_wrapped.dart';
import '../../screens/insights/screen_16_monthly_synthesis.dart';
import '../../screens/insights/screen_17_rare_pulse_feed.dart';
import '../../screens/insights/screen_19_environmental_map.dart';
import '../../screens/insights/screen_20_precision_profile.dart';
import '../../screens/booking/screen_21_optimize_shelf.dart';
import '../../screens/booking/screen_22_plan_my_relief.dart';
import '../../screens/booking/screen_23_booking_webview.dart';
import '../../screens/booking/screen_39_checkout_state.dart';
import '../../screens/profile/screen_33_profile_hub.dart';
import '../../screens/profile/screen_45_account_details.dart';
import '../../screens/settings/screen_25_settings.dart';
import '../../screens/settings/screen_26_privacy_dashboard.dart';
import '../../screens/settings/screen_27_kill_switch.dart';
import '../../screens/settings/screen_32_credits_ledger.dart';
import '../../screens/calendar/screen_28_cycle_calendar.dart';
import '../../screens/calendar/screen_34_data_log_edit_history.dart';
import '../../screens/support/screen_40_help_support.dart';
import '../../screens/legal/screen_38_legal_documents.dart';
import '../../screens/rituals/screen_41_rare_rituals.dart';
import '../../screens/orders/screen_31_order_booking_history.dart';
import '../../screens/b2b/screen_42_practitioner_login.dart';
import '../../screens/b2b/screen_43_pre_treatment_sync.dart';
import '../../screens/b2b/screen_44_post_treatment_protocol.dart';
import '../../screens/error/screen_30_error_empty.dart';

const _publicRoutes = <String>{
  '/',
  '/auth/splash',
  '/onboarding/welcome',
  '/onboarding/soft-scan',
  '/onboarding/account-sync',
  '/onboarding/privacy-gate',
  '/onboarding/cycle-baseline',
  '/onboarding/wearable-connection',
  '/onboarding/aura-awakening',
  '/error-empty',
  '/legal/documents',
  '/b2b/practitioner-login',
};

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.splashReturning,
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isPublicRoute = _publicRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isPublicRoute) {
        return RouteNames.splashReturning;
      }
      if (isLoggedIn && state.matchedLocation == RouteNames.splashReturning) {
        return RouteNames.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splashReturning,
        name: 'splash',
        builder: (context, state) => const SplashReturningScreen(),
      ),
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.softScan,
        name: 'softScan',
        builder: (context, state) => const SoftScanScreen(),
      ),
      GoRoute(
        path: RouteNames.accountSync,
        name: 'accountSync',
        builder: (context, state) => const AccountSyncScreen(),
      ),
      GoRoute(
        path: RouteNames.privacyGate,
        name: 'privacyGate',
        builder: (context, state) => const PrivacyGateScreen(),
      ),
      GoRoute(
        path: RouteNames.cycleBaseline,
        name: 'cycleBaseline',
        builder: (context, state) => const CycleBaselineScreen(),
      ),
      GoRoute(
        path: RouteNames.wearableConnection,
        name: 'wearableConnection',
        builder: (context, state) => const WearableConnectionScreen(),
      ),
      GoRoute(
        path: RouteNames.auraAwakening,
        name: 'auraAwakening',
        builder: (context, state) => const AuraAwakeningScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.amCheckin,
        name: 'amCheckin',
        builder: (context, state) => const AMCheckinScreen(),
      ),
      GoRoute(
        path: RouteNames.pmCheckin,
        name: 'pmCheckin',
        builder: (context, state) => const PMCheckinScreen(),
      ),
      GoRoute(
        path: RouteNames.skinLog,
        name: 'skinLog',
        builder: (context, state) => const SkinLogScreen(),
      ),
      GoRoute(
        path: RouteNames.quickLog,
        name: 'quickLog',
        builder: (context, state) => const QuickLogScreen(),
      ),
      GoRoute(
        path: RouteNames.shelf,
        name: 'shelf',
        builder: (context, state) => const ShelfScreen(),
      ),
      GoRoute(
        path: RouteNames.routineBuilder,
        name: 'routineBuilder',
        builder: (context, state) => const RoutineBuilderScreen(),
      ),
      GoRoute(
        path: RouteNames.biweeklyWrapped,
        name: 'biweeklyWrapped',
        builder: (context, state) => const BiweeklyWrappedScreen(),
      ),
      GoRoute(
        path: RouteNames.monthlySynthesis,
        name: 'monthlySynthesis',
        builder: (context, state) => const MonthlySynthesisScreen(),
      ),
      GoRoute(
        path: RouteNames.pulseFeed,
        name: 'pulseFeed',
        builder: (context, state) => const PulseFeedScreen(),
      ),
      GoRoute(
        path: RouteNames.routineInterventionLog,
        name: 'routineInterventionLog',
        builder: (context, state) => const RoutineInterventionLogScreen(),
      ),
      GoRoute(
        path: RouteNames.environmentalMap,
        name: 'environmentalMap',
        builder: (context, state) => const EnvironmentalMapScreen(),
      ),
      GoRoute(
        path: RouteNames.precisionProfile,
        name: 'precisionProfile',
        builder: (context, state) => const PrecisionProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.optimizeShelf,
        name: 'optimizeShelf',
        builder: (context, state) => const OptimizeShelfScreen(),
      ),
      GoRoute(
        path: RouteNames.planMyRelief,
        name: 'planMyRelief',
        builder: (context, state) => const PlanMyReliefScreen(),
      ),
      GoRoute(
        path: RouteNames.bookingWebview,
        name: 'bookingWebview',
        builder: (context, state) => const BookingWebviewScreen(),
      ),
      GoRoute(
        path: RouteNames.depletionConfirmation,
        name: 'depletionConfirmation',
        builder: (context, state) {
          final itemId = state.uri.queryParameters['itemId'];
          return DepletionConfirmationScreen(itemId: itemId);
        },
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.privacyDashboard,
        name: 'privacyDashboard',
        builder: (context, state) => const PrivacyDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.killSwitch,
        name: 'killSwitch',
        builder: (context, state) => const KillSwitchScreen(),
      ),
      GoRoute(
        path: RouteNames.cycleCalendar,
        name: 'cycleCalendar',
        builder: (context, state) => const CycleCalendarScreen(),
      ),
      GoRoute(
        path: RouteNames.dormantState,
        name: 'dormantState',
        builder: (context, state) => const DormantStateScreen(),
      ),
      GoRoute(
        path: RouteNames.errorEmpty,
        name: 'errorEmpty',
        builder: (context, state) => const ErrorEmptyScreen(),
      ),
      GoRoute(
        path: RouteNames.orderHistory,
        name: 'orderHistory',
        builder: (context, state) => const OrderBookingHistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.creditsLedger,
        name: 'creditsLedger',
        builder: (context, state) => const CreditsLedgerScreen(),
      ),
      GoRoute(
        path: RouteNames.profileHub,
        name: 'profileHub',
        builder: (context, state) => const ProfileHubScreen(),
      ),
      GoRoute(
        path: RouteNames.dataLogEdit,
        name: 'dataLogEdit',
        builder: (context, state) => const DataLogEditHistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.skinProgressTimeline,
        name: 'skinProgressTimeline',
        builder: (context, state) => const SkinProgressTimelineScreen(),
      ),
      GoRoute(
        path: RouteNames.quietInbox,
        name: 'quietInbox',
        builder: (context, state) => const QuietInboxScreen(),
      ),
      GoRoute(
        path: RouteNames.legalDocuments,
        name: 'legalDocuments',
        builder: (context, state) => const LegalDocumentsScreen(),
      ),
      GoRoute(
        path: RouteNames.checkoutState,
        name: 'checkoutState',
        builder: (context, state) => const CheckoutStateScreen(
          isSuccess: true,
        ),
      ),
      GoRoute(
        path: RouteNames.helpSupport,
        name: 'helpSupport',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: RouteNames.rituals,
        name: 'rituals',
        builder: (context, state) => const RareRitualsScreen(),
      ),
      GoRoute(
        path: RouteNames.practitionerLogin,
        name: 'practitionerLogin',
        builder: (context, state) => const PractitionerLoginScreen(),
      ),
      GoRoute(
        path: RouteNames.preTreatmentSync,
        name: 'preTreatmentSync',
        builder: (context, state) => const PreTreatmentSyncScreen(),
      ),
      GoRoute(
        path: RouteNames.postTreatmentProtocol,
        name: 'postTreatmentProtocol',
        builder: (context, state) => const PostTreatmentProtocolScreen(),
      ),
      GoRoute(
        path: RouteNames.accountDetails,
        name: 'accountDetails',
        builder: (context, state) => const AccountDetailsScreen(),
      ),
    ],
  );
});
