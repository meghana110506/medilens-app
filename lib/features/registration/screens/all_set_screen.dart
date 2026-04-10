import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/constants.dart';
import '../../../providers/language_provider.dart';

class AllSetScreen extends StatefulWidget {
  const AllSetScreen({super.key});

  @override
  State<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends State<AllSetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'You\'re All Set!',
      'te': 'మీరు సిద్ధంగా ఉన్నారు!',
      'hi': 'आप तैयार हैं!',
      'ta': 'நீங்கள் தயார்!'
    },
    'subtitle': {
      'en': 'MediLens is ready to help you',
      'te': 'MediLens మీకు సహాయం చేయడానికి సిద్ధంగా ఉంది',
      'hi': 'MediLens आपकी मदद के लिए तैयार है',
      'ta': 'MediLens உங்களுக்கு உதவ தயாராக உள்ளது'
    },
    'start': {
      'en': 'Start Using MediLens',
      'te': 'MediLens ఉపయోగించడం ప్రారంభించండి',
      'hi': 'MediLens उपयोग शुरू करें',
      'ta': 'MediLens பயன்படுத்த தொடங்குங்கள்'
    },
    'scan': {
      'en': 'Scan medicine labels',
      'te': 'మందు లేబుల్స్ స్కాన్ చేయండి',
      'hi': 'दवा लेबल स्कैन करें',
      'ta': 'மருந்து லேபல்களை ஸ்கேன் செய்யுங்கள்'
    },
    'audio': {
      'en': 'Listen in 4 languages',
      'te': '4 భాషలలో వినండి',
      'hi': '4 भाषाओं में सुनें',
      'ta': '4 மொழிகளில் கேளுங்கள்'
    },
    'warnings': {
      'en': 'Get safety warnings',
      'te': 'భద్రతా హెచ్చరికలు పొందండి',
      'hi': 'सुरक्षा चेतावनियाँ प्राप्त करें',
      'ta': 'பாதுகாப்பு எச்சரிக்கைகள் பெறுங்கள்'
    },
    'sos': {
      'en': 'SOS emergency alerts',
      'te': 'SOS అత్యవసర అలర్ట్లు',
      'hi': 'SOS आपातकालीन अलर्ट',
      'ta': 'SOS அவசர அலர்ட்கள்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _speakWelcome();
  }

  Future<void> _speakWelcome() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    final provider = context.read<LanguageProvider>();
    final Map<String, String> welcomeTexts = {
      'en': 'You are all set! Welcome to MediLens.',
      'te': 'మీరు సిద్ధంగా ఉన్నారు! MediLens కి స్వాగతం.',
      'hi': 'आप तैयार हैं! MediLens में आपका स्वागत है।',
      'ta': 'நீங்கள் தயார்! MediLens-க்கு வரவேற்கிறோம்.',
    };
    await provider
        .speak(welcomeTexts[provider.language] ?? welcomeTexts['en']!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goToHome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyUserSetup, true);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.teal.withOpacity(0.4),
                            blurRadius: 40,
                            spreadRadius: 10),
                      ],
                    ),
                    child: const Icon(Icons.check_circle,
                        size: 100, color: AppTheme.teal),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  _label('title', lang),
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _label('subtitle', lang),
                  style: const TextStyle(fontSize: 16, color: AppTheme.teal),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                _buildFeatureChip(Icons.camera_alt, _label('scan', lang)),
                const SizedBox(height: 12),
                _buildFeatureChip(Icons.volume_up, _label('audio', lang)),
                const SizedBox(height: 12),
                _buildFeatureChip(
                    Icons.warning_amber, _label('warnings', lang)),
                const SizedBox(height: 12),
                _buildFeatureChip(Icons.sos, _label('sos', lang)),
                const Spacer(),
                ElevatedButton(
                  onPressed: _goToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.teal,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(_label('start', lang),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.teal, size: 22),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(color: AppTheme.white, fontSize: 15)),
        ],
      ),
    );
  }
}
