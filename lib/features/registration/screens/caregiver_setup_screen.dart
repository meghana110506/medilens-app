import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _nameError = false;
  bool _phoneError = false;

  String? _entryFrom(BuildContext context) =>
      GoRouterState.of(context).uri.queryParameters['from'];

  void _navigateBack(BuildContext context) {
    switch (_entryFrom(context)) {
      case 'settings':
        context.go(AppRoutes.settings);
        break;
      case 'sos':
        context.go(AppRoutes.sos);
        break;
      case 'allset':
        context.go(AppRoutes.allSet);
        break;
      case 'accessibility':
        context.go(AppRoutes.accessibility);
        break;
      default:
        context.go(AppRoutes.healthProfile);
    }
  }

  void _navigateAfterSave(BuildContext context) {
    switch (_entryFrom(context)) {
      case 'settings':
        context.go(AppRoutes.settings);
        break;
      case 'sos':
        context.go(AppRoutes.sos);
        break;
      case 'allset':
        context.go(AppRoutes.allSet);
        break;
      case 'accessibility':
        context.go(AppRoutes.accessibility);
        break;
      default:
        context.go(AppRoutes.accessibility);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final p = context.read<LanguageProvider>();
      final relationKeys =
          _relations.map((r) => r['key'] as String).toSet();
      if (p.caregiverName.isNotEmpty) {
        _nameController.text = p.caregiverName;
      }
      if (p.caregiverPhone.isNotEmpty) {
        _phoneController.text = p.caregiverPhone;
      }
      if (p.caregiverRelation.isNotEmpty &&
          relationKeys.contains(p.caregiverRelation)) {
        _selectedRelation = p.caregiverRelation;
      }
      if (p.caregiverName.isNotEmpty ||
          p.caregiverPhone.isNotEmpty ||
          (p.caregiverRelation.isNotEmpty &&
              relationKeys.contains(p.caregiverRelation))) {
        setState(() {});
      }
    });
  }

  final List<Map<String, dynamic>> _relations = [
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
    {
      'key': 'sibling',
      'en': '🧑 Sibling',
      'te': '🧑 సోదరుడు/సోదరి',
      'hi': '🧑 भाई/बहन',
      'ta': '🧑 சகோதரர்/சகோதரி'
    },
    {
      'key': 'parent',
      'en': '👨‍👩 Parent',
      'te': '👨‍👩 తల్లిదండ్రి',
      'hi': '👨‍👩 माता/पिता',
      'ta': '👨‍👩 பெற்றோர்'
    },
    {
      'key': 'friend',
      'en': '🤝 Friend',
      'te': '🤝 స్నేహితుడు',
      'hi': '🤝 मित्र',
      'ta': '🤝 நண்பர்'
    },
    {
      'key': 'neighbour',
      'en': '🏠 Neighbour',
      'te': '🏠 పొరుగువారు',
      'hi': '🏠 पड़ोसी',
      'ta': '🏠 அண்டை வீட்டார்'
    },
    {
      'key': 'nurse',
      'en': '👩‍⚕️ Nurse',
      'te': '👩‍⚕️ నర్సు',
      'hi': '👩‍⚕️ नर्स',
      'ta': '👩‍⚕️ செவிலியர்'
    },
    {
      'key': 'caretaker',
      'en': '🧑‍🦯 Caretaker',
      'te': '🧑‍🦯 సంరక్షకుడు',
      'hi': '🧑‍🦯 देखभालकर्ता',
      'ta': '🧑‍🦯 பாதுகாவலர்'
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
      'te': '＋ రెండవ సంరక్షకుడిని జోడించండి',
      'hi': '＋ दूसरा देखभालकर्ता जोड़ें',
      'ta': '＋ இரண்டாவது பராமரிப்பாளரை சேர்க்கவும்'
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
    'name_required': {
      'en': 'Caregiver name is required',
      'te': 'సంరక్షకుడి పేరు అవసరం',
      'hi': 'देखभालकर्ता का नाम आवश्यक है',
      'ta': 'பராமரிப்பாளரின் பெயர் தேவை'
    },
    'phone_required': {
      'en': 'Phone number is required',
      'te': 'ఫోన్ నంబర్ అవసరం',
      'hi': 'फ़ोन नंबर आवश्यक है',
      'ta': 'தொலைபேசி எண் தேவை'
    },
    'phone_invalid': {
      'en': 'Enter valid 10-digit phone number',
      'te': 'చెల్లుబాటు అయ్యే 10 అంకెల ఫోన్ నంబర్ నమోదు చేయండి',
      'hi': '10 अंकों का वैध फ़ोन नंबर दर्ज करें',
      'ta': 'சரியான 10 இலக்க தொலைபேசி எண்ணை உள்ளிடுங்கள்'
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

  bool _isValidName(String name) => name.trim().length >= 2;
  bool _isValidPhone(String phone) => RegExp(r'^[6-9]\d{9}$').hasMatch(phone);

  Future<void> _continue(String lang) async {
    setState(() {
      _nameError = !_isValidName(_nameController.text);
      _phoneError = !_isValidPhone(_phoneController.text);
    });

    if (_nameError) {
      _showError(_label('name_required', lang));
      return;
    }
    if (_phoneError) {
      _showError(_phoneController.text.trim().isEmpty
          ? _label('phone_required', lang)
          : _label('phone_invalid', lang));
      return;
    }

    await context.read<LanguageProvider>().saveCaregiver(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          relation: _selectedRelation,
        );

    if (!mounted) return;
    _navigateAfterSave(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final font = LanguageProvider.getFontFamily(lang);
    final fontSize = context.watch<LanguageProvider>().fontSize;

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
                          onTap: () => _navigateBack(context),
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
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold),
                              LangText(_label('sub', lang), lang,
                                  fontSize: fontSize - 3, color: AppTheme.grey),
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
                          fontSize: fontSize - 3, color: AppTheme.grey),
                    ),
                    const SizedBox(height: 14),

                    // Name field
                    LangText('${_label('name', lang)} *', lang,
                        fontSize: fontSize - 3,
                        color: _nameError ? AppTheme.error : AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: _nameError
                              ? AppTheme.error
                              : _nameController.text.isNotEmpty
                                  ? AppTheme.teal.withValues(alpha: 0.8)
                                  : AppTheme.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: TextStyle(
                            fontFamily: font,
                            color: AppTheme.white,
                            fontSize: fontSize - 2),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person,
                              color: AppTheme.accent, size: 20),
                          suffixIcon: _isValidName(_nameController.text)
                              ? const Icon(Icons.check,
                                  color: AppTheme.teal, size: 16)
                              : _nameController.text.isNotEmpty
                                  ? const Icon(Icons.error_outline,
                                      color: AppTheme.error, size: 16)
                                  : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                        ),
                      ),
                    ),
                    if (_nameError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: LangText(_label('name_required', lang), lang,
                            fontSize: fontSize - 5, color: AppTheme.error),
                      ),
                    const SizedBox(height: 12),

                    // Relationship
                    LangText(_label('relation', lang), lang,
                        fontSize: fontSize - 3,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _relations.map((r) {
                        final isSelected = _selectedRelation == r['key'];
                        return GestureDetector(
                          onTap: () => setState(
                              () => _selectedRelation = r['key'] as String),
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
                              r[lang] as String? ?? r['en'] as String,
                              lang,
                              fontSize: fontSize - 3,
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
                        fontSize: fontSize - 3,
                        color: _phoneError ? AppTheme.error : AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: _phoneError
                              ? AppTheme.error
                              : _phoneController.text.isNotEmpty
                                  ? AppTheme.teal.withValues(alpha: 0.8)
                                  : AppTheme.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                            fontFamily: font,
                            color: AppTheme.white,
                            fontSize: fontSize - 2),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone,
                              color: AppTheme.accent, size: 20),
                          suffixIcon: _isValidPhone(_phoneController.text)
                              ? const Icon(Icons.check,
                                  color: AppTheme.teal, size: 16)
                              : _phoneController.text.isNotEmpty
                                  ? const Icon(Icons.error_outline,
                                      color: AppTheme.error, size: 16)
                                  : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                        ),
                      ),
                    ),
                    if (_phoneError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: LangText(
                            _phoneController.text.trim().isEmpty
                                ? _label('phone_required', lang)
                                : _label('phone_invalid', lang),
                            lang,
                            fontSize: fontSize - 5,
                            color: AppTheme.error),
                      ),
                    const SizedBox(height: 12),

                    // Add second caregiver
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppTheme.grey.withValues(alpha: 0.2)),
                      ),
                      child: Center(
                        child: LangText(_label('add_second', lang), lang,
                            fontSize: fontSize - 3, color: AppTheme.grey),
                      ),
                    ),
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
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: LangText(_label('step', lang), lang,
                          fontSize: fontSize - 4, color: AppTheme.grey),
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
}
