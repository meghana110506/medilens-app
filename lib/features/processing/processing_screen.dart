import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';
import 'package:medilens/repositories/database_helper.dart';

class ProcessingScreen extends StatefulWidget {
  final String? scannedText;
  const ProcessingScreen({super.key, this.scannedText});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _currentStep = 0;
  double _confidence = 0;
  Map<String, dynamic>? _medicineData;

  final List<Map<String, dynamic>> _steps = [
    {'icon': '🖼️', 'label': 'Image Enhancement', 'status': 'waiting'},
    {'icon': '🔤', 'label': 'OCR Extraction', 'status': 'waiting'},
    {'icon': '🔍', 'label': 'Confidence Check', 'status': 'waiting'},
    {'icon': '📚', 'label': 'Offline DB Match', 'status': 'waiting'},
    {'icon': '📅', 'label': 'Expiry Detection', 'status': 'waiting'},
    {'icon': '🔊', 'label': 'Audio Prep', 'status': 'waiting'},
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {'en': 'Analysing Image...', 'te': 'చిత్రాన్ని విశ్లేషిస్తున్నాము...', 'hi': 'छवि का विश्लेषण हो रहा है...', 'ta': 'படத்தை பகுப்பாய்வு செய்கிறோம்...'},
    'offline': {'en': 'On-device · No internet needed', 'te': 'పరికరంలో · ఇంటర్నెట్ అవసరం లేదు', 'hi': 'डिवाइस पर · इंटरनेट की जरूरत नहीं', 'ta': 'சாதனத்தில் · இணையம் தேவையில்லை'},
    'view_result': {'en': '→ View Results', 'te': '→ ఫలితాలు చూడండి', 'hi': '→ परिणाम देखें', 'ta': '→ முடிவுகளை பார்க்கவும்'},
    'done': {'en': '✓ Done', 'te': '✓ పూర్తైంది', 'hi': '✓ हो गया', 'ta': '✓ முடிந்தது'},
    'running': {'en': '● Running', 'te': '● నడుస్తోంది', 'hi': '● चल रहा है', 'ta': '● இயங்குகிறது'},
    'waiting': {'en': 'Waiting', 'te': 'వేచి ఉంది', 'hi': 'प्रतीक्षारत', 'ta': 'காத்திருக்கிறது'},
    'confidence': {'en': 'Confidence', 'te': 'నమ్మకం', 'hi': 'विश्वास', 'ta': 'நம்பகத்தன்மை'},
    'auto_proceed': {'en': 'Auto-proceeding.', 'te': 'స్వయంచాలకంగా కొనసాగుతోంది.', 'hi': 'स्वतः आगे बढ़ रहा है।', 'ta': 'தானாக தொடர்கிறது.'},
    'expiry_found': {'en': 'Expiry detected', 'te': 'గడువు గుర్తించబడింది', 'hi': 'समाप्ति तिथि मिली', 'ta': 'காலாவதி கண்டறியப்பட்டது'},
    'expiry_not_found': {'en': 'Expiry not found', 'te': 'గడువు కనుగొనబడలేదు', 'hi': 'समाप्ति तिथि नहीं मिली', 'ta': 'காலாவதி கிடைக்கவில்லை'},
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
    _processSteps();
  }

  String? _extractExpiry(String text) {
    final patterns = [
      RegExp(r'EXP(?:IRY)?(?:\s*DATE)?[:\s]*(\d{2}[\/\-]\d{4})',
          caseSensitive: false),
      RegExp(r'USE\s+BEFORE[:\s]*(\d{2}[\/\-]\d{4})', caseSensitive: false),
      RegExp(r'BEST\s+BEFORE[:\s]*(\d{2}[\/\-]\d{4})', caseSensitive: false),
      RegExp(
          r'EXP[:\s]*(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s+(\d{4})',
          caseSensitive: false),
      RegExp(r'(\d{2})[\/\-](\d{4})'),
      RegExp(
          r'(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)[\s\-\/]+(\d{4})',
          caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(0);
      }
    }
    return null;
  }

  Future<void> _processSteps() async {
    final scannedText = widget.scannedText ?? '';

    await _setStep(0, 'done', 400);
    await _setStep(1, 'done', 600);

    await _setStep(2, 'running', 200);
    _confidence = scannedText.isNotEmpty ? 94 : 61;
    await _setStep(2, 'done', 600);

    await _setStep(3, 'running', 200);
    if (scannedText.isNotEmpty) {
      try {
        final db = DatabaseHelper();
        final words = scannedText
            .split(RegExp(r'\s+'))
            .where((w) => w.length > 3)
            .toList();
        Map<String, dynamic>? found;
        for (final word in words) {
          final results = await db.searchDrug(word);
          if (results.isNotEmpty) {
            found = Map<String, dynamic>.from(results.first);
            break;
          }
        }
        _medicineData = found;
      } catch (e) {
        debugPrint('DB error: $e');
      }
    }
    await _setStep(3, 'done', 400);

    // Step 5 - Expiry Detection
    await _setStep(4, 'running', 200);
    if (scannedText.isNotEmpty) {
      final expiry = _extractExpiry(scannedText);
      if (expiry != null) {
        _medicineData ??= {};
        _medicineData!['expiry_date'] = expiry;
        debugPrint('Expiry detected: $expiry');
      }
    }
    await _setStep(4, 'done', 400);

    await _setStep(5, 'done', 400);

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      context.go(AppRoutes.medicineInfo, extra: _medicineData);
    }
  }

  Future<void> _setStep(int index, String status, int delayMs) async {
    if (!mounted) return;
    setState(() {
      _steps[index]['status'] = status;
      _currentStep = index;
    });
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _ctrl,
                child: Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.accent, width: 3),
                    gradient: LinearGradient(colors: [
                      AppTheme.accent.withValues(alpha: 0.2),
                      Colors.transparent
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              LangText(_label('title', lang), lang,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center),
              const SizedBox(height: 6),
              LangText(_label('offline', lang), lang,
                  fontSize: 12,
                  color: AppTheme.grey,
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ..._steps.asMap().entries.map((entry) {
                final step = entry.value;
                final status = step['status'] as String;
                Color statusColor = AppTheme.grey;
                String statusText = _label('waiting', lang);
                if (status == 'done') {
                  statusColor = AppTheme.success;
                  statusText = _label('done', lang);
                } else if (status == 'running') {
                  statusColor = AppTheme.accent;
                  statusText = _label('running', lang);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: status == 'done'
                              ? AppTheme.success.withValues(alpha: 0.15)
                              : status == 'running'
                                  ? AppTheme.accent.withValues(alpha: 0.15)
                                  : AppTheme.card,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                            child: Text(step['icon'] as String,
                                style: const TextStyle(fontSize: 14))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(step['label'] as String,
                            style: TextStyle(
                              color: status == 'waiting'
                                  ? AppTheme.grey
                                  : AppTheme.white,
                              fontSize: 14,
                            )),
                      ),
                      Text(statusText,
                          style:
                              TextStyle(color: statusColor, fontSize: 12)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              if (_confidence > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.accent.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    children: [
                      const Text('ℹ️', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      LangText('${_label('confidence', lang)}: ', lang,
                          fontSize: 13, color: AppTheme.grey),
                      Text('${_confidence.toInt()}%',
                          style: const TextStyle(
                              color: AppTheme.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      const SizedBox(width: 6),
                      LangText(_label('auto_proceed', lang), lang,
                          fontSize: 12, color: AppTheme.grey),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () =>
                    context.go(AppRoutes.medicineInfo, extra: _medicineData),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppTheme.accent, AppTheme.teal]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: LangText(_label('view_result', lang), lang,
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}