import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/constants.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';
import 'package:medilens/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _bilingualAudio = true;
  bool _voiceReminders = true;

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Settings',
      'te': 'సెట్టింగులు',
      'hi': 'सेटिंग्स',
      'ta': 'அமைப்புகள்'
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
      'en': 'Select languages for bilingual voice readout',
      'te': 'ద్విభాష వాయిస్ కోసం భాషలు ఎంచుకోండి',
      'hi': 'द्विभाषी वॉयस के लिए भाषाएं चुनें',
      'ta': 'இரு மொழி குரலுக்கு மொழிகளை தேர்ந்தெடுக்கவும்'
    },
    'voice_speed': {
      'en': 'TTS Voice Speed',
      'te': 'TTS వాయిస్ వేగం',
      'hi': 'TTS आवाज़ की गति',
      'ta': 'TTS குரல் வேகம்'
    },
    'slow': {
      'en': '🐢 Slow',
      'te': '🐢 నెమ్మది',
      'hi': '🐢 धीरे',
      'ta': '🐢 மெதுவாக'
    },
    'normal': {
      'en': '🚶 Normal',
      'te': '🚶 సాధారణ',
      'hi': '🚶 सामान्य',
      'ta': '🚶 சாதாரண'
    },
    'fast': {
      'en': '🏃 Fast',
      'te': '🏃 వేగంగా',
      'hi': '🏃 तेज़',
      'ta': '🏃 வேகமாக'
    },
    'font_size': {
      'en': 'Text Size',
      'te': 'అక్షరాల పరిమాణం',
      'hi': 'पाठ आकार',
      'ta': 'உரை அளவு'
    },
    'small': {'en': 'Small', 'te': 'చిన్న', 'hi': 'छोटा', 'ta': 'சிறியது'},
    'medium': {
      'en': 'Medium',
      'te': 'మధ్యమం',
      'hi': 'मध्यम',
      'ta': 'நடுத்தரம்'
    },
    'large': {'en': 'Large', 'te': 'పెద్ద', 'hi': 'बड़ा', 'ta': 'பெரியது'},
    'xlarge': {
      'en': 'Extra Large',
      'te': 'చాలా పెద్ద',
      'hi': 'अतिरिक्त बड़ा',
      'ta': 'மிகவும் பெரியது'
    },
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
      'hi': 'रिमाइंडर समय पर दवा का नाम बोलें',
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
    'notifications': {
      'en': 'Notifications',
      'te': 'నోటిఫికేషన్లు',
      'hi': 'सूचनाएं',
      'ta': 'அறிவிப்புகள்'
    },
    'reminders_notif': {
      'en': 'Medicine Reminders',
      'te': 'మందుల రిమైండర్లు',
      'hi': 'दवा रिमाइंडर',
      'ta': 'மருந்து நினைவூட்டல்கள்'
    },
    'expiry': {
      'en': 'Expiry Alerts',
      'te': 'గడువు హెచ్చరికలు',
      'hi': 'समाप्ति अलर्ट',
      'ta': 'காலாவதி எச்சரிக்கைகள்'
    },
    'digest_time': {
      'en': 'Daily expiry summary time',
      'te': 'రోజువారీ గడువు సారాంశ సమయం',
      'hi': 'दैनिक एक्सपायरी सारांश समय',
      'ta': 'தினசரி காலாவதி சுருக்க நேரம்'
    },
    'digest_time_sub': {
      'en': 'Digest + per-medicine heads-up use this time',
      'te': 'డైజెస్ట్ మరియు ప్రతి మందు హెచ్చరికలు ఈ సమయాన్ని ఉపయోగిస్తాయి',
      'hi': 'सारांश और प्रति-दवा अलर्ट इस समय पर',
      'ta': 'சுருக்கமும் மருந்து எச்சரிக்கைகளும் இந்த நேரத்தில்'
    },
    'notif_permission_cta': {
      'en': 'Review notification permission…',
      'te': 'నోటిఫికేషన్ అనుమతి చూడండి…',
      'hi': 'सूचना अनुमति देखें…',
      'ta': 'அறிவிப்பு அனுமதியைப் பார்க்கவும்…'
    },
    'profile': {
      'en': 'Profile',
      'te': 'ప్రొఫైల్',
      'hi': 'प्रोफ़ाइल',
      'ta': 'சுயவிவரம்'
    },
    'your_name': {
      'en': 'Your Name',
      'te': 'మీ పేరు',
      'hi': 'आपका नाम',
      'ta': 'உங்கள் பெயர்'
    },
    'your_city': {
      'en': 'Your City',
      'te': 'మీ నగరం',
      'hi': 'आपका शहर',
      'ta': 'உங்கள் நகரம்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void initState() {
    super.initState();
    final provider = context.read<LanguageProvider>();
    _bilingualAudio = provider.bilingualEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    final lang = provider.language;
    final font = LanguageProvider.getFontFamily(lang);
    final fontSize = provider.fontSize;
    final voiceSpeed = provider.voiceSpeed;

    final displayName = provider.userName.isEmpty
        ? _label('your_name', lang)
        : provider.userName;
    final displayCity = provider.userCity.isEmpty
        ? _label('your_city', lang)
        : provider.userCity;
    final displayAge = provider.userAge;
    final displayBlood = provider.userBlood;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: LangText(_label('title', lang), lang,
            fontSize: fontSize, fontWeight: FontWeight.bold),
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
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E3A6A)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
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
                          fontSize: provider.userName.isNotEmpty ? 22 : 24,
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
                        Text(displayName,
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white)),
                        Text('$displayAge yrs · $displayCity · $displayBlood',
                            style: TextStyle(
                                fontSize: fontSize - 3, color: AppTheme.grey)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            _pill(
                                LanguageProvider.languageNames[lang] ??
                                    'English',
                                AppTheme.accent,
                                fontSize),
                            _pill(provider.userGender, AppTheme.teal, fontSize),
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
                      fontSize: fontSize, fontWeight: FontWeight.w600),
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
                                  horizontal: 14, vertical: 8),
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
                                    fontSize: fontSize,
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

            // Audio Language (for bilingual output)
            _sectionLabel('🎵 ${_label('audio_lang', lang)}', font),
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
                      fontSize: fontSize - 2, color: AppTheme.grey),
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
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: provider.language == e.key
                                    ? AppTheme.teal.withValues(alpha: 0.15)
                                    : AppTheme.background,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: provider.language == e.key
                                      ? AppTheme.teal
                                      : AppTheme.grey.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(e.value,
                                  style: TextStyle(
                                    fontFamily:
                                        LanguageProvider.getFontFamily(e.key),
                                    color: provider.language == e.key
                                        ? AppTheme.teal
                                        : AppTheme.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: fontSize,
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


            // Text Size
            _sectionLabel('🔤 ${_label('font_size', lang)}', font),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  _fontBtn(AppConstants.fontSmall, _label('small', lang), lang,
                      fontSize, provider),
                  const SizedBox(width: 8),
                  _fontBtn(AppConstants.fontMedium, _label('medium', lang),
                      lang, fontSize, provider),
                  const SizedBox(width: 8),
                  _fontBtn(AppConstants.fontLarge, _label('large', lang), lang,
                      fontSize, provider),
                  const SizedBox(width: 8),
                  _fontBtn(AppConstants.fontXLarge, _label('xlarge', lang),
                      lang, fontSize, provider),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Voice Speed
            _sectionLabel('🎵 ${_label('voice_speed', lang)}', font),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  _speedBtn(AppConstants.voiceSpeedSlow, _label('slow', lang),
                      lang, fontSize, voiceSpeed, provider),
                  const SizedBox(width: 8),
                  _speedBtn(
                      AppConstants.voiceSpeedNormal,
                      _label('normal', lang),
                      lang,
                      fontSize,
                      voiceSpeed,
                      provider),
                  const SizedBox(width: 8),
                  _speedBtn(AppConstants.voiceSpeedFast, _label('fast', lang),
                      lang, fontSize, voiceSpeed, provider),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Voice Settings
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
                      '🔊',
                      _label('bilingual', lang),
                      _label('bilingual_sub', lang),
                      _bilingualAudio,
                      lang,
                      fontSize, (val) {
                    setState(() => _bilingualAudio = val);
                    provider.setBilingualEnabled(val);
                  }),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.15), height: 20),
                  _toggleRow(
                      '🔔',
                      _label('voice_rem', lang),
                      _label('voice_rem_sub', lang),
                      _voiceReminders,
                      lang,
                      fontSize,
                      (val) => setState(() => _voiceReminders = val)),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.15), height: 20),
                  _toggleRow(
                      '🔆',
                      'High Contrast Mode',
                      'Larger text and stronger colours',
                      provider.highContrastMode,
                      lang,
                      fontSize,
                      (val) => provider.setHighContrastMode(val)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final text = lang == 'te'
                          ? 'MediLens మీకు సహాయం చేయడానికి సిద్ధంగా ఉంది'
                          : lang == 'hi'
                              ? 'MediLens आपकी सहायता के लिए तैयार है'
                              : lang == 'ta'
                                  ? 'MediLens உங்களுக்கு உதவ தயாராக உள்ளது'
                                  : 'MediLens is ready to help you';
                      await provider.speak(text);
                      if (_bilingualAudio && lang != 'en') {
                        await provider.speakInLanguage(
                            'MediLens is ready to help you', 'en');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.accent.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.volume_up,
                              color: AppTheme.accent, size: 20),
                          const SizedBox(width: 8),
                          LangText(_label('test_voice', lang), lang,
                              fontSize: fontSize,
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                  ),
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
                          fontSize: fontSize, fontWeight: FontWeight.w600),
                      const Spacer(),
                      Text('${(provider.confidenceThreshold * 100).toInt()}%',
                          style: const TextStyle(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppTheme.accent,
                      inactiveTrackColor: AppTheme.grey.withValues(alpha: 0.2),
                      thumbColor: AppTheme.teal,
                      overlayColor: AppTheme.teal.withValues(alpha: 0.2),
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value: provider.confidenceThreshold,
                      min: 0.75,
                      max: 1.0,
                      divisions: 5,
                      onChanged: (value) => provider.setConfidenceThreshold(value),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('75%', style: TextStyle(color: AppTheme.grey, fontSize: fontSize - 4)),
                      Text('100%', style: TextStyle(color: AppTheme.grey, fontSize: fontSize - 4)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Notifications
            _sectionLabel('🔔 ${_label('notifications', lang)}', font),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _toggleRow(
                      '💊',
                      _label('reminders_notif', lang),
                      '',
                      provider.remindersNotifEnabled,
                      lang,
                      fontSize,
                      (val) => provider.setRemindersNotifEnabled(val)),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.2), height: 20),
                  _toggleRow(
                      '📅',
                      _label('expiry', lang),
                      '',
                      provider.expiryAlertsEnabled,
                      lang,
                      fontSize,
                      (val) => provider.setExpiryAlertsEnabled(val)),
                  if (provider.expiryAlertsEnabled) ...[
                    Divider(
                        color: AppTheme.grey.withValues(alpha: 0.2), height: 20),
                    GestureDetector(
                      onTap: () async {
                        final initial = TimeOfDay(
                            hour: provider.expiryDigestHour,
                            minute: provider.expiryDigestMinute);
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: initial,
                          builder: (ctx, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppTheme.accent,
                                surface: AppTheme.card,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null && context.mounted) {
                          await provider.setExpiryDigestTime(
                              picked.hour, picked.minute);
                        }
                      },
                      child: Row(
                        children: [
                          const Text('⏰',
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LangText(_label('digest_time', lang), lang,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600),
                                LangText(_label('digest_time_sub', lang), lang,
                                    fontSize: fontSize - 3,
                                    color: AppTheme.grey),
                              ],
                            ),
                          ),
                          Text(
                            TimeOfDay(
                                    hour: provider.expiryDigestHour,
                                    minute: provider.expiryDigestMinute)
                                .format(context),
                            style: TextStyle(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                              fontFamily: font,
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppTheme.grey, size: 20),
                        ],
                      ),
                    ),
                  ],
                  if (!kIsWeb &&
                      defaultTargetPlatform == TargetPlatform.android &&
                      !provider.notificationPermissionRequested) ...[
                    Divider(
                        color: AppTheme.grey.withValues(alpha: 0.2), height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          NotificationService
                              .showAndroidPermissionPrecheckIfNeeded(context);
                        },
                        child: LangText(
                            _label('notif_permission_cta', lang), lang,
                            fontSize: fontSize - 1,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accent),
                      ),
                    ),
                  ],
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
                  _dataRow('💾', _label('db', lang), 'v2.1.3', Icons.refresh,
                      lang, fontSize),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.1), height: 1),
                  GestureDetector(
                    onTap: () =>
                        context.go('${AppRoutes.caregiversManage}?from=settings'),
                    child: _dataRow('👤', _label('caregivers', lang), 
                        '${provider.caregivers.length} added',
                        Icons.chevron_right, lang, fontSize),
                  ),
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
                      LangText(_label('version', lang), lang,
                          fontSize: fontSize),
                      const Spacer(),
                      Text(AppConstants.appVersion,
                          style: TextStyle(
                              color: AppTheme.grey, fontSize: fontSize)),
                    ],
                  ),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.15), height: 20),
                  Row(
                    children: [
                      const Icon(Icons.people, color: AppTheme.teal, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('A. Meghana, M. Harivarsha, S. Manimanya',
                            style: TextStyle(
                                color: AppTheme.white, fontSize: fontSize - 2)),
                      ),
                    ],
                  ),
                  Divider(
                      color: AppTheme.grey.withValues(alpha: 0.15), height: 20),
                  Row(
                    children: [
                      const Icon(Icons.school,
                          color: AppTheme.warning, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('Guide: Mr. Krutibash Nayak',
                            style: TextStyle(
                                color: AppTheme.white, fontSize: fontSize - 2)),
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
                      fontSize: fontSize,
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

  Widget _pill(String label, Color color, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: fontSize - 4,
              fontWeight: FontWeight.w600)),
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



  Widget _fontBtn(double size, String label, String lang, double currentSize,
      LanguageProvider provider) {
    final isSelected = currentSize == size;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setFontSize(size),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accent : AppTheme.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isSelected
                    ? AppTheme.accent
                    : AppTheme.grey.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text('A',
                  style: TextStyle(
                    color: isSelected ? AppTheme.white : AppTheme.grey,
                    fontSize: size * 0.7,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 4),
              LangText(label, lang,
                  fontSize: 9,
                  color: isSelected ? AppTheme.white : AppTheme.grey,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _speedBtn(double speed, String label, String lang, double fontSize,
      double currentSpeed, LanguageProvider provider) {
    final isSelected = currentSpeed == speed;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setVoiceSpeed(speed),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.teal.withValues(alpha: 0.2)
                : AppTheme.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppTheme.teal
                  : AppTheme.grey.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: LangText(label, lang,
                fontSize: fontSize - 1,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.teal : AppTheme.grey,
                textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget _toggleRow(String icon, String title, String subtitle, bool value,
      String lang, double fontSize, Function(bool) onChanged) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LangText(title, lang,
                  fontSize: fontSize, fontWeight: FontWeight.w600),
              if (subtitle.isNotEmpty)
                LangText(subtitle, lang,
                    fontSize: fontSize - 3, color: AppTheme.grey),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppTheme.accent,
        ),
      ],
    );
  }

  Widget _dataRow(String emoji, String title, String sub, IconData trailing,
      String lang, double fontSize) {
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
                  fontSize: fontSize, fontWeight: FontWeight.w600)),
          Text(sub,
              style: TextStyle(color: AppTheme.grey, fontSize: fontSize - 3)),
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
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) context.go(AppRoutes.welcome);
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
