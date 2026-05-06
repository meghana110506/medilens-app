import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/providers/language_provider.dart';
import 'package:medilens/core/widgets/sos_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, Map<String, String>> _labels = {
    'banner_tag': {
      'en': 'AI · Offline · Safe',
      'te': 'AI · ఆఫ్లైన్ · సురక్షితం',
      'hi': 'AI · ऑफलाइन · सुरक्षित',
      'ta': 'AI · ஆஃப்லைன் · பாதுகாப்பு'
    },
    'banner_title': {
      'en': 'Scan any medicine label instantly',
      'te': 'ఏ మందు లేబుల్ అయినా వెంటనే స్కాన్ చేయండి',
      'hi': 'किसी भी दवा लेबल को तुरंत स्कैन करें',
      'ta': 'எந்த மருந்து லேபலையும் உடனே ஸ்கேன் செய்யுங்கள்'
    },
    'banner_sub': {
      'en': 'Works offline · Audio readout',
      'te': 'ఆఫ్లైన్ లో పని చేస్తుంది · ఆడియో',
      'hi': 'ऑफलाइन काम करता है · ऑडियो',
      'ta': 'ஆஃப்லைனில் வேலை செய்கிறது'
    },
    'scan_now': {
      'en': 'Scan Now',
      'te': 'ఇప్పుడు స్కాన్',
      'hi': 'अभी स्कैन करें',
      'ta': 'இப்போது ஸ்கேன்'
    },
    'quick_access': {
      'en': 'Quick Access',
      'te': 'శీఘ్ర యాక్సెస్',
      'hi': 'त्वरित पहुंच',
      'ta': 'விரைவு அணுகல்'
    },
    'cabinet': {
      'en': 'Medicine Cabinet',
      'te': 'మందుల పెట్టె',
      'hi': 'दवा कैबिनेट',
      'ta': 'மருந்து பெட்டி'
    },
    'cabinet_sub': {
      'en': '0 saved',
      'te': '0 సేవ్ చేయబడ్డాయి',
      'hi': '0 सहेजी गई',
      'ta': '0 சேமிக்கப்பட்டது'
    },
    'reminders': {
      'en': 'My Reminders',
      'te': 'నా రిమైండర్లు',
      'hi': 'मेरे रिमाइंडर',
      'ta': 'என் நினைவூட்டல்கள்'
    },
    'reminders_sub': {
      'en': '0 due today',
      'te': 'ఈరోజు 0 ఉన్నాయి',
      'hi': 'आज 0 बकाया',
      'ta': 'இன்று 0 உள்ளன'
    },
    'expiry': {
      'en': 'Expiry Tracker',
      'te': 'గడువు ట్రాకర్',
      'hi': 'समाप्ति ट्रैकर',
      'ta': 'காலாவதி கண்காணிப்பு'
    },
    'expiry_sub': {
      'en': '0 expiring soon',
      'te': '0 త్వరలో గడువు',
      'hi': '0 जल्द समाप्त',
      'ta': '0 விரைவில் காலாவதி'
    },
    'interaction': {
      'en': 'Drug Interaction',
      'te': 'మందుల పరస్పర చర్య',
      'hi': 'दवा परस्पर क्रिया',
      'ta': 'மருந்து தொடர்பு'
    },
    'interaction_sub': {
      'en': 'Check compatibility',
      'te': 'అనుకూలత తనిఖీ',
      'hi': 'अनुकूलता जांचें',
      'ta': 'இணக்கம் சரிபார்'
    },
    'tip': {
      'en': 'Daily Tip',
      'te': 'రోజువారీ చిట్కా',
      'hi': 'दैनिक सुझाव',
      'ta': 'தினசரி குறிப்பு'
    },
    'tip_text': {
      'en': 'Always take medicines at the same time each day for best results.',
      'te': 'ఉత్తమ ఫలితాల కోసం ప్రతిరోజూ అదే సమయంలో మందులు తీసుకోండి.',
      'hi': 'सर्वोत्तम परिणामों के लिए हर दिन एक ही समय पर दवाएं लें।',
      'ta':
          'சிறந்த முடிவுகளுக்கு ஒவ்வொரு நாளும் ஒரே நேரத்தில் மருந்துகளை எடுங்கள்.'
    },
    'nav_home': {'en': 'Home', 'te': 'హోమ్', 'hi': 'होम', 'ta': 'முகப்பு'},
    'nav_scan': {'en': 'Scan', 'te': 'స్కాన్', 'hi': 'स्कैन', 'ta': 'ஸ்கேன்'},
    'nav_cabinet': {
      'en': 'Cabinet',
      'te': 'పెట్టె',
      'hi': 'कैबिनेट',
      'ta': 'பெட்டி'
    },
    'nav_reminders': {
      'en': 'Reminders',
      'te': 'రిమైండర్లు',
      'hi': 'रिमाइंडर',
      'ta': 'நினைவூட்டல்'
    },
    'nav_settings': {
      'en': 'Settings',
      'te': 'సెట్టింగులు',
      'hi': 'सेटिंग்స',
      'ta': 'அமைப்புகள்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    final lang = provider.language;
    final font = LanguageProvider.getFontFamily(lang);
    final fontSize = provider.fontSize;

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: const SOSFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.medication,
                            color: AppTheme.accent, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Text('MediLens',
                          style: TextStyle(
                              fontSize: fontSize + 2,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.settings),
                        child: const Icon(Icons.settings,
                            color: AppTheme.white, size: 24),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 90),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0E2550), Color(0xFF0D1E40)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF1E3A6A)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.accent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: AppTheme.accent
                                          .withValues(alpha: 0.4)),
                                ),
                                child: Text(_label('banner_tag', lang),
                                    style: TextStyle(
                                        fontFamily: font,
                                        color: AppTheme.accent,
                                        fontSize: fontSize - 3,
                                        fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(height: 6),
                              Text(_label('banner_title', lang),
                                  style: TextStyle(
                                      fontFamily: font,
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.white)),
                              const SizedBox(height: 3),
                              Text(_label('banner_sub', lang),
                                  style: TextStyle(
                                      fontFamily: font,
                                      fontSize: fontSize - 3,
                                      color: AppTheme.grey)),
                            ],
                          ),
                        ),
                        // Round Scan Button
                        Center(
                          child: GestureDetector(
                            onTap: () => context.go(AppRoutes.scan),
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [AppTheme.accent, AppTheme.teal],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppTheme.accent
                                          .withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      spreadRadius: 4),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.qr_code_scanner,
                                      color: AppTheme.white, size: 28),
                                  const SizedBox(height: 4),
                                  Text(_label('scan_now', lang),
                                      style: TextStyle(
                                          fontFamily: font,
                                          color: AppTheme.white,
                                          fontSize: fontSize - 5,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Quick Access title
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
                          child: Text(_label('quick_access', lang),
                              style: TextStyle(
                                  fontFamily: font,
                                  color: AppTheme.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8)),
                        ),
                        // Quick cards row 1
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              _quickCard(
                                  icon: '💊',
                                  color: AppTheme.accent,
                                  title: _label('cabinet', lang),
                                  subtitle: _label('cabinet_sub', lang),
                                  lang: lang,
                                  fontSize: fontSize,
                                  onTap: () => context.go(AppRoutes.cabinet)),
                              const SizedBox(width: 8),
                              _quickCard(
                                  icon: '🔔',
                                  color: AppTheme.teal,
                                  title: _label('reminders', lang),
                                  subtitle: _label('reminders_sub', lang),
                                  lang: lang,
                                  fontSize: fontSize,
                                  onTap: () => context.go(AppRoutes.reminders)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Quick cards row 2
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              _quickCard(
                                  icon: '📅',
                                  color: const Color(0xFF9C27B0),
                                  title: _label('expiry', lang),
                                  subtitle: _label('expiry_sub', lang),
                                  lang: lang,
                                  fontSize: fontSize,
                                  onTap: () =>
                                      context.go(AppRoutes.expiryTracker)),
                              const SizedBox(width: 8),
                              _quickCard(
                                  icon: '⚡',
                                  color: const Color(0xFFE91E63),
                                  title: _label('interaction', lang),
                                  subtitle: _label('interaction_sub', lang),
                                  lang: lang,
                                  fontSize: fontSize,
                                  onTap: () =>
                                      context.go(AppRoutes.interactionChecker)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Daily tip
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.warning.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb,
                                  color: AppTheme.warning, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_label('tip', lang),
                                        style: TextStyle(
                                            fontFamily: font,
                                            color: AppTheme.warning,
                                            fontSize: fontSize - 2,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(_label('tip_text', lang),
                                        style: TextStyle(
                                            fontFamily: font,
                                            color: AppTheme.grey,
                                            fontSize: fontSize - 3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SOS FAB
          Positioned(
            bottom: 80,
            right: 14,
            child: _SOSButton(onTap: () => context.go(AppRoutes.sos)),
          ),
          // Bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.card,
                border: Border(
                    top: BorderSide(
                        color: AppTheme.grey.withValues(alpha: 0.2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home, _label('nav_home', lang), true, null,
                      font, fontSize),
                  _navItem(Icons.qr_code_scanner, _label('nav_scan', lang),
                      false, () => context.go(AppRoutes.scan), font, fontSize),
                  _navItem(
                      Icons.medical_services,
                      _label('nav_cabinet', lang),
                      false,
                      () => context.go(AppRoutes.cabinet),
                      font,
                      fontSize),
                  _navItem(Icons.alarm, _label('nav_reminders', lang), false,
                      () => context.go(AppRoutes.reminders), font, fontSize),
                  _navItem(Icons.settings, _label('nav_settings', lang), false,
                      () => context.go(AppRoutes.settings), font, fontSize),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickCard(
      {required String icon,
      required Color color,
      required String title,
      required String subtitle,
      required String lang,
      required double fontSize,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 16))),
              ),
              const SizedBox(height: 8),
              Text(title,
                  style: TextStyle(
                      fontFamily: LanguageProvider.getFontFamily(lang),
                      color: AppTheme.white,
                      fontSize: fontSize - 2,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: TextStyle(
                      fontFamily: LanguageProvider.getFontFamily(lang),
                      color: AppTheme.grey,
                      fontSize: fontSize - 4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive,
      VoidCallback? onTap, String font, double fontSize) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isActive ? AppTheme.accent : AppTheme.grey, size: 26),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                  fontFamily: font,
                  color: isActive ? AppTheme.accent : AppTheme.grey,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}

class _SOSButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SOSButton({required this.onTap});

  @override
  State<_SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<_SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.93, end: 1.07)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.error.withValues(alpha: 0.5),
                  blurRadius: 14,
                  spreadRadius: 2),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🆘', style: TextStyle(fontSize: 20)),
              Text('SOS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }
}
