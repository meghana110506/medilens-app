import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class MedicineInfoScreen extends StatefulWidget {
  const MedicineInfoScreen({super.key});

  @override
  State<MedicineInfoScreen> createState() => _MedicineInfoScreenState();
}

class _MedicineInfoScreenState extends State<MedicineInfoScreen> {
  bool _isPlaying = false;
  final Set<String> _selectedAudioLangs = {'en', 'te'};

  final Map<String, dynamic> _medicine = {
    'name': 'Metformin HCl',
    'generic': 'Metformin Hydrochloride 500mg',
    'confidence': 94,
    'dosage': {
      'en': '500mg — 1 tablet, twice daily',
      'te': '500mg — రోజుకు రెండుసార్లు 1 మాత్ర',
      'hi': '500mg — दिन में दो बार 1 गोली',
      'ta': '500mg — தினமும் இரண்டு முறை 1 மாத்திரை'
    },
    'frequency': {
      'en': 'Morning & Night, after meals',
      'te': 'ఉదయం & రాత్రి, భోజనం తర్వాత',
      'hi': 'सुबह और रात, खाने के बाद',
      'ta': 'காலை மற்றும் இரவு, உணவுக்குப் பிறகு'
    },
    'warnings': {
      'en': 'Avoid alcohol. Not for kidney disease.',
      'te': 'మద్యం నివారించండి. మూత్రపిండాల సమస్యలకు వద్దు.',
      'hi': 'शराब से बचें। गुर्दे की बीमारी में न लें।',
      'ta': 'மது அருந்தாதீர்கள். சிறுநீரக நோய்க்கு வேண்டாம்.'
    },
    'expiry': 'December 2026',
    'contraindications': {
      'en': 'Renal failure, hepatic impairment.',
      'te': 'మూత్రపిండ వైఫల్యం, కాలేయ సమస్యలు.',
      'hi': 'गुर्दे की विफलता, यकृत हानि।',
      'ta': 'சிறுநீரக செயலிழப்பு, கல்லீரல் பலவீனம்.'
    },
  };

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Medicine Info',
      'te': 'మందు వివరాలు',
      'hi': 'दवा की जानकारी',
      'ta': 'மருந்து தகவல்'
    },
    'scanned': {
      'en': 'Scanned 2 min ago',
      'te': '2 నిమిషాల క్రితం స్కాన్ చేయబడింది',
      'hi': '2 मिनट पहले स्कैन किया गया',
      'ta': '2 நிமிடங்களுக்கு முன் ஸ்கேன் செய்யப்பட்டது'
    },
    'confidence': {
      'en': 'Confidence',
      'te': 'నమ్మకం',
      'hi': 'विश्वास',
      'ta': 'நம்பகத்தன்மை'
    },
    'dosage': {
      'en': 'DOSAGE',
      'te': 'మోతాదు',
      'hi': 'खुराक',
      'ta': 'மருந்தளவு'
    },
    'frequency': {
      'en': 'FREQUENCY',
      'te': 'పౌనఃపున్యం',
      'hi': 'बारंबारता',
      'ta': 'அடிக்கடி'
    },
    'warnings': {
      'en': 'WARNINGS',
      'te': 'హెచ్చరికలు',
      'hi': 'चेतावनियां',
      'ta': 'எச்சரிக்கைகள்'
    },
    'expiry': {'en': 'EXPIRY', 'te': 'గడువు', 'hi': 'समाप्ति', 'ta': 'காலாவதி'},
    'contra': {
      'en': 'CONTRAINDICATIONS',
      'te': 'విరుద్ధ సూచనలు',
      'hi': 'विरोधाभास',
      'ta': 'முரண்பாடுகள்'
    },
    'valid': {
      'en': '✓ Valid',
      'te': '✓ చెల్లుబాటు',
      'hi': '✓ वैध',
      'ta': '✓ செல்லுபடியாகும்'
    },
    'audio_lang': {
      'en': '🔊 Audio Language',
      'te': '🔊 ఆడియో భాష',
      'hi': '🔊 ऑडियो भाषा',
      'ta': '🔊 ஆடியோ மொழி'
    },
    'select_all': {
      'en': 'Select all that apply',
      'te': 'వర్తించే అన్నీ ఎంచుకోండి',
      'hi': 'सभी लागू चुनें',
      'ta': 'பொருந்தும் அனைத்தையும் தேர்ந்தெடுக்கவும்'
    },
    'reminder': {
      'en': 'Reminder',
      'te': 'రిమైండర్',
      'hi': 'रिमाइंडर',
      'ta': 'நினைவூட்டல்'
    },
    'cabinet': {
      'en': 'Cabinet',
      'te': 'పెట్టె',
      'hi': 'कैबिनेट',
      'ta': 'பெட்டி'
    },
    'interactions': {
      'en': 'Interactions',
      'te': 'పరస్పర చర్యలు',
      'hi': 'परस्पर क्रियाएं',
      'ta': 'தொடர்புகள்'
    },
    'play_audio': {
      'en': '🔊 Play Audio Instructions',
      'te': '🔊 ఆడియో సూచనలు వినండి',
      'hi': '🔊 ऑडियो निर्देश सुनें',
      'ta': '🔊 ஆடியோ வழிமுறைகளை கேளுங்கள்'
    },
    'playing': {
      'en': '⏸ Playing...',
      'te': '⏸ ప్లే అవుతోంది...',
      'hi': '⏸ चल रहा है...',
      'ta': '⏸ இயங்குகிறது...'
    },
    'nav_home': {'en': 'Home', 'te': 'హోమ్', 'hi': 'होम', 'ta': 'முகப்பு'},
    'nav_scan': {'en': 'Scan', 'te': 'స్కాన్', 'hi': 'स्कैन', 'ta': 'ஸ்கேன்'},
    'nav_cabinet': {
      'en': 'Cabinet',
      'te': 'పెట్టె',
      'hi': 'कैबిनेట',
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
      'hi': 'सेटिंग்स',
      'ta': 'அமைப்புகள்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  String _medInfo(String key, String lang) {
    final val = _medicine[key];
    if (val is Map) return val[lang] ?? val['en'] ?? '';
    return val?.toString() ?? '';
  }

  Future<void> _playAudio(String lang) async {
    if (_isPlaying) {
      await context.read<LanguageProvider>().stopSpeaking();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isPlaying = true);

    final provider = context.read<LanguageProvider>();

    // Build full audio text
    final name = _medicine['name'];
    final dosage = _medInfo('dosage', lang);
    final frequency = _medInfo('frequency', lang);
    final warnings = _medInfo('warnings', lang);

    final audioText = lang == 'te'
        ? '$name. మోతాదు: $dosage. $frequency. హెచ్చరిక: $warnings'
        : lang == 'hi'
            ? '$name. खुराक: $dosage. $frequency. चेतावनी: $warnings'
            : lang == 'ta'
                ? '$name. மருந்தளவு: $dosage. $frequency. எச்சரிக்கை: $warnings'
                : '$name. Dosage: $dosage. $frequency. Warning: $warnings';

    await provider.speak(audioText);

    // Also speak in English if bilingual mode
    if (provider.bilingualEnabled && lang != 'en') {
      final enText =
          '${_medicine['name']}. Dosage: ${_medInfo('dosage', 'en')}. ${_medInfo('frequency', 'en')}. Warning: ${_medInfo('warnings', 'en')}';
      await provider.speakInLanguage(enText, 'en');
    }

    if (mounted) setState(() => _isPlaying = false);
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
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.scan),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: AppTheme.card,
                              borderRadius: BorderRadius.circular(8)),
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
                                fontSize: 16, fontWeight: FontWeight.bold),
                            LangText(
                                '${_label('scanned', lang)} · ${_medicine['confidence']}%',
                                lang,
                                fontSize: 11,
                                color: AppTheme.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                    child: Column(
                      children: [
                        // Drug hero card
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFF0E2550), Color(0xFF0D1E40)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF1E3A6A)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                      colors: [AppTheme.accent, AppTheme.teal]),
                                ),
                                child: const Center(
                                    child: Text('💊',
                                        style: TextStyle(fontSize: 22))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_medicine['name'],
                                        style: const TextStyle(
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(_medicine['generic'],
                                        style: const TextStyle(
                                            color: AppTheme.grey,
                                            fontSize: 12)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        LangText(
                                            _label('confidence', lang), lang,
                                            fontSize: 11, color: AppTheme.grey),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            child: LinearProgressIndicator(
                                              value:
                                                  _medicine['confidence'] / 100,
                                              backgroundColor: AppTheme.grey
                                                  .withValues(alpha: 0.2),
                                              valueColor:
                                                  const AlwaysStoppedAnimation(
                                                      AppTheme.teal),
                                              minHeight: 4,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text('${_medicine['confidence']}%',
                                            style: const TextStyle(
                                                color: AppTheme.teal,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Info cards
                        _infoCard('💊', _label('dosage', lang),
                            _medInfo('dosage', lang), AppTheme.accent, lang),
                        _infoCard('⏱', _label('frequency', lang),
                            _medInfo('frequency', lang), AppTheme.teal, lang),
                        _infoCard('⚠️', _label('warnings', lang),
                            _medInfo('warnings', lang), AppTheme.warning, lang),
                        _infoCard(
                            '📅',
                            _label('expiry', lang),
                            '${_medicine['expiry']}  ✓ Valid',
                            AppTheme.success,
                            lang),
                        _infoCard(
                            '🚫',
                            _label('contra', lang),
                            _medInfo('contraindications', lang),
                            AppTheme.error,
                            lang),
                        const SizedBox(height: 10),
                        // Audio language selector
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.grey.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  LangText(_label('audio_lang', lang), lang,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                  LangText(_label('select_all', lang), lang,
                                      fontSize: 11, color: AppTheme.grey),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _langChip('en', '🇬🇧 English', font),
                                  _langChip('te', '🇮🇳 తెలుగు', font),
                                  _langChip('hi', '🇮🇳 हिंदी', font),
                                  _langChip('ta', '🇮🇳 தமிழ்', font),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Action buttons
                        Row(
                          children: [
                            _actionBtn('🔔', _label('reminder', lang), lang,
                                () => context.go(AppRoutes.reminders)),
                            const SizedBox(width: 8),
                            _actionBtn('🗄️', _label('cabinet', lang), lang,
                                () => context.go(AppRoutes.cabinet)),
                            const SizedBox(width: 8),
                            _actionBtn('⚡', _label('interactions', lang), lang,
                                () => context.go(AppRoutes.interactionChecker)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Play audio button
                        GestureDetector(
                          onTap: () => _playAudio(lang),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: _isPlaying
                                  ? LinearGradient(colors: [
                                      AppTheme.grey.withValues(alpha: 0.3),
                                      AppTheme.grey.withValues(alpha: 0.2)
                                    ])
                                  : const LinearGradient(
                                      colors: [AppTheme.accent, AppTheme.teal]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: LangText(
                                _isPlaying
                                    ? _label('playing', lang)
                                    : _label('play_audio', lang),
                                lang,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                      true, () => context.go(AppRoutes.scan), font),
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
        ],
      ),
    );
  }

  Widget _infoCard(
      String emoji, String label, String value, Color color, String lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LangText(label, lang,
                    fontSize: 10,
                    color: AppTheme.grey,
                    fontWeight: FontWeight.w600),
                const SizedBox(height: 3),
                LangText(value, lang,
                    fontSize: 13, fontWeight: FontWeight.w500),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _langChip(String code, String label, String font) {
    final isSelected = _selectedAudioLangs.contains(code);
    return GestureDetector(
      onTap: () => setState(() {
        if (isSelected) {
          _selectedAudioLangs.remove(code);
        } else {
          _selectedAudioLangs.add(code);
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accent.withValues(alpha: 0.15)
              : AppTheme.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.accent
                : AppTheme.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(label,
            style: TextStyle(
              fontFamily: font,
              color: isSelected ? AppTheme.accent : AppTheme.grey,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            )),
      ),
    );
  }

  Widget _actionBtn(
      String emoji, String label, String lang, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              LangText(label, lang, fontSize: 11, color: AppTheme.grey),
            ],
          ),
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
