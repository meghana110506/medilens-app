import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';

class ExpiryTrackerScreen extends StatefulWidget {
  const ExpiryTrackerScreen({super.key});

  @override
  State<ExpiryTrackerScreen> createState() => _ExpiryTrackerScreenState();
}

class _ExpiryTrackerScreenState extends State<ExpiryTrackerScreen> {
  final List<Map<String, dynamic>> _medicines = [
    {'name': 'Paracetamol', 'expiry': '2025-06-30', 'daysLeft': 85},
    {'name': 'Metformin', 'expiry': '2025-03-15', 'daysLeft': 8},
    {'name': 'Amlodipine', 'expiry': '2024-12-01', 'daysLeft': -30},
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Expiry Tracker',
      'te': 'గడువు ట్రాకర్',
      'hi': 'समाप्ति ट्रैकर',
      'ta': 'காலாவதி கண்காணிப்பு'
    },
    'subtitle': {
      'en': 'Medicine Expiry Tracker',
      'te': 'మందుల గడువు తేదీ ట్రాకర్',
      'hi': 'दवा समाप्ति ट्रैकर',
      'ta': 'மருந்து காலாவதி கண்காணிப்பு'
    },
    'expired': {
      'en': 'Expired',
      'te': 'గడువు ముగిసింది',
      'hi': 'समाप्त',
      'ta': 'காலாவதியானது'
    },
    'expiring': {
      'en': 'Expiring Soon',
      'te': 'త్వరలో గడువు ముగుస్తుంది',
      'hi': 'जल्द समाप्त होगी',
      'ta': 'விரைவில் காலாவதியாகும்'
    },
    'good': {'en': 'Good', 'te': 'మంచిది', 'hi': 'अच्छी', 'ta': 'நல்லது'},
    'add': {
      'en': 'Add Medicine',
      'te': 'మందు జోడించండి',
      'hi': 'दवा जोड़ें',
      'ta': 'மருந்து சேர்க்கவும்'
    },
    'name': {
      'en': 'Medicine Name',
      'te': 'మందు పేరు',
      'hi': 'दवा का नाम',
      'ta': 'மருந்தின் பெயர்'
    },
    'expiry_date': {
      'en': 'Select Expiry Date',
      'te': 'గడువు తేదీ ఎంచుకోండి',
      'hi': 'समाप्ति तिथि चुनें',
      'ta': 'காலாவதி தேதி தேர்ந்தெடுக்கவும்'
    },
    'days_left': {
      'en': 'd left',
      'te': 'రోజులు మిగిలాయి',
      'hi': 'दिन बचे',
      'ta': 'நாட்கள் உள்ளன'
    },
    'days_ago': {
      'en': 'd ago',
      'te': 'రోజుల క్రితం',
      'hi': 'दिन पहले',
      'ta': 'நாட்கள் முன்பு'
    },
    'cancel': {
      'en': 'Cancel',
      'te': 'రద్దు',
      'hi': 'रद्द करें',
      'ta': 'ரத்து செய்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  Color _getExpiryColor(int daysLeft) {
    if (daysLeft < 0) return AppTheme.error;
    if (daysLeft <= 30) return AppTheme.warning;
    return AppTheme.success;
  }

  String _getExpiryStatus(int daysLeft, String lang) {
    if (daysLeft < 0) return _label('expired', lang);
    if (daysLeft <= 30) return _label('expiring', lang);
    return _label('good', lang);
  }

  IconData _getExpiryIcon(int daysLeft) {
    if (daysLeft < 0) return Icons.error;
    if (daysLeft <= 30) return Icons.warning_amber;
    return Icons.check_circle;
  }

  Future<void> _addMedicine(String lang) async {
    final nameController = TextEditingController();
    DateTime? selectedDate;
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.card,
          title: Text(_label('add', lang),
              style: const TextStyle(color: AppTheme.white, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppTheme.white),
                decoration: InputDecoration(
                  labelText: _label('name', lang),
                  labelStyle: const TextStyle(color: AppTheme.grey),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.grey)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.accent)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  setDialogState(() {});
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(selectedDate != null
                    ? selectedDate!.toString().split(' ')[0]
                    : _label('expiry_date', lang)),
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_label('cancel', lang),
                  style: const TextStyle(color: AppTheme.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && selectedDate != null) {
                  final daysLeft =
                      selectedDate!.difference(DateTime.now()).inDays;
                  setState(() {
                    _medicines.add({
                      'name': nameController.text,
                      'expiry': selectedDate!.toString().split(' ')[0],
                      'daysLeft': daysLeft,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(_label('add', lang)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final expired = _medicines.where((m) => m['daysLeft'] < 0).toList();
    final expiringSoon = _medicines
        .where((m) => m['daysLeft'] >= 0 && m['daysLeft'] <= 30)
        .toList();
    final good = _medicines.where((m) => m['daysLeft'] > 30).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(_label('title', lang)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          IconButton(
            onPressed: () => _addMedicine(lang),
            icon: const Icon(Icons.add_circle, color: AppTheme.accent),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_label('subtitle', lang),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white)),
              const SizedBox(height: 24),

              // Summary
              Row(
                children: [
                  _buildSummaryCard(_label('expired', lang),
                      expired.length.toString(), AppTheme.error),
                  const SizedBox(width: 12),
                  _buildSummaryCard(_label('expiring', lang),
                      expiringSoon.length.toString(), AppTheme.warning),
                  const SizedBox(width: 12),
                  _buildSummaryCard(_label('good', lang),
                      good.length.toString(), AppTheme.success),
                ],
              ),
              const SizedBox(height: 32),

              if (expired.isNotEmpty) ...[
                _buildSectionHeader(_label('expired', lang), AppTheme.error),
                const SizedBox(height: 12),
                ...expired.map((m) => _buildMedicineCard(m, lang)),
                const SizedBox(height: 24),
              ],
              if (expiringSoon.isNotEmpty) ...[
                _buildSectionHeader(_label('expiring', lang), AppTheme.warning),
                const SizedBox(height: 12),
                ...expiringSoon.map((m) => _buildMedicineCard(m, lang)),
                const SizedBox(height: 24),
              ],
              if (good.isNotEmpty) ...[
                _buildSectionHeader(_label('good', lang), AppTheme.success),
                const SizedBox(height: 12),
                ...good.map((m) => _buildMedicineCard(m, lang)),
              ],

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _addMedicine(lang),
                icon: const Icon(Icons.add),
                label: Text(_label('add', lang)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(count,
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(fontSize: 11, color: color),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: color),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 15)),
      ],
    );
  }

  Widget _buildMedicineCard(Map<String, dynamic> medicine, String lang) {
    final color = _getExpiryColor(medicine['daysLeft']);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(_getExpiryIcon(medicine['daysLeft']),
                color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine['name'],
                    style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                Text('${medicine['expiry']}',
                    style: const TextStyle(color: AppTheme.grey, fontSize: 13)),
                Text(_getExpiryStatus(medicine['daysLeft'], lang),
                    style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Text(
            medicine['daysLeft'] < 0
                ? '${medicine['daysLeft'].abs()} ${_label('days_ago', lang)}'
                : '${medicine['daysLeft']} ${_label('days_left', lang)}',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
