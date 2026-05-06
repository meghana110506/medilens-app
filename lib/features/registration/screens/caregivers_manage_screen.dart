import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

/// Screen to manage multiple caregivers (up to 3)
class CaregiversManageScreen extends StatefulWidget {
  const CaregiversManageScreen({super.key});

  @override
  State<CaregiversManageScreen> createState() => _CaregiversManageScreenState();
}

class _CaregiversManageScreenState extends State<CaregiversManageScreen> {
  int? _editingIndex; // null = adding new, 0-2 = editing existing
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String _selectedRelation = 'daughter';
  
  bool _nameError = false;
  bool _phoneError = false;
  bool _otpError = false;
  bool _isVerifying = false;
  bool _isCodeSent = false;
  bool _isVerified = false;
  String _verificationId = '';

  final List<Map<String, dynamic>> _relations = [
    {'key': 'daughter', 'en': '👧 Daughter', 'te': '👧 కుమార్తె', 'hi': '👧 बेटी', 'ta': '👧 மகள்'},
    {'key': 'son', 'en': '👦 Son', 'te': '👦 కుమారుడు', 'hi': '👦 बेटा', 'ta': '👦 மகன்'},
    {'key': 'spouse', 'en': '👫 Spouse', 'te': '👫 జీవిత భాగస్వామి', 'hi': '👫 जीवनसाथी', 'ta': '👫 துணைவர்'},
    {'key': 'doctor', 'en': '👨‍⚕️ Doctor', 'te': '👨‍⚕️ డాక్టర్', 'hi': '👨‍⚕️ डॉक्टर', 'ta': '👨‍⚕️ மருத்துவர்'},
    {'key': 'sibling', 'en': '🧑 Sibling', 'te': '🧑 సోదరుడు/సోదరి', 'hi': '🧑 भाई/बहन', 'ta': '🧑 சகோதரர்/சகோதரி'},
    {'key': 'parent', 'en': '👨‍👩 Parent', 'te': '👨‍👩 తల్లిదండ్రి', 'hi': '👨‍👩 माता/पिता', 'ta': '👨‍👩 பெற்றோர்'},
    {'key': 'friend', 'en': '🤝 Friend', 'te': '🤝 స్నేహితుడు', 'hi': '🤝 मित्र', 'ta': '🤝 நண்பர்'},
    {'key': 'neighbour', 'en': '🏠 Neighbour', 'te': '🏠 పొరుగువారు', 'hi': '🏠 पड़ोसी', 'ta': '🏠 அண்டை வீட்டார்'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String _label(String key, String lang) {
    const labels = {
      'title': {'en': 'Emergency Caregivers', 'te': 'అత్యవసర సంరక్షకులు', 'hi': 'आपातकालीन देखभालकर्ता', 'ta': 'அவசர பராமரிப்பாளர்கள்'},
      'subtitle': {'en': 'Add up to 3 caregivers', 'te': '3 మంది సంరక్షకులను జోడించండి', 'hi': '3 देखभालकर्ता जोड़ें', 'ta': '3 பராமரிப்பாளர்களை சேர்க்கவும்'},
      'add_new': {'en': '＋ Add Caregiver', 'te': '＋ సంరక్షకుడిని జోడించండి', 'hi': '＋ देखभालकर्ता जोड़ें', 'ta': '＋ பராமரிப்பாளரை சேர்க்கவும்'},
      'name': {'en': 'Name', 'te': 'పేరు', 'hi': 'नाम', 'ta': 'பெயர்'},
      'phone': {'en': 'Phone', 'te': 'ఫోన్', 'hi': 'फ़ोन', 'ta': 'தொலைபேசி'},
      'relation': {'en': 'Relationship', 'te': 'సంబంధం', 'hi': 'संबंध', 'ta': 'உறவு'},
      'verify': {'en': 'Verify Number', 'te': 'నంబర్‌ను ధృవీకరించండి', 'hi': 'नंबर सत्यापित करें', 'ta': 'எண்ணை சரிபார்க்கவும்'},
      'enter_otp': {'en': 'Enter OTP', 'te': 'OTP నమోదు చేయండి', 'hi': 'OTP दर्ज करें', 'ta': 'OTP உள்ளிடுங்கள்'},
      'save': {'en': 'Save', 'te': 'సేవ్', 'hi': 'सहेजें', 'ta': 'சேமி'},
      'cancel': {'en': 'Cancel', 'te': 'రద్దు', 'hi': 'रद्द करें', 'ta': 'ரத்து'},
      'delete': {'en': 'Delete', 'te': 'తొలగించు', 'hi': 'हटाएं', 'ta': 'நீக்கு'},
      'verified': {'en': 'Verified ✓', 'te': 'ధృవీకరించబడింది ✓', 'hi': 'सत्यापित ✓', 'ta': 'சரிபார்க்கப்பட்டது ✓'},
      'must_verify': {'en': 'Please verify phone', 'te': 'ఫోన్‌ను ధృవీకరించండి', 'hi': 'फ़ोन सत्यापित करें', 'ta': 'தொலைபேசியை சரிபார்க்கவும்'},
      'phone_same_as_user': {'en': 'Cannot be your phone', 'te': 'మీ ఫోన్ కాకూడదు', 'hi': 'आपका फ़ोन नहीं हो सकता', 'ta': 'உங்கள் தொலைபேசி இருக்க முடியாது'},
      'limit_reached': {'en': 'Maximum 3 caregivers', 'te': 'గరిష్టంగా 3 మంది', 'hi': 'अधिकतम 3', 'ta': 'அதிகபட்சம் 3'},
    };
    return labels[key]?[lang] ?? labels[key]?['en'] ?? key;
  }

  bool _isValidName(String name) => name.trim().isNotEmpty && name.trim().split(RegExp(r'\s+')).length >= 2;
  bool _isValidPhone(String phone) => RegExp(r'^[6-9]\d{9}$').hasMatch(phone);

  Future<void> _verifyPhoneNumber(String lang) async {
    final phone = _phoneController.text.trim();
    if (!_isValidPhone(phone)) {
      _showError('Invalid phone number');
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
            _showSuccess(_label('verified', lang));
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
          if (mounted) _verificationId = verificationId;
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
        _showSuccess(_label('verified', lang));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _otpError = true;
          _isVerifying = false;
        });
        _showError('Invalid OTP');
      }
    }
  }

  Future<void> _saveCaregiver() async {
    final provider = context.read<LanguageProvider>();
    final lang = provider.language;
    
    if (!_isValidName(_nameController.text)) {
      _showError('Enter valid name');
      return;
    }
    if (!_isValidPhone(_phoneController.text)) {
      _showError('Enter valid phone');
      return;
    }
    if (_phoneController.text.trim() == provider.userPhone) {
      _showError(_label('phone_same_as_user', lang));
      return;
    }
    if (!_isVerified) {
      _showError(_label('must_verify', lang));
      return;
    }

    await provider.saveCaregiver(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      relation: _selectedRelation,
      index: _editingIndex,
    );

    if (mounted) {
      setState(() {
        _editingIndex = null;
        _nameController.clear();
        _phoneController.clear();
        _otpController.clear();
        _isVerified = false;
        _isCodeSent = false;
      });
    }
  }

  void _startEdit(int index, Map<String, String> caregiver) {
    setState(() {
      _editingIndex = index;
      _nameController.text = caregiver['name'] ?? '';
      _phoneController.text = caregiver['phone'] ?? '';
      _selectedRelation = caregiver['relation'] ?? 'daughter';
      _isVerified = true; // Already verified
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingIndex = null;
      _nameController.clear();
      _phoneController.clear();
      _otpController.clear();
      _isVerified = false;
      _isCodeSent = false;
    });
  }

  Future<void> _deleteCaregiver(int index) async {
    await context.read<LanguageProvider>().removeCaregiver(index);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.teal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    final lang = provider.language;
    final font = LanguageProvider.getFontFamily(lang);
    final fontSize = provider.fontSize;
    final caregivers = provider.caregivers;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back, color: AppTheme.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LangText(_label('title', lang), lang, fontSize: fontSize, fontWeight: FontWeight.bold),
                        LangText(_label('subtitle', lang), lang, fontSize: fontSize - 3, color: AppTheme.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    // Existing caregivers list
                    ...caregivers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final caregiver = entry.value;
                      return _buildCaregiverCard(index, caregiver, lang, font, fontSize);
                    }).toList(),
                    
                    const SizedBox(height: 12),
                    
                    // Add/Edit form
                    if (_editingIndex != null || caregivers.length < 3)
                      _buildEditForm(lang, font, fontSize),
                    
                    // Add button (when not editing and under limit)
                    if (_editingIndex == null && caregivers.length < 3)
                      GestureDetector(
                        onTap: () => setState(() => _editingIndex = caregivers.length),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: LangText(_label('add_new', lang), lang, fontSize: fontSize, color: AppTheme.accent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    
                    if (caregivers.length >= 3 && _editingIndex == null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: LangText(_label('limit_reached', lang), lang, fontSize: fontSize - 2, color: AppTheme.grey),
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

  Widget _buildCaregiverCard(int index, Map<String, String> caregiver, String lang, String font, double fontSize) {
    final name = caregiver['name'] ?? '';
    final phone = caregiver['phone'] ?? '';
    final relation = caregiver['relation'] ?? '';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFA855F7)]),
              ),
              child: Center(
                child: Text(
                  name.isEmpty ? '?' : name.characters.first.toUpperCase(),
                  style: const TextStyle(color: AppTheme.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontFamily: font, color: AppTheme.white, fontWeight: FontWeight.w600, fontSize: fontSize)),
                  if (relation.isNotEmpty)
                    Text(relation, style: TextStyle(fontFamily: font, fontSize: fontSize - 3, color: AppTheme.grey)),
                  Text(phone, style: TextStyle(fontFamily: font, color: AppTheme.accent, fontSize: fontSize - 2)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.accent, size: 20),
              onPressed: () => _startEdit(index, caregiver),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.error, size: 20),
              onPressed: () => _deleteCaregiver(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(String lang, String font, double fontSize) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name field
          LangText(_label('name', lang), lang, fontSize: fontSize - 2, color: AppTheme.grey),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            style: TextStyle(fontFamily: font, color: AppTheme.white, fontSize: fontSize),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.card,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 12),
          
          // Phone field
          LangText(_label('phone', lang), lang, fontSize: fontSize - 2, color: AppTheme.grey),
          const SizedBox(height: 6),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: TextStyle(fontFamily: font, color: AppTheme.white, fontSize: fontSize),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            onChanged: (_) {
              if (_isVerified || _isCodeSent) {
                setState(() {
                  _isVerified = false;
                  _isCodeSent = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.card,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              suffixIcon: _isVerified ? const Icon(Icons.verified, color: AppTheme.teal, size: 18) : null,
            ),
          ),
          
          // Verify button
          if (!_isVerified && !_isCodeSent)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : () => _verifyPhoneNumber(lang),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: _isVerifying
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.white))
                      : LangText(_label('verify', lang), lang, fontSize: fontSize - 2, color: AppTheme.white),
                ),
              ),
            ),
          
          // OTP field
          if (_isCodeSent)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LangText(_label('enter_otp', lang), lang, fontSize: fontSize - 2, color: AppTheme.grey),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontFamily: font, color: AppTheme.white, fontSize: fontSize),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppTheme.card,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isVerifying ? null : () => _submitOTP(lang),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.teal,
                          padding: const EdgeInsets.all(12),
                        ),
                        child: _isVerifying
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.white))
                            : const Icon(Icons.arrow_forward, color: AppTheme.white, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Relation chips
          LangText(_label('relation', lang), lang, fontSize: fontSize - 2, color: AppTheme.grey),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _relations.map((r) {
              final isSelected = _selectedRelation == r['key'];
              return GestureDetector(
                onTap: () => setState(() => _selectedRelation = r['key'] as String),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accent.withValues(alpha: 0.2) : AppTheme.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppTheme.accent : AppTheme.grey.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    r[lang] as String? ?? r['en'] as String,
                    style: TextStyle(fontFamily: font, fontSize: fontSize - 3, color: isSelected ? AppTheme.accent : AppTheme.grey),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _cancelEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.grey.withValues(alpha: 0.3),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: LangText(_label('cancel', lang), lang, fontSize: fontSize - 1, color: AppTheme.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveCaregiver,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: LangText(_label('save', lang), lang, fontSize: fontSize - 1, color: AppTheme.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
