import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class CaregiverSetupScreen extends StatefulWidget {
  const CaregiverSetupScreen({super.key});

  @override
  State<CaregiverSetupScreen> createState() => _CaregiverSetupScreenState();
}

class _CaregiverSetupScreenState extends State<CaregiverSetupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRelation = 'daughter';

  final List<Map<String, String>> _relations = [
    {
      'key': 'daughter',
      'en': '👧 Daughter',
      'te': '👧 కుమార్తె',
      'hi': '👧 बेटी',
      'ta': '👧 மகள்'
    },
    {
      'key': 'son',
      'en': '👦 Son',
      'te': '👦 కుమారుడు',
      'hi': '👦 बेटा',
      'ta': '👦 மகன்'
    },
    {
      'key': 'spouse',
      'en': '👫 Spouse',
      'te': '👫 జీవిత భాగస్వామి',
      'hi': '👫 जीवनसाथी',
      'ta': '👫 துணைவர்'
    },
    {
      'key': 'doctor',
      'en': '👨‍⚕️ Doctor',
      'te': '👨‍⚕️ డాక్టర్',
      'hi': '👨‍⚕️ डॉक्टर',
      'ta': '👨‍⚕️ மருத்துவர்'
    },
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Emergency Caregiver',
      'te': 'అత్యవసర సంరక్షకుడు',
      'hi': 'आपातकालीन देखभालकर्ता',
      'ta': 'அவசர பராமரிப்பாளர்'
    },
    'sub': {
      'en': 'Who to contact in emergency',
      'te': 'అత్యవసర సమయంలో ఎవరిని సంప్రదించాలి',
      'hi': 'आपात स्थिति में किससे संपर्क करें',
      'ta': 'அவசரகாலத்தில் யாரை தொடர்பு கொள்வது'
    },
    'sos_info': {
      'en': '🆘 This person gets SMS + GPS if you press the SOS button.',
      'te': '🆘 మీరు SOS బటన్ నొక్కినప్పుడు ఈ వ్యక్తికి SMS + GPS వస్తుంది.',
      'hi': '🆘 SOS बटन दबाने पर इस व्यक्ति को SMS + GPS मिलेगा।',
      'ta': '🆘 நீங்கள் SOS பொத்தானை அழுத்தினால் இந்த நபருக்கு SMS + GPS வரும்.'
    },
    'name': {
      'en': 'Caregiver Name',
      'te': 'సంరక్షకుడి పేరు',
      'hi': 'देखभालकर्ता का नाम',
      'ta': 'பராமரிப்பாளரின் பெயர்'
    },
    'relation': {
      'en': 'Relationship',
      'te': 'సంబంధం',
      'hi': 'संबंध',
      'ta': 'உறவு'
    },
    'phone': {
      'en': 'Phone Number',
      'te': 'ఫోన్ నంబర్',
      'hi': 'फ़ोन नंबर',
      'ta': 'தொலைபேசி எண்'
    },
    'add_second': {
      'en': '＋ Add Second Caregiver (Optional)',
      'te': '＋ రెండవ సంరక్షకుడిని జోడించండి (ఐచ్ఛికం)',
      'hi': '＋ दूसरा देखभालकर्ता जोड़ें (वैकल्पिक)',
      'ta': '＋ இரண்டாவது பராமரிப்பாளரை சேர்க்கவும் (விருப்பமானது)'
    },
    'continue': {
      'en': 'Continue →',
      'te': 'కొనసాగించు →',
      'hi': 'जारी रखें →',
      'ta': 'தொடர் →'
    },
    'step': {
      'en': 'Step 4 of 5',
      'te': 'దశ 4/5',
      'hi': 'चरण 4/5',
      'ta': 'படி 4/5'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
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
            _progressDots(3),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.healthProfile),
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
                    const SizedBox(height: 14),
                    // SOS info box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.error.withValues(alpha: 0.2)),
                      ),
                      child: LangText(_label('sos_info', lang), lang,
                          fontSize: 12, color: AppTheme.grey),
                    ),
                    const SizedBox(height: 14),
                    // Name field
                    LangText('${_label('name', lang)} *', lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 4),
                    _inputField(_nameController, Icons.person, font),
                    const SizedBox(height: 12),
                    // Relationship
                    LangText(_label('relation', lang), lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _relations.map((r) {
                        final isSelected = _selectedRelation == r['key'];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedRelation = r['key']!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.accent.withValues(alpha: 0.15)
                                  : AppTheme.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.accent
                                    : AppTheme.grey.withValues(alpha: 0.2),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: LangText(
                              r[lang] ?? r['en']!,
                              lang,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected ? AppTheme.accent : AppTheme.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    // Phone
                    LangText('${_label('phone', lang)} *', lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 4),
                    _inputField(_phoneController, Icons.phone, font,
                        isPhone: true),
                    const SizedBox(height: 12),
                    // Add second caregiver
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.grey.withValues(alpha: 0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: LangText(_label('add_second', lang), lang,
                            fontSize: 13, color: AppTheme.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.accessibility),
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

  Widget _inputField(
      TextEditingController controller, IconData icon, String font,
      {bool isPhone = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppTheme.teal.withValues(alpha: 0.5)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        style: TextStyle(fontFamily: font, color: AppTheme.white, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppTheme.accent, size: 20),
          suffixIcon: const Icon(Icons.check, color: AppTheme.teal, size: 16),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        ),
      ),
    );
  }
}
