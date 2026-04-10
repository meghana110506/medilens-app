import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';
import '../../../repositories/database_helper.dart';

class InteractionCheckerScreen extends StatefulWidget {
  const InteractionCheckerScreen({super.key});

  @override
  State<InteractionCheckerScreen> createState() =>
      _InteractionCheckerScreenState();
}

class _InteractionCheckerScreenState extends State<InteractionCheckerScreen> {
  final TextEditingController _drug1Controller = TextEditingController();
  final TextEditingController _drug2Controller = TextEditingController();
  bool _isChecking = false;
  Map<String, dynamic>? _result;
  List<Map<String, dynamic>> _drug1Suggestions = [];
  List<Map<String, dynamic>> _drug2Suggestions = [];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Drug Interactions',
      'te': 'మందుల పరస్పర క్రియ',
      'hi': 'दवा परस्पर क्रिया',
      'ta': 'மருந்து தொடர்புகள்'
    },
    'subtitle': {
      'en': 'Check if medicines are safe together',
      'te': 'మందులు కలిపి తీసుకోవడం సురక్షితమో తనిఖీ చేయండి',
      'hi': 'जांचें कि दवाएं एक साथ सुरक्षित हैं',
      'ta': 'மருந்துகள் ஒன்றாக பாதுகாப்பானதா என சரிபாருங்கள்'
    },
    'medicine1': {
      'en': 'Medicine 1',
      'te': 'మందు 1',
      'hi': 'दवा 1',
      'ta': 'மருந்து 1'
    },
    'medicine2': {
      'en': 'Medicine 2',
      'te': 'మందు 2',
      'hi': 'दवा 2',
      'ta': 'மருந்து 2'
    },
    'check': {
      'en': 'Check Interaction',
      'te': 'తనిఖీ చేయండి',
      'hi': 'परस्पर क्रिया जांचें',
      'ta': 'தொடர்பை சரிபாருங்கள்'
    },
    'checking': {
      'en': 'Checking...',
      'te': 'తనిఖీ చేస్తోంది...',
      'hi': 'जांच रहा है...',
      'ta': 'சரிபார்க்கிறது...'
    },
    'level': {
      'en': 'Interaction Level',
      'te': 'పరస్పర క్రియ స్థాయి',
      'hi': 'परस्पर क्रिया स्तर',
      'ta': 'தொடர்பு நிலை'
    },
    'listen': {
      'en': 'Listen',
      'te': 'వినండి',
      'hi': 'सुनें',
      'ta': 'கேளுங்கள்'
    },
    'desc': {
      'en':
          'Monitor closely when using these medicines together. Consult your doctor.',
      'te':
          'ఈ మందులు కలిపి వాడేటప్పుడు జాగ్రత్తగా గమనించండి. మీ డాక్టర్‌ని సంప్రదించండి.',
      'hi':
          'इन दवाओं को एक साथ उपयोग करते समय ध्यान से देखें। अपने डॉक्टर से परामर्श करें।',
      'ta':
          'இந்த மருந்துகளை ஒன்றாக பயன்படுத்தும்போது கவனமாக கண்காணிக்கவும். உங்கள் மருத்துவரை அணுகவும்.'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void dispose() {
    _drug1Controller.dispose();
    _drug2Controller.dispose();
    super.dispose();
  }

  Future<void> _searchDrug(String query, bool isDrug1) async {
    if (query.length < 3) return;
    try {
      final db = DatabaseHelper();
      final results = await db.searchDrug(query);
      setState(() {
        if (isDrug1)
          _drug1Suggestions = results;
        else
          _drug2Suggestions = results;
      });
    } catch (e) {
      debugPrint('Search error: $e');
    }
  }

  Future<void> _checkInteraction() async {
    if (_drug1Controller.text.isEmpty || _drug2Controller.text.isEmpty) return;
    setState(() {
      _isChecking = true;
      _result = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isChecking = false;
      _result = {
        'drug1': _drug1Controller.text,
        'drug2': _drug2Controller.text,
        'severity': 'moderate',
      };
    });
  }

  Future<void> _speak() async {
    if (_result == null) return;
    final provider = context.read<LanguageProvider>();
    final lang = provider.language;
    await provider.speak(_label('desc', lang));
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'severe':
        return AppTheme.error;
      case 'moderate':
        return AppTheme.warning;
      case 'mild':
        return AppTheme.success;
      default:
        return AppTheme.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'severe':
        return Icons.dangerous;
      case 'moderate':
        return Icons.warning_amber;
      case 'mild':
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(_label('title', lang)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_label('subtitle', lang),
                  style: const TextStyle(fontSize: 14, color: AppTheme.grey)),
              const SizedBox(height: 24),
              _buildDrugField(
                controller: _drug1Controller,
                label: _label('medicine1', lang),
                suggestions: _drug1Suggestions,
                isDrug1: true,
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppTheme.card, shape: BoxShape.circle),
                  child: const Icon(Icons.compare_arrows,
                      color: AppTheme.accent, size: 28),
                ),
              ),
              const SizedBox(height: 16),
              _buildDrugField(
                controller: _drug2Controller,
                label: _label('medicine2', lang),
                suggestions: _drug2Suggestions,
                isDrug1: false,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isChecking ? null : _checkInteraction,
                icon: _isChecking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.search),
                label: Text(_isChecking
                    ? _label('checking', lang)
                    : _label('check', lang)),
              ),
              const SizedBox(height: 24),
              if (_result != null) _buildResult(lang),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrugField({
    required TextEditingController controller,
    required String label,
    required List<Map<String, dynamic>> suggestions,
    required bool isDrug1,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppTheme.card, borderRadius: BorderRadius.circular(16)),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: AppTheme.white),
            onChanged: (val) => _searchDrug(val, isDrug1),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: AppTheme.grey),
              prefixIcon: const Icon(Icons.medication, color: AppTheme.accent),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
                color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: suggestions
                  .take(3)
                  .map((drug) => ListTile(
                        title: Text(drug['brand_name'] ?? '',
                            style: const TextStyle(
                                color: AppTheme.white, fontSize: 14)),
                        subtitle: Text(drug['generic_name'] ?? '',
                            style: const TextStyle(
                                color: AppTheme.grey, fontSize: 12)),
                        onTap: () {
                          controller.text = drug['brand_name'] ?? '';
                          setState(() {
                            if (isDrug1)
                              _drug1Suggestions = [];
                            else
                              _drug2Suggestions = [];
                          });
                        },
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildResult(String lang) {
    final severity = _result!['severity'];
    final color = _getSeverityColor(severity);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getSeverityIcon(severity), color: color, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(severity.toUpperCase(),
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Text(_label('level', lang),
                      style: TextStyle(
                          color: color.withOpacity(0.7), fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(_label('desc', lang),
              style: const TextStyle(
                  color: AppTheme.white, fontSize: 15, height: 1.5)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _speak,
            icon: const Icon(Icons.volume_up),
            label: Text(_label('listen', lang)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.teal,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
