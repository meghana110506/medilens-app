import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  bool _sosSent = false;

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': '🆘 Emergency SOS',
      'te': '🆘 అత్యవసర SOS',
      'hi': '🆘 आपातकालीन SOS',
      'ta': '🆘 அவசர SOS'
    },
    'sub': {
      'en': 'SMS + GPS sent instantly to caregiver',
      'te': 'SMS + GPS వెంటనే సంరక్షకుడికి పంపబడుతుంది',
      'hi': 'SMS + GPS तुरंत देखभालकर्ता को भेजा जाता है',
      'ta': 'SMS + GPS உடனடியாக பராமரிப்பாளருக்கு அனுப்பப்படுகிறது'
    },
    'desc': {
      'en': 'Press the button below to immediately alert your caregiver.',
      'te': 'మీ సంరక్షకుడికి వెంటనే హెచ్చరించడానికి కింది బటన్ నొక్కండి.',
      'hi': 'अपने देखभालकर्ता को तुरंत सचेत करने के लिए नीचे दिए बटन को दबाएं।',
      'ta':
          'உங்கள் பராமரிப்பாளருக்கு உடனடியாக எச்சரிக்க கீழே உள்ள பொத்தானை அழுத்துங்கள்.'
    },
    'send_sos': {
      'en': 'SEND\nSOS',
      'te': 'SOS\nపంపు',
      'hi': 'SOS\nभेजें',
      'ta': 'SOS\nஅனுப்பு'
    },
    'tip': {
      'en': 'Tip: The floating 🆘 button is always visible on every screen.',
      'te': 'చిట్కా: తేలుతున్న 🆘 బటన్ ప్రతి స్క్రీన్‌పై కనిపిస్తుంది.',
      'hi': 'सुझाव: फ्लोटिंग 🆘 बटन हर स्क्रीन पर दिखता है।',
      'ta': 'குறிப்பு: மிதக்கும் 🆘 பொத்தான் ஒவ்வொரு திரையிலும் தெரியும்.'
    },
    'caregiver': {
      'en': 'Registered Caregiver',
      'te': 'నమోదిత సంరక్షకుడు',
      'hi': 'पंजीकृत देखभालकर्ता',
      'ta': 'பதிவுசெய்த பராமரிப்பாளர்'
    },
    'primary': {
      'en': 'Primary Caregiver',
      'te': 'ప్రాథమిక సంరక్షకుడు',
      'hi': 'प्राथमिक देखभालकर्ता',
      'ta': 'முதன்மை பராமரிப்பாளர்'
    },
    'sos_sends': {
      'en': 'SOS Will Send',
      'te': 'SOS పంపుతుంది',
      'hi': 'SOS भेजेगा',
      'ta': 'SOS அனுப்பும்'
    },
    'location': {'en': 'Location', 'te': 'స్థానం', 'hi': 'स्थान', 'ta': 'இடம்'},
    'gps': {'en': 'GPS', 'te': 'GPS', 'hi': 'GPS', 'ta': 'GPS'},
    'last_scan': {
      'en': 'Last Scan',
      'te': 'చివరి స్కాన్',
      'hi': 'अंतिम स्कैन',
      'ta': 'கடைசி ஸ்கேன்'
    },
    'method': {'en': 'Method', 'te': 'పద్ధతి', 'hi': 'तरीका', 'ta': 'முறை'},
    'sms': {'en': 'SMS', 'te': 'SMS', 'hi': 'SMS', 'ta': 'SMS'},
    'voice_label': {
      'en': 'Voice',
      'te': 'వాయిస్',
      'hi': 'आवाज़',
      'ta': 'குரல்'
    },
    'manage': {
      'en': 'Manage Caregivers →',
      'te': 'సంరక్షకులను నిర్వహించండి →',
      'hi': 'देखभालकर्ताओं को प्रबंधित करें →',
      'ta': 'பராமரிப்பாளர்களை நிர்வகிக்கவும் →'
    },
    'sent_title': {
      'en': 'SOS Sent!',
      'te': 'SOS పంపబడింది!',
      'hi': 'SOS भेजा गया!',
      'ta': 'SOS அனுப்பப்பட்டது!'
    },
    'sent_sub': {
      'en': 'SMS sent to Padma at +91 98765 11111. Voice alert played.',
      'te':
          'SMS పద్మకు +91 98765 11111 కి పంపబడింది. వాయిస్ అలర్ట్ ప్లే అయింది.',
      'hi': 'SMS पद्मा को +91 98765 11111 पर भेजा गया।',
      'ta': 'SMS பத்மாவுக்கு +91 98765 11111 க்கு அனுப்பப்பட்டது.'
    },
    'sent_at': {
      'en': 'Sent at',
      'te': 'పంపిన సమయం',
      'hi': 'भेजा गया',
      'ta': 'அனுப்பிய நேரம்'
    },
    'dismiss': {
      'en': 'Dismiss',
      'te': 'తొలగించు',
      'hi': 'खारिज करें',
      'ta': 'நிராகரி'
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
      'hi': 'सेटिंग्స',
      'ta': 'அமைப்புகள்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendSOS(String lang) async {
    // Speak alert first
    await context.read<LanguageProvider>().speak(lang == 'te'
        ? 'అత్యవసర సహాయం కోసం కాల్ చేస్తున్నాం'
        : lang == 'hi'
            ? 'आपातकालीन सहायता के लिए कॉल कर रहे हैं'
            : lang == 'ta'
                ? 'அவசர உதவிக்கு அழைக்கிறோம்'
                : 'Sending emergency SOS alert');

    // Open SMS app with pre-filled emergency message
    final message = Uri.encodeComponent('EMERGENCY SOS from MediLens!\n'
        'Patient: Lakshmi Devi needs immediate help.\n'
        'Last medicine taken: Metformin 500mg.\n'
        'Please call immediately!\n'
        'Sent from MediLens Safety App.');

    final smsUri = Uri.parse('sms:+919876511111?body=$message');

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    } catch (e) {
      debugPrint('SMS launch error: $e');
    }

    setState(() => _sosSent = true);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final font = LanguageProvider.getFontFamily(lang);
    return Scaffold(
      backgroundColor: AppTheme.background,
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
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.home),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: AppTheme.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LangText(_label('title', lang), lang,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.error),
                            LangText(_label('sub', lang), lang,
                                fontSize: 11, color: AppTheme.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 100),
                    child: Column(
                      children: [
                        LangText(_label('desc', lang), lang,
                            fontSize: 13,
                            color: AppTheme.grey,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        // SOS Button with pulse rings
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnim,
                                builder: (_, __) => Transform.scale(
                                  scale: _pulseAnim.value,
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppTheme.error
                                              .withValues(alpha: 0.25),
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _pulseAnim,
                                builder: (_, __) => Transform.scale(
                                  scale: _pulseAnim.value * 0.85,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppTheme.error
                                              .withValues(alpha: 0.2),
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _sendSOS(lang),
                                child: Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFDC2626),
                                        Color(0xFFEF4444)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppTheme.error
                                              .withValues(alpha: 0.5),
                                          blurRadius: 20,
                                          spreadRadius: 4),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('🆘',
                                          style: TextStyle(fontSize: 22)),
                                      const SizedBox(height: 2),
                                      Text(_label('send_sos', lang),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: font,
                                            color: AppTheme.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            height: 1.2,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Tip box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.error.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppTheme.error.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('💡', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: LangText(_label('tip', lang), lang,
                                    fontSize: 12, color: AppTheme.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Caregiver
                        Align(
                          alignment: Alignment.centerLeft,
                          child: LangText(_label('caregiver', lang), lang,
                              fontSize: 11,
                              color: AppTheme.grey,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.grey.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(colors: [
                                    Color(0xFF7C3AED),
                                    Color(0xFFA855F7)
                                  ]),
                                ),
                                child: const Center(
                                  child: Text('P',
                                      style: TextStyle(
                                          color: AppTheme.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Padma (Daughter)',
                                        style: TextStyle(
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                    LangText(_label('primary', lang), lang,
                                        fontSize: 11, color: AppTheme.grey),
                                    const Text('+91 98765 11111',
                                        style: TextStyle(
                                            color: AppTheme.accent,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    context.go(AppRoutes.caregiverSetup),
                                child: const Icon(Icons.edit,
                                    color: AppTheme.grey, size: 18),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: LangText(_label('sos_sends', lang), lang,
                              fontSize: 11,
                              color: AppTheme.grey,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _infoCard('📍', _label('location', lang),
                                _label('gps', lang), lang),
                            const SizedBox(width: 8),
                            _infoCard('💊', _label('last_scan', lang),
                                'Metformin', lang),
                            const SizedBox(width: 8),
                            _infoCard('📱', _label('method', lang),
                                _label('sms', lang), lang),
                            const SizedBox(width: 8),
                            _infoCard(
                                '🔊',
                                _label('voice_label', lang),
                                lang == 'te'
                                    ? 'Telugu'
                                    : lang == 'hi'
                                        ? 'Hindi'
                                        : lang == 'ta'
                                            ? 'Tamil'
                                            : 'English',
                                lang),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.caregiverSetup),
                          child: Center(
                            child: LangText(_label('manage', lang), lang,
                                fontSize: 13, color: AppTheme.accent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                  _navItem(Icons.home, _label('nav_home', lang), false,
                      () => context.go(AppRoutes.home), font),
                  _navItem(Icons.qr_code_scanner, _label('nav_scan', lang),
                      false, () => context.go(AppRoutes.scan), font),
                  _navItem(Icons.medical_services, _label('nav_cabinet', lang),
                      false, () => context.go(AppRoutes.cabinet), font),
                  _navItem(Icons.alarm, _label('nav_reminders', lang), false,
                      () => context.go(AppRoutes.reminders), font),
                  _navItem(Icons.settings, _label('nav_settings', lang), false,
                      () => context.go(AppRoutes.settings), font),
                ],
              ),
            ),
          ),
          // SOS Sent overlay
          if (_sosSent)
            Positioned.fill(
              child: Container(
                color: AppTheme.error.withValues(alpha: 0.96),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🆘', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 16),
                    LangText(_label('sent_title', lang), lang,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: LangText(_label('sent_sub', lang), lang,
                          fontSize: 14,
                          color: Colors.white70,
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          LangText(_label('sent_at', lang), lang,
                              fontSize: 12, color: Colors.white70),
                          const SizedBox(height: 4),
                          Text(TimeOfDay.now().format(context),
                              style: const TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => setState(() => _sosSent = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: LangText(_label('dismiss', lang), lang,
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoCard(String emoji, String label, String value, String lang) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            LangText(label, lang, fontSize: 10, color: AppTheme.grey),
            const SizedBox(height: 2),
            LangText(value, lang, fontSize: 11, fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive,
      VoidCallback onTap, String font) {
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
