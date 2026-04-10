import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  String _selectedLanguage = 'en';

  final List<Map<String, String>> _languages = [
    {
      'code': 'en',
      'native': 'English',
      'welcome': 'Welcome to MediLens',
      'sub': 'Scan medicines, get instant info'
    },
    {
      'code': 'te',
      'native': 'తెలుగు',
      'welcome': 'MediLens కి స్వాగతం',
      'sub': 'మందులు స్కాన్ చేసి సమాచారం పొందండి'
    },
    {
      'code': 'hi',
      'native': 'हिंदी',
      'welcome': 'MediLens में आपका स्वागत है',
      'sub': 'दवाएं स्कैन करें, जानकारी पाएं'
    },
    {
      'code': 'ta',
      'native': 'தமிழ்',
      'welcome': 'MediLens-க்கு வரவேற்கிறோம்',
      'sub': 'மருந்துகளை ஸ்கேன் செய்து தகவல் பெறுங்கள்'
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, String> get _currentLang =>
      _languages.firstWhere((l) => l['code'] == _selectedLanguage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                // Logo
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withOpacity(0.4),
                        blurRadius: 40,
                        spreadRadius: 8,
                      )
                    ],
                  ),
                  child: const Icon(Icons.medication_rounded,
                      size: 80, color: AppTheme.accent),
                ),
                const SizedBox(height: 40),

                // Dynamic Welcome Text
                Text(
                  _currentLang['welcome']!,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _currentLang['sub']!,
                  style: const TextStyle(fontSize: 16, color: AppTheme.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Language Selection
                const Text('Choose your language • భాష ఎంచుకోండి',
                    style: TextStyle(fontSize: 13, color: AppTheme.grey)),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: _languages
                      .map((lang) => GestureDetector(
                            onTap: () async {
                              setState(() => _selectedLanguage = lang['code']!);
                              await context
                                  .read<LanguageProvider>()
                                  .setLanguage(lang['code']!);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selectedLanguage == lang['code']
                                    ? AppTheme.accent
                                    : AppTheme.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedLanguage == lang['code']
                                      ? AppTheme.accent
                                      : AppTheme.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Center(
                                child: Text(lang['native']!,
                                    style: TextStyle(
                                      color: _selectedLanguage == lang['code']
                                          ? AppTheme.white
                                          : AppTheme.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const Spacer(),

                // Features
                _featureRow(Icons.camera_alt, 'Scan Medicine Labels',
                    'మందు లేబుల్స్ స్కాన్'),
                const SizedBox(height: 12),
                _featureRow(Icons.volume_up, '4 Language Audio Support',
                    '4 భాషల ఆడియో సపోర్ట్'),
                const SizedBox(height: 12),
                _featureRow(Icons.wifi_off, 'Works Offline',
                    'ఆఫ్లైన్ లో పని చేస్తుంది'),
                const Spacer(),

                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.personalDetails),
                  child: const Text(
                      'Get Started • ప్రారంభించండి • शुरू करें • தொடங்கு'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String english, String local) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppTheme.teal, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(english,
                  style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
              Text(local,
                  style: const TextStyle(color: AppTheme.grey, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}
