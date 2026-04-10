import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';

class HealthProfileScreen extends StatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  final _doctorNameController = TextEditingController();
  final _doctorPhoneController = TextEditingController();
  final List<String> _selectedConditions = [];

  final List<Map<String, String>> _conditions = [
    {'en': 'Diabetes', 'te': 'మధుమేహం', 'hi': 'मधुमेह', 'ta': 'நீரிழிவு'},
    {
      'en': 'Hypertension',
      'te': 'రక్తపోటు',
      'hi': 'उच्च रक्तचाप',
      'ta': 'உயர் இரத்த அழுத்தம்'
    },
    {
      'en': 'Heart Disease',
      'te': 'గుండె జబ్బు',
      'hi': 'हृदय रोग',
      'ta': 'இதய நோய்'
    },
    {'en': 'Asthma', 'te': 'ఆస్తమా', 'hi': 'अस्थमा', 'ta': 'ஆஸ்துமா'},
    {
      'en': 'Kidney Disease',
      'te': 'మూత్రపిండాల జబ్బు',
      'hi': 'गुर्दे की बीमारी',
      'ta': 'சிறுநீரக நோய்'
    },
    {'en': 'Thyroid', 'te': 'థైరాయిడ్', 'hi': 'थायराइड', 'ta': 'தைராய்டு'},
    {'en': 'Arthritis', 'te': 'కీళ్ల నొప్పి', 'hi': 'गठिया', 'ta': 'மூட்டுவலி'},
    {
      'en': 'Eye Problems',
      'te': 'కళ్ల సమస్యలు',
      'hi': 'आँखों की समस्या',
      'ta': 'கண் பிரச்சனைகள்'
    },
    {'en': 'Cancer', 'te': 'క్యాన్సర్', 'hi': 'कैंसर', 'ta': 'புற்றுநோய்'},
    {
      'en': 'Liver Disease',
      'te': 'కాలేయ జబ్బు',
      'hi': 'लिवर की बीमारी',
      'ta': 'கல்லீரல் நோய்'
    },
    {'en': 'Stroke', 'te': 'పక్షవాతం', 'hi': 'स्ट्रोक', 'ta': 'பக்கவாதம்'},
    {
      'en': 'Epilepsy',
      'te': 'మూర్ఛ వ్యాధి',
      'hi': 'मिर्गी',
      'ta': 'வலிப்பு நோய்'
    },
    {'en': 'Depression', 'te': 'మాంద్యం', 'hi': 'अवसाद', 'ta': 'மன அழுத்தம்'},
    {
      'en': 'Alzheimer\'s',
      'te': 'మతిమరుపు',
      'hi': 'अल्जाइमर',
      'ta': 'அல்சைமர்'
    },
    {
      'en': 'Parkinson\'s',
      'te': 'పార్కిన్సన్స్',
      'hi': 'पार्किंसन',
      'ta': 'பார்கின்சன்'
    },
    {
      'en': 'Osteoporosis',
      'te': 'ఎముక బలహీనత',
      'hi': 'ऑस्टियोपोरोसिस',
      'ta': 'எலும்பு பலவீனம்'
    },
    {'en': 'Anemia', 'te': 'రక్తహీనత', 'hi': 'एनीमिया', 'ta': 'இரத்த சோகை'},
    {'en': 'Obesity', 'te': 'స్థూలకాయం', 'hi': 'मोटापा', 'ta': 'உடல் பருமன்'},
    {
      'en': 'COPD',
      'te': 'శ్వాస జబ్బు',
      'hi': 'सीओपीडी',
      'ta': 'நுரையீரல் நோய்'
    },
    {'en': 'None', 'te': 'ఏదీ లేదు', 'hi': 'कोई नहीं', 'ta': 'எதுவும் இல்லை'},
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Health Profile',
      'te': 'ఆరోగ్య వివరాలు',
      'hi': 'स्वास्थ्य प्रोफ़ाइल',
      'ta': 'உடல்நல விவரங்கள்'
    },
    'subtitle': {
      'en': 'Your Health Profile',
      'te': 'మీ ఆరోగ్య వివరాలు',
      'hi': 'आपकी स्वास्थ्य प्रोफ़ाइल',
      'ta': 'உங்கள் உடல்நல விவரங்கள்'
    },
    'conditions': {
      'en': 'Existing Conditions',
      'te': 'ఉన్న జబ్బులు',
      'hi': 'मौजूदा बीमारियाँ',
      'ta': 'தற்போதைய நோய்கள்'
    },
    'doctor': {
      'en': 'Doctor Details',
      'te': 'డాక్టర్ వివరాలు',
      'hi': 'डॉक्टर विवरण',
      'ta': 'மருத்துவர் விவரங்கள்'
    },
    'doctor_name': {
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
    'next': {'en': 'Next', 'te': 'తదుపరి', 'hi': 'अगला', 'ta': 'அடுத்து'},
    'helps': {
      'en': 'This helps us give better medicine warnings',
      'te': 'ఇది మెరుగైన హెచ్చరికలు ఇవ్వడానికి సహాయపడుతుంది',
      'hi': 'यह बेहतर दवा चेतावनियाँ देने में मदद करता है',
      'ta': 'இது சிறந்த மருந்து எச்சரிக்கைகள் வழங்க உதவுகிறது'
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
          onPressed: () => context.go(AppRoutes.personalDetails),
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
              const SizedBox(height: 8),
              Text(_label('helps', lang),
                  style: const TextStyle(fontSize: 14, color: AppTheme.grey)),
              const SizedBox(height: 32),
              Text(_label('conditions', lang),
                  style: const TextStyle(color: AppTheme.grey, fontSize: 14)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _conditions.map((c) {
                  final isSelected = _selectedConditions.contains(c['en']);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (c['en'] == 'None') {
                        _selectedConditions.clear();
                        _selectedConditions.add('None');
                      } else {
                        _selectedConditions.remove('None');
                        if (isSelected) {
                          _selectedConditions.remove(c['en']);
                        } else {
                          _selectedConditions.add(c['en']!);
                        }
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accent : AppTheme.card,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: AppTheme.accent)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(c['en']!,
                              style: TextStyle(
                                color:
                                    isSelected ? AppTheme.white : AppTheme.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              )),
                          Text(c[lang] ?? c['te']!,
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.white.withOpacity(0.8)
                                    : AppTheme.grey.withOpacity(0.7),
                                fontSize: 11,
                              )),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Text(_label('doctor', lang),
                  style: const TextStyle(color: AppTheme.grey, fontSize: 14)),
              const SizedBox(height: 12),
              _buildTextField(_doctorNameController,
                  _label('doctor_name', lang), Icons.local_hospital),
              const SizedBox(height: 16),
              _buildTextField(_doctorPhoneController,
                  _label('doctor_phone', lang), Icons.phone,
                  isPhone: true),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.caregiverSetup),
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
