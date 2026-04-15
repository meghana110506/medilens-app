import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/providers/language_provider.dart';

class MedicineInfoScreen extends StatefulWidget {
  const MedicineInfoScreen({super.key});

  @override
  State<MedicineInfoScreen> createState() => _MedicineInfoScreenState();
}

class _MedicineInfoScreenState extends State<MedicineInfoScreen> {
  bool _isSaved = false;
  int _selectedTab = 0;

  final Map<String, dynamic> _medicineData = {
    'name': 'Paracetamol',
    'generic': 'Acetaminophen',
    'strength': '500mg',
    'manufacturer': 'Generic Pharma',
    'type': 'Tablet',
    'uses_en': 'Fever, Headache, Body pain, Mild to moderate pain relief',
    'uses_te': 'జ్వరం, తలనొప్పి, శరీర నొప్పి, మితమైన నొప్పి నుండి ఉపశమనం',
    'uses_hi': 'बुखार, सिरदर्द, शरीर दर्द, हल्के से मध्यम दर्द से राहत',
    'uses_ta': 'காய்ச்சல், தலைவலி, உடல் வலி, லேசான முதல் மிதமான வலி நிவாரணம்',
    'dosage_en': 'Adults: 1-2 tablets every 4-6 hours. Max 8 tablets per day.',
    'dosage_te':
        'పెద్దలు: ప్రతి 4-6 గంటలకు 1-2 మాత్రలు. రోజుకు గరిష్టంగా 8 మాత్రలు.',
    'dosage_hi':
        'वयस्क: हर 4-6 घंटे में 1-2 गोलियां। प्रति दिन अधिकतम 8 गोलियां।',
    'dosage_ta':
        'பெரியவர்கள்: ஒவ்வொரு 4-6 மணி நேரத்திற்கும் 1-2 மாத்திரைகள். தினமும் அதிகபட்சம் 8 மாத்திரைகள்.',
    'side_effects_en':
        'Nausea, Vomiting, Stomach pain, Allergic reactions (rare)',
    'side_effects_te':
        'వికారం, వాంతులు, కడుపు నొప్పి, అలెర్జీ ప్రతిచర్యలు (అరుదు)',
    'side_effects_hi': 'मतली, उल्टी, पेट दर्द, एलर्जी प्रतिक्रियाएं (दुर्लभ)',
    'side_effects_ta':
        'குமட்டல், வாந்தி, வயிற்று வலி, ஒவ்வாமை எதிர்வினைகள் (அரிதானது)',
    'warnings_en':
        'Do not exceed recommended dose. Avoid alcohol. Consult doctor if symptoms persist.',
    'warnings_te':
        'సిఫార్సు మోతాదు మించవద్దు. మద్యం నివారించండి. లక్షణాలు కొనసాగితే వైద్యుడిని సంప్రదించండి.',
    'warnings_hi':
        'अनुशंसित खुराक से अधिक न लें। शराब से बचें। यदि लक्षण बने रहें तो डॉक्टर से सलाह लें।',
    'warnings_ta':
        'பரிந்துரைக்கப்பட்ட அளவை மீறாதீர்கள். மது தவிர்க்கவும். அறிகுறிகள் தொடர்ந்தால் மருத்துவரை அணுகவும்.',
    'storage_en':
        'Store below 25°C. Keep away from moisture and direct sunlight.',
    'storage_te':
        '25°C కంటే తక్కువ ఉష్ణోగ్రతలో నిల్వ చేయండి. తేమ మరియు నేరుగా సూర్యకాంతి నుండి దూరంగా ఉంచండి.',
    'storage_hi': '25°C से नीचे स्टोर करें। नमी और सीधी धूप से दूर रखें।',
    'storage_ta':
        '25°C க்கு கீழே சேமிக்கவும். ஈரப்பதம் மற்றும் நேரடி சூரிய ஒளியிலிருந்து விலக்கி வையுங்கள்.',
  };

  final List<Map<String, String>> _tabs = [
    {'en': 'Uses', 'te': 'ఉపయోగాలు', 'hi': 'उपयोग', 'ta': 'பயன்கள்'},
    {'en': 'Dosage', 'te': 'మోతాదు', 'hi': 'खुराक', 'ta': 'மருந்தளவு'},
    {
      'en': 'Side Effects',
      'te': 'దుష్ప్రభావాలు',
      'hi': 'दुष्प्रभाव',
      'ta': 'பக்க விளைவுகள்'
    },
    {
      'en': 'Warnings',
      'te': 'హెచ్చరికలు',
      'hi': 'चेतावनियाँ',
      'ta': 'எச்சரிக்கைகள்'
    },
    {'en': 'Storage', 'te': 'నిల్వ', 'hi': 'भंडारण', 'ta': 'சேமிப்பு'},
  ];

  String _getTabContent(String tabKey, String lang) {
    final key = '${tabKey}_$lang';
    return _medicineData[key] ?? _medicineData['${tabKey}_en'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
    final lang = provider.language;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: const Text('Medicine Info',
            style:
                TextStyle(color: AppTheme.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: _isSaved ? AppTheme.accent : AppTheme.white),
            onPressed: () => setState(() => _isSaved = !_isSaved),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up, color: AppTheme.white),
            onPressed: () {
              final tabKey = [
                'uses',
                'dosage',
                'side_effects',
                'warnings',
                'storage'
              ][_selectedTab];
              provider.speak(_getTabContent(tabKey, lang));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Medicine header
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.medication,
                      color: AppTheme.accent, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_medicineData['name'],
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white)),
                      Text(_medicineData['generic'],
                          style: const TextStyle(
                              fontSize: 14, color: AppTheme.teal)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _chip(_medicineData['strength'], AppTheme.accent),
                          const SizedBox(width: 8),
                          _chip(_medicineData['type'], AppTheme.teal),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tabs
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tabs.length,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedTab == i ? AppTheme.accent : AppTheme.card,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_tabs[i][lang] ?? _tabs[i]['en']!,
                      style: TextStyle(
                        color:
                            _selectedTab == i ? AppTheme.white : AppTheme.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      )),
                ),
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTabContent(
                            [
                              'uses',
                              'dosage',
                              'side_effects',
                              'warnings',
                              'storage'
                            ][_selectedTab],
                            'en',
                          ),
                          style: const TextStyle(
                              color: AppTheme.white, fontSize: 16, height: 1.6),
                        ),
                        if (lang != 'en') ...[
                          const Divider(color: AppTheme.grey, height: 24),
                          Text(
                            _getTabContent(
                              [
                                'uses',
                                'dosage',
                                'side_effects',
                                'warnings',
                                'storage'
                              ][_selectedTab],
                              lang,
                            ),
                            style: const TextStyle(
                                color: AppTheme.teal,
                                fontSize: 15,
                                height: 1.6),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.go(AppRoutes.cabinet),
                          icon: const Icon(Icons.save),
                          label: const Text('Save to Cabinet'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.teal,
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.go(AppRoutes.reminders),
                          icon: const Icon(Icons.alarm),
                          label: const Text('Set Reminder'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.card,
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}


