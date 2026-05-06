import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class AllSetScreen extends StatefulWidget {
  const AllSetScreen({super.key});

  @override
  State<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends State<AllSetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': "You're all set!",
      'te': 'మీరు సిద్ధంగా ఉన్నారు!',
      'hi': 'आप तैयार हैं!',
      'ta': 'நீங்கள் தயாராக உள்ளீர்கள்!'
    },
    'sub': {
      'en': 'MediLens is ready to help you manage your medicines safely.',
      'te': 'MediLens మీ మందులను సురక్షితంగా నిర్వహించడానికి సిద్ధంగా ఉంది.',
      'hi':
          'MediLens आपकी दवाओं को सुरक्षित रूप से प्रबंधित करने के लिए तैयार है।',
      'ta': 'MediLens உங்கள் மருந்துகளை பாதுகாப்பாக நிர்வகிக்க தயாராக உள்ளது.'
    },
    'summary': {
      'en': 'Your Profile Summary',
      'te': 'మీ ప్రొఫైల్ సారాంశం',
      'hi': 'आपकी प्रोफ़ाइल सारांश',
      'ta': 'உங்கள் சுயவிவர சுருக்கம்'
    },
    'sos': {
      'en': 'SOS Emergency Contact',
      'te': 'SOS అత్యవసర సంప్రదింపు',
      'hi': 'SOS आपातकालीन संपर्क',
      'ta': 'SOS அவசர தொடர்பு'
    },
    'go_home': {
      'en': '🏠 Go to Home →',
      'te': '🏠 హోమ్ కి వెళ్ళండి →',
      'hi': '🏠 होम पर जाएं →',
      'ta': '🏠 முகப்புக்கு செல்லுங்கள் →'
    },
    'no_register': {
      'en': "You won't need to register again",
      'te': 'మీరు మళ్ళీ నమోదు చేసుకోవాల్సిన అవసరం లేదు',
      'hi': 'आपको दोबारा पंजीकरण करने की आवश्यकता नहीं',
      'ta': 'நீங்கள் மீண்டும் பதிவு செய்ய வேண்டியதில்லை'
    },
    'yrs': {'en': 'yrs', 'te': 'సంవత్సరాలు', 'hi': 'वर्ष', 'ta': 'வயது'},
    'reminders_on': {
      'en': 'Reminders ON',
      'te': 'రిమైండర్లు ఆన్',
      'hi': 'रिमाइंडर चालू',
      'ta': 'நினైவூட்டல்கள் ON'
    },
    'not_set': {
      'en': 'Not set yet',
      'te': 'ఇంకా సెట్ చేయలేదు',
      'hi': 'अभी सेट नहीं',
      'ta': 'இன்னும் அமைக்கவில்லை'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    final lang = provider.language;

    final name = provider.userName.isEmpty ? 'Your Name' : provider.userName;
    final age = provider.userAge;
    final city = provider.userCity.isEmpty ? 'Your City' : provider.userCity;
    final blood = provider.userBlood;
    final gender = provider.userGender;
    final langName = LanguageProvider.languageNames[lang] ?? 'English';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
          child: Column(
            children: [
              _progressDots(),
              const SizedBox(height: 20),
              // Success icon
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.success, Color(0xFF16A34A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.success.withValues(alpha: 0.4),
                          blurRadius: 24,
                          spreadRadius: 4)
                    ],
                  ),
                  child:
                      const Icon(Icons.check, color: AppTheme.white, size: 44),
                ),
              ),
              const SizedBox(height: 16),
              LangText(_label('title', lang), lang,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              LangText(_label('sub', lang), lang,
                  fontSize: 13,
                  color: AppTheme.grey,
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),

              // Profile summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LangText(_label('summary', lang), lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 12),
                    // Profile row
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.userPhoto.isNotEmpty
                                ? Color(int.tryParse(provider.userPhoto) ??
                                    AppTheme.accent.toARGB32())
                                : AppTheme.accent,
                          ),
                          child: Center(
                            child: Text(
                              provider.userName.isNotEmpty
                                  ? provider.userName[0].toUpperCase()
                                  : '👤',
                              style: TextStyle(
                                fontSize:
                                    provider.userName.isNotEmpty ? 20 : 22,
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$name, $age ${_label('yrs', lang)}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.white)),
                              Text('$city · $blood · $gender',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppTheme.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _pill(langName, AppTheme.accent),
                        _pill(_label('reminders_on', lang), AppTheme.success),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // SOS contact
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.error.withValues(alpha: 0.15)),
                      ),
                      child: Row(
                        children: [
                          const Text('🆘', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LangText(_label('sos', lang), lang,
                                    fontSize: 12, fontWeight: FontWeight.w600),
                                LangText(_label('not_set', lang), lang,
                                    fontSize: 11, color: AppTheme.grey),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                context.go('${AppRoutes.caregiversManage}?from=allset'),
                            child: const Icon(Icons.edit,
                                color: AppTheme.grey, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => context.go(AppRoutes.home),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppTheme.accent, AppTheme.teal]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: LangText(_label('go_home', lang), lang,
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              LangText(_label('no_register', lang), lang,
                  fontSize: 12,
                  color: AppTheme.grey,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressDots() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
      child: Row(
        children: List.generate(
            5,
            (i) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.teal,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
