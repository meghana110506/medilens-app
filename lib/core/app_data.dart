import 'package:flutter/material.dart';

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
}

class AppData extends ChangeNotifier {
  static final AppData _instance = AppData._internal();
  factory AppData() => _instance;
  AppData._internal();

  final List<MedicineEntry> _cabinet = [];
  final List<Map<String, dynamic>> _reminders = [];

  List<MedicineEntry> get cabinet => List.unmodifiable(_cabinet);
  List<Map<String, dynamic>> get reminders => List.unmodifiable(_reminders);

  int get validCount => _cabinet.where((m) => m.expiryStatus == 'valid').length;
  int get expiringCount =>
      _cabinet.where((m) => m.expiryStatus == 'expiring').length;
  int get expiredCount =>
      _cabinet.where((m) => m.expiryStatus == 'expired').length;

  void addMedicine(MedicineEntry entry) {
    _cabinet.add(entry);
    notifyListeners();
  }

  void removeMedicine(int index) {
    _cabinet.removeAt(index);
    notifyListeners();
  }

  void addReminder(Map<String, dynamic> reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void removeReminder(int index) {
    _reminders.removeAt(index);
    notifyListeners();
  }

  static String getExpiryStatus(String expiryDate) {
    try {
      DateTime? expiry;
      final monthYear = RegExp(r'(\d{2})[\/\-](\d{4})');
      final monthNameYear = RegExp(
          r'(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s+(\d{4})',
          caseSensitive: false);
      final monthNameYear2 = RegExp(
          r'(January|February|March|April|May|June|July|August|September|October|November|December)\s+(\d{4})',
          caseSensitive: false);

      final m1 = monthYear.firstMatch(expiryDate);
      final m2 = monthNameYear.firstMatch(expiryDate);
      final m3 = monthNameYear2.firstMatch(expiryDate);

      if (m1 != null) {
        final month = int.parse(m1.group(1)!);
        final year = int.parse(m1.group(2)!);
        expiry = DateTime(year, month + 1, 0);
      } else if (m2 != null) {
        const months = {
          'jan': 1,
          'feb': 2,
          'mar': 3,
          'apr': 4,
          'may': 5,
          'jun': 6,
          'jul': 7,
          'aug': 8,
          'sep': 9,
          'oct': 10,
          'nov': 11,
          'dec': 12,
        };
        final month = months[m2.group(1)!.toLowerCase()] ?? 1;
        final year = int.parse(m2.group(2)!);
        expiry = DateTime(year, month + 1, 0);
      } else if (m3 != null) {
        const months = {
          'january': 1,
          'february': 2,
          'march': 3,
          'april': 4,
          'may': 5,
          'june': 6,
          'july': 7,
          'august': 8,
          'september': 9,
          'october': 10,
          'november': 11,
          'december': 12,
        };
        final month = months[m3.group(1)!.toLowerCase()] ?? 1;
        final year = int.parse(m3.group(2)!);
        expiry = DateTime(year, month + 1, 0);
      }

      if (expiry == null) return 'valid';
      final now = DateTime.now();
      final diff = expiry.difference(now).inDays;
      if (diff < 0) return 'expired';
      if (diff <= 90) return 'expiring';
      return 'valid';
    } catch (e) {
      return 'valid';
    }
  }

  static String getTimeLeft(String expiryDate) {
    try {
      DateTime? expiry;
      final monthYear = RegExp(r'(\d{2})[\/\-](\d{4})');
      final monthNameYear = RegExp(
          r'(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s+(\d{4})',
          caseSensitive: false);
      final monthNameYear2 = RegExp(
          r'(January|February|March|April|May|June|July|August|September|October|November|December)\s+(\d{4})',
          caseSensitive: false);

      final m1 = monthYear.firstMatch(expiryDate);
      final m2 = monthNameYear.firstMatch(expiryDate);
      final m3 = monthNameYear2.firstMatch(expiryDate);

      if (m1 != null) {
        final month = int.parse(m1.group(1)!);
        final year = int.parse(m1.group(2)!);
        expiry = DateTime(year, month + 1, 0);
      } else if (m2 != null) {
        const months = {
          'jan': 1,
          'feb': 2,
          'mar': 3,
          'apr': 4,
          'may': 5,
          'jun': 6,
          'jul': 7,
          'aug': 8,
          'sep': 9,
          'oct': 10,
          'nov': 11,
          'dec': 12,
        };
        final month = months[m2.group(1)!.toLowerCase()] ?? 1;
        final year = int.parse(m2.group(2)!);
        expiry = DateTime(year, month + 1, 0);
      } else if (m3 != null) {
        const months = {
          'january': 1,
          'february': 2,
          'march': 3,
          'april': 4,
          'may': 5,
          'june': 6,
          'july': 7,
          'august': 8,
          'september': 9,
          'october': 10,
          'november': 11,
          'december': 12,
        };
        final month = months[m3.group(1)!.toLowerCase()] ?? 1;
        final year = int.parse(m3.group(2)!);
        expiry = DateTime(year, month + 1, 0);
      }

      if (expiry == null) return 'Unknown';
      final now = DateTime.now();
      final diff = expiry.difference(now).inDays;
      if (diff < 0) return 'Expired';
      if (diff == 0) return 'Today';
      if (diff <= 30) return '$diff days';
      if (diff <= 90) return '~${(diff / 30).round()} months';
      return '${(diff / 30).round()} months';
    } catch (e) {
      return 'Unknown';
    }
  }
}
