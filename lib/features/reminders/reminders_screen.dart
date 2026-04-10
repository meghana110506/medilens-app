
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final List<Map<String, dynamic>> _reminders = [
    {'medicine': 'Metformin', 'dose': '500mg - 1 tablet', 'time': '08:00 AM', 'isActive': true},
    {'medicine': 'Amlodipine', 'dose': '5mg - 1 tablet', 'time': '09:00 PM', 'isActive': true},
    {'medicine': 'Vitamin D', 'dose': '1 capsule', 'time': '01:00 PM', 'isActive': false},
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {'en': 'Reminders', 'te': 'రిమైండర్లు', 'hi': 'रिमाइंडर', 'ta': 'நினைவூட்டல்கள்'},
    'subtitle': {'en': 'Medicine Reminders', 'te': 'మందుల రిమైండర్లు', 'hi': 'दवा रिमाइंडर', 'ta': 'மருந்து நினைவூட்டல்கள்'},
    'active': {'en': 'Active', 'te': 'క్రియాశీల', 'hi': 'सक्रिय', 'ta': 'செயலில்'},
    'inactive': {'en': 'Inactive', 'te': 'నిష్క్రియ', 'hi': 'निष्क्रिय', 'ta': 'செயலற்ற'},
    'add': {'en': 'Add Reminder', 'te': 'రిమైండర్ జోడించండి', 'hi': 'रिमाइंडर जोड़ें', 'ta': 'நினைவூட்டல் சேர்க்கவும்'},
    'medicine': {'en': 'Medicine Name', 'te': 'మందు పేరు', 'hi': 'दवा का नाम', 'ta': 'மருந்தின் பெயர்'},
    'dose': {'en': 'Dose', 'te': 'మోతాదు', 'hi': 'खुराक', 'ta': 'மருந்தளவு'},
    'time': {'en': 'Time', 'te': 'సమయం', 'hi': 'समय', 'ta': 'நேரம்'},
    'cancel': {'en': 'Cancel', 'te': 'రద్దు', 'hi': 'रद्द करें', 'ta': 'ரத்து செய்'},
    'active_count': {'en': 'active reminders', 'te': 'క్రియాశీల రిమైండర్లు', 'hi': 'सक्रिय रिमाइंडर', 'ta': 'செயலில் உள்ள நினைவூட்டல்கள்'},
  };

  String _label(String key, String lang) => _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  Future<void> _addReminder(String lang) async {
    final medicineController = TextEditingController();
    final doseController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

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
                controller: medicineController,
                style: const TextStyle(color: AppTheme.white),
                decoration: InputDecoration(
                  labelText: _label('medicine', lang),
                  labelStyle: const TextStyle(color: AppTheme.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.grey)),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.accent)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: doseController,
                style: const TextStyle(color: AppTheme.white),
                decoration: InputDecoration(
                  labelText: _label('dose', lang),
                  labelStyle: const TextStyle(color: AppTheme.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.grey)),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.accent)),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) setDialogState(() => selectedTime = time);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: AppTheme.accent),
                      const SizedBox(width: 8),
                      Text(selectedTime.format(context),
                        style: const TextStyle(color: AppTheme.white, fontSize: 16)),
                    ],
                  ),
                ),
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
                if (medicineController.text.isNotEmpty) {
                  setState(() {
                    _reminders.add({
                      'medicine': medicineController.text,
                      'dose': doseController.text,
                      'time': selectedTime.format(context),
                      'isActive': true,
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

  Future<void> _speakReminder(Map<String, dynamic> reminder) async {
    final provider = context.read<LanguageProvider>();
    final lang = provider.language;
    final Map<String, String> texts = {
      'en': 'Time to take ${reminder['medicine']}. Dose: ${reminder['dose']}',
      'te': '${reminder['medicine']} తీసుకునే సమయం. మోతాదు: ${reminder['dose']}',
      'hi': '${reminder['medicine']} लेने का समय। खुराक: ${reminder['dose']}',
      'ta': '${reminder['medicine']} எடுக்கும் நேரம். அளவு: ${reminder['dose']}',
    };
    await provider.speak(texts[lang] ?? texts['en']!);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final activeReminders = _reminders.where((r) => r['isActive'] == true).toList();
    final inactiveReminders = _reminders.where((r) => r['isActive'] == false).toList();

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
            onPressed: () => _addReminder(lang),
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
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.white)),
              const SizedBox(height: 8),
              Text('${activeReminders.length} ${_label('active_count', lang)}',
                style: const TextStyle(fontSize: 14, color: AppTheme.grey)),
              const SizedBox(height: 32),

              if (activeReminders.isNotEmpty) ...[
                _buildSectionHeader(_label('active', lang), AppTheme.success),
                const SizedBox(height: 12),
                ...activeReminders.map((r) => _buildReminderCard(r, lang)),
                const SizedBox(height: 24),
              ],

              if (inactiveReminders.isNotEmpty) ...[
                _buildSectionHeader(_label('inactive', lang), AppTheme.grey),
                const SizedBox(height: 12),
                ...inactiveReminders.map((r) => _buildReminderCard(r, lang)),
                const SizedBox(height: 24),
              ],

              ElevatedButton.icon(
                onPressed: () => _addReminder(lang),
                icon: const Icon(Icons.add_alarm),
                label: Text(_label('add', lang)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: color),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 15)),
      ],
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder, String lang) {
    final isActive = reminder['isActive'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? AppTheme.accent.withOpacity(0.3) : AppTheme.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.accent.withOpacity(0.15) : AppTheme.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.alarm,
              color: isActive ? AppTheme.accent : AppTheme.grey, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder['medicine'],
                  style: TextStyle(
                    color: isActive ? AppTheme.white : AppTheme.grey,
                    fontWeight: FontWeight.w600, fontSize: 16,
                  )),
                Text(reminder['dose'],
                  style: const TextStyle(color: AppTheme.grey, fontSize: 13)),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: AppTheme.teal, size: 14),
                    const SizedBox(width: 4),
                    Text(reminder['time'],
                      style: const TextStyle(color: AppTheme.teal, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _speakReminder(reminder),
                icon: const Icon(Icons.volume_up, color: AppTheme.teal, size: 20),
              ),
              Switch(
                value: isActive,
                onChanged: (val) => setState(() => reminder['isActive'] = val),
                activeColor: AppTheme.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
