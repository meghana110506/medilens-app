import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';
import '../../../repositories/database_helper.dart';

class MedicineInfoScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const MedicineInfoScreen({super.key, this.data});

  @override
  State<MedicineInfoScreen> createState() => _MedicineInfoScreenState();
}

class _MedicineInfoScreenState extends State<MedicineInfoScreen> {
  bool _isSpeaking = false;
  bool _isLoading = true;
  Map<String, dynamic>? _drugInfo;
  String _extractedText = '';

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Medicine Info',
      'te': 'మందు సమాచారం',
      'hi': 'दवा जानकारी',
      'ta': 'மருந்து தகவல்'
    },
    'scanned': {
      'en': 'Scanned Text',
      'te': 'స్కాన్ చేసిన వచనం',
      'hi': 'स्कैन किया गया टेक्स्ट',
      'ta': 'ஸ்கேன் செய்த உரை'
    },
    'uses': {'en': 'Uses', 'te': 'ఉపయోగాలు', 'hi': 'उपयोग', 'ta': 'பயன்கள்'},
    'side_effects': {
      'en': 'Side Effects',
      'te': 'దుష్ప్రభావాలు',
      'hi': 'दुष्प्रभाव',
      'ta': 'பக்க விளைவுகள்'
    },
    'warnings': {
      'en': 'Warnings',
      'te': 'హెచ్చరికలు',
      'hi': 'चेतावनियाँ',
      'ta': 'எச்சரிக்கைகள்'
    },
    'dosage': {
      'en': 'Dosage',
      'te': 'మోతాదు',
      'hi': 'खुराक',
      'ta': 'மருந்தளவு'
    },
    'how_to_use': {
      'en': 'How to Use',
      'te': 'ఎలా వాడాలి',
      'hi': 'कैसे उपयोग करें',
      'ta': 'எப்படி பயன்படுத்துவது'
    },
    'not_found': {
      'en': 'Medicine not found in database',
      'te': 'మందు డేటాబేస్ లో దొరకలేదు',
      'hi': 'दवाबेस में दवा नहीं मिली',
      'ta': 'தரவுத்தளத்தில் மருந்து கிடைக்கவில்லை'
    },
    'listen': {
      'en': 'Listen',
      'te': 'వినండి',
      'hi': 'सुनें',
      'ta': 'கேளுங்கள்'
    },
    'stop': {'en': 'Stop', 'te': 'ఆపండి', 'hi': 'रोकें', 'ta': 'நிறுத்து'},
    'scan_another': {
      'en': 'Scan Another',
      'te': 'మరొకటి స్కాన్ చేయండి',
      'hi': 'दूसरा स्कैन करें',
      'ta': 'மற்றொன்றை ஸ்கேன் செய்யுங்கள்'
    },
    'check_interaction': {
      'en': 'Check Drug Interactions',
      'te': 'మందుల పరస్పర క్రియ తనిఖీ',
      'hi': 'दवा परस्पर क्रिया जांचें',
      'ta': 'மருந்து தொடர்புகளை சரிபாருங்கள்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void initState() {
    super.initState();
    _loadDrugInfo();
  }

  Future<void> _loadDrugInfo() async {
    try {
      _extractedText = widget.data?['extractedText'] ?? '';
      if (_extractedText.isNotEmpty) {
        final db = DatabaseHelper();
        final words = _extractedText
            .split(' ')
            .where((w) => w.length > 3)
            .take(5)
            .toList();
        for (final word in words) {
          final results = await db.searchDrug(word);
          if (results.isNotEmpty) {
            setState(() {
              _drugInfo = results.first;
              _isLoading = false;
            });
            return;
          }
        }
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _speakInfo() async {
    final provider = context.read<LanguageProvider>();
    if (_isSpeaking) {
      await provider.stopSpeaking();
      setState(() => _isSpeaking = false);
      return;
    }
    setState(() => _isSpeaking = true);

    final lang = provider.language;
    final Map<String, String> speechTexts = {
      'en': _buildSpeechText('en'),
      'te': _buildSpeechText('te'),
      'hi': _buildSpeechText('hi'),
      'ta': _buildSpeechText('ta'),
    };

    await provider.speak(speechTexts[lang] ?? speechTexts['en']!);
    setState(() => _isSpeaking = false);
  }

  String _buildSpeechText(String lang) {
    if (_drugInfo == null) {
      return {
            'en': 'Medicine information not found',
            'te': 'మందు సమాచారం దొరకలేదు',
            'hi': 'दवा की जानकारी नहीं मिली',
            'ta': 'மருந்து தகவல் கிடைக்கவில்லை',
          }[lang] ??
          'Medicine information not found';
    }
    final name = _drugInfo!['brand_name'] ?? _drugInfo!['generic_name'] ?? '';
    final uses = _drugInfo!['uses'] ?? '';
    final warnings = _drugInfo!['warnings'] ?? '';
    return {
          'en': 'Medicine name $name. Uses: $uses. Warnings: $warnings',
          'te': 'మందు పేరు $name. ఉపయోగాలు: $uses. హెచ్చరికలు: $warnings',
          'hi': 'दवा का नाम $name. उपयोग: $uses. चेतावनियाँ: $warnings',
          'ta':
              'மருந்தின் பெயர் $name. பயன்கள்: $uses. எச்சரிக்கைகள்: $warnings',
        }[lang] ??
        'Medicine name $name. Uses: $uses. Warnings: $warnings';
  }

  @override
  void dispose() {
    context.read<LanguageProvider>().stopSpeaking();
    super.dispose();
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
        actions: [
          IconButton(
            onPressed: () => context.go(AppRoutes.scan),
            icon: const Icon(Icons.camera_alt, color: AppTheme.accent),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.accent))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medicine Name Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.accent, Color(0xFF1565C0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.medication,
                              color: Colors.white, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            _drugInfo?['brand_name'] ?? 'Unknown Medicine',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          if (_drugInfo?['generic_name'] != null)
                            Text(_drugInfo!['generic_name'],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white70)),
                          if (_drugInfo?['manufacturer'] != null)
                            Text(_drugInfo!['manufacturer'],
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.white60)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Listen Button - All 4 Languages
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _speakInfo,
                            icon: Icon(
                                _isSpeaking ? Icons.stop : Icons.volume_up),
                            label: Text(_isSpeaking
                                ? _label('stop', lang)
                                : _label('listen', lang)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accent,
                              minimumSize: const Size(0, 52),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Language TTS buttons
                    Row(
                      children: [
                        _buildLangButton('EN', 'en'),
                        const SizedBox(width: 8),
                        _buildLangButton('TE', 'te'),
                        const SizedBox(width: 8),
                        _buildLangButton('HI', 'hi'),
                        const SizedBox(width: 8),
                        _buildLangButton('TA', 'ta'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (_extractedText.isNotEmpty) ...[
                      _buildInfoCard(_label('scanned', lang), _extractedText,
                          Icons.text_fields, AppTheme.grey),
                      const SizedBox(height: 16),
                    ],

                    if (_drugInfo != null) ...[
                      if (_drugInfo!['uses']?.isNotEmpty == true)
                        _buildInfoCard(_label('uses', lang), _drugInfo!['uses'],
                            Icons.check_circle, AppTheme.success),
                      const SizedBox(height: 16),
                      if (_drugInfo!['side_effects']?.isNotEmpty == true)
                        _buildInfoCard(
                            _label('side_effects', lang),
                            _drugInfo!['side_effects'],
                            Icons.warning_amber,
                            AppTheme.warning),
                      const SizedBox(height: 16),
                      if (_drugInfo!['warnings']?.isNotEmpty == true)
                        _buildInfoCard(
                            _label('warnings', lang),
                            _drugInfo!['warnings'],
                            Icons.error,
                            AppTheme.error),
                      const SizedBox(height: 16),
                      if (_drugInfo!['dosage']?.isNotEmpty == true)
                        _buildInfoCard(
                            _label('dosage', lang),
                            _drugInfo!['dosage'],
                            Icons.medication,
                            AppTheme.accent),
                      const SizedBox(height: 16),
                      if (_drugInfo!['how_to_use']?.isNotEmpty == true)
                        _buildInfoCard(
                            _label('how_to_use', lang),
                            _drugInfo!['how_to_use'],
                            Icons.info,
                            AppTheme.teal),
                    ] else
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            const Icon(Icons.search_off,
                                color: AppTheme.grey, size: 48),
                            const SizedBox(height: 12),
                            Text(_label('not_found', lang),
                                style: const TextStyle(
                                    color: AppTheme.white, fontSize: 16),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: () => context.go(AppRoutes.interactionChecker),
                      icon: const Icon(Icons.compare_arrows),
                      label: Text(_label('check_interaction', lang)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.card,
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => context.go(AppRoutes.scan),
                      icon: const Icon(Icons.camera_alt),
                      label: Text(_label('scan_another', lang)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLangButton(String label, String langCode) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          setState(() => _isSpeaking = true);
          final provider = context.read<LanguageProvider>();
          await provider.speakInLanguage(_buildSpeechText(langCode), langCode);
          setState(() => _isSpeaking = false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.card,
          minimumSize: const Size(0, 44),
          padding: EdgeInsets.zero,
        ),
        child: Text(label,
            style: const TextStyle(
                color: AppTheme.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Text(content,
              style: const TextStyle(
                  color: AppTheme.white, fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }
}
