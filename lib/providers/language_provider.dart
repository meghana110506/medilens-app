import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:medilens/core/constants.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = AppConstants.english;
  double _fontSize = AppConstants.fontMedium;
  double _voiceSpeed = AppConstants.voiceSpeedNormal;
  bool _bilingualEnabled = true;
  bool _highContrastMode = false;
  String _userName = '';
  String _userAge = '60';
  String _userCity = '';
  String _userBlood = 'B+';
  String _userGender = 'Female';
  String _userPhone = '';
  String _userPhoto = '';
  
  // Multiple caregivers support (up to 3)
  List<Map<String, String>> _caregivers = [];
  
  int _expiryDigestHour = 9;
  int _expiryDigestMinute = 0;
  double _confidenceThreshold = 0.75; // Default 75%
  bool _remindersNotifEnabled = true;
  bool _expiryAlertsEnabled = true;
  bool _notificationPermissionRequested = false;
  final FlutterTts _tts = FlutterTts();

  String get language => _language;
  double get fontSize => _fontSize;
  double get voiceSpeed => _voiceSpeed;
  bool get bilingualEnabled => _bilingualEnabled;
  bool get highContrastMode => _highContrastMode;
  String get userName => _userName;
  String get userAge => _userAge;
  String get userCity => _userCity;
  String get userBlood => _userBlood;
  String get userGender => _userGender;
  String get userPhone => _userPhone;
  String get userPhoto => _userPhoto;
  
  // Caregivers getters
  List<Map<String, String>> get caregivers => List.unmodifiable(_caregivers);
  
  // Legacy getters for backward compatibility (returns first caregiver if exists)
  String get caregiverName => _caregivers.isNotEmpty ? _caregivers[0]['name'] ?? '' : '';
  String get caregiverPhone => _caregivers.isNotEmpty ? _caregivers[0]['phone'] ?? '' : '';
  String get caregiverRelation => _caregivers.isNotEmpty ? _caregivers[0]['relation'] ?? '' : '';
  
  int get expiryDigestHour => _expiryDigestHour;
  int get expiryDigestMinute => _expiryDigestMinute;
  double get confidenceThreshold => _confidenceThreshold;
  bool get remindersNotifEnabled => _remindersNotifEnabled;
  bool get expiryAlertsEnabled => _expiryAlertsEnabled;
  bool get notificationPermissionRequested =>
      _notificationPermissionRequested;

  static const Map<String, String> languageNames = {
    'en': 'English',
    'te': 'తెలుగు',
    'hi': 'हिंदी',
    'ta': 'தமிழ்',
  };

  static const Map<String, String> ttsLanguageCodes = {
    'en': 'en-IN',
    'te': 'te-IN',
    'hi': 'hi-IN',
    'ta': 'ta-IN',
  };

  static String getFontFamily(String language) {
    switch (language) {
      case 'te': return 'NotoSansTelugu';
      case 'hi': return 'NotoSansDevanagari';
      case 'ta': return 'NotoSansTamil';
      default: return 'NotoSans';
    }
  }

  LanguageProvider() {
    _loadPreferences();
  }

  Future<void> _initTts() async {
    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage(ttsLanguageCodes[_language] ?? 'en-IN');
    await _tts.setSpeechRate(_voiceSpeed);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _language = prefs.getString(AppConstants.keyLanguage) ?? AppConstants.english;
      _fontSize = prefs.getDouble(AppConstants.keyFontSize) ?? AppConstants.fontMedium;
      _voiceSpeed = prefs.getDouble(AppConstants.keyVoiceSpeed) ?? AppConstants.voiceSpeedNormal;
      _bilingualEnabled = prefs.getBool(AppConstants.keyBilingualEnabled) ?? true;
      _highContrastMode = prefs.getBool('high_contrast_mode') ?? false;
      _userName = prefs.getString('user_name') ?? '';
      _userAge = prefs.getString('user_age') ?? '60';
      _userCity = prefs.getString('user_city') ?? '';
      _userBlood = prefs.getString('user_blood') ?? 'B+';
      _userGender = prefs.getString('user_gender') ?? 'Female';
      _userPhone = prefs.getString('user_phone') ?? '';
      _userPhoto = prefs.getString('user_photo') ?? '';
      
      // Load caregivers (up to 3)
      _caregivers = [];
      for (int i = 0; i < 3; i++) {
        final name = prefs.getString('caregiver_${i}_name') ?? '';
        final phone = prefs.getString('caregiver_${i}_phone') ?? '';
        final relation = prefs.getString('caregiver_${i}_relation') ?? '';
        if (name.isNotEmpty && phone.isNotEmpty) {
          _caregivers.add({
            'name': name,
            'phone': phone,
            'relation': relation,
          });
        }
      }
      
      _expiryDigestHour =
          prefs.getInt(AppConstants.keyExpiryDigestHour) ?? 9;
      _expiryDigestMinute =
          prefs.getInt(AppConstants.keyExpiryDigestMinute) ?? 0;
      _confidenceThreshold =
          prefs.getDouble('confidence_threshold') ?? 0.75;
      _remindersNotifEnabled =
          prefs.getBool(AppConstants.keyRemindersNotifEnabled) ?? true;
      _expiryAlertsEnabled =
          prefs.getBool(AppConstants.keyExpiryAlertsEnabled) ?? true;
      _notificationPermissionRequested = prefs
              .getBool(AppConstants.keyNotificationPermissionRequested) ??
          false;
      await _initTts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  Future<void> saveProfile({
    required String name,
    required String age,
    required String city,
    required String blood,
    required String gender,
    required String phone,
    String photo = '',
  }) async {
    try {
      _userName = name;
      _userAge = age;
      _userCity = city;
      _userBlood = blood;
      _userGender = gender;
      _userPhone = phone;
      _userPhoto = photo;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_age', age);
      await prefs.setString('user_city', city);
      await prefs.setString('user_blood', blood);
      await prefs.setString('user_gender', gender);
      await prefs.setString('user_phone', phone);
      await prefs.setString('user_photo', photo);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving profile: $e');
    }
  }

  Future<void> saveCaregiver({
    required String name,
    required String phone,
    required String relation,
    int? index,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // If index is provided, update that specific caregiver
      if (index != null && index >= 0 && index < 3) {
        if (index < _caregivers.length) {
          _caregivers[index] = {
            'name': name,
            'phone': phone,
            'relation': relation,
          };
        } else {
          _caregivers.add({
            'name': name,
            'phone': phone,
            'relation': relation,
          });
        }
      } else {
        // Add new caregiver if under limit
        if (_caregivers.length < 3) {
          _caregivers.add({
            'name': name,
            'phone': phone,
            'relation': relation,
          });
        }
      }
      
      // Save all caregivers to SharedPreferences
      for (int i = 0; i < 3; i++) {
        if (i < _caregivers.length) {
          await prefs.setString('caregiver_${i}_name', _caregivers[i]['name'] ?? '');
          await prefs.setString('caregiver_${i}_phone', _caregivers[i]['phone'] ?? '');
          await prefs.setString('caregiver_${i}_relation', _caregivers[i]['relation'] ?? '');
        } else {
          await prefs.remove('caregiver_${i}_name');
          await prefs.remove('caregiver_${i}_phone');
          await prefs.remove('caregiver_${i}_relation');
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving caregiver: $e');
    }
  }

  Future<void> removeCaregiver(int index) async {
    try {
      if (index >= 0 && index < _caregivers.length) {
        _caregivers.removeAt(index);
        
        final prefs = await SharedPreferences.getInstance();
        // Re-save all caregivers
        for (int i = 0; i < 3; i++) {
          if (i < _caregivers.length) {
            await prefs.setString('caregiver_${i}_name', _caregivers[i]['name'] ?? '');
            await prefs.setString('caregiver_${i}_phone', _caregivers[i]['phone'] ?? '');
            await prefs.setString('caregiver_${i}_relation', _caregivers[i]['relation'] ?? '');
          } else {
            await prefs.remove('caregiver_${i}_name');
            await prefs.remove('caregiver_${i}_phone');
            await prefs.remove('caregiver_${i}_relation');
          }
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing caregiver: $e');
    }
  }

  /// Reloads only caregiver fields from storage (e.g. when SOS opens after
  /// returning from caregiver setup) without re-running full TTS init.
  Future<void> reloadCaregiverFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _caregivers = [];
      for (int i = 0; i < 3; i++) {
        final name = prefs.getString('caregiver_${i}_name') ?? '';
        final phone = prefs.getString('caregiver_${i}_phone') ?? '';
        final relation = prefs.getString('caregiver_${i}_relation') ?? '';
        if (name.isNotEmpty && phone.isNotEmpty) {
          _caregivers.add({
            'name': name,
            'phone': phone,
            'relation': relation,
          });
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error reloading caregiver: $e');
    }
  }

  Future<void> setLanguage(String language) async {
    try {
      _language = language;
      await _tts.setLanguage(ttsLanguageCodes[language] ?? 'en-IN');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyLanguage, language);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting language: $e');
    }
  }

  Future<void> setFontSize(double size) async {
    try {
      _fontSize = size;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(AppConstants.keyFontSize, size);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting font size: $e');
    }
  }

  Future<void> setVoiceSpeed(double speed) async {
    try {
      _voiceSpeed = speed;
      await _tts.setSpeechRate(speed);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(AppConstants.keyVoiceSpeed, speed);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting voice speed: $e');
    }
  }

  Future<void> setExpiryDigestTime(int hour, int minute) async {
    try {
      _expiryDigestHour = hour.clamp(0, 23);
      _expiryDigestMinute = minute.clamp(0, 59);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.keyExpiryDigestHour, _expiryDigestHour);
      await prefs.setInt(
          AppConstants.keyExpiryDigestMinute, _expiryDigestMinute);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving expiry digest time: $e');
    }
  }

  Future<void> setConfidenceThreshold(double threshold) async {
    try {
      _confidenceThreshold = threshold.clamp(0.75, 1.0);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('confidence_threshold', _confidenceThreshold);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving confidence threshold: $e');
    }
  }

  Future<void> setRemindersNotifEnabled(bool enabled) async {
    try {
      _remindersNotifEnabled = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyRemindersNotifEnabled, enabled);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving reminder notifications toggle: $e');
    }
  }

  Future<void> setExpiryAlertsEnabled(bool enabled) async {
    try {
      _expiryAlertsEnabled = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyExpiryAlertsEnabled, enabled);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving expiry alerts toggle: $e');
    }
  }

  /// Call after the user accepts the in-app explanation (before the OS prompt).
  Future<void> markNotificationPermissionFlowCompleted() async {
    try {
      _notificationPermissionRequested = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
          AppConstants.keyNotificationPermissionRequested, true);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving notification permission flag: $e');
    }
  }

  Future<void> setBilingualEnabled(bool enabled) async {
    try {
      _bilingualEnabled = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyBilingualEnabled, enabled);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting bilingual: $e');
    }
  }

  Future<void> setHighContrastMode(bool enabled) async {
    try {
      _highContrastMode = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('high_contrast_mode', enabled);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting high contrast: $e');
    }
  }

  Future<void> speak(String text) async {
    try {
      await _tts.stop();
      await _tts.awaitSpeakCompletion(true);
      await _tts.setLanguage(ttsLanguageCodes[_language] ?? 'en-IN');
      await _tts.setSpeechRate(_voiceSpeed);
      await _tts.setVolume(1.0);
      await _tts.speak(text); // now blocks until utterance is fully spoken
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  Future<void> speakInLanguage(String text, String language) async {
    try {
      await _tts.stop();
      await _tts.awaitSpeakCompletion(true);
      await _tts.setLanguage(ttsLanguageCodes[language] ?? 'en-IN');
      await _tts.setSpeechRate(_voiceSpeed);
      await _tts.setVolume(1.0);
      await _tts.speak(text); // blocks until this language utterance finishes
    } catch (e) {
      debugPrint('TTS speakInLanguage error: $e');
    }
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  String get langSuffix {
    switch (_language) {
      case 'te': return '_te';
      case 'hi': return '_hi';
      case 'ta': return '_ta';
      default: return '';
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}