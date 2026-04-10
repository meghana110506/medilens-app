import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';

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
  String _gender = 'Male';
  String _bloodGroup = 'A+';

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

  final List<Map<String, String>> _genders = [
    {'en': 'Male', 'te': 'పురుషుడు', 'hi': 'पुरुष', 'ta': 'ஆண்'},
    {'en': 'Female', 'te': 'స్త్రీ', 'hi': 'महिला', 'ta': 'பெண்'},
    {'en': 'Other', 'te': 'ఇతర', 'hi': 'अन्य', 'ta': 'மற்றவர்'},
  ];

  // Labels for all 4 languages
  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Personal Details',
      'te': 'వ్యక్తిగత వివరాలు',
      'hi': 'व्यक्तिगत विवरण',
      'ta': 'தனிப்பட்ட விவரங்கள்'
    },
    'subtitle': {
      'en': 'Tell us about yourself',
      'te': 'మీ గురించి చెప్పండి',
      'hi': 'अपने बारे में बताएं',
      'ta': 'உங்களைப் பற்றி சொல்லுங்கள்'
    },
    'name': {
      'en': 'Full Name',
      'te': 'పూర్తి పేరు',
      'hi': 'पूरा नाम',
      'ta': 'முழு பெயர்'
    },
    'phone': {
      'en': 'Phone Number',
      'te': 'ఫోన్ నంబర్',
      'hi': 'फ़ोन नंबर',
      'ta': 'தொலைபேசி எண்'
    },
    'city': {'en': 'City', 'te': 'నగరం', 'hi': 'शहर', 'ta': 'நகரம்'},
    'age': {'en': 'Age', 'te': 'వయసు', 'hi': 'आयु', 'ta': 'வயது'},
    'years': {
      'en': 'years',
      'te': 'సంవత్సరాలు',
      'hi': 'वर्ष',
      'ta': 'ஆண்டுகள்'
    },
    'gender': {'en': 'Gender', 'te': 'లింగం', 'hi': 'लिंग', 'ta': 'பாலினம்'},
    'blood': {
      'en': 'Blood Group',
      'te': 'రక్త వర్గం',
      'hi': 'रक्त समूह',
      'ta': 'இரத்த வகை'
    },
    'next': {'en': 'Next', 'te': 'తదుపరి', 'hi': 'अगला', 'ta': 'அடுத்து'},
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

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(_label('title', lang)),
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.welcome),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_label('subtitle', lang),
                  style: const TextStyle(fontSize: 14, color: AppTheme.teal)),
              const SizedBox(height: 4),
              Text(_label('title', lang),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white)),
              const SizedBox(height: 32),

              _buildTextField(
                  _nameController, _label('name', lang), Icons.person),
              const SizedBox(height: 16),
              _buildTextField(
                  _phoneController, _label('phone', lang), Icons.phone,
                  isPhone: true),
              const SizedBox(height: 16),
              _buildTextField(
                  _cityController, _label('city', lang), Icons.location_city),
              const SizedBox(height: 24),

              // Age
              Text(_label('age', lang),
                  style: const TextStyle(color: AppTheme.grey, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        if (_age > 1) _age--;
                      }),
                      icon: const Icon(Icons.remove_circle,
                          color: AppTheme.accent, size: 32),
                    ),
                    Expanded(
                      child: Text(
                        '$_age ${_label('years', lang)}',
                        style: const TextStyle(
                            fontSize: 18,
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        if (_age < 120) _age++;
                      }),
                      icon: const Icon(Icons.add_circle,
                          color: AppTheme.accent, size: 32),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Gender
              Text(_label('gender', lang),
                  style: const TextStyle(color: AppTheme.grey, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: _genders
                    .map((g) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _gender = g['en']!),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _gender == g['en']
                                      ? AppTheme.accent
                                      : AppTheme.card,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Text(g['en']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _gender == g['en']
                                              ? AppTheme.white
                                              : AppTheme.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        )),
                                    Text(g[lang] ?? g['te']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _gender == g['en']
                                              ? AppTheme.white.withOpacity(0.8)
                                              : AppTheme.grey.withOpacity(0.6),
                                          fontSize: 11,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Blood Group
              Text(_label('blood', lang),
                  style: const TextStyle(color: AppTheme.grey, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _bloodGroups
                    .map((bg) => GestureDetector(
                          onTap: () => setState(() => _bloodGroup = bg),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: _bloodGroup == bg
                                  ? AppTheme.accent
                                  : AppTheme.card,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(bg,
                                style: TextStyle(
                                  color: _bloodGroup == bg
                                      ? AppTheme.white
                                      : AppTheme.grey,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => context.go(AppRoutes.healthProfile),
                child: Text(_label('next', lang)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPhone = false}) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.card, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        style: const TextStyle(color: AppTheme.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppTheme.grey),
          prefixIcon: Icon(icon, color: AppTheme.accent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
