import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Color _avatarColor = AppTheme.accent;
  bool _photoSelected = false;

  final List<Color> _avatarColors = [
    AppTheme.accent,
    AppTheme.teal,
    const Color(0xFF9C27B0),
    const Color(0xFFE91E63),
    AppTheme.warning,
    AppTheme.success,
  ];

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
      'en': 'Tap to choose avatar color',
      'te': 'అవతార్ రంగు ఎంచుకోండి',
      'hi': 'अवतार रंग चुनें',
      'ta': 'அவதார் நிறம் தேர்ந்தெடுக்கவும்'
    },
    'photo_sub': {
      'en': 'Your profile avatar',
      'te': 'మీ ప్రొఫైల్ అవతార్',
      'hi': 'आपका प्रोफ़ाइल अवतार',
      'ta': 'உங்கள் சுயவிவர அவதார்'
    },
    'name': {
      'en': 'Full Name *',
      'te': 'పూర్తి పేరు *',
      'hi': 'पूरा नाम *',
      'ta': 'முழு பெயர் *'
    },
    'age': {'en': 'Age *', 'te': 'వయసు *', 'hi': 'आयु *', 'ta': 'வயது *'},
    'gender': {
      'en': 'Gender *',
      'te': 'లింగం *',
      'hi': 'लिंग *',
      'ta': 'பாலினம் *'
    },
    'phone': {
      'en': 'Phone Number *',
      'te': 'ఫోన్ నంబర్ *',
      'hi': 'फ़ोन नंबर *',
      'ta': 'தொலைபேசி எண் *'
    },
    'city': {
      'en': 'City / Village *',
      'te': 'నగరం / గ్రామం *',
      'hi': 'शहर / गाँव *',
      'ta': 'நகரம் / கிராமம் *'
    },
    'blood': {
      'en': 'Blood Group *',
      'te': 'రక్త వర్గం *',
      'hi': 'रक्त समूह *',
      'ta': 'இரத்த வகை *'
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
    'fill_required': {
      'en': 'Please fill all required fields',
      'te': 'దయచేసి అన్ని అవసరమైన ఫీల్డ్‌లు పూరించండి',
      'hi': 'कृपया सभी आवश्यक फ़ील्ड भरें',
      'ta': 'தயவுசெய்து அனைத்து தேவையான புலங்களையும் நிரப்பவும்'
    },
    'choose_color': {
      'en': 'Choose Avatar Color',
      'te': 'అవతార్ రంగు ఎంచుకోండి',
      'hi': 'अवतार रंग चुनें',
      'ta': 'அவதார் நிறம் தேர்ந்தெடுக்கவும்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void initState() {
    super.initState();
    // Load existing profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LanguageProvider>();
      _nameController.text =
          provider.userName == 'Lakshmi Devi' ? '' : provider.userName;
      _phoneController.text = provider.userPhone;
      _cityController.text =
          provider.userCity == 'Vijayawada, AP' ? '' : provider.userCity;
      setState(() {
        _age = int.tryParse(provider.userAge) ?? 60;
        _gender = provider.userGender;
        _bloodGroup = provider.userBlood;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _showColorPicker(BuildContext context, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: LangText(_label('choose_color', lang), lang,
            fontSize: 16, fontWeight: FontWeight.bold),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _avatarColors
              .map((color) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _avatarColor = color;
                        _photoSelected = true;
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          color: _avatarColor == color
                              ? AppTheme.white
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  bool _isValidName(String name) => name.trim().length >= 2;
  bool _isValidPhone(String phone) => RegExp(r'^[6-9]\d{9}$').hasMatch(phone);

  Future<void> _continue(String lang) async {
    // Validate required fields
    if (!_isValidName(_nameController.text)) {
      _showError(_label('fill_required', lang));
      return;
    }
    if (!_isValidPhone(_phoneController.text)) {
      _showError(_label('fill_required', lang));
      return;
    }
    if (!_isValidName(_cityController.text)) {
      _showError(_label('fill_required', lang));
      return;
    }

    // Save profile
    await context.read<LanguageProvider>().saveProfile(
          name: _nameController.text.trim(),
          age: _age.toString(),
          city: _cityController.text.trim(),
          blood: _bloodGroup,
          gender: _gender,
          phone: _phoneController.text.trim(),
          photo: _avatarColor.value.toString(),
        );

    if (mounted) context.go(AppRoutes.healthProfile);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
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
                    const SizedBox(height: 16),

                    // Photo/Avatar area
                    GestureDetector(
                      onTap: () => _showColorPicker(context, lang),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: _photoSelected
                                ? AppTheme.teal.withValues(alpha: 0.5)
                                : AppTheme.grey.withValues(alpha: 0.2),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _avatarColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: _avatarColor.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _nameController.text.isEmpty
                                      ? '👤'
                                      : _nameController.text[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize:
                                        _nameController.text.isEmpty ? 32 : 28,
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            LangText(_label('photo', lang), lang,
                                fontSize: fontSize - 2,
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w600),
                            const SizedBox(height: 2),
                            LangText(_label('photo_sub', lang), lang,
                                fontSize: fontSize - 4, color: AppTheme.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Name
                    _inputField(
                      controller: _nameController,
                      label: _label('name', lang),
                      icon: Icons.person,
                      font: font,
                      fontSize: fontSize,
                      isRequired: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),

                    // Age and Gender
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LangText(_label('age', lang), lang,
                                  fontSize: fontSize - 3,
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
                                          color: AppTheme.accent, size: 20),
                                    ),
                                    Expanded(
                                      child: Text('$_age',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppTheme.white,
                                              fontSize: fontSize,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        if (_age < 120) _age++;
                                      }),
                                      child: const Icon(Icons.add,
                                          color: AppTheme.accent, size: 20),
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
                                  fontSize: fontSize - 3,
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
                                          fontSize: fontSize - 2,
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
                    const SizedBox(height: 8),

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
                                      fontSize: fontSize - 3,
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

                    // Phone
                    _inputField(
                      controller: _phoneController,
                      label: _label('phone', lang),
                      icon: Icons.phone,
                      font: font,
                      fontSize: fontSize,
                      isPhone: true,
                      isRequired: true,
                    ),
                    const SizedBox(height: 10),

                    // City
                    _inputField(
                      controller: _cityController,
                      label: _label('city', lang),
                      icon: Icons.location_on,
                      font: font,
                      fontSize: fontSize,
                      isRequired: true,
                    ),
                    const SizedBox(height: 10),

                    // Blood Group
                    LangText(_label('blood', lang), lang,
                        fontSize: fontSize - 3,
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
                                  fontSize: fontSize - 2,
                                )),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Continue button
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

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String font,
    required double fontSize,
    bool isPhone = false,
    bool isRequired = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LangText(label, font,
            fontSize: fontSize - 3,
            color: AppTheme.grey,
            fontWeight: FontWeight.w600),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: controller.text.isNotEmpty
                  ? AppTheme.teal.withValues(alpha: 0.8)
                  : isRequired
                      ? AppTheme.error.withValues(alpha: 0.4)
                      : AppTheme.grey.withValues(alpha: 0.3),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
            inputFormatters: isPhone ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ] : [],
            style: TextStyle(
                fontFamily: font,
                color: AppTheme.white,
                fontSize: fontSize - 2),
            onChanged: onChanged ?? (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.accent, size: 20),
              suffixIcon: controller.text.trim().length >= (isPhone ? 10 : 2) && (!isPhone || RegExp(r'^[6-9]\d{9}$').hasMatch(controller.text))
                  ? const Icon(Icons.check, color: AppTheme.teal, size: 16)
                  : isRequired && controller.text.isNotEmpty
                      ? const Icon(Icons.error_outline,
                          color: AppTheme.error, size: 16)
                      : null,
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
