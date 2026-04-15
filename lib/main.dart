import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/theme.dart';
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
      providers: [ChangeNotifierProvider(create: (_) => LanguageProvider())],
      child: MaterialApp.router(
        title: 'MediLens',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme.copyWith(
          textTheme: GoogleFonts.notoSansTextTheme(
            AppTheme.darkTheme.textTheme,
          ).apply(bodyColor: AppTheme.white, displayColor: AppTheme.white),
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
