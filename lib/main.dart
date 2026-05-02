import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/app_data.dart';
import 'package:medilens/providers/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      child: Consumer<LanguageProvider>(
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
      ),
    );
  }
}
