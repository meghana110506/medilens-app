import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineEntry {
  final String name;
  final String generic;
  final String strength;
  final String type;
  final String expiryDate;
  final String expiryStatus;
  final DateTime addedOn;

  MedicineEntry({
    required this.name,
    required this.generic,
    required this.strength,
    required this.type,
    required this.expiryDate,
    required this.expiryStatus,
    required this.addedOn,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'generic': generic,
        'strength': strength,
        'type': type,
        'expiryDate': expiryDate,
        'expiryStatus': expiryStatus,
        'addedOn': addedOn.toIso8601String(),
      };

  factory MedicineEntry.fromJson(Map<String, dynamic> j) => MedicineEntry(
        name: j['name'] as String? ?? '',
        generic: j['generic'] as String? ?? '',
        strength: j['strength'] as String? ?? '',
        type: j['type'] as String? ?? '',
        expiryDate: j['expiryDate'] as String? ?? '',
        expiryStatus: j['expiryStatus'] as String? ?? 'valid',
        addedOn: DateTime.tryParse(j['addedOn'] as String? ?? '') ?? DateTime.now(),
      );
}

class AppData extends ChangeNotifier {
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal() {
    _load();
  }

  List<MedicineEntry> _cabinet = [];
  List<MedicineEntry> get cabinet => _cabinet;

  int get validCount => _cabinet.where((m) => m.expiryStatus == 'valid').length;
  int get expiringCount => _cabinet.where((m) => m.expiryStatus == 'expiring').length;
  int get expiredCount => _cabinet.where((m) => m.expiryStatus == 'expired').length;

  List<ReminderEntry> _reminders = [];
  List<ReminderEntry> get reminders => _reminders;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final cabinetJson = prefs.getString('cabinet');
    if (cabinetJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(cabinetJson);
        _cabinet = decoded.map((e) => MedicineEntry.fromJson(e as Map<String, dynamic>)).toList();
      } catch (e) {
        debugPrint('Error loading cabinet');
      }
    }
    final remindersJson = prefs.getString('reminders');
    if (remindersJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(remindersJson);
        _reminders = decoded.map((e) => ReminderEntry.fromJson(e as Map<String, dynamic>)).toList();
      } catch (e) {
        debugPrint('Error loading reminders');
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cabinet', jsonEncode(_cabinet.map((e) => e.toJson()).toList()));
    await prefs.setString('reminders', jsonEncode(_reminders.map((e) => e.toJson()).toList()));
  }

  void addMedicine(MedicineEntry entry) {
    _cabinet.add(entry);
    notifyListeners();
    _save();
  }

  void removeMedicine(int index) {
    if (index >= 0 && index < _cabinet.length) {
      _cabinet.removeAt(index);
      notifyListeners();
      _save();
    }
  }

  void addReminder(ReminderEntry entry) {
    _reminders.add(entry);
    notifyListeners();
    _save();
  }

  void removeReminder(int index) {
    if (index >= 0 && index < _reminders.length) {
      _reminders.removeAt(index);
      notifyListeners();
      _save();
    }
  }

  void markReminderAsTaken(int index, bool taken) {
    if (index >= 0 && index < _reminders.length) {
      _reminders[index] = _reminders[index].copyWith(takenToday: taken);
      notifyListeners();
      _save();
    }
  }

  void toggleTaken(int index) {
    if (index >= 0 && index < _reminders.length) {
      final current = _reminders[index].takenToday;
      _reminders[index] = _reminders[index].copyWith(takenToday: !current);
      notifyListeners();
      _save();
    }
  }

  String getTimeLeft(String expiryDateStr) {
    try {
      final now = DateTime.now();
      DateTime? expiryDate;
      final patterns = [
        RegExp(r'(\d{2})[\/\-](\d{4})'),
        RegExp(r'(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s+(\d{4})', caseSensitive: false),
      ];
      for (final pattern in patterns) {
        final match = pattern.firstMatch(expiryDateStr);
        if (match != null) {
          if (pattern.pattern.contains(r'\d{2}')) {
            final month = int.tryParse(match.group(1)!);
            final year = int.tryParse(match.group(2)!);
            if (month != null && year != null) {
              expiryDate = DateTime(year, month, 1);
            }
          } else {
            final monthStr = match.group(1)!.toUpperCase().substring(0, 3);
            final year = int.tryParse(match.group(2)!);
            final monthMap = {'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6, 'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12};
            final month = monthMap[monthStr];
            if (month != null && year != null) {
              expiryDate = DateTime(year, month, 1);
            }
          }
          break;
        }
      }
      if (expiryDate == null) return 'Unknown';
      final difference = expiryDate.difference(now).inDays;
      if (difference < 0) return 'Expired';
      if (difference == 0) return 'Today';
      if (difference == 1) return '1 day';
      if (difference < 30) return '$difference days';
      final months = (difference / 30).floor();
      if (months == 1) return '1 month';
      return '$months months';
    } catch (e) {
      return 'Unknown';
    }
  }

  static String getExpiryStatus(String expiryDateStr) {
    try {
      final now = DateTime.now();
      DateTime? expiryDate;
      final patterns = [
        RegExp(r'(\d{2})[\/\-](\d{4})'),
        RegExp(r'(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s+(\d{4})', caseSensitive: false),
      ];
      for (final pattern in patterns) {
        final match = pattern.firstMatch(expiryDateStr);
        if (match != null) {
          if (pattern.pattern.contains(r'\d{2}')) {
            final month = int.tryParse(match.group(1)!);
            final year = int.tryParse(match.group(2)!);
            if (month != null && year != null) {
              expiryDate = DateTime(year, month, 1);
            }
          } else {
            final monthStr = match.group(1)!.toUpperCase().substring(0, 3);
            final year = int.tryParse(match.group(2)!);
            final monthMap = {'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6, 'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12};
            final month = monthMap[monthStr];
            if (month != null && year != null) {
              expiryDate = DateTime(year, month, 1);
            }
          }
          break;
        }
      }
      if (expiryDate == null) return 'valid';
      final difference = expiryDate.difference(now).inDays;
      if (difference < 0) return 'expired';
      if (difference <= 90) return 'expiring';
      return 'valid';
    } catch (e) {
      return 'valid';
    }
  }
}

class ReminderEntry {
  final String medicineName;
  final String time;
  final List<String> days;
  final bool takenToday;

  ReminderEntry({required this.medicineName, required this.time, required this.days, this.takenToday = false});

  Map<String, dynamic> toJson() => {'medicineName': medicineName, 'time': time, 'days': days, 'takenToday': takenToday};

  factory ReminderEntry.fromJson(Map<String, dynamic> j) => ReminderEntry(
        medicineName: j['medicineName'] as String? ?? '',
        time: j['time'] as String? ?? '',
        days: (j['days'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        takenToday: j['takenToday'] as bool? ?? false,
      );

  ReminderEntry copyWith({String? medicineName, String? time, List<String>? days, bool? takenToday}) {
    return ReminderEntry(
      medicineName: medicineName ?? this.medicineName,
      time: time ?? this.time,
      days: days ?? this.days,
      takenToday: takenToday ?? this.takenToday,
    );
  }
}
