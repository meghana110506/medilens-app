import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:medilens/core/app_data.dart';
import 'package:medilens/core/constants.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/providers/language_provider.dart';

/// Local notifications: medicine reminders, daily expiry digest, per-medicine
/// one-shots, and bilingual text. TTS runs when the user taps a notification.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _tzReady = false;

  static const int _idExpiryDigest = 900;
  static const int _reminderIdBase = 500;
  static const int _maxReminderSlots = 25;

  /// One-shot alerts per cabinet item (7d / 1d / expiry day), max 30 items.
  static const int _perMedicineIdBase = 2000;
  static const int _perMedicineSpan = 30;
  static const int _slotsPerMedicine = 3;

  Future<void> init() async {
    if (_initialized) return;
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      const channel = AndroidNotificationChannel(
        'medilens_alerts',
        'MediLens alerts',
        description: 'Medicine reminders and expiry check-ins',
        importance: Importance.high,
      );
      await android?.createNotificationChannel(channel);
    }

    _initialized = true;
  }

  /// Android 13+ POST_NOTIFICATIONS — call only after your in-app rationale.
  Future<void> requestAndroidPostNotificationsPermission() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  /// In-app explanation before the OS permission dialog (Android).
  static Future<void> showAndroidPermissionPrecheckIfNeeded(
    BuildContext context,
  ) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(AppConstants.keyNotificationPermissionRequested) ==
        true) {
      return;
    }
    final navCtx = AppRoutes.rootNavigatorKey.currentContext ?? context;
    if (!navCtx.mounted) return;

    final lang = navCtx.read<LanguageProvider>().language;
    final chosen = await showDialog<bool>(
      context: navCtx,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          _precheckTitle(lang),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Text(
            _precheckBody(lang),
            style: const TextStyle(color: Color(0xFF94A3B8), height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(_precheckNotNow(lang),
                style: const TextStyle(color: Color(0xFF94A3B8))),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(_precheckContinue(lang)),
          ),
        ],
      ),
    );

    if (chosen != true) return;
    if (!navCtx.mounted) return;
    await navCtx
        .read<LanguageProvider>()
        .markNotificationPermissionFlowCompleted();
    await NotificationService.instance
        .requestAndroidPostNotificationsPermission();
  }

  static String _precheckTitle(String lang) {
    switch (lang) {
      case 'te':
        return 'నోటిఫికేషన్లు అవసరం';
      case 'hi':
        return 'सूचनाएं ज़रूरी हैं';
      case 'ta':
        return 'அறிவிப்புகள் தேவை';
      default:
        return 'Turn on notifications';
    }
  }

  static String _precheckBody(String lang) {
    switch (lang) {
      case 'te':
        return 'మెడిలెన్స్ మీ మందు రిమైండర్లు, గడువు హెచ్చరికలు మరియు రోజువారీ గడువు సారాంశాన్ని చూపడానికి నోటిఫికేషన్లను ఉపయోగిస్తుంది. కొనసాగించు నొక్కిన తర్వాత Android అనుమతి విండో వస్తుంది—అక్కడ అనుమతించండి నొక్కండి.';
      case 'hi':
        return 'MediLens दवा रिमाइंडर, एक्सपायरी अलर्ट और दैनिक सारांश दिखाने के लिए सूचनाएं उपयोग करता है। जारी रखें दबाने के बाद Android अनुमति विंडो खुलेगी—वहां अनुमति दें चुनें।';
      case 'ta':
        return 'MediLens மருந்து நினைவூட்டல்கள், காலாவதி எச்சரிக்கைகள் மற்றும் தினசரி சுருக்கத்தைக் காட்ட அறிவிப்புகளைப் பயன்படுத்துகிறது. தொடரை அழுத்திய பிறகு Android அனுமதி சாளரம் திறக்கும்—அங்கு அனுமதி என்பதைத் தேர்ந்தெடுக்கவும்.';
      default:
        return 'MediLens uses notifications to show medicine reminders, expiry alerts, and your daily expiry summary. After you tap Continue, Android will ask for permission—please choose Allow so alerts can appear.';
    }
  }

  static String _precheckContinue(String lang) {
    switch (lang) {
      case 'te':
        return 'కొనసాగించు';
      case 'hi':
        return 'जारी रखें';
      case 'ta':
        return 'தொடர்';
      default:
        return 'Continue';
    }
  }

  static String _precheckNotNow(String lang) {
    switch (lang) {
      case 'te':
        return 'ఇప్పుడు కాదు';
      case 'hi':
        return 'अभी नहीं';
      case 'ta':
        return 'இப்போது வேண்டாம்';
      default:
        return 'Not now';
    }
  }

  Future<void> _ensureTimeZone() async {
    if (_tzReady) return;
    try {
      tzdata.initializeTimeZones();
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
      _tzReady = true;
    } catch (e) {
      debugPrint('NotificationService: timezone init failed ($e), using UTC');
      try {
        tzdata.initializeTimeZones();
        tz.setLocalLocation(tz.UTC);
        _tzReady = true;
      } catch (e2) {
        debugPrint('NotificationService: UTC fallback failed: $e2');
      }
    }
  }

  Future<NotificationAppLaunchDetails?> getLaunchDetails() =>
      _plugin.getNotificationAppLaunchDetails();

  Future<void> handleLaunchIfNeeded(BuildContext context) async {
    final details = await getLaunchDetails();
    final response = details?.notificationResponse;
    if (details?.didNotificationLaunchApp == true && response != null) {
      if (!context.mounted) return;
      await _dispatchPayload(context, response.payload);
    }
  }

  static void _onNotificationResponse(NotificationResponse response) {
    final ctx = AppRoutes.rootNavigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) return;
    unawaited(NotificationService.instance._dispatchPayload(
      ctx,
      response.payload,
    ));
  }

  Future<void> _dispatchPayload(BuildContext context, String? payload) async {
    if (payload == null || payload.isEmpty) return;
    final parts = payload.split('|');
    final kind = parts.first;
    final lang = context.read<LanguageProvider>();
    final appData = context.read<AppData>();

    if (kind == 'reminder' && parts.length >= 2) {
      final med = Uri.decodeComponent(parts[1]);
      await _speakReminder(lang, med);
      if (context.mounted) context.go(AppRoutes.reminders);
      return;
    }
    if (kind == 'expiry') {
      await _speakExpiryDigest(lang, appData);
      if (context.mounted) context.go(AppRoutes.expiryTracker);
      return;
    }
    if (kind == 'expiryMed' && parts.length >= 3) {
      final med = Uri.decodeComponent(parts[1]);
      final tier = parts[2];
      await _speakExpiryMedicine(lang, med, tier);
      if (context.mounted) context.go(AppRoutes.expiryTracker);
    }
  }

  Future<void> _speakReminder(LanguageProvider lang, String med) async {
    await lang.speak(_reminderLineNative(med, lang.language));
    if (lang.bilingualEnabled && lang.language != 'en') {
      await lang.speakInLanguage('Time to take $med.', 'en');
    }
  }

  Future<void> _speakExpiryMedicine(
    LanguageProvider lang,
    String med,
    String tier,
  ) async {
    final primary = _expiryMedVoice(lang.language, med, tier);
    await lang.speak(primary);
    if (lang.bilingualEnabled && lang.language != 'en') {
      await lang.speakInLanguage(_expiryMedVoiceEnglish(med, tier), 'en');
    }
  }

  String _expiryMedVoice(String code, String med, String tier) {
    final t = tier == '7'
        ? 7
        : tier == '1'
            ? 1
            : 0;
    if (t == 0) {
      switch (code) {
        case 'te':
          return '$med గడువు ఈ నెలలో ముగుస్తుంది. దయచేసి ట్రాకర్ చూడండి.';
        case 'hi':
          return '$med इस महीने समाप्त हो रही है। कृपया ट्रैकर देखें।';
        case 'ta':
          return '$med இந்த மாதம் காலாவதியாகிறது. தயவுசெய்து கண்காணிப்பைப் பார்க்கவும்.';
        default:
          return '$med reaches expiry this month. Please check your tracker.';
      }
    }
    if (t == 1) {
      switch (code) {
        case 'te':
          return '$med గడువు రేపు లేదా ఇంకా దగ్గరలో. ట్రాకర్ తనిఖీ చేయండి.';
        case 'hi':
          return '$med की समाप्ति कल या बहुत जल्द है। ट्रैकर देखें।';
        case 'ta':
          return '$med காலாவதி நாளை அல்லது விரைவில். கண்காணிப்பைச் சரிபார்க்கவும்.';
        default:
          return '$med expires tomorrow or very soon. Check your tracker.';
      }
    }
    switch (code) {
      case 'te':
        return '$med గడువు సుమారు ఒక వారంలో. ట్రాకర్ చూడండి.';
      case 'hi':
        return '$med लगभग एक सप्ताह में समाप्त हो रही है। ट्रैकर देखें।';
      case 'ta':
        return '$med ஒரு வாரத்தில் காலாவதியாகிறது. கண்காணிப்பைப் பார்க்கவும்.';
      default:
        return '$med expires in about a week. Check your tracker.';
    }
  }

  String _expiryMedVoiceEnglish(String med, String tier) {
    final t = tier == '7'
        ? 7
        : tier == '1'
            ? 1
            : 0;
    if (t == 0) {
      return '$med reaches expiry this month. Please open MediLens expiry tracker.';
    }
    if (t == 1) {
      return '$med expires tomorrow or very soon. Open MediLens expiry tracker.';
    }
    return '$med expires in about a week. Open MediLens expiry tracker.';
  }

  Future<void> _speakExpiryDigest(
      LanguageProvider lang, AppData appData) async {
    final n = appData.expiringCount + appData.expiredCount;
    final primary = _expiryVoicePrimary(lang.language, n);
    await lang.speak(primary);
    if (lang.bilingualEnabled && lang.language != 'en') {
      await lang.speakInLanguage(_expiryVoiceEnglish(n), 'en');
    }
  }

  String _reminderLineNative(String med, String code) {
    switch (code) {
      case 'te':
        return 'ఇప్పుడు $med తీసుకోండి.';
      case 'hi':
        return 'अब $med लें।';
      case 'ta':
        return 'இப்போது $med எடுக்கவும்.';
      default:
        return 'Time to take $med.';
    }
  }

  String _expiryVoicePrimary(String code, int n) {
    if (n <= 0) {
      switch (code) {
        case 'te':
          return 'గడువు ట్రాకర్‌లో ప్రత్యేక హెచ్చరికలు లేవు.';
        case 'hi':
          return 'एक्सपायरी ट्रैकर में कोई तत्काल अलर्ट नहीं है।';
        case 'ta':
          return 'காலாவதி கண்காணிப்பில் உடனடி எச்சரிக்கை இல்லை.';
        default:
          return 'No urgent expiry alerts in your tracker.';
      }
    }
    switch (code) {
      case 'te':
        return 'మీ గడువు ట్రాకర్‌లో $n మందులు శ్రద్ధ అవసరం.';
      case 'hi':
        return 'आपके एक्सपायरी ट्रैकर में $n दवाओं पर ध्यान दें।';
      case 'ta':
        return 'உங்கள் காலாவதி கண்காணிப்பில் $n மருந்துகள் கவனம் தேவை.';
      default:
        return _expiryVoiceEnglish(n);
    }
  }

  String _expiryVoiceEnglish(int n) {
    if (n <= 0) {
      return 'No urgent expiry alerts in your tracker.';
    }
    return 'You have $n medicine${n == 1 ? '' : 's'} that need attention in MediLens.';
  }

  TimeOfDay? _parseReminderTime(Map<String, dynamic> r) {
    final h = r['hour'];
    final m = r['minute'];
    if (h is int && m is int) {
      return TimeOfDay(hour: h.clamp(0, 23), minute: m.clamp(0, 59));
    }
    final s = r['time'] as String?;
    if (s == null || s.trim().isEmpty) return null;
    try {
      final dt = DateFormat.jm().parseLoose(s);
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {
      try {
        final dt = DateFormat.Hm().parse(s);
        return TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {
        return null;
      }
    }
  }

  int _weekdayFromReminder(Map<String, dynamic> r) {
    final w = r['weekday'];
    if (w is int && w >= 1 && w <= 7) return w;
    return DateTime.monday;
  }

  tz.TZDateTime _nextWallClock(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextWeekdayOccurrence(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != weekday || !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _tzAtDigestOnCalendarDay(
    DateTime calendarDay,
    int hour,
    int minute,
  ) {
    return tz.TZDateTime(
      tz.local,
      calendarDay.year,
      calendarDay.month,
      calendarDay.day,
      hour,
      minute,
    );
  }

  String _reminderNotificationTitle(LanguageProvider lang) {
    switch (lang.language) {
      case 'te':
        return 'మెడిలెన్స్ రిమైండర్';
      case 'hi':
        return 'मेडिलेंस रिमाइंडर';
      case 'ta':
        return 'மெடிலென்ஸ் நினைவூட்டல்';
      default:
        return 'MediLens reminder';
    }
  }

  String _reminderNotificationBody(
    String medName,
    LanguageProvider lang,
  ) {
    final native = _reminderLineNative(medName, lang.language);
    final english = 'Time to take $medName.';
    if (lang.bilingualEnabled && lang.language != 'en') {
      return '$native\n\n$english';
    }
    return native;
  }

  String _expiryTitle(LanguageProvider lang) {
    switch (lang.language) {
      case 'te':
        return 'గడువు ట్రాకర్';
      case 'hi':
        return 'एक्सपायरी ट्रैकर';
      case 'ta':
        return 'காலாவதி கண்காணிப்பு';
      default:
        return 'Expiry tracker';
    }
  }

  String _expiryBody(LanguageProvider lang, AppData appData) {
    final n = appData.expiringCount + appData.expiredCount;
    String primary;
    if (n <= 0) {
      primary = lang.language == 'te'
          ? 'అన్ని మందులు చెల్లుబాటులో ఉన్నాయి.'
          : lang.language == 'hi'
              ? 'सभी दवाएँ वैध हैं।'
              : lang.language == 'ta'
                  ? 'அனைத்து மருந்துகளும் செல்லுபடியாகும்.'
                  : 'All tracked medicines look fine.';
    } else {
      primary = lang.language == 'te'
          ? '$n మందుల గడువు పరిశీలించండి.'
          : lang.language == 'hi'
              ? '$n दवाओं की समाप्ति देखें।'
              : lang.language == 'ta'
                  ? '$n மருந்துகளின் காலாவதியை சரிபார்க்கவும்.'
                  : 'Review $n medicine${n == 1 ? '' : 's'} in MediLens.';
    }
    final english = n <= 0
        ? 'All tracked medicines look fine.'
        : 'Review $n medicine${n == 1 ? '' : 's'} in MediLens.';
    if (lang.bilingualEnabled && lang.language != 'en') {
      return '$primary\n\n$english';
    }
    return primary;
  }

  String _perMedTitle(LanguageProvider lang, String medName) {
    switch (lang.language) {
      case 'te':
        return 'గడువు: $medName';
      case 'hi':
        return 'समाप्ति: $medName';
      case 'ta':
        return 'காலாவதி: $medName';
      default:
        return 'Expiry: $medName';
    }
  }

  String _perMedBody(
    LanguageProvider lang,
    String medName,
    String tier,
  ) {
    final t = tier == '7'
        ? 7
        : tier == '1'
            ? 1
            : 0;
    String native;
    String english;
    if (t == 7) {
      native = lang.language == 'te'
          ? 'సుమారు ఒక వారంలో గడువు.'
          : lang.language == 'hi'
              ? 'लगभग एक सप्ताह में समाप्ति।'
              : lang.language == 'ta'
                  ? 'ஒரு வாரத்தில் காலாவதி.'
                  : 'Expires in about a week.';
      english = 'Expires in about a week. Open MediLens.';
    } else if (t == 1) {
      native = lang.language == 'te'
          ? 'రేపు లేదా చాలా త్వరలో గడువు.'
          : lang.language == 'hi'
              ? 'कल या बहुत जल्द समाप्ति।'
              : lang.language == 'ta'
                  ? 'நாளை அல்லது விரைவில் காலாவதி.'
                  : 'Expires tomorrow or very soon.';
      english = 'Expires tomorrow or very soon. Open MediLens.';
    } else {
      native = lang.language == 'te'
          ? 'ఈ నెలలో గడువు ముగుస్తుంది.'
          : lang.language == 'hi'
              ? 'इस महीने समाप्ति।'
              : lang.language == 'ta'
                  ? 'இந்த மாதம் காலாவதி.'
                  : 'Expiry end of this month.';
      english = 'Expiry this month. Open MediLens.';
    }
    if (lang.bilingualEnabled && lang.language != 'en') {
      return '$native\n\n$english';
    }
    return native;
  }

  AndroidNotificationDetails _androidDetails(String channelId) {
    return AndroidNotificationDetails(
      channelId,
      'MediLens alerts',
      channelDescription: 'Medicine reminders and expiry check-ins',
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  Future<void> sync(AppData appData, LanguageProvider lang) async {
    if (kIsWeb) return;
    if (!_initialized) await init();
    await _ensureTimeZone();
    if (!_tzReady) return;

    for (int id = _reminderIdBase; id < _reminderIdBase + 100; id++) {
      await _plugin.cancel(id);
    }
    await _plugin.cancel(_idExpiryDigest);
    for (int i = 0; i < _perMedicineSpan * _slotsPerMedicine; i++) {
      await _plugin.cancel(_perMedicineIdBase + i);
    }

    const uiMode = UILocalNotificationDateInterpretation.wallClockTime;
    final langProvider = lang;
    final digestH = langProvider.expiryDigestHour;
    final digestM = langProvider.expiryDigestMinute;

    if (langProvider.remindersNotifEnabled) {
      int slot = 0;
      for (var i = 0; i < appData.reminders.length; i++) {
        if (slot >= _maxReminderSlots) break;
        final r = appData.reminders[i];
        if ((r['enabled'] ?? true) == false) continue;

        final tod = _parseReminderTime(r);
        if (tod == null) continue;

        final name = (r['name'] as String?)?.trim() ?? 'Medicine';
        final freq = r['frequency'] as String? ?? 'daily';
        final payload = 'reminder|${Uri.encodeComponent(name)}';

        final details = NotificationDetails(
          android: _androidDetails('medilens_alerts'),
          iOS: const DarwinNotificationDetails(),
        );

        try {
          if (freq == 'weekly') {
            final wd = _weekdayFromReminder(r);
            final when = _nextWeekdayOccurrence(wd, tod.hour, tod.minute);
            await _plugin.zonedSchedule(
              _reminderIdBase + slot * 2,
              _reminderNotificationTitle(langProvider),
              _reminderNotificationBody(name, langProvider),
              when,
              details,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation: uiMode,
              payload: payload,
              matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            );
          } else {
            final when = _nextWallClock(tod.hour, tod.minute);
            await _plugin.zonedSchedule(
              _reminderIdBase + slot * 2,
              _reminderNotificationTitle(langProvider),
              _reminderNotificationBody(name, langProvider),
              when,
              details,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation: uiMode,
              payload: payload,
              matchDateTimeComponents: DateTimeComponents.time,
            );
            if (freq == 'twice') {
              final h2 = (tod.hour + 12) % 24;
              final when2 = _nextWallClock(h2, tod.minute);
              await _plugin.zonedSchedule(
                _reminderIdBase + slot * 2 + 1,
                _reminderNotificationTitle(langProvider),
                _reminderNotificationBody(name, langProvider),
                when2,
                details,
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                uiLocalNotificationDateInterpretation: uiMode,
                payload: payload,
                matchDateTimeComponents: DateTimeComponents.time,
              );
            }
          }
        } catch (e) {
          debugPrint('NotificationService: schedule reminder failed: $e');
        }
        slot++;
      }
    }

    if (!langProvider.expiryAlertsEnabled) return;

    try {
      final whenExpiry = _nextWallClock(digestH, digestM);
      await _plugin.zonedSchedule(
        _idExpiryDigest,
        _expiryTitle(langProvider),
        _expiryBody(langProvider, appData),
        whenExpiry,
        NotificationDetails(
          android: _androidDetails('medilens_alerts'),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: uiMode,
        payload: 'expiry|digest',
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('NotificationService: schedule expiry digest failed: $e');
    }

    final nowLocal = tz.TZDateTime.now(tz.local);
    for (var i = 0; i < appData.cabinet.length && i < _perMedicineSpan; i++) {
      final med = appData.cabinet[i];
      final end = AppData.parseExpiryEndDate(med.expiryDate);
      if (end == null) continue;

      final name = med.name.trim().isEmpty ? 'Medicine' : med.name.trim();
      final encoded = Uri.encodeComponent(name);
      final offsets = [7, 1, 0];
      for (var oi = 0; oi < offsets.length; oi++) {
        final daysBefore = offsets[oi];
        final fireCal = DateTime(end.year, end.month, end.day)
            .subtract(Duration(days: daysBefore));
        final scheduled = _tzAtDigestOnCalendarDay(fireCal, digestH, digestM);
        if (!scheduled.isAfter(nowLocal)) continue;

        final tier = daysBefore == 7 ? '7' : (daysBefore == 1 ? '1' : '0');
        final id = _perMedicineIdBase + i * _slotsPerMedicine + oi;
        final payload = 'expiryMed|$encoded|$tier';

        try {
          await _plugin.zonedSchedule(
            id,
            _perMedTitle(langProvider, name),
            _perMedBody(langProvider, name, tier),
            scheduled,
            NotificationDetails(
              android: _androidDetails('medilens_alerts'),
              iOS: const DarwinNotificationDetails(),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: uiMode,
            payload: payload,
          );
        } catch (e) {
          debugPrint('NotificationService: per-med schedule failed: $e');
        }
      }
    }
  }
}
