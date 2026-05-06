import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  String _textSize = 'normal';
  String _voiceSpeed = 'normal';
  bool _bilingualAudio = true;
  bool _voiceReminders = true;
  bool _expiryAlerts = true;
  bool _highContrast = false;

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Accessibility',
      'te': 'యాక్సెసిబిలిటీ',
      'hi': 'अभिगम्यता',
      'ta': 'அணுகல்தன்மை'
    },
    'sub': {
      'en': 'Set your comfort preferences',
      'te': 'మీ సౌకర్య ప్రాధాన్యతలు సెట్ చేయండి',
      'hi': 'अपनी सुविधा प्राथमिकताएं सेट करें',
      'ta': 'உங்கள் வசதி விருப்பங்களை அமைக்கவும்'
    },
    'text_size': {
      'en': 'Text Size',
      'te': 'అక్షరాల పరిమాణం',
      'hi': 'पाठ आकार',
      'ta': 'உரை அளவு'
    },
    'small': {'en': 'Small', 'te': 'చిన్న', 'hi': 'छोटा', 'ta': 'சிறியது'},
    'normal': {
      'en': 'Normal ✓',
      'te': 'సాధారణ ✓',
      'hi': 'सामान्य ✓',
      'ta': 'சாதாரண ✓'
    },
    'large': {'en': 'Large', 'te': 'పెద్ద', 'hi': 'बड़ा', 'ta': 'பெரியது'},
    'xlarge': {
      'en': 'Extra Large',
      'te': 'చాలా పెద్ద',
      'hi': 'अति बड़ा',
      'ta': 'மிகவும் பெரியது'
    },
    'voice_speed': {
      'en': 'Voice Speed',
      'te': 'వాయిస్ వేగం',
      'hi': 'आवाज़ की गति',
      'ta': 'குரல் வேகம்'
    },
    'slow': {
      'en': '🐢 Slow',
      'te': '🐢 నెమ్మది',
      'hi': '🐢 धीरे',
      'ta': '🐢 மெதுவாக'
    },
    'normal_speed': {
      'en': '🚶 Normal ✓',
      'te': '🚶 సాధారణ ✓',
      'hi': '🚶 सामान्य ✓',
      'ta': '🚶 சாதாரண ✓'
    },
    'fast': {
      'en': '🏃 Fast',
      'te': '🏃 వేగంగా',
      'hi': '🏃 तेज़',
      'ta': '🏃 வேகமாக'
    },
    'voice_settings': {
      'en': 'Voice Settings',
      'te': 'వాయిస్ సెట్టింగులు',
      'hi': 'आवाज़ सेटिंग्स',
      'ta': 'குரல் அமைப்புகள்'
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
    'expiry_alerts': {
      'en': 'Expiry Voice Alerts',
      'te': 'గడువు వాయిస్ హెచ్చరికలు',
      'hi': 'समाप्ति वॉयस अलर्ट',
      'ta': 'காலாவதி குரல் எச்சரிக்கைகள்'
    },
    'expiry_alerts_sub': {
      'en': 'Warn when medicine near expiry',
      'te': 'మందు గడువు దగ్గరపడినప్పుడు హెచ్చరించండి',
      'hi': 'दवा की समाप्ति के पास होने पर चेतावनी दें',
      'ta': 'மருந்து காலாவதி நெருங்கும்போது எச்சரிக்கவும்'
    },
    'high_contrast': {
      'en': 'High Contrast',
      'te': 'హై కాంట్రాస్ట్',
      'hi': 'उच्च कंट्रास्ट',
      'ta': 'உயர் வேறுபாடு'
    },
    'high_contrast_sub': {
      'en': 'Larger text and stronger colours',
      'te': 'పెద్ద టెక్స్ట్ మరియు బలమైన రంగులు',
      'hi': 'बड़ा टेक्स्ट और मजबूत रंग',
      'ta': 'பெரிய உரை மற்றும் வலிமையான வண்ணங்கள்'
    },
    'continue': {
      'en': 'Almost Done →',
      'te': 'దాదాపు పూర్తైంది →',
      'hi': 'लगभग हो गया →',
      'ta': 'கிட்டத்தட்ட முடிந்தது →'
    },
    'step': {
      'en': 'Step 5 of 5',
      'te': 'దశ 5/5',
      'hi': 'चरण 5/5',
      'ta': 'படி 5/5'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _progressDots(4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context
                                .go('${AppRoutes.caregiversManage}?from=accessibility'),
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              LangText(_label('sub', lang), lang,
                                  fontSize: 11, color: AppTheme.grey),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Text size
                    LangText(_label('text_size', lang), lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _textSizeBtn('small', 'A', 13, lang),
                        const SizedBox(width: 6),
                        _textSizeBtn('normal', 'A', 17, lang),
                        const SizedBox(width: 6),
                        _textSizeBtn('large', 'A', 21, lang),
                        const SizedBox(width: 6),
                        _textSizeBtn('xlarge', 'A', 25, lang),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Voice speed
                    LangText(_label('voice_speed', lang), lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _speedBtn('slow', _label('slow', lang), lang),
                        const SizedBox(width: 6),
                        _speedBtn('normal', _label('normal_speed', lang), lang),
                        const SizedBox(width: 6),
                        _speedBtn('fast', _label('fast', lang), lang),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Voice settings
                    LangText(_label('voice_settings', lang), lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.grey.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        children: [
                          _toggleRow(
                              '🔊',
                              _label('bilingual', lang),
                              _label('bilingual_sub', lang),
                              _bilingualAudio,
                              lang,
                              (v) => setState(() => _bilingualAudio = v)),
                          _divider(),
                          _toggleRow(
                              '🔔',
                              _label('voice_rem', lang),
                              _label('voice_rem_sub', lang),
                              _voiceReminders,
                              lang,
                              (v) => setState(() => _voiceReminders = v)),
                          _divider(),
                          _toggleRow(
                              '⚠️',
                              _label('expiry_alerts', lang),
                              _label('expiry_alerts_sub', lang),
                              _expiryAlerts,
                              lang,
                              (v) => setState(() => _expiryAlerts = v)),
                          _divider(),
                          _toggleRow(
                              '🔆',
                              _label('high_contrast', lang),
                              _label('high_contrast_sub', lang),
                              _highContrast,
                              lang,
                              (v) => setState(() => _highContrast = v)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Save all settings
                        final provider = context.read<LanguageProvider>();
                        provider.setHighContrastMode(_highContrast);
                        provider.setBilingualEnabled(_bilingualAudio);
                        // Navigate
                        context.go(AppRoutes.allSet);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [AppTheme.accent, AppTheme.teal]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: LangText(_label('continue', lang), lang,
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: LangText(_label('step', lang), lang,
                          fontSize: 12, color: AppTheme.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressDots(int active) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
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

  Widget _textSizeBtn(String size, String label, double fontSize, String lang) {
    final isSelected = _textSize == size;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _textSize = size),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accent.withValues(alpha: 0.1)
                : AppTheme.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppTheme.accent
                  : AppTheme.grey.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(label,
                  style: TextStyle(
                      color: isSelected ? AppTheme.accent : AppTheme.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              LangText(
                size == 'small'
                    ? _label('small', lang)
                    : size == 'normal'
                        ? 'Normal'
                        : size == 'large'
                            ? _label('large', lang)
                            : _label('xlarge', lang),
                lang,
                fontSize: 9,
                color: isSelected ? AppTheme.accent : AppTheme.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _speedBtn(String speed, String label, String lang) {
    final isSelected = _voiceSpeed == speed;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _voiceSpeed = speed),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.teal.withValues(alpha: 0.1)
                : AppTheme.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppTheme.teal
                  : AppTheme.grey.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: LangText(label, lang,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.teal : AppTheme.grey),
          ),
        ),
      ),
    );
  }

  Widget _toggleRow(String icon, String title, String subtitle, bool value,
      String lang, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LangText(title, lang,
                    fontSize: 13, fontWeight: FontWeight.w600),
                const SizedBox(height: 2),
                LangText(subtitle, lang, fontSize: 11, color: AppTheme.grey),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppTheme.accent,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
      color: AppTheme.grey.withValues(alpha: 0.1),
      height: 1,
      indent: 14,
      endIndent: 14);
}
