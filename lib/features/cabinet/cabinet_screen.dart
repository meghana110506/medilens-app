import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/core/app_data.dart';
import 'package:medilens/core/widgets/sos_fab.dart';
import 'package:medilens/providers/language_provider.dart';

class CabinetScreen extends StatefulWidget {
  const CabinetScreen({super.key});

  @override
  State<CabinetScreen> createState() => _CabinetScreenState();
}

class _CabinetScreenState extends State<CabinetScreen> {
  String _searchQuery = '';
  // null = all, 'valid', 'expiring', 'expired'
  String? _filterStatus;

  final Map<String, Map<String, String>> _labels = {
    'title': {'en': 'My Cabinet', 'te': 'నా మందుల పెట్టె', 'hi': 'मेरी दवाएं', 'ta': 'என் மருந்துக் கொட்டகை'},
    'search': {'en': 'Search medicines...', 'te': 'మందులు వెతకండి...', 'hi': 'दवाएं खोजें...', 'ta': 'மருந்துகளை தேடுங்கள்...'},
    'empty': {'en': 'No medicines saved yet.\nScan a medicine to add it here.', 'te': 'ఇంకా మందులు సేవ్ చేయలేదు.\nమందు స్కాన్ చేసి ఇక్కడ జోడించండి.', 'hi': 'अभी कोई दवा सहेजी नहीं।\nदवा स्कैन करके यहाँ जोड़ें।', 'ta': 'இன்னும் மருந்துகள் சேமிக்கப்படவில்லை.\nமருந்தை ஸ்கேன் செய்து இங்கே சேர்க்கவும்.'},
    'total': {'en': 'Total Medicines', 'te': 'మొత్తం మందులు', 'hi': 'कुल दवाएं', 'ta': 'மொத்த மருந்துகள்'},
    'delete': {'en': 'Delete', 'te': 'తొలగించు', 'hi': 'हटाएं', 'ta': 'நீக்கு'},
    'reminder': {'en': 'Set Reminder', 'te': 'రిమైండర్ సెట్ చేయండి', 'hi': 'रिमाइंडर सेट करें', 'ta': 'நினைவூட்டல் அமைக்கவும்'},
    'add': {'en': 'Scan to Add', 'te': 'జోడించడానికి స్కాన్ చేయండి', 'hi': 'जोड़ने के लिए स्कैन करें', 'ta': 'சேர்க்க ஸ்கேன் செய்யுங்கள்'},
    'valid': {'en': 'Valid', 'te': 'చెల్లుబాటు', 'hi': 'वैध', 'ta': 'செல்லுபடியாகும்'},
    'expiring': {'en': 'Expiring', 'te': 'గడువు దగ్గరలో', 'hi': 'जल्द समाप्त', 'ta': 'விரைவில் காலாவதி'},
    'expired': {'en': 'Expired', 'te': 'గడువు తీరింది', 'hi': 'समाप्त', 'ta': 'காலாவதியானது'},
    'all': {'en': 'All', 'te': 'అన్నీ', 'hi': 'सभी', 'ta': 'அனைத்தும்'},
    'filter': {'en': 'Filter', 'te': 'ఫిల్టర్', 'hi': 'फ़िल्टर', 'ta': 'வடிகட்டு'},
    'no_results': {'en': 'No medicines match your filter.', 'te': 'మీ ఫిల్టర్‌కు సరిపోయే మందులు లేవు.', 'hi': 'आपके फ़िल्टर से कोई दवा नहीं मिली।', 'ta': 'உங்கள் வடிகட்டிக்கு பொருந்தும் மருந்துகள் இல்லை.'},
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final font = LanguageProvider.getFontFamily(lang);
    final appData = context.watch<AppData>();

    // Apply search + filter
    final medicines = appData.cabinet.where((m) {
      final matchesSearch = _searchQuery.isEmpty ||
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.generic.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _filterStatus == null || m.expiryStatus == _filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: const SOSFab(),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: [
                // Stats row
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.medical_services,
                            color: AppTheme.accent, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LangText(_label('total', lang), lang,
                              fontSize: 12, color: AppTheme.grey),
                          Text('${appData.cabinet.length}',
                              style: const TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.scan),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add,
                                  color: AppTheme.white, size: 16),
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
                const SizedBox(height: 10),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Filter chips
                Row(
                  children: [
                    LangText(_label('filter', lang), lang,
                        fontSize: 12, color: AppTheme.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _filterChip(null, _label('all', lang), AppTheme.accent, lang),
                            const SizedBox(width: 6),
                            _filterChip('valid', _label('valid', lang), AppTheme.success, lang),
                            const SizedBox(width: 6),
                            _filterChip('expiring', _label('expiring', lang), AppTheme.warning, lang),
                            const SizedBox(width: 6),
                            _filterChip('expired', _label('expired', lang), AppTheme.error, lang),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: medicines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.medical_services,
                            color: AppTheme.grey, size: 64),
                        const SizedBox(height: 16),
                        LangText(
                          _filterStatus != null || _searchQuery.isNotEmpty
                              ? _label('no_results', lang)
                              : _label('empty', lang),
                          lang,
                          fontSize: 14,
                          color: AppTheme.grey,
                          textAlign: TextAlign.center,
                        ),
                        if (_filterStatus == null && _searchQuery.isEmpty) ...[
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                    itemCount: medicines.length,
                    itemBuilder: (context, i) =>
                        _medicineCard(medicines[i], appData.cabinet.indexOf(medicines[i]), lang, appData),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String? status, String label, Color color, String lang) {
    final isSelected = _filterStatus == status;
    return GestureDetector(
      onTap: () => setState(() => _filterStatus = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppTheme.grey.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppTheme.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontFamily: LanguageProvider.getFontFamily(lang),
          ),
        ),
      ),
    );
  }

  Widget _medicineCard(
      MedicineEntry medicine, int index, String lang, AppData appData) {
    final statusColor = medicine.expiryStatus == 'valid'
        ? AppTheme.success
        : medicine.expiryStatus == 'expiring'
            ? AppTheme.warning
            : AppTheme.error;
    final statusLabel = medicine.expiryStatus == 'valid'
        ? _label('valid', lang)
        : medicine.expiryStatus == 'expiring'
            ? _label('expiring', lang)
            : _label('expired', lang);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: medicine.expiryStatus == 'expired'
              ? AppTheme.error.withValues(alpha: 0.3)
              : AppTheme.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication,
                color: AppTheme.accent, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine.name,
                    style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Text(medicine.generic,
                    style:
                        const TextStyle(color: AppTheme.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: [
                    _chip(medicine.strength, AppTheme.accent),
                    _chip(medicine.type, AppTheme.teal),
                    _chip(statusLabel, statusColor),
                  ],
                ),
                if (medicine.expiryDate.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Exp: ${medicine.expiryDate}',
                        style:
                            TextStyle(color: statusColor, fontSize: 11)),
                  ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppTheme.grey),
            color: AppTheme.card,
            onSelected: (val) {
              if (val == 'reminder') {
                context.go(AppRoutes.reminders);
              } else if (val == 'delete') {
                appData.removeMedicine(index);
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'reminder',
                child: Row(children: [
                  const Icon(Icons.alarm, color: AppTheme.accent, size: 18),
                  const SizedBox(width: 8),
                  LangText(_label('reminder', lang), lang, fontSize: 14),
                ]),
              ),
              PopupMenuItem(
                value: 'delete',
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
