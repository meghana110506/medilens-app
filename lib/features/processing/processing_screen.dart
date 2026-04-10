import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../repositories/database_helper.dart';

class ProcessingScreen extends StatefulWidget {
  final String? imagePath;
  const ProcessingScreen({super.key, this.imagePath});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _currentStep = 'Analyzing image...';
  String _currentStepTe = 'చిత్రాన్ని విశ్లేషిస్తోంది...';
  int _stepIndex = 0;
  bool _isDone = false;

  final List<Map<String, String>> _steps = [
    {'en': 'Analyzing image...', 'te': 'చిత్రాన్ని విశ్లేషిస్తోంది...'},
    {'en': 'Extracting text...', 'te': 'వచనాన్ని వెలికితీస్తోంది...'},
    {
      'en': 'Searching medicine database...',
      'te': 'మందుల డేటాబేస్ శోధిస్తోంది...'
    },
    {
      'en': 'Preparing bilingual info...',
      'te': 'ద్విభాషా సమాచారం సిద్ధం చేస్తోంది...'
    },
    {'en': 'Almost done!', 'te': 'దాదాపు పూర్తైంది!'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _processImage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processImage() async {
    String extractedText = '';

    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() {
        _stepIndex = i;
        _currentStep = _steps[i]['en']!;
        _currentStepTe = _steps[i]['te']!;
      });
      await Future.delayed(const Duration(milliseconds: 800));

      // Do OCR on step 1
      if (i == 1 && widget.imagePath != null) {
        try {
          final inputImage = InputImage.fromFile(File(widget.imagePath!));
          final textRecognizer =
              TextRecognizer(script: TextRecognitionScript.latin);
          final recognized = await textRecognizer.processImage(inputImage);
          extractedText = recognized.text;
          await textRecognizer.close();
        } catch (e) {
          extractedText = '';
        }
      }

      // Search database on step 2
      if (i == 2 && extractedText.isNotEmpty) {
        try {
          final db = DatabaseHelper();
          final words = extractedText
              .split(' ')
              .where((w) => w.length > 3)
              .take(3)
              .toList();
          for (final word in words) {
            final results = await db.searchDrug(word);
            if (results.isNotEmpty) break;
          }
        } catch (e) {
          debugPrint('DB search error: $e');
        }
      }
    }

    if (!mounted) return;
    setState(() => _isDone = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      context.go(AppRoutes.medicineInfo, extra: {
        'imagePath': widget.imagePath,
        'extractedText': extractedText,
      });
    }
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
              // Animated Icon
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
                          color: AppTheme.accent.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 8)
                    ],
                  ),
                  child: Icon(
                    _isDone ? Icons.check_circle : Icons.document_scanner,
                    size: 60,
                    color: _isDone ? AppTheme.teal : AppTheme.accent,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                _currentStep,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _currentStepTe,
                style: const TextStyle(fontSize: 18, color: AppTheme.teal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Step indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    _steps.length,
                    (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _stepIndex ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i <= _stepIndex
                                ? AppTheme.accent
                                : AppTheme.card,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
              ),
              const Spacer(),
              const Text('Please wait • దయచేసి వేచి ఉండండి',
                  style: TextStyle(color: AppTheme.grey, fontSize: 14)),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
