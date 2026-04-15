import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/providers/language_provider.dart';

class ExpiryTrackerScreen extends StatefulWidget {
  const ExpiryTrackerScreen({super.key});

  @override
  State<ExpiryTrackerScreen> createState() => _ExpiryTrackerScreenState();
}

class _ExpiryTrackerScreenState extends State<ExpiryTrackerScreen> {
  final List<Map<String, dynamic>> _medicines = [
    {
      'name': 'Paracetamol',
      'brand': 'Crocin',
      'expiry': DateTime(2025, 8, 15),
      'quantity': 10
    },
    {
      'name': 'Metformin',
      'brand': 'Glycomet',
      'expiry': DateTime(2024, 12, 31),
      'quantity': 30
    },
    {
      'name': 'Amlodipine',
      'brand': 'Amlokind',
      'expiry': DateTime(2026, 3, 20),
      'quantity': 15
    },
    {
      'name': 'Aspirin',
      'brand': 'Ecosprin',
      'expiry': DateTime(2024, 11, 10),
      'quantity': 5
    },
    {
      'name': 'Omeprazole',
      'brand': 'Omez',
      'expiry': DateTime(2025, 6, 30),
      'quantity': 20
    },
    {
      'name': 'Atorvastatin',
      'brand': 'Atorva',
      'expiry': DateTime(2026, 1, 15),
      'quantity': 25
    },
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Expiry Tracker',
      'te': 'గడువు ట్రాకర్',
      'hi': 'समाप्ति ट्रैकर',
      'ta': 'காலாவதி கண்காணிப்பு'
    },
    'expired': {
      'en': 'Expired',
      'te': 'గడువు తీరింది',
      'hi': 'समाप्त हो गई',
      'ta': 'காலாவதியானது'
    },
    'expiring_soon': {
      'en': 'Expiring Soon',
      'te': 'త్వరలో గడువు తీరుతోంది',
      'hi': 'जल्द समाप्त होगी',
      'ta': 'விரைவில் காலாவதியாகும்'
    },
    'good': {'en': 'Good', 'te': 'మంచిది', 'hi': 'अच्छी', 'ta': 'நல்லது'},
    'qty': {'en': 'Qty', 'te': 'పరిమాణం', 'hi': 'मात्रा', 'ta': 'அளவு'},
    'add': {
      'en': 'Add Medicine',
      'te': 'మందు జోడించండి',
      'hi': 'दवा जोड़ें',
      'ta': 'மருந்தை சேர்க்கவும்'
    },
    'expires': {
      'en': 'Expires',
      'te': 'గడువు',
      'hi': 'समाप्ति',
      'ta': 'காலாவதி'
    },
    'days_left': {
      'en': 'days left',
      'te': 'రోజులు మిగిలాయి',
      'hi': 'दिन बचे हैं',
      'ta': 'நாட்கள் மீதம்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  int _daysUntilExpiry(DateTime expiry) {
    return expiry.difference(DateTime.now()).inDays;
  }

  Color _expiryColor(int days) {
    if (days < 0) return AppTheme.error;
    if (days <= 30) return AppTheme.warning;
    return AppTheme.success;
  }

  String _expiryStatus(int days, String lang) {
    if (days < 0) return _label('expired', lang);
    if (days <= 30) return _label('expiring_soon', lang);
    return _label('good', lang);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final now = DateTime.now();

    final expired = _medicines
        .where((m) => (m['expiry'] as DateTime).isBefore(now))
        .toList();
    final expiringSoon = _medicines.where((m) {
      final days = _daysUntilExpiry(m['expiry'] as DateTime);
      return days >= 0 && days <= 30;
    }).toList();
    final good = _medicines
        .where((m) => _daysUntilExpiry(m['expiry'] as DateTime) > 30)
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text(_label('title', lang),
            style: const TextStyle(
                color: AppTheme.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.white),
            onPressed: () => _showAddDialog(context, lang),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _summaryCard(_label('expired', lang), expired.length.toString(),
                    AppTheme.error),
                const SizedBox(width: 12),
                _summaryCard(_label('expiring_soon', lang),
                    expiringSoon.length.toString(), AppTheme.warning),
                const SizedBox(width: 12),
                _summaryCard(_label('good', lang), good.length.toString(),
                    AppTheme.success),
              ],
            ),
            const SizedBox(height: 24),
            if (expired.isNotEmpty) ...[
              _sectionHeader(_label('expired', lang), AppTheme.error),
              const SizedBox(height: 8),
              ...expired.map((m) => _medicineCard(m, lang)),
              const SizedBox(height: 16),
            ],
            if (expiringSoon.isNotEmpty) ...[
              _sectionHeader(_label('expiring_soon', lang), AppTheme.warning),
              const SizedBox(height: 8),
              ...expiringSoon.map((m) => _medicineCard(m, lang)),
              const SizedBox(height: 16),
            ],
            if (good.isNotEmpty) ...[
              _sectionHeader(_label('good', lang), AppTheme.success),
              const SizedBox(height: 8),
              ...good.map((m) => _medicineCard(m, lang)),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, lang),
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add, color: AppTheme.white),
        label: Text(_label('add', lang),
            style: const TextStyle(color: AppTheme.white)),
      ),
    );
  }

  Widget _summaryCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(count,
                style: TextStyle(
                    color: color, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(color: color, fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _medicineCard(Map<String, dynamic> medicine, String lang) {
    final days = _daysUntilExpiry(medicine['expiry'] as DateTime);
    final color = _expiryColor(days);
    final status = _expiryStatus(days, lang);
    final expiry = medicine['expiry'] as DateTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.medication, color: color, size: 26),
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
                        fontSize: 15)),
                Text(medicine['brand'],
                    style: const TextStyle(color: AppTheme.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                    '${_label('expires', lang)}: ${expiry.day}/${expiry.month}/${expiry.year}',
                    style: const TextStyle(color: AppTheme.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(status,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              Text(
                days < 0
                    ? '${days.abs()} ${_label('days_left', lang)}'
                    : '$days ${_label('days_left', lang)}',
                style: TextStyle(color: color, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, String lang) {
    final nameController = TextEditingController();
    final brandController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: Text(_label('add', lang),
            style: const TextStyle(color: AppTheme.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: AppTheme.white),
              decoration: const InputDecoration(
                hintText: 'Medicine name',
                hintStyle: TextStyle(color: AppTheme.grey),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.grey)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: brandController,
              style: const TextStyle(color: AppTheme.white),
              decoration: const InputDecoration(
                hintText: 'Brand name',
                hintStyle: TextStyle(color: AppTheme.grey),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.grey)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.grey)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() => _medicines.add({
                      'name': nameController.text,
                      'brand': brandController.text,
                      'expiry': DateTime.now().add(const Duration(days: 365)),
                      'quantity': 0,
                    }));
              }
              Navigator.pop(ctx);
            },
            child: Text(_label('add', lang),
                style: const TextStyle(color: AppTheme.accent)),
          ),
        ],
      ),
    );
  }
}


