import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class HealthProfileScreen extends StatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  final _doctorNameController = TextEditingController();
  final _doctorPhoneController = TextEditingController();
  final Set<String> _selectedConditions = {};

  final List<Map<String, dynamic>> _conditions = [
    {
      'key': 'diabetes',
      'icon': '🩺',
      'en': 'Diabetes',
      'te': 'మధుమేహం',
      'hi': 'मधुमेह',
      'ta': 'நீரிழிவு'
    },
    {
      'key': 'bp',
      'icon': '❤️',
      'en': 'High BP',
      'te': 'రక్తపోటు',
      'hi': 'उच्च रक्तचाप',
      'ta': 'உயர் BP'
    },
    {
      'key': 'heart',
      'icon': '🫀',
      'en': 'Heart Disease',
      'te': 'గుండె జబ్బు',
      'hi': 'हृदय रोग',
      'ta': 'இதய நோய்'
    },
    {
      'key': 'asthma',
      'icon': '🫁',
      'en': 'Asthma',
      'te': 'ఆస్తమా',
      'hi': 'अस्थमा',
      'ta': 'ஆஸ்துமா'
    },
    {
      'key': 'arthritis',
      'icon': '🦴',
      'en': 'Arthritis',
      'te': 'కీళ్ల నొప్పి',
      'hi': 'गठिया',
      'ta': 'மூட்டுவலி'
    },
    {
      'key': 'vision',
      'icon': '👁️',
      'en': 'Vision Impaired',
      'te': 'దృష్టి సమస్య',
      'hi': 'दृष्टि दोष',
      'ta': 'பார்வை குறை'
    },
    {
      'key': 'kidney',
      'icon': '🫘',
      'en': 'Kidney Disease',
      'te': 'మూత్రపిండాల జబ్బు',
      'hi': 'गुर्दे की बीमारी',
      'ta': 'சிறுநீரக நோய்'
    },
    {
      'key': 'other',
      'icon': '➕',
      'en': 'Other',
      'te': 'ఇతర',
      'hi': 'अन्य',
      'ta': 'மற்றவை'
    },
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Health Profile',
      'te': 'ఆరోగ్య వివరాలు',
      'hi': 'स्वास्थ्य प्रोफ़ाइल',
      'ta': 'உடல்நல விவரங்கள்'
    },
    'sub': {
      'en': 'Helps MediLens give safer advice',
      'te': 'MediLens సురక్షితమైన సలహా ఇవ్వడానికి సహాయపడుతుంది',
      'hi': 'MediLens को सुरक्षित सलाह देने में मदद करता है',
      'ta': 'MediLens பாதுகாப்பான ஆலோசனை வழங்க உதவுகிறது'
    },
    'conditions': {
      'en': 'Known Conditions',
      'te': 'తెలిసిన జబ్బులు',
      'hi': 'ज्ञात स्थितियाँ',
      'ta': 'தெரிந்த நோய்கள்'
    },
    'doctor': {
      'en': "Doctor's Name",
      'te': 'డాక్టర్ పేరు',
      'hi': 'डॉक्टर का नाम',
      'ta': 'மருத்துவரின் பெயர்'
    },
    'doctor_phone': {
      'en': "Doctor's Phone",
      'te': 'డాక్టర్ ఫోన్',
      'hi': 'डॉक्टर का फ़ोन',
      'ta': 'மருத்துவரின் தொலைபேசி'
    },
    'continue': {
      'en': 'Continue →',
      'te': 'కొనసాగించు →',
      'hi': 'जारी रखें →',
      'ta': 'தொடர் →'
    },
    'step': {
      'en': 'Step 3 of 5',
      'te': 'దశ 3/5',
      'hi': 'चरण 3/5',
      'ta': 'படி 3/5'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void dispose() {
    _doctorNameController.dispose();
    _doctorPhoneController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.error),
    );
  }

  void _continue(String lang) {
    final name = _doctorNameController.text.trim();
    final phone = _doctorPhoneController.text.trim();

    if (name.isNotEmpty && name.length < 2) {
      _showError(lang == 'en' ? 'Enter a valid doctor name' : 'సరైన పేరు నమోదు చేయండి');
      return;
    }
    if (phone.isNotEmpty && !RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      _showError(lang == 'en' ? 'Enter a valid 10-digit phone number' : 'చెల్లుబాటు అయ్యే 10 అంకెల ఫోన్ నంబర్ నమోదు చేయండి');
      return;
    }

    // Currently Health Profile doesn't persist this data, 
    // but we ensure it's valid if they chose to type it.
    context.go(AppRoutes.caregiverSetup);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final font = LanguageProvider.getFontFamily(lang);
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _progressDots(2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.personalDetails),
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
                    LangText(_label('conditions', lang), lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3.2,
                      children: _conditions.map((c) {
                        final isSelected =
                            _selectedConditions.contains(c['key']);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (isSelected)
                              _selectedConditions.remove(c['key']);
                            else
                              _selectedConditions.add(c['key'] as String);
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accent.withValues(alpha: 0.08)
                                  : AppTheme.card,
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.accent
                                    : AppTheme.grey.withValues(alpha: 0.2),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.accent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.accent
                                          : AppTheme.grey
                                              .withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check,
                                          color: AppTheme.white, size: 12)
                                      : null,
                                ),
                                const SizedBox(width: 6),
                                Text(c['icon'] as String,
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: LangText(
                                    c[lang] as String? ?? c['en'] as String,
                                    lang,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppTheme.white
                                        : AppTheme.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _inputField(_doctorNameController, _label('doctor', lang),
                        Icons.local_hospital, font),
                    const SizedBox(height: 10),
                    _inputField(_doctorPhoneController,
                        _label('doctor_phone', lang), Icons.phone, font,
                        isPhone: true),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _continue(lang),
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

  Widget _inputField(TextEditingController controller, String label,
      IconData icon, String font,
      {bool isPhone = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LangText(label, font,
            fontSize: 11, color: AppTheme.grey, fontWeight: FontWeight.w600),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppTheme.teal.withValues(alpha: 0.5)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            inputFormatters: isPhone ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ] : [],
            onChanged: (_) => setState(() {}),
            style: TextStyle(
                fontFamily: font, color: AppTheme.white, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.accent, size: 20),
              suffixIcon: controller.text.trim().length >= (isPhone ? 10 : 2) && (!isPhone || RegExp(r'^[6-9]\d{9}$').hasMatch(controller.text))
                  ? const Icon(Icons.check, color: AppTheme.teal, size: 16)
                  : controller.text.isNotEmpty ? const Icon(Icons.error_outline, color: AppTheme.error, size: 16) : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            ),
          ),
        ),
      ],
    );
  }
}
