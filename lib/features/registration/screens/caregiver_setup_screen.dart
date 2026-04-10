import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';

class CaregiverSetupScreen extends StatefulWidget {
  const CaregiverSetupScreen({super.key});

  @override
  State<CaregiverSetupScreen> createState() => _CaregiverSetupScreenState();
}

class _CaregiverSetupScreenState extends State<CaregiverSetupScreen> {
  final List<Map<String, TextEditingController>> _caregivers = [
    {
      'name': TextEditingController(),
      'phone': TextEditingController(),
      'relationship': TextEditingController(),
    }
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Caregiver Setup',
      'te': 'సంరక్షకుల వివరాలు',
      'hi': 'देखभाल करने वाले',
      'ta': 'பராமரிப்பாளர் அமைப்பு'
    },
    'subtitle': {
      'en': 'Add Caregivers',
      'te': 'సంరక్షకులను జోడించండి',
      'hi': 'देखभालकर्ता जोड़ें',
      'ta': 'பராமரிப்பாளர்களை சேர்க்கவும்'
    },
    'desc': {
      'en': 'They will be alerted in emergencies via SOS',
      'te': 'అత్యవసర సమయంలో వారికి SOS అలర్ట్ వెళ్తుంది',
      'hi': 'आपात स्थिति में उन्हें SOS अलर्ट भेजा जाएगा',
      'ta': 'அவசரநிலையில் அவர்களுக்கு SOS அலர்ட் அனுப்பப்படும்'
    },
    'name': {'en': 'Name', 'te': 'పేరు', 'hi': 'नाम', 'ta': 'பெயர்'},
    'phone': {'en': 'Phone', 'te': 'ఫోన్', 'hi': 'फ़ोन', 'ta': 'தொலைபேசி'},
    'relation': {
      'en': 'Relationship',
      'te': 'సంబంధం',
      'hi': 'संबंध',
      'ta': 'உறவு'
    },
    'primary': {
      'en': 'Primary Caregiver',
      'te': 'ప్రాథమిక సంరక్షకుడు',
      'hi': 'प्राथमिक देखभालकर्ता',
      'ta': 'முதன்மை பராமரிப்பாளர்'
    },
    'add': {
      'en': 'Add Another Caregiver',
      'te': 'మరొకరిని జోడించండి',
      'hi': 'और जोड़ें',
      'ta': 'மற்றொருவரை சேர்க்கவும்'
    },
    'next': {'en': 'Next', 'te': 'తదుపరి', 'hi': 'अगला', 'ta': 'அடுத்து'},
    'skip': {
      'en': 'Skip for now',
      'te': 'ఇప్పుడు దాటవేయండి',
      'hi': 'अभी छोड़ें',
      'ta': 'இப்போது தவிர்'
    },
  };

  final List<Map<String, String>> _relationships = [
    {'en': 'Son', 'te': 'కొడుకు', 'hi': 'बेटा', 'ta': '息子'},
    {'en': 'Daughter', 'te': 'కూతురు', 'hi': 'बेटी', 'ta': 'மகள்'},
    {
      'en': 'Spouse',
      'te': 'జీవిత భాగస్వామి',
      'hi': 'जीवनसाथी',
      'ta': 'வாழ்க்கைத்துணை'
    },
    {'en': 'Brother', 'te': 'అన్న/తమ్ముడు', 'hi': 'भाई', 'ta': 'சகோதரன்'},
    {'en': 'Sister', 'te': 'అక్క/చెల్లి', 'hi': 'बहन', 'ta': 'சகோதரி'},
    {'en': 'Friend', 'te': 'స్నేహితుడు', 'hi': 'दोस्त', 'ta': 'நண்பர்'},
    {
      'en': 'Neighbour',
      'te': 'పొరుగువారు',
      'hi': 'पड़ोसी',
      'ta': 'அண்டை வீட்டார்'
    },
    {'en': 'Other', 'te': 'ఇతర', 'hi': 'अन्य', 'ta': 'மற்றவர்'},
  ];

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  void _addCaregiver() {
    if (_caregivers.length < 3) {
      setState(() {
        _caregivers.add({
          'name': TextEditingController(),
          'phone': TextEditingController(),
          'relationship': TextEditingController(),
        });
      });
    }
  }

  void _removeCaregiver(int index) {
    if (_caregivers.length > 1) {
      setState(() {
        _caregivers[index].forEach((_, c) => c.dispose());
        _caregivers.removeAt(index);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _caregivers) {
      c.forEach((_, controller) => controller.dispose());
    }
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
          onPressed: () => context.go(AppRoutes.healthProfile),
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
              Text(_label('desc', lang),
                  style: const TextStyle(fontSize: 13, color: AppTheme.grey)),
              const SizedBox(height: 32),
              ...List.generate(_caregivers.length,
                  (index) => _buildCaregiverCard(index, lang)),
              if (_caregivers.length < 3)
                GestureDetector(
                  onTap: _addCaregiver,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppTheme.accent.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle, color: AppTheme.accent),
                        const SizedBox(width: 8),
                        Text(_label('add', lang),
                            style: const TextStyle(
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.accessibility),
                child: Text(_label('next', lang)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(AppRoutes.accessibility),
                child: Text(_label('skip', lang),
                    style: const TextStyle(color: AppTheme.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaregiverCard(int index, String lang) {
    final isFirst = index == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: isFirst
            ? Border.all(color: AppTheme.accent.withOpacity(0.5))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isFirst
                    ? '★ ${_label('primary', lang)}'
                    : 'Caregiver ${index + 1}',
                style: TextStyle(
                  color: isFirst ? AppTheme.accent : AppTheme.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              if (!isFirst)
                IconButton(
                  onPressed: () => _removeCaregiver(index),
                  icon: const Icon(Icons.remove_circle,
                      color: AppTheme.error, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
              _caregivers[index]['name']!, _label('name', lang), Icons.person),
          const SizedBox(height: 12),
          _buildTextField(
              _caregivers[index]['phone']!, _label('phone', lang), Icons.phone,
              isPhone: true),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _caregivers[index]['relationship']!.text.isEmpty
                    ? null
                    : _caregivers[index]['relationship']!.text,
                hint: Text(_label('relation', lang),
                    style: const TextStyle(color: AppTheme.grey)),
                dropdownColor: AppTheme.card,
                isExpanded: true,
                items: _relationships
                    .map((r) => DropdownMenuItem(
                          value: r['en'],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(r['en']!,
                                  style: const TextStyle(
                                      color: AppTheme.white, fontSize: 14)),
                              Text(r[lang] ?? r['te']!,
                                  style: const TextStyle(
                                      color: AppTheme.grey, fontSize: 11)),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (val) => setState(
                    () => _caregivers[index]['relationship']!.text = val ?? ''),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPhone = false}) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.background, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        style: const TextStyle(color: AppTheme.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppTheme.grey, fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.accent, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
