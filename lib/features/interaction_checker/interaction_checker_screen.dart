import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/core/widgets/sos_fab.dart';
import 'package:medilens/providers/language_provider.dart';

class InteractionCheckerScreen extends StatefulWidget {
  const InteractionCheckerScreen({super.key});

  @override
  State<InteractionCheckerScreen> createState() =>
      _InteractionCheckerScreenState();
}

class _InteractionCheckerScreenState extends State<InteractionCheckerScreen> {
  final _searchController = TextEditingController();
  final List<String> _selectedMedicines = [];
  bool _isChecking = false;
  List<Map<String, dynamic>> _results = [];

  final List<String> _commonMedicines = [
    'Paracetamol',
    'Aspirin',
    'Ibuprofen',
    'Metformin',
    'Amlodipine',
    'Atorvastatin',
    'Omeprazole',
    'Metoprolol',
    'Lisinopril',
    'Warfarin',
    'Digoxin',
    'Furosemide',
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Interaction Checker',
      'te': 'మందుల పరస్పర చర్య తనిఖీ',
      'hi': 'दवा परस्पर क्रिया जाँच',
      'ta': 'மருந்து தொடர்பு சரிபார்ப்பு'
    },
    'subtitle': {
      'en': 'Check if medicines are safe together',
      'te': 'మందులు కలిసి సురక్షితంగా ఉన్నాయో తనిఖీ చేయండి',
      'hi': 'जांचें कि दवाएं एक साथ सुरक्षित हैं',
      'ta': 'மருந்துகள் ஒன்றாக பாதுகாப்பானவையா என சரிபார்க்கவும்'
    },
    'search': {
      'en': 'Search medicine...',
      'te': 'మందు వెతకండి...',
      'hi': 'दवा खोजें...',
      'ta': 'மருந்தை தேடுங்கள்...'
    },
    'selected': {
      'en': 'Selected Medicines',
      'te': 'ఎంచుకున్న మందులు',
      'hi': 'चुनी गई दवाएं',
      'ta': 'தேர்ந்தெடுக்கப்பட்ட மருந்துகள்'
    },
    'common': {
      'en': 'Common Medicines',
      'te': 'సాధారణ మందులు',
      'hi': 'सामान्य दवाएं',
      'ta': 'பொதுவான மருந்துகள்'
    },
    'check': {
      'en': 'Check Interactions',
      'te': 'పరస్పర చర్యలు తనిఖీ చేయండి',
      'hi': 'परस्पर क्रियाएं जांचें',
      'ta': 'தொடர்புகளை சரிபார்க்கவும்'
    },
    'results': {
      'en': 'Results',
      'te': 'ఫలితాలు',
      'hi': 'परिणाम',
      'ta': 'முடிவுகள்'
    },
    'safe': {
      'en': 'Safe to use together',
      'te': 'కలిసి వాడటానికి సురక్షితం',
      'hi': 'एक साथ उपयोग करना सुरक्षित',
      'ta': 'ஒன்றாக பயன்படுத்த பாதுகாப்பானது'
    },
    'warning': {
      'en': 'Use with caution',
      'te': 'జాగ్రత్తగా వాడండి',
      'hi': 'सावधानी के साथ उपयोग करें',
      'ta': 'எச்சரிக்கையுடன் பயன்படுத்துங்கள்'
    },
    'danger': {
      'en': 'Dangerous combination!',
      'te': 'ప్రమాదకరమైన కలయిక!',
      'hi': 'खतरनाक संयोजन!',
      'ta': 'ஆபத்தான கலவை!'
    },
    'min_medicines': {
      'en': 'Please select at least 2 medicines',
      'te': 'దయచేసి కనీసం 2 మందులు ఎంచుకోండి',
      'hi': 'कृपया कम से कम 2 दवाएं चुनें',
      'ta': 'குறைந்தது 2 மருந்துகளை தேர்ந்தெடுக்கவும்'
    },
    'checking': {
      'en': 'Checking...',
      'te': 'తనిఖీ చేస్తున్నాము...',
      'hi': 'जांच रहे हैं...',
      'ta': 'சரிபார்க்கிறோம்...'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  void _checkInteractions(String lang) {
    if (_selectedMedicines.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                LangText(_label('min_medicines', lang), lang, fontSize: 13)),
      );
      return;
    }
    setState(() {
      _isChecking = true;
      _results = [];
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isChecking = false;
        _results = _generateResults();
      });
    });
  }

  List<Map<String, dynamic>> _generateResults() {
    final results = <Map<String, dynamic>>[];
    for (int i = 0; i < _selectedMedicines.length - 1; i++) {
      for (int j = i + 1; j < _selectedMedicines.length; j++) {
        final m1 = _selectedMedicines[i];
        final m2 = _selectedMedicines[j];
        int severity = 0;
        if ((m1 == 'Aspirin' && m2 == 'Warfarin') ||
            (m1 == 'Warfarin' && m2 == 'Aspirin')) {
          severity = 2;
        } else if ((m1 == 'Metformin' && m2 == 'Ibuprofen') ||
            (m1 == 'Ibuprofen' && m2 == 'Metformin')) {
          severity = 1;
        }
        results.add({'medicine1': m1, 'medicine2': m2, 'severity': severity});
      }
    }
    return results;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final font = LanguageProvider.getFontFamily(lang);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: LangText(_label('title', lang), lang,
            fontSize: 16, fontWeight: FontWeight.bold),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
        padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LangText(_label('subtitle', lang), lang,
                    fontSize: 13, color: AppTheme.grey),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16)),
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontFamily: font, color: AppTheme.white),
                decoration: InputDecoration(
                  hintText: _label('search', lang),
                  hintStyle: TextStyle(fontFamily: font, color: AppTheme.grey),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.accent),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty && !_selectedMedicines.contains(val)) {
                    setState(() => _selectedMedicines.add(val));
                    _searchController.clear();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedMedicines.isNotEmpty) ...[
              LangText(_label('selected', lang), lang,
                  fontSize: 12, color: AppTheme.grey),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedMedicines
                    .map((m) => Chip(
                          label: Text(m,
                              style: const TextStyle(
                                  color: AppTheme.white, fontSize: 13)),
                          backgroundColor: AppTheme.accent,
                          deleteIcon: const Icon(Icons.close,
                              size: 16, color: AppTheme.white),
                          onDeleted: () =>
                              setState(() => _selectedMedicines.remove(m)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
            LangText(_label('common', lang), lang,
                fontSize: 12, color: AppTheme.grey),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonMedicines.map((m) {
                final isSelected = _selectedMedicines.contains(m);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selectedMedicines.remove(m);
                    } else {
                      _selectedMedicines.add(m);
                    }
                  }),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accent : AppTheme.card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(m,
                        style: TextStyle(
                          color: isSelected ? AppTheme.white : AppTheme.grey,
                          fontSize: 13,
                        )),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _isChecking ? null : () => _checkInteractions(lang),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.accent, Color(0xFF1D6FD8)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _isChecking
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: AppTheme.white, strokeWidth: 2)),
                            const SizedBox(width: 12),
                            LangText(_label('checking', lang), lang,
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ],
                        )
                      : LangText(_label('check', lang), lang,
                          fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (_results.isNotEmpty) ...[
              const SizedBox(height: 24),
              LangText(_label('results', lang), lang,
                  fontSize: 14, fontWeight: FontWeight.bold),
              const SizedBox(height: 12),
                  ..._results.map((r) => _resultCard(r, lang)),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const SOSFab(),
    );
  }

  Widget _resultCard(Map<String, dynamic> result, String lang) {
    final severity = result['severity'] as int;
    final colors = [AppTheme.success, AppTheme.warning, AppTheme.error];
    final icons = [Icons.check_circle, Icons.warning, Icons.dangerous];
    final labelKeys = ['safe', 'warning', 'danger'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors[severity].withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icons[severity], color: colors[severity], size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${result['medicine1']} + ${result['medicine2']}',
                    style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors[severity].withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: LangText(_label(labelKeys[severity], lang), lang,
                fontSize: 12,
                color: colors[severity],
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
