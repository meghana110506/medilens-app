import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class CabinetScreen extends StatefulWidget {
  const CabinetScreen({super.key});

  @override
  State<CabinetScreen> createState() => _CabinetScreenState();
}

class _CabinetScreenState extends State<CabinetScreen> {
  final List<Map<String, dynamic>> _medicines = [];
  String _searchQuery = '';

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'My Cabinet',
      'te': 'నా మందుల పెట్టె',
      'hi': 'मेरी दवाएं',
      'ta': 'என் மருந்துக் கொட்டகை'
    },
    'search': {
      'en': 'Search medicines...',
      'te': 'మందులు వెతకండి...',
      'hi': 'दवाएं खोजें...',
      'ta': 'மருந்துகளை தேடுங்கள்...'
    },
    'empty': {
      'en': 'No medicines saved yet.\nScan a medicine to add it here.',
      'te': 'ఇంకా మందులు సేవ్ చేయలేదు.\nమందు స్కాన్ చేసి ఇక్కడ జోడించండి.',
      'hi': 'अभी कोई दवा सहेजी नहीं।\nदवा स्कैन करके यहाँ जोड़ें।',
      'ta':
          'இன்னும் மருந்துகள் சேமிக்கப்படவில்லை.\nமருந்தை ஸ்கேன் செய்து இங்கே சேர்க்கவும்.'
    },
    'total': {
      'en': 'Total Medicines',
      'te': 'మొత్తం మందులు',
      'hi': 'कुल दवाएं',
      'ta': 'மொத்த மருந்துகள்'
    },
    'qty': {'en': 'Qty', 'te': 'పరిమాణం', 'hi': 'मात्रा', 'ta': 'அளவு'},
    'delete': {'en': 'Delete', 'te': 'తొలగించు', 'hi': 'हटाएं', 'ta': 'நீக்கு'},
    'reminder': {
      'en': 'Set Reminder',
      'te': 'రిమైండర్ సెట్ చేయండి',
      'hi': 'रिमाइंडर सेट करें',
      'ta': 'நினைவூட்டல் அமைக்கவும்'
    },
    'add': {
      'en': 'Scan to Add',
      'te': 'జోడించడానికి స్కాన్ చేయండి',
      'hi': 'जोड़ने के लिए स्कैन करें',
      'ta': 'சேர்க்க ஸ்கேன் செய்யுங்கள்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  List<Map<String, dynamic>> get _filteredMedicines {
    if (_searchQuery.isEmpty) return _medicines;
    return _medicines
        .where((m) =>
            m['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m['generic'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final font = LanguageProvider.getFontFamily(lang);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: LangText(_label('title', lang), lang,
            fontSize: 18, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: AppTheme.white),
            onPressed: () => context.go(AppRoutes.scan),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.medical_services,
                            color: AppTheme.accent, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LangText(_label('total', lang), lang,
                              fontSize: 13, color: AppTheme.grey),
                          Text('${_medicines.length}',
                              style: const TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.scan),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Icon(Icons.add,
                                  color: AppTheme.white, size: 18),
                              const SizedBox(width: 4),
                              LangText(_label('add', lang), lang,
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(16)),
                  child: TextField(
                    style: TextStyle(fontFamily: font, color: AppTheme.white),
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: _label('search', lang),
                      hintStyle:
                          TextStyle(fontFamily: font, color: AppTheme.grey),
                      prefixIcon:
                          const Icon(Icons.search, color: AppTheme.accent),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredMedicines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.medical_services,
                            color: AppTheme.grey, size: 64),
                        const SizedBox(height: 16),
                        LangText(_label('empty', lang), lang,
                            fontSize: 15,
                            color: AppTheme.grey,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.scan),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [AppTheme.accent, AppTheme.teal]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.camera_alt,
                                    color: AppTheme.white, size: 20),
                                const SizedBox(width: 8),
                                LangText(_label('add', lang), lang,
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredMedicines.length,
                    itemBuilder: (context, i) =>
                        _medicineCard(_filteredMedicines[i], i, lang),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _medicineCard(Map<String, dynamic> medicine, int index, String lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                const Icon(Icons.medication, color: AppTheme.accent, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine['name'],
                    style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(medicine['generic'],
                    style: const TextStyle(color: AppTheme.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _chip(medicine['strength'], AppTheme.accent),
                    const SizedBox(width: 6),
                    _chip(medicine['type'], AppTheme.teal),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.grey),
            color: AppTheme.card,
            itemBuilder: (ctx) => [
              PopupMenuItem(
                onTap: () => context.go(AppRoutes.reminders),
                child: Row(children: [
                  const Icon(Icons.alarm, color: AppTheme.accent, size: 18),
                  const SizedBox(width: 8),
                  LangText(_label('reminder', lang), lang, fontSize: 14),
                ]),
              ),
              PopupMenuItem(
                onTap: () => setState(() => _medicines.removeAt(index)),
                child: Row(children: [
                  const Icon(Icons.delete, color: AppTheme.error, size: 18),
                  const SizedBox(width: 8),
                  LangText(_label('delete', lang), lang,
                      fontSize: 14, color: AppTheme.error),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w500)),
    );
  }
}
