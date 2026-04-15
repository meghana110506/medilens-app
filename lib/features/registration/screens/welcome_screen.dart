import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/providers/language_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _selectedLanguage = 'en';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'flag': '🇬🇧', 'name': 'English', 'sub': 'Selected'},
    {'code': 'te', 'flag': '🇮🇳', 'name': 'తెలుగు', 'sub': 'Telugu'},
    {'code': 'hi', 'flag': '🇮🇳', 'name': 'हिंदी', 'sub': 'Hindi'},
    {'code': 'ta', 'flag': '🇮🇳', 'name': 'தமிழ்', 'sub': 'Tamil'},
  ];

  final Map<String, String> _getStarted = {
    'en': 'Get Started →',
    'te': 'ప్రారంభించండి →',
    'hi': 'शुरू करें →',
    'ta': 'தொடங்கு →',
  };

  final Map<String, String> _subtitle = {
    'en': 'Your offline AI medicine companion',
    'te': 'మీ ఆఫ్లైన్ AI మందుల సహాయకుడు',
    'hi': 'आपका ऑफलाइन AI दवा साथी',
    'ta': 'உங்கள் ஆஃப்லைன் AI மருந்து துணை',
  };

  final Map<String, String> _chooseLang = {
    'en': 'Choose Language / భాష ఎంచుకోండి',
    'te': 'భాష ఎంచుకోండి',
    'hi': 'भाषा चुनें',
    'ta': 'மொழியை தேர்ந்தெடுக்கவும்',
  };

  final Map<String, String> _privacy = {
    'en':
        '🔒 All app text, buttons, reminders and audio will be in your chosen language. You can change this later in Settings.',
    'te':
        '🔒 అన్ని యాప్ టెక్స్ట్, బటన్లు, రిమైండర్లు మరియు ఆడియో మీరు ఎంచుకున్న భాషలో ఉంటాయి.',
    'hi':
        '🔒 सभी ऐप टेक्स्ट, बटन, रिमाइंडर और ऑडियो आपकी चुनी हुई भाषा में होंगे।',
    'ta':
        '🔒 அனைத்து ஆப் உரை, பொத்தான்கள், நினைவூட்டல்கள் உங்கள் தேர்ந்தெடுத்த மொழியில் இருக்கும்.',
  };

  @override
  Widget build(BuildContext context) {
    final font = LanguageProvider.getFontFamily(_selectedLanguage);
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            children: [
              // Progress dots
              _progressDots(0),
              const SizedBox(height: 12),
              // Logo
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accent, AppTheme.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: AppTheme.accent.withValues(alpha: 0.4),
                        blurRadius: 24)
                  ],
                ),
                child: const Center(
                    child: Text('💊', style: TextStyle(fontSize: 36))),
              ),
              const SizedBox(height: 12),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppTheme.accent, AppTheme.teal],
                ).createShader(bounds),
                child: const Text('MediLens',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              const SizedBox(height: 6),
              Text(_subtitle[_selectedLanguage] ?? _subtitle['en']!,
                  style: TextStyle(
                      fontFamily: font, fontSize: 13, color: AppTheme.grey),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              // Choose Language label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      _chooseLang[_selectedLanguage] ?? _chooseLang['en']!,
                      style: TextStyle(
                          fontFamily: font,
                          fontSize: 11,
                          color: AppTheme.grey,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: 10),
              // Language grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.2,
                  children: _languages.map((lang) {
                    final isSelected = _selectedLanguage == lang['code'];
                    return GestureDetector(
                      onTap: () async {
                        setState(() => _selectedLanguage = lang['code']!);
                        await context
                            .read<LanguageProvider>()
                            .setLanguage(lang['code']!);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.accent.withValues(alpha: 0.1)
                              : AppTheme.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accent
                                : AppTheme.grey.withValues(alpha: 0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(lang['flag']!,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 4),
                            Text(lang['name']!,
                                style: TextStyle(
                                  fontFamily: LanguageProvider.getFontFamily(
                                      lang['code']!),
                                  color: isSelected
                                      ? AppTheme.accent
                                      : AppTheme.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                            if (isSelected)
                              Text('✓ Selected',
                                  style: const TextStyle(
                                      color: AppTheme.accent, fontSize: 10)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Privacy note
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.teal.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppTheme.teal.withValues(alpha: 0.2)),
                ),
                child: Text(_privacy[_selectedLanguage] ?? _privacy['en']!,
                    style: TextStyle(
                        fontFamily: font,
                        fontSize: 12,
                        color: AppTheme.grey,
                        height: 1.5)),
              ),
              const SizedBox(height: 16),
              // Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.personalDetails),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppTheme.accent, AppTheme.teal]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                          _getStarted[_selectedLanguage] ?? _getStarted['en']!,
                          style: TextStyle(
                              fontFamily: font,
                              color: AppTheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Step 1 of 5',
                  style: const TextStyle(color: AppTheme.grey, fontSize: 12)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressDots(int active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: List.generate(
            5,
            (i) => Expanded(
                  flex: i == active ? 2 : 1,
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: i < active
                          ? AppTheme.teal
                          : i == active
                              ? AppTheme.accent
                              : AppTheme.card,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
      ),
    );
  }
}
