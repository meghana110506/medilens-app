import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/repositories/database_helper.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _status = 'Reading medicine label...';
  double _progress = 0.0;
  int _currentStep = 0;

  final List<Map<String, String>> _steps = [
    {'icon': '🔍', 'text': 'Reading medicine label...'},
    {'icon': '🧠', 'text': 'Recognizing text with OCR...'},
    {'icon': '💊', 'text': 'Searching medicine database...'},
    {'icon': '🌐', 'text': 'Translating information...'},
    {'icon': '✅', 'text': 'Done! Loading results...'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _processSteps();
  }

  Future<void> _processSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() {
        _currentStep = i;
        _status = _steps[i]['text']!;
        _progress = (i + 1) / _steps.length;
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      try {
        final db = DatabaseHelper();
        final results = await db.searchDrug('Paracetamol');
        if (mounted) context.go(AppRoutes.medicineInfo);
      } catch (e) {
        if (mounted) context.go(AppRoutes.medicineInfo);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              RotationTransition(
                turns: _controller,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: const Icon(Icons.medication,
                      size: 60, color: AppTheme.accent),
                ),
              ),
              const SizedBox(height: 40),
              const Text('Processing...',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white)),
              const SizedBox(height: 8),
              Text(_status,
                  style: const TextStyle(fontSize: 16, color: AppTheme.grey),
                  textAlign: TextAlign.center),
              const SizedBox(height: 40),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppTheme.card,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppTheme.accent),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text('${(_progress * 100).toInt()}%',
                  style: const TextStyle(
                      color: AppTheme.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ...List.generate(
                  _steps.length,
                  (i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Text(_steps[i]['icon']!,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(_steps[i]['text']!,
                                  style: TextStyle(
                                    color: i <= _currentStep
                                        ? AppTheme.white
                                        : AppTheme.grey,
                                    fontSize: 14,
                                    fontWeight: i == _currentStep
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  )),
                            ),
                            if (i < _currentStep)
                              const Icon(Icons.check_circle,
                                  color: AppTheme.teal, size: 18)
                            else if (i == _currentStep)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: AppTheme.accent),
                              ),
                          ],
                        ),
                      )),
              const Spacer(),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Cancel',
                    style: TextStyle(color: AppTheme.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
