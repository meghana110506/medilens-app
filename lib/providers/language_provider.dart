import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:medilens/core/constants.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = AppConstants.english;
  double _fontSize = AppConstants.fontMedium;
  double _voiceSpeed = AppConstants.voiceSpeedNormal;
  bool _bilingualEnabled = true;
  String _userName = '';
  String _userAge = '60';
  String _userCity = '';
  String _userBlood = 'B+';
  String _userGender = 'Female';
  String _userPhone = '';
  String _userPhoto = '';
  String _caregiverName = '';
  String _caregiverPhone = '';
  String _caregiverRelation = '';
  final FlutterTts _tts = FlutterTts();

  String get language => _language;
  double get fontSize => _fontSize;
  double get voiceSpeed => _voiceSpeed;
  bool get bilingualEnabled => _bilingualEnabled;
  String get userName => _userName;
  String get userAge => _userAge;
  String get userCity => _userCity;
  String get userBlood => _userBlood;
  String get userGender => _userGender;
  String get userPhone => _userPhone;
  String get userPhoto => _userPhoto;
  String get caregiverName => _caregiverName;
  String get caregiverPhone => _caregiverPhone;
  String get caregiverRelation => _caregiverRelation;

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
      _userName = prefs.getString('user_name') ?? '';
      _userAge = prefs.getString('user_age') ?? '60';
      _userCity = prefs.getString('user_city') ?? '';
      _userBlood = prefs.getString('user_blood') ?? 'B+';
      _userGender = prefs.getString('user_gender') ?? 'Female';
      _userPhone = prefs.getString('user_phone') ?? '';
      _userPhoto = prefs.getString('user_photo') ?? '';
      _caregiverName = prefs.getString('caregiver_name') ?? '';
      _caregiverPhone = prefs.getString('caregiver_phone') ?? '';
      _caregiverRelation = prefs.getString('caregiver_relation') ?? '';
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
  }) async {
    try {
      _caregiverName = name;
      _caregiverPhone = phone;
      _caregiverRelation = relation;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('caregiver_name', name);
      await prefs.setString('caregiver_phone', phone);
      await prefs.setString('caregiver_relation', relation);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving caregiver: $e');
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

  Future<void> speak(String text) async {
    try {
      await _tts.stop();
      await _tts.setLanguage(ttsLanguageCodes[_language] ?? 'en-IN');
      await _tts.setSpeechRate(_voiceSpeed);
      await _tts.setVolume(1.0);
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  Future<void> speakInLanguage(String text, String language) async {
    try {
      await _tts.stop();
      await _tts.setLanguage(ttsLanguageCodes[language] ?? 'en-IN');
      await _tts.setSpeechRate(_voiceSpeed);
      await _tts.setVolume(1.0);
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS error: $e');
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