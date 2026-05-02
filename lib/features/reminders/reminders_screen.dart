import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<Map<String, dynamic>> _reminders = [];

  int _selectedTab = 0;

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Reminders',
      'te': 'రిమైండర్లు',
      'hi': 'रिमाइंडर',
      'ta': 'நினைவூட்டல்கள்'
    },
    'today': {
      'en': 'Today\'s Schedule',
      'te': 'ఈరోజు షెడ్యూల్',
      'hi': 'आज का कार्यक्रम',
      'ta': 'இன்றைய அட்டவணை'
    },
    'all': {
      'en': 'All Reminders',
      'te': 'అన్ని రిమైండర్లు',
      'hi': 'सभी रिमाइंडर',
      'ta': 'அனைத்து நினைவூட்டல்கள்'
    },
    'add': {
      'en': 'Add Reminder',
      'te': 'రిమైండర్ జోడించండి',
      'hi': 'रिमाइंडर जोड़ें',
      'ta': 'நினைவூட்டல் சேர்க்கவும்'
    },
    'dose': {'en': 'Dose', 'te': 'మోతాదు', 'hi': 'खुराक', 'ta': 'மருந்தளவு'},
    'daily': {'en': 'Daily', 'te': 'రోజువారీ', 'hi': 'दैनिक', 'ta': 'தினசரி'},
    'taken': {
      'en': 'Taken',
      'te': 'తీసుకున్నారు',
      'hi': 'ली गई',
      'ta': 'எடுத்தாகிவிட்டது'
    },
    'not_taken': {
      'en': 'Not Taken',
      'te': 'తీసుకోలేదు',
      'hi': 'नहीं ली',
      'ta': 'எடுக்கவில்லை'
    },
    'medicine_name': {
      'en': 'Medicine Name',
      'te': 'మందు పేరు',
      'hi': 'दवा का नाम',
      'ta': 'மருந்தின் பெயர்'
    },
    'save': {'en': 'Save', 'te': 'సేవ్', 'hi': 'सहेजें', 'ta': 'சேமி'},
    'cancel': {'en': 'Cancel', 'te': 'రద్దు', 'hi': 'रद्द', 'ta': 'ரத்து'},
    'no_reminders': {
      'en': 'No reminders yet',
      'te': 'ఇంకా రిమైండర్లు లేవు',
      'hi': 'अभी कोई रिमाइंडर नहीं',
      'ta': 'இன்னும் நினைவூட்டல்கள் இல்லை'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
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
            icon: const Icon(Icons.add, color: AppTheme.white, size: 26),
            onPressed: () => _showAddDialog(context, lang),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _tabButton(_label('today', lang), 0, lang),
                const SizedBox(width: 8),
                _tabButton(_label('all', lang), 1, lang),
              ],
            ),
          ),
          Expanded(
            child: _reminders.isEmpty
                ? Center(
                    child: LangText(_label('no_reminders', lang), lang,
                        fontSize: 16, color: AppTheme.grey),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                    itemCount: _reminders.length,
                    itemBuilder: (context, i) =>
                        _reminderCard(_reminders[i], i, lang),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, lang),
        backgroundColor: AppTheme.accent,
        icon: const Icon(Icons.add, color: AppTheme.white),
        label: LangText(_label('add', lang), lang,
            fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _tabButton(String label, int index, String lang) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : AppTheme.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: LangText(label, lang,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTheme.white : AppTheme.grey),
      ),
    );
  }

  Widget _reminderCard(Map<String, dynamic> reminder, int index, String lang) {
    final isTaken = reminder['taken'] as bool;
    final isEnabled = reminder['enabled'] as bool;
    final days = reminder['days'] as List;
    final isDaily = days.length == 7;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTaken
              ? AppTheme.success.withValues(alpha: 0.3)
              : AppTheme.accent.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isTaken
                      ? AppTheme.success.withValues(alpha: 0.15)
                      : AppTheme.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.medication,
                    color: isTaken ? AppTheme.success : AppTheme.accent,
                    size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reminder['medicine'],
                        style: const TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 2),
                    LangText(
                        '${_label('dose', lang)}: ${reminder['dose']}', lang,
                        fontSize: 13, color: AppTheme.grey),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: (val) =>
                    setState(() => _reminders[index]['enabled'] = val),
                activeThumbColor: AppTheme.accent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppTheme.accent, size: 16),
              const SizedBox(width: 4),
              Text(reminder['time'],
                  style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: LangText(
                    isDaily ? _label('daily', lang) : days.join(', '), lang,
                    fontSize: 11, color: AppTheme.accent),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    setState(() => _reminders[index]['taken'] = !isTaken),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isTaken
                        ? AppTheme.success.withValues(alpha: 0.15)
                        : AppTheme.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTaken ? Icons.check_circle : Icons.circle_outlined,
                        color: isTaken ? AppTheme.success : AppTheme.grey,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      LangText(
                        isTaken
                            ? _label('taken', lang)
                            : _label('not_taken', lang),
                        lang,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isTaken ? AppTheme.success : AppTheme.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, String lang) {
    final nameController = TextEditingController();
    final doseController = TextEditingController();
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
    final font = LanguageProvider.getFontFamily(lang);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.card,
          title: LangText(_label('add', lang), lang,
              fontSize: 16, fontWeight: FontWeight.bold),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(fontFamily: font, color: AppTheme.white),
                decoration: InputDecoration(
                  hintText: _label('medicine_name', lang),
                  hintStyle: TextStyle(fontFamily: font, color: AppTheme.grey),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.grey)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: doseController,
                style: TextStyle(fontFamily: font, color: AppTheme.white),
                decoration: InputDecoration(
                  hintText: _label('dose', lang),
                  hintStyle: TextStyle(fontFamily: font, color: AppTheme.grey),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.grey)),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                      context: ctx, initialTime: selectedTime);
                  if (time != null) setDialogState(() => selectedTime = time);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: AppTheme.accent, size: 20),
                      const SizedBox(width: 8),
                      Text(selectedTime.format(context),
                          style: const TextStyle(
                              color: AppTheme.white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: LangText(_label('cancel', lang), lang,
                  fontSize: 14, color: AppTheme.grey),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() => _reminders.add({
                        'medicine': nameController.text,
                        'time': selectedTime.format(context),
                        'dose': doseController.text.isEmpty
                            ? '1 tablet'
                            : doseController.text,
                        'days': [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ],
                        'enabled': true,
                        'taken': false,
                      }));
                }
                Navigator.pop(ctx);
              },
              child: LangText(_label('save', lang), lang,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accent),
            ),
          ],
        ),
      ),
    );
  }
}
