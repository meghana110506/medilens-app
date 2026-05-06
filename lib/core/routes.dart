import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medilens/features/setup/setup_screen.dart';
import 'package:medilens/features/registration/screens/welcome_screen.dart';
import 'package:medilens/features/registration/screens/personal_details_screen.dart';
import 'package:medilens/features/registration/screens/health_profile_screen.dart';
import 'package:medilens/features/registration/screens/caregivers_manage_screen.dart';
import 'package:medilens/features/registration/screens/accessibility_screen.dart';
import 'package:medilens/features/registration/screens/all_set_screen.dart';
import 'package:medilens/features/home/home_screen.dart';
import 'package:medilens/features/scan/scan_screen.dart';
import 'package:medilens/features/processing/processing_screen.dart';
import 'package:medilens/features/medicine_info/medicine_info_screen.dart';
import 'package:medilens/features/cabinet/cabinet_screen.dart';
import 'package:medilens/features/reminders/reminders_screen.dart';
import 'package:medilens/features/expiry_tracker/expiry_tracker_screen.dart';
import 'package:medilens/features/interaction_checker/interaction_checker_screen.dart';
import 'package:medilens/features/sos/sos_screen.dart';
import 'package:medilens/features/settings/settings_screen.dart';

class AppRoutes {
  /// Used so notification taps can access [NavigatorState] / [BuildContext].
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static const String setup = '/';
  static const String welcome = '/welcome';
  static const String personalDetails = '/personal-details';
  static const String healthProfile = '/health-profile';
  static const String caregiversManage = '/caregivers-manage';
  static const String accessibility = '/accessibility';
  static const String allSet = '/all-set';
  static const String home = '/home';
  static const String scan = '/scan';
  static const String processing = '/processing';
  static const String medicineInfo = '/medicine-info';
  static const String cabinet = '/cabinet';
  static const String reminders = '/reminders';
  static const String expiryTracker = '/expiry-tracker';
  static const String interactionChecker = '/interaction-checker';
  static const String sos = '/sos';
  static const String settings = '/settings';

  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: setup,
    routes: [
      GoRoute(path: setup, builder: (ctx, state) => const SetupScreen()),
      GoRoute(path: welcome, builder: (ctx, state) => const WelcomeScreen()),
      GoRoute(
          path: personalDetails,
          builder: (ctx, state) => const PersonalDetailsScreen()),
      GoRoute(
          path: healthProfile,
          builder: (ctx, state) => const HealthProfileScreen()),
      GoRoute(
          path: caregiversManage,
          builder: (ctx, state) => const CaregiversManageScreen()),
      GoRoute(
          path: accessibility,
          builder: (ctx, state) => const AccessibilityScreen()),
      GoRoute(path: allSet, builder: (ctx, state) => const AllSetScreen()),
      GoRoute(path: home, builder: (ctx, state) => const HomeScreen()),
      GoRoute(path: scan, builder: (ctx, state) => const ScanScreen()),
      GoRoute(
        path: processing,
        builder: (ctx, state) => ProcessingScreen(
          scannedText: state.extra as String?,
        ),
      ),
      GoRoute(
        path: medicineInfo,
        builder: (ctx, state) => MedicineInfoScreen(
          medicineData: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(path: cabinet, builder: (ctx, state) => const CabinetScreen()),
      GoRoute(
          path: reminders, builder: (ctx, state) => const RemindersScreen()),
      GoRoute(
          path: expiryTracker,
          builder: (ctx, state) => const ExpiryTrackerScreen()),
      GoRoute(
          path: interactionChecker,
          builder: (ctx, state) => const InteractionCheckerScreen()),
      GoRoute(path: sos, builder: (ctx, state) => const SosScreen()),
      GoRoute(path: settings, builder: (ctx, state) => const SettingsScreen()),
    ],
  );
}
