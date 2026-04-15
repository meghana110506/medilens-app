import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  int _age = 60;
  String _gender = 'Female';
  String _bloodGroup = 'B+';

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Personal Details',
      'te': 'వ్యక్తిగత వివరాలు',
      'hi': 'व्यक्तिगत विवरण',
      'ta': 'தனிப்பட்ட விவரங்கள்'
    },
    'sub': {
      'en': 'Tell us about yourself',
      'te': 'మీ గురించి చెప్పండి',
      'hi': 'अपने बारे में बताएं',
      'ta': 'உங்களைப் பற்றி சொல்லுங்கள்'
    },
    'photo': {
      'en': '📷 Add Profile Photo',
      'te': '📷 ప్రొఫైల్ ఫోటో జోడించండి',
      'hi': '📷 प्रोफ़ाइल फ़ोटो जोड़ें',
      'ta': '📷 சுயவிவர புகைப்படம் சேர்க்கவும்'
    },
    'photo_sub': {
      'en': 'Optional · Helps caregivers identify you',
      'te': 'ఐచ్ఛికం · సంరక్షకులకు గుర్తించడానికి సహాయం',
      'hi': 'वैकल्पिक · देखभाल करने वालों को पहचानने में मदद',
      'ta': 'விருப்பமானது · பராமரிப்பாளர்களுக்கு உதவும்'
    },
    'name': {
      'en': 'Full Name',
      'te': 'పూర్తి పేరు',
      'hi': 'पूरा नाम',
      'ta': 'முழு பெயர்'
    },
    'age': {'en': 'Age', 'te': 'వయసు', 'hi': 'आयु', 'ta': 'வயது'},
    'gender': {'en': 'Gender', 'te': 'లింగం', 'hi': 'लिंग', 'ta': 'பாலினம்'},
    'phone': {
      'en': 'Phone Number',
      'te': 'ఫోన్ నంబర్',
      'hi': 'फ़ोन नंबर',
      'ta': 'தொலைபேசி எண்'
    },
    'city': {
      'en': 'City / Village',
      'te': 'నగరం / గ్రామం',
      'hi': 'शहर / गाँव',
      'ta': 'நகரம் / கிராமம்'
    },
    'blood': {
      'en': 'Blood Group',
      'te': 'రక్త వర్గం',
      'hi': 'रक्त समूह',
      'ta': 'இரத்த வகை'
    },
    'continue': {
      'en': 'Continue →',
      'te': 'కొనసాగించు →',
      'hi': 'जारी रखें →',
      'ta': 'தொடர் →'
    },
    'step': {
      'en': 'Step 2 of 5',
      'te': 'దశ 2/5',
      'hi': 'चरण 2/5',
      'ta': 'படி 2/5'
    },
    'male': {'en': 'Male', 'te': 'పురుషుడు', 'hi': 'पुरुष', 'ta': 'ஆண்'},
    'female': {'en': 'Female', 'te': 'స్త్రీ', 'hi': 'महिला', 'ta': 'பெண்'},
    'other': {'en': 'Other', 'te': 'ఇతర', 'hi': 'अन्य', 'ta': 'மற்றவர்'},
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
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
            _progressDots(1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.welcome),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LangText(_label('title', lang), lang,
                                fontSize: 16, fontWeight: FontWeight.bold),
                            LangText(_label('sub', lang), lang,
                                fontSize: 12, color: AppTheme.grey),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Photo area
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: AppTheme.grey.withValues(alpha: 0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppTheme.accent, AppTheme.teal],
                              ),
                            ),
                            child: const Icon(Icons.person,
                                color: AppTheme.white, size: 30),
                          ),
                          const SizedBox(height: 8),
                          LangText(_label('photo', lang), lang,
                              fontSize: 13,
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w600),
                          const SizedBox(height: 2),
                          LangText(_label('photo_sub', lang), lang,
                              fontSize: 11, color: AppTheme.grey),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Name
                    _inputField(_nameController, _label('name', lang),
                        Icons.person, font,
                        isRequired: true),
                    const SizedBox(height: 10),
                    // Age and Gender row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LangText(_label('age', lang), lang,
                                  fontSize: 11,
                                  color: AppTheme.grey,
                                  fontWeight: FontWeight.w600),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.card,
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                      color:
                                          AppTheme.teal.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        if (_age > 1) _age--;
                                      }),
                                      child: const Icon(Icons.remove,
                                          color: AppTheme.accent, size: 18),
                                    ),
                                    Expanded(
                                      child: Text('$_age',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: AppTheme.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        if (_age < 120) _age++;
                                      }),
                                      child: const Icon(Icons.add,
                                          color: AppTheme.accent, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LangText(_label('gender', lang), lang,
                                  fontSize: 11,
                                  color: AppTheme.grey,
                                  fontWeight: FontWeight.w600),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.card,
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                      color:
                                          AppTheme.teal.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.people,
                                        color: AppTheme.accent, size: 18),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: LangText(
                                          _label(_gender.toLowerCase(), lang),
                                          lang,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Icon(Icons.check,
                                        color: AppTheme.teal, size: 14),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Gender buttons
                    Row(
                      children: ['male', 'female', 'other'].map((g) {
                        final isSelected = _gender.toLowerCase() == g;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: GestureDetector(
                              onTap: () => setState(() => _gender =
                                  g[0].toUpperCase() + g.substring(1)),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.accent
                                      : AppTheme.card,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: LangText(_label(g, lang), lang,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppTheme.white
                                          : AppTheme.grey),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    _inputField(_phoneController, _label('phone', lang),
                        Icons.phone, font,
                        isPhone: true, isRequired: true),
                    const SizedBox(height: 10),
                    _inputField(_cityController, _label('city', lang),
                        Icons.location_on, font),
                    const SizedBox(height: 10),
                    // Blood Group
                    LangText(_label('blood', lang), lang,
                        fontSize: 11,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _bloodGroups.map((bg) {
                        final isSelected = _bloodGroup == bg;
                        return GestureDetector(
                          onTap: () => setState(() => _bloodGroup = bg),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? AppTheme.accent : AppTheme.card,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: isSelected
                                      ? AppTheme.accent
                                      : AppTheme.grey.withValues(alpha: 0.2)),
                            ),
                            child: Text(bg,
                                style: TextStyle(
                                    color: isSelected
                                        ? AppTheme.white
                                        : AppTheme.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Continue button
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.healthProfile),
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
      {bool isPhone = false, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            LangText(label, font,
                fontSize: 11,
                color: AppTheme.grey,
                fontWeight: FontWeight.w600),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(color: AppTheme.error, fontSize: 11)),
          ],
        ),
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
            style: TextStyle(
                fontFamily: font, color: AppTheme.white, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.accent, size: 20),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              suffixIcon:
                  const Icon(Icons.check, color: AppTheme.teal, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
