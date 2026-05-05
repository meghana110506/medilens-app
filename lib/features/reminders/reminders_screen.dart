import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/core/app_data.dart';
import 'package:medilens/providers/language_provider.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': '🔔 My Reminders',
      'te': '🔔 నా రిమైండర్లు',
      'hi': '🔔 मेरे रिमाइंडर',
      'ta': '🔔 என் நினைவூட்டல்கள்'
    },
    'sub': {
      'en': 'Never miss your medicine again',
      'te': 'మీ మందు ఎప్పుడూ మిస్ చేయకండి',
      'hi': 'अपनी दवा कभी न भूलें',
      'ta': 'உங்கள் மருந்தை ஒருபோதும் தவறவிடாதீர்கள்'
    },
    'empty': {
      'en': 'No reminders set yet.\nAdd a reminder to get started.',
      'te':
          'ఇంకా రిమైండర్లు సెట్ చేయలేదు.\nప్రారంభించడానికి రిమైండర్ జోడించండి.',
      'hi': 'अभी कोई रिमाइंडर सेट नहीं।\nशुरू करने के लिए रिमाइंडर जोड़ें।',
      'ta':
          'இன்னும் நினைவூட்டல்கள் அமைக்கப்படவில்லை.\nதொடங்க நினைவூட்டல் சேர்க்கவும்.'
    },
    'add': {
      'en': '+ Add Reminder',
      'te': '+ రిమైండర్ జోడించు',
      'hi': '+ रिमाइंडर जोड़ें',
      'ta': '+ நினைவூட்டல் சேர்'
    },
    'medicine': {
      'en': 'Medicine Name',
      'te': 'మందు పేరు',
      'hi': 'दवा का नाम',
      'ta': 'மருந்தின் பெயர்'
    },
    'time': {'en': 'Time', 'te': 'సమయం', 'hi': 'समय', 'ta': 'நேரம்'},
    'frequency': {
      'en': 'Frequency',
      'te': 'పౌనఃపున్యం',
      'hi': 'बारंबारता',
      'ta': 'அடிக்கடி'
    },
    'save': {
      'en': 'Save Reminder',
      'te': 'రిమైండర్ సేవ్ చేయి',
      'hi': 'रिमाइंडर सहेजें',
      'ta': 'நினைவூட்டலை சேமி'
    },
    'cancel': {'en': 'Cancel', 'te': 'రద్దు', 'hi': 'रद्द', 'ta': 'ரத்து'},
    'daily': {'en': 'Daily', 'te': 'రోజువారీ', 'hi': 'दैनिक', 'ta': 'தினசரி'},
    'twice': {
      'en': 'Twice Daily',
      'te': 'రోజుకు రెండుసార్లు',
      'hi': 'दिन में दो बार',
      'ta': 'தினமும் இரண்டு முறை'
    },
    'weekly': {
      'en': 'Weekly',
      'te': 'వారానికి ఒకసారి',
      'hi': 'साप्ताहिक',
      'ta': 'வாரம் ஒரு முறை'
    },
    'delete': {'en': 'Delete', 'te': 'తొలగించు', 'hi': 'हटाएं', 'ta': 'நீக்கு'},
    'total': {
      'en': 'Total Reminders',
      'te': 'మొత్తం రిమైండర్లు',
      'hi': 'कुल रिमाइंडर',
      'ta': 'மொத்த நினைவூட்டல்கள்'
    },
    'enter_name': {
      'en': 'Enter medicine name',
      'te': 'మందు పేరు నమోదు చేయండి',
      'hi': 'दवा का नाम दर्ज करें',
      'ta': 'மருந்தின் பெயரை உள்ளிடுங்கள்'
    },
    'nav_home': {'en': 'Home', 'te': 'హోమ్', 'hi': 'होम', 'ta': 'முகப்பு'},
    'nav_scan': {'en': 'Scan', 'te': 'స్కాన్', 'hi': 'स्कैन', 'ta': 'ஸ்கேன்'},
    'nav_cabinet': {
      'en': 'Cabinet',
      'te': 'పెట్టె',
      'hi': 'कैबिनेट',
      'ta': 'பெட்டி'
    },
    'nav_reminders': {
      'en': 'Reminders',
      'te': 'రిమైండర్లు',
      'hi': 'रिमाइंडर',
      'ta': 'நினைவூட்டல்'
    },
    'nav_settings': {
      'en': 'Settings',
      'te': 'సెట్టింగులు',
      'hi': 'सेटिंग्स',
      'ta': 'அமைப்புகள்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  void _showAddDialog(BuildContext context, String lang, AppData appData) {
    final nameController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    String selectedFreq = 'daily';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine name
              LangText(_label('medicine', lang), lang,
                  fontSize: 12, color: AppTheme.grey),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: AppTheme.grey.withValues(alpha: 0.3)),
                ),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(fontFamily: font, color: AppTheme.white),
                  decoration: InputDecoration(
                    hintText: _label('enter_name', lang),
                    hintStyle:
                        TextStyle(fontFamily: font, color: AppTheme.grey),
                    prefixIcon: const Icon(Icons.medication,
                        color: AppTheme.accent, size: 18),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Time picker
              LangText(_label('time', lang), lang,
                  fontSize: 12, color: AppTheme.grey),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: ctx,
                    initialTime: selectedTime,
                    builder: (context, child) => Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppTheme.accent,
                          surface: AppTheme.card,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedTime = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppTheme.accent.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: AppTheme.accent, size: 18),
                      const SizedBox(width: 8),
                      Text(selectedTime.format(ctx),
                          style: const TextStyle(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Frequency
              LangText(_label('frequency', lang), lang,
                  fontSize: 12, color: AppTheme.grey),
              const SizedBox(height: 6),
              Row(
                children: ['daily', 'twice', 'weekly'].map((f) {
                  final isSelected = selectedFreq == f;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: GestureDetector(
                        onTap: () => setDialogState(() => selectedFreq = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.accent
                                : AppTheme.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isSelected
                                    ? AppTheme.accent
                                    : AppTheme.grey.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: LangText(_label(f, lang), lang,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.white
                                    : AppTheme.grey),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
                if (nameController.text.trim().isEmpty) return;
                appData.addReminder({
                  'name': nameController.text.trim(),
                  'time': selectedTime.format(ctx),
                  'hour': selectedTime.hour,
                  'minute': selectedTime.minute,
                  'weekday': DateTime.now().weekday,
                  'frequency': selectedFreq,
                  'enabled': true,
                });
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

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final font = LanguageProvider.getFontFamily(lang);
    final appData = context.watch<AppData>();
    final reminders = appData.reminders;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.home),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: AppTheme.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LangText(_label('title', lang), lang,
                                fontSize: 16, fontWeight: FontWeight.bold),
                            LangText(_label('sub', lang), lang,
                                fontSize: 11, color: AppTheme.grey),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showAddDialog(context, lang, appData),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: LangText(_label('add', lang), lang,
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.grey.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.teal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.alarm,
                              color: AppTheme.teal, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LangText(_label('total', lang), lang,
                                fontSize: 12, color: AppTheme.grey),
                            Text('${reminders.length}',
                                style: const TextStyle(
                                    color: AppTheme.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => _showAddDialog(context, lang, appData),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [AppTheme.accent, AppTheme.teal]),
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
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: reminders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.alarm_off,
                                  color: AppTheme.grey, size: 64),
                              const SizedBox(height: 16),
                              LangText(_label('empty', lang), lang,
                                  fontSize: 15,
                                  color: AppTheme.grey,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 24),
                              GestureDetector(
                                onTap: () =>
                                    _showAddDialog(context, lang, appData),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      AppTheme.accent,
                                      AppTheme.teal
                                    ]),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: LangText(_label('add', lang), lang,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          itemCount: reminders.length,
                          itemBuilder: (context, i) =>
                              _reminderCard(reminders[i], i, lang, appData),
                        ),
                ),
              ],
            ),
          ),
          // Bottom nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.card,
                border: Border(
                    top: BorderSide(
                        color: AppTheme.grey.withValues(alpha: 0.2))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home, _label('nav_home', lang), false,
                      () => context.go(AppRoutes.home), font),
                  _navItem(Icons.qr_code_scanner, _label('nav_scan', lang),
                      false, () => context.go(AppRoutes.scan), font),
                  _navItem(Icons.medical_services, _label('nav_cabinet', lang),
                      false, () => context.go(AppRoutes.cabinet), font),
                  _navItem(Icons.alarm, _label('nav_reminders', lang), true,
                      () => context.go(AppRoutes.reminders), font),
                  _navItem(Icons.settings, _label('nav_settings', lang), false,
                      () => context.go(AppRoutes.settings), font),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reminderCard(
      Map<String, dynamic> reminder, int index, String lang, AppData appData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.grey.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.teal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication, color: AppTheme.teal, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder['name'] ?? '',
                    style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: AppTheme.accent, size: 14),
                    const SizedBox(width: 4),
                    Text(reminder['time'] ?? '',
                        style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.teal.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: LangText(
                          _label(reminder['frequency'] ?? 'daily', lang), lang,
                          fontSize: 10, color: AppTheme.teal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: reminder['enabled'] ?? true,
                onChanged: (val) {
                  final updated = Map<String, dynamic>.from(reminder);
                  updated['enabled'] = val;
                  appData.updateReminder(index, updated);
                },
                activeThumbColor: AppTheme.accent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              GestureDetector(
                onTap: () => appData.removeReminder(index),
                child: const Icon(Icons.delete_outline,
                    color: AppTheme.error, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive,
      VoidCallback onTap, String font) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isActive ? AppTheme.accent : AppTheme.grey, size: 26),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                  fontFamily: font,
                  color: isActive ? AppTheme.accent : AppTheme.grey,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}
