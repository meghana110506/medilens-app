import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medilens/core/constants.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/theme.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String _status = 'Starting MediLens...';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _updateStatus('Loading medicine database...');
    await Future.delayed(const Duration(milliseconds: 800));
    _updateStatus('Setting up language support...');
    await Future.delayed(const Duration(milliseconds: 600));
    _updateStatus('Ready!');
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final isSetupDone = prefs.getBool(AppConstants.keyUserSetup) ?? false;
    if (mounted) {
      context.go(isSetupDone ? AppRoutes.home : AppRoutes.welcome);
    }
  }

  void _updateStatus(String status) {
    if (mounted) setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: const Icon(Icons.medication,
                  size: 70, color: AppTheme.accent),
            ),
            const SizedBox(height: 32),
            const Text('MediLens',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                    letterSpacing: 2)),
            const SizedBox(height: 8),
            const Text('మందుల సమాచారం',
                style: TextStyle(fontSize: 20, color: AppTheme.teal)),
            const SizedBox(height: 60),
            const CircularProgressIndicator(color: AppTheme.accent),
            const SizedBox(height: 24),
            Text(_status,
                style: const TextStyle(fontSize: 14, color: AppTheme.grey)),
            const SizedBox(height: 60),
            const Text('For Elderly & Visually Impaired',
                style: TextStyle(fontSize: 12, color: AppTheme.grey)),
            const Text('वृद्धों और दृष्टिहीनों के लिए • பார்வையற்றவர்களுக்காக',
                style: TextStyle(fontSize: 12, color: AppTheme.grey)),
          ],
        ),
      ),
    );
  }
}


