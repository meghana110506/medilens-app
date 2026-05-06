import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _otpController = TextEditingController();
  final _cityController = TextEditingController();
  int _age = 60;
  String _gender = 'Female';
  String _bloodGroup = 'B+';
  Color _avatarColor = AppTheme.accent;
  bool _photoSelected = false;
  bool _otpError = false;

  bool _isVerifying = false;
  bool _isCodeSent = false;
  bool _isVerified = false;
  String _verificationId = '';

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
    'verify_phone': {
      'en': 'Verify Number',
      'te': 'నంబర్‌ను ధృవీకరించండి',
      'hi': 'नंबर सत्यापित करें',
      'ta': 'எண்ணை சரிபார்க்கவும்'
    },
    'enter_otp': {
      'en': 'Enter 6-digit OTP',
      'te': '6 అంకెల OTP ని నమోదు చేయండి',
      'hi': '6 अंकों का OTP दर्ज करें',
      'ta': '6 இலக்க OTP-ஐ உள்ளிடுங்கள்'
    },
    'invalid_otp': {
      'en': 'Invalid or incorrect OTP',
      'te': 'చెల్లని లేదా తప్పు OTP',
      'hi': 'अमान्य या गलत OTP',
      'ta': 'தவறான அல்லது செல்லாத OTP'
    },
    'phone_verified': {
      'en': 'Phone Number Verified!',
      'te': 'ఫోన్ నంబర్ ధృవీకరించబడింది!',
      'hi': 'फ़ोन नंबर सत्यापित!',
      'ta': 'தொலைபேசி எண் சரிபார்க்கப்பட்டது!'
    },
    'must_verify': {
      'en': 'Please verify phone number before saving',
      'te': 'దయచేసి సేవ్ చేసే ముందు ఫోన్ నంబర్‌ను ధృవీకరించండి',
      'hi': 'सहेजने से पहले कृपया फ़ोन नंबर सत्यापित करें',
      'ta': 'சேமிக்க முன் தொலைபேசி எண்ணை சரிபார்க்கவும்'
    },
    'phone_invalid': {
      'en': 'Enter valid 10-digit phone number',
      'te': 'చెల్లుబాటు అయ్యే 10 అంకెల ఫోన్ నంబర్ నమోదు చేయండి',
      'hi': '10 अंकों का वैध फ़ोन नंबर दर्ज करें',
      'ta': 'சரியான 10 இலக்க தொலைபேசி எண்ணை உள்ளிடுங்கள்'
    },
    'invalid_name_chars': {
      'en': 'Name cannot contain numbers or special characters',
      'te': 'పేరులో అంకెలు లేదా ప్రత్యేక అక్షరాలు ఉండకూడదు',
      'hi': 'नाम में संख्याएँ या विशेष वर्ण नहीं होने चाहिए',
      'ta': 'பெயரில் எண்கள் அல்லது சிறப்பு எழுத்துக்கள் இருக்கக்கூடாது'
    },
    'invalid_name_format': {
      'en': 'Please enter both First and Last name',
      'te': 'దయచేసి మొదటి మరియు చివరి పేరును నమోదు చేయండి',
      'hi': 'कृपया प्रथम और अंतिम नाम दोनों दर्ज करें',
      'ta': 'முதல் மற்றும் கடைசி பெயரை உள்ளிடவும்'
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
    _otpController.dispose();
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

  // Using unicode: true allows letters from any language but strictly no numbers/symbols
  bool _isValidNameChars(String name) => RegExp(r'^[\p{L}\s]+$', unicode: true).hasMatch(name);
  bool _hasFirstAndLastName(String name) => name.trim().split(RegExp(r'\s+')).length >= 2;
  
  bool _isValidPhone(String phone) => RegExp(r'^[6-9]\d{9}$').hasMatch(phone);

  Future<void> _verifyPhoneNumber(String lang) async {
    final phone = _phoneController.text.trim();
    if (!_isValidPhone(phone)) {
      _showError(_label('phone_invalid', lang));
      return;
    }
    
    setState(() => _isVerifying = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            setState(() {
              _isVerified = true;
              _isVerifying = false;
              _isCodeSent = false;
            });
            _showSuccess(_label('phone_verified', lang));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (mounted) {
            setState(() => _isVerifying = false);
            _showError(e.message ?? 'Verification failed');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (mounted) {
            setState(() {
              _verificationId = verificationId;
              _isCodeSent = true;
              _isVerifying = false;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            _verificationId = verificationId;
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isVerifying = false);
        _showError(e.toString());
      }
    }
  }

  Future<void> _submitOTP(String lang) async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      setState(() => _otpError = true);
      return;
    }
    setState(() => _isVerifying = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        setState(() {
          _isVerified = true;
          _isCodeSent = false;
          _isVerifying = false;
        });
        _showSuccess(_label('phone_verified', lang));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _otpError = true;
          _isVerifying = false;
        });
        _showError(_label('invalid_otp', lang));
      }
    }
  }

  Future<void> _continue(String lang) async {
    // Validate required fields
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showError(_label('fill_required', lang));
      return;
    }
    if (!_isValidNameChars(name)) {
      _showError(_label('invalid_name_chars', lang));
      return;
    }
    if (!_hasFirstAndLastName(name)) {
      _showError(_label('invalid_name_format', lang));
      return;
    }

    if (!_isValidPhone(_phoneController.text)) {
      _showError(_label('fill_required', lang));
      return;
    }
    if (!_isVerified) {
      _showError(_label('must_verify', lang));
      return;
    }
    if (_cityController.text.trim().isEmpty) {
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
          photo: _avatarColor.toARGB32().toString(),
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.teal),
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
                    LangText('${_label('phone', lang)} *', lang,
                        fontSize: fontSize - 3,
                        color: AppTheme.grey,
                        fontWeight: FontWeight.w600),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: _phoneController.text.isNotEmpty
                              ? AppTheme.teal.withValues(alpha: 0.8)
                              : AppTheme.error.withValues(alpha: 0.4),
                        ),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        style: TextStyle(
                            fontFamily: font,
                            color: AppTheme.white,
                            fontSize: fontSize - 2),
                        onChanged: (_) {
                          if (_isVerified || _isCodeSent) {
                            setState(() {
                              _isVerified = false;
                              _isCodeSent = false;
                              _verificationId = '';
                            });
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone,
                              color: AppTheme.accent, size: 20),
                          suffixIcon: _isVerified
                              ? const Icon(Icons.verified, color: AppTheme.teal, size: 18)
                              : _isValidPhone(_phoneController.text)
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
                    if (!_isVerified && !_isCodeSent)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _isVerifying ? null : () => _verifyPhoneNumber(lang),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: _isVerifying ? AppTheme.grey.withValues(alpha: 0.3) : AppTheme.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: _isVerifying ? AppTheme.grey : AppTheme.accent),
                              ),
                              child: _isVerifying
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent))
                                : LangText(_label('verify_phone', lang), lang, fontSize: fontSize - 2, color: AppTheme.accent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      
                    if (_isCodeSent)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LangText('${_label('enter_otp', lang)} *', lang,
                                fontSize: fontSize - 3,
                                color: _otpError ? AppTheme.error : AppTheme.grey,
                                fontWeight: FontWeight.w600),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.card,
                                      borderRadius: BorderRadius.circular(11),
                                      border: Border.all(
                                        color: _otpError
                                            ? AppTheme.error
                                            : _otpController.text.isNotEmpty
                                                ? AppTheme.teal.withValues(alpha: 0.8)
                                                : AppTheme.grey.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _otpController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontFamily: font,
                                          color: AppTheme.white,
                                          fontSize: fontSize - 2),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      onChanged: (_) => setState(() => _otpError = false),
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.security,
                                            color: AppTheme.accent, size: 20),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: _isVerifying ? null : () => _submitOTP(lang),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _isVerifying ? AppTheme.grey.withValues(alpha: 0.3) : AppTheme.teal,
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: _isVerifying
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.white))
                                      : const Icon(Icons.arrow_forward, color: AppTheme.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                            if (_otpError)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: LangText(_label('invalid_otp', lang), lang,
                                    fontSize: fontSize - 5, color: AppTheme.error),
                              ),
                          ],
                        ),
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
