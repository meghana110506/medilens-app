import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/app_data.dart';
import 'package:medilens/providers/language_provider.dart';
import 'package:medilens/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const MediLensApp());
}

class MediLensApp extends StatelessWidget {
  const MediLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppData()),
      ],
      child: const _NotificationSyncScope(
        child: _MediLensRouterShell(),
      ),
    );
  }
}

/// Keeps local notifications aligned with cabinet/reminders and language.
class _NotificationSyncScope extends StatefulWidget {
  const _NotificationSyncScope({required this.child});

  final Widget child;

  @override
  State<_NotificationSyncScope> createState() => _NotificationSyncScopeState();
}

class _NotificationSyncScopeState extends State<_NotificationSyncScope> {
  Timer? _debounce;
  late AppData _appData;
  late LanguageProvider _language;

  @override
  void initState() {
    super.initState();
    _appData = context.read<AppData>();
    _language = context.read<LanguageProvider>();
    _appData.addListener(_scheduleSync);
    _language.addListener(_scheduleSync);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(NotificationService.instance.handleLaunchIfNeeded(context));
      _scheduleSync();
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        unawaited(
            NotificationService.showAndroidPermissionPrecheckIfNeeded(context));
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _appData.removeListener(_scheduleSync);
    _language.removeListener(_scheduleSync);
    super.dispose();
  }

  void _scheduleSync() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      await NotificationService.instance.sync(_appData, _language);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _MediLensRouterShell extends StatelessWidget {
  const _MediLensRouterShell();

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        return MaterialApp.router(
          title: 'MediLens',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(provider.fontSize / 18.0),
              ),
              child: child!,
            );
          },
          routerConfig: AppRoutes.router,
        );
      },
    );
  }
}
