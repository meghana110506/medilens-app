import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/constants.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _remindersEnabled = true;
  bool _expiryAlertsEnabled = true;
  bool _bilingualAudio = true;
  bool _voiceReminders = true;

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Settings',
      'te': 'సెట్టింగులు',
      'hi': 'सेटिंग्स',
      'ta': 'அமைப்புகள்'
    },
    'profile': {
      'en': 'Your Profile',
      'te': 'మీ ప్రొఫైల్',
      'hi': 'आपकी प्रोफ़ाइल',
      'ta': 'உங்கள் சுயவிவரம்'
    },
    'edit': {
      'en': 'Edit',
      'te': 'సవరించు',
      'hi': 'संपादित करें',
      'ta': 'திருத்து'
    },
    'ui_lang': {
      'en': 'App Interface Language',
      'te': 'యాప్ ఇంటర్ఫేస్ భాష',
      'hi': 'ऐप इंटरफ़ेस भाषा',
      'ta': 'ஆப் இடைமுக மொழி'
    },
    'interface_lang': {
      'en': 'Interface Language',
      'te': 'ఇంటర్ఫేస్ భాష',
      'hi': 'इंटरफ़ेस भाषा',
      'ta': 'இடைமுக மொழி'
    },
    'audio_lang': {
      'en': 'Audio / Voice Language',
      'te': 'ఆడియో / వాయిస్ భాష',
      'hi': 'ऑडियो / आवाज़ भाषा',
      'ta': 'ஆடியோ / குரல் மொழி'
    },
    'audio_lang_desc': {
      'en': 'Select all languages for bilingual voice readout',
      'te': 'ద్విభాష వాయిస్ రీడవుట్ కోసం అన్ని భాషలు ఎంచుకోండి',
      'hi': 'द्विभाषी वॉयस रीडआउट के लिए सभी भाषाएं चुनें',
      'ta': 'இரு மொழி குரல் வாசிப்புக்கு அனைத்து மொழிகளையும் தேர்ந்தெடுக்கவும்'
    },
    'voice_speed': {
      'en': 'TTS Voice Speed',
      'te': 'TTS వాయిస్ వేగం',
      'hi': 'TTS आवाज़ की गति',
      'ta': 'TTS குரல் வேகம்'
    },
    'speed_label': {
      'en': 'Voice Speed',
      'te': 'వాయిస్ వేగం',
      'hi': 'आवाज़ की गति',
      'ta': 'குரல் வேகம்'
    },
    'normal': {'en': 'Normal', 'te': 'సాధారణ', 'hi': 'सामान्य', 'ta': 'சாதாரண'},
    'safety': {
      'en': 'Safety',
      'te': 'భద్రత',
      'hi': 'सुरक्षा',
      'ta': 'பாதுகாப்பு'
    },
    'confidence': {
      'en': 'Confidence Threshold',
      'te': 'నమ్మకం పరిమితి',
      'hi': 'विश्वास सीमा',
      'ta': 'நம்பகத்தன்மை வரம்பு'
    },
    'data': {'en': 'Data', 'te': 'డేటా', 'hi': 'डेटा', 'ta': 'தரவு'},
    'db': {
      'en': 'Offline Drug Database',
      'te': 'ఆఫ్లైన్ మందుల డేటాబేస్',
      'hi': 'ऑफलाइन दवा डेटाबेस',
      'ta': 'ஆஃப்லைன் மருந்து தரவுத்தளம்'
    },
    'caregivers': {
      'en': 'Manage Caregivers',
      'te': 'సంరక్షకులను నిర్వహించండి',
      'hi': 'देखभाल करने वालों को प्रबंधित करें',
      'ta': 'பராமரிப்பாளர்களை நிர்வகிக்கவும்'
    },
    'bilingual': {
      'en': 'Bilingual Audio',
      'te': 'ద్విభాష ఆడియో',
      'hi': 'द्विभाषी ऑडियो',
      'ta': 'இரு மொழி ஆடியோ'
    },
    'bilingual_sub': {
      'en': 'Speak in your language + English',
      'te': 'మీ భాషలో + ఆంగ్లంలో మాట్లాడండి',
      'hi': 'आपकी भाषा + अंग्रेजी में बोलें',
      'ta': 'உங்கள் மொழி + ஆங்கிலத்தில் பேசுங்கள்'
    },
    'voice_rem': {
      'en': 'Voice Reminders',
      'te': 'వాయిస్ రిమైండర్లు',
      'hi': 'वॉयस रिमाइंडर',
      'ta': 'குரல் நினைவூட்டல்கள்'
    },
    'voice_rem_sub': {
      'en': 'Speak medicine name at reminder time',
      'te': 'రిమైండర్ సమయంలో మందు పేరు చెప్పండి',
      'hi': 'रिमाइंडर के समय दवा का नाम बोलें',
      'ta': 'நினைவூட்டல் நேரத்தில் மருந்தின் பெயரை சொல்லுங்கள்'
    },
    'test_voice': {
      'en': 'Test Voice',
      'te': 'వాయిస్ పరీక్ష',
      'hi': 'आवाज़ परीक्षण',
      'ta': 'குரல் சோதனை'
    },
    'reset': {
      'en': 'Reset App',
      'te': 'యాప్ రీసెట్',
      'hi': 'ऐप रीसेट करें',
      'ta': 'ஆப்பை மீட்டமை'
    },
    'reset_confirm': {
      'en': 'Are you sure? This will clear all data.',
      'te': 'మీరు ఖచ్చితంగా ఉన్నారా?',
      'hi': 'क्या आप सुनिश्चित हैं?',
      'ta': 'நீங்கள் உறுதியாக இருக்கிறீர்களா?'
    },
    'yes': {
      'en': 'Yes, Reset',
      'te': 'అవును, రీసెట్',
      'hi': 'हाँ, रीसेट',
      'ta': 'ஆம், மீட்டமை'
    },
    'no': {'en': 'Cancel', 'te': 'రద్దు', 'hi': 'रद्द', 'ta': 'ரத்து'},
    'version': {
      'en': 'Version',
      'te': 'వెర్షన్',
      'hi': 'संस्करण',
      'ta': 'பதிப்பு'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    final lang = provider.language;
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
            fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E2550), Color(0xFF0D1E40)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E3A6A)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.accent, AppTheme.teal],
                      ),
                    ),
                    child: const Icon(Icons.person,
                        color: AppTheme.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lakshmi Devi',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white)),
                        const SizedBox(height: 2),
                        const Text('68 yrs · Vijayawada · B+',
                            style:
                                TextStyle(fontSize: 12, color: AppTheme.grey)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            _pill('Diabetes', AppTheme.error),
                            _pill('High BP', AppTheme.warning),
                            _pill(
                                lang == 'te'
                                    ? 'తెలుగు'
                                    : lang == 'hi'
                                        ? 'हिंदी'
                                        : lang == 'ta'
                                            ? 'தமிழ்'
                                            : 'English',
                                AppTheme.accent),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.personalDetails),
                    child:
                        const Icon(Icons.edit, color: AppTheme.grey, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // UI Language
            _sectionLabel('🌐 ${_label('ui_lang', lang)}', font),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LangText(_label('interface_lang', lang), lang,
                      fontSize: 13, fontWeight: FontWeight.w600),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: LanguageProvider.languageNames.entries
                        .map(
                          (e) => GestureDetector(
                            onTap: () => provider.setLanguage(e.key),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: provider.language == e.key
                                    ? AppTheme.accent.withValues(alpha: 0.15)
                                    : AppTheme.background,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: provider.language == e.key
                                      ? AppTheme.accent
                                      : AppTheme.grey.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(e.value,
                                  style: TextStyle(
                                    fontFamily:
                                        LanguageProvider.getFontFamily(e.key),
                                    color: provider.language == e.key
                                        ? AppTheme.accent
                                        : AppTheme.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  )),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Audio Language
            _sectionLabel('🔊 ${_label('audio_lang', lang)}', font),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LangText(_label('audio_lang_desc', lang), lang,
                      fontSize: 12, color: AppTheme.grey),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _audioLangChip('🇬🇧 English', true, AppTheme.accent),
                      _audioLangChip(
                          '🇮🇳 తెలుగు', lang == 'te', AppTheme.accent),
                      _audioLangChip(
                          '🇮🇳 हिंदी', lang == 'hi', AppTheme.accent),
                      _audioLangChip(
                          '🇮🇳 தமிழ்', lang == 'ta', AppTheme.accent),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Voice Speed
            _sectionLabel('🎵 ${_label('voice_speed', lang)}', font),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  LangText(_label('speed_label', lang), lang,
                      fontSize: 13, fontWeight: FontWeight.w600),
                  const Spacer(),
                  LangText(_label('normal', lang), lang,
                      fontSize: 12, color: AppTheme.grey),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right,
                      color: AppTheme.grey, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Safety
            _sectionLabel('🎯 ${_label('safety', lang)}', font),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      LangText(_label('confidence', lang), lang,
                          fontSize: 13, fontWeight: FontWeight.w600),
                      const Spacer(),
                      const Text('75%',
                          style: TextStyle(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.75,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [AppTheme.accent, AppTheme.teal]),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Voice toggles
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  _toggleRow(
                    icon: '🔊',
                    title: _label('bilingual', lang),
                    subtitle: _label('bilingual_sub', lang),
                    value: _bilingualAudio,
                    lang: lang,
                    onChanged: (val) {
                      setState(() => _bilingualAudio = val);
                      provider.setBilingualEnabled(val);
                    },
                  ),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.15), height: 20),
                  _toggleRow(
                    icon: '🔔',
                    title: _label('voice_rem', lang),
                    subtitle: _label('voice_rem_sub', lang),
                    value: _voiceReminders,
                    lang: lang,
                    onChanged: (val) => setState(() => _voiceReminders = val),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => provider
                        .speak('MediLens మీకు సహాయం చేయడానికి సిద్ధంగా ఉంది'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.accent.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.volume_up,
                              color: AppTheme.accent, size: 18),
                          const SizedBox(width: 8),
                          LangText(_label('test_voice', lang), lang,
                              fontSize: 13, color: AppTheme.accent),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Data
            _sectionLabel('💾 ${_label('data', lang)}', font),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  _dataRow(
                      '💾', _label('db', lang), 'v2.1.3', Icons.refresh, lang),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.1), height: 1),
                  _dataRow('👤', _label('caregivers', lang), '1 added',
                      Icons.chevron_right, lang),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // About
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppTheme.accent, size: 18),
                      const SizedBox(width: 10),
                      LangText(_label('version', lang), lang, fontSize: 13),
                      const Spacer(),
                      Text(AppConstants.appVersion,
                          style: const TextStyle(
                              color: AppTheme.grey, fontSize: 13)),
                    ],
                  ),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.15), height: 20),
                  const Row(
                    children: [
                      Icon(Icons.people, color: AppTheme.teal, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('A. Meghana, M. Harivarsha, S. Manimanya',
                            style:
                                TextStyle(color: AppTheme.white, fontSize: 12)),
                      ),
                    ],
                  ),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.15), height: 20),
                  const Row(
                    children: [
                      Icon(Icons.school, color: AppTheme.warning, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('Guide: Mr. Krutibash Nayak',
                            style:
                                TextStyle(color: AppTheme.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Reset
            GestureDetector(
              onTap: () => _showResetDialog(context, lang),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppTheme.error.withValues(alpha: 0.4)),
                ),
                child: Center(
                  child: LangText(_label('reset', lang), lang,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

  Widget _sectionLabel(String text, String font) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: TextStyle(
              fontFamily: font,
              color: AppTheme.grey,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8)),
    );
  }

  Widget _audioLangChip(String label, bool isOn, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOn ? color.withValues(alpha: 0.15) : AppTheme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOn ? color : AppTheme.grey.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Text(label,
          style: TextStyle(
            color: isOn ? color : AppTheme.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          )),
    );
  }

  Widget _toggleRow(
      {required String icon,
      required String title,
      required String subtitle,
      required bool value,
      required String lang,
      required Function(bool) onChanged}) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LangText(title, lang, fontSize: 13, fontWeight: FontWeight.w600),
              LangText(subtitle, lang, fontSize: 11, color: AppTheme.grey),
            ],
          ),
        ),
        Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.accent),
      ],
    );
  }

  Widget _dataRow(
      String emoji, String title, String sub, IconData trailing, String lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LangText(title, lang,
                fontSize: 13, fontWeight: FontWeight.w600),
          ),
          Text(sub, style: const TextStyle(color: AppTheme.grey, fontSize: 12)),
          const SizedBox(width: 6),
          Icon(trailing, color: AppTheme.grey, size: 18),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: LangText(_label('reset', lang), lang,
            fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.error),
        content: LangText(_label('reset_confirm', lang), lang,
            fontSize: 14, color: AppTheme.grey),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: LangText(_label('no', lang), lang,
                fontSize: 14, color: AppTheme.grey),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pop(ctx);
                context.go(AppRoutes.welcome);
              }
            },
            child: LangText(_label('yes', lang), lang,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.error),
          ),
        ],
      ),
    );
  }
}
