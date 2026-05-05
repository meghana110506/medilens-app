class AppConstants {
  static const String appName = 'MediLens';
  static const String appVersion = '1.0.0';

  static const String english = 'en';
  static const String telugu = 'te';
  static const String hindi = 'hi';
  static const String tamil = 'ta';

  static const String keyLanguage = 'language';
  static const String keyFontSize = 'font_size';
  static const String keyVoiceSpeed = 'voice_speed';
  static const String keyBilingualEnabled = 'bilingual_enabled';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserSetup = 'user_setup_complete';

  /// Daily expiry digest + per-medicine one-shot times (local wall clock).
  static const String keyExpiryDigestHour = 'expiry_digest_hour';
  static const String keyExpiryDigestMinute = 'expiry_digest_minute';

  /// Master toggles for scheduling local notifications.
  static const String keyRemindersNotifEnabled = 'reminders_notif_enabled';
  static const String keyExpiryAlertsEnabled = 'expiry_alerts_enabled';

  /// After user taps Continue on the in-app explanation (before the OS dialog).
  static const String keyNotificationPermissionRequested =
      'notification_permission_requested';

  static const String dbName = 'drugs.db';
  static const String localDbName = 'medilens_local.db';

  static const double fontSmall = 14.0;
  static const double fontMedium = 18.0;
  static const double fontLarge = 22.0;
  static const double fontXLarge = 26.0;

  static const double voiceSpeedSlow = 0.5;
  static const double voiceSpeedNormal = 1.0;
  static const double voiceSpeedFast = 1.5;

  static const double ocrConfidenceThreshold = 0.7;

  static const Map<String, String> appStrings = {
    'scan_medicine': 'Scan Medicine',
    'scan_medicine_te': 'à°®à°‚à°¦à± à°¸à±à°•à°¾à°¨à± à°šà±‡à°¯à°‚à°¡à°¿',
    'scan_medicine_hi': 'à¤¦à¤µà¤¾ à¤¸à¥à¤•à¥ˆà¤¨ à¤•à¤°à¥‡à¤‚',
    'scan_medicine_ta': 'à®®à®°à¯à®¨à¯à®¤à¯ˆ à®¸à¯à®•à¯‡à®©à¯ à®šà¯†à®¯à¯à®¯à¯à®™à¯à®•à®³à¯',
    'home': 'Home',
    'home_te': 'à°¹à±‹à°®à±',
    'home_hi': 'à¤¹à¥‹à¤®',
    'home_ta': 'à®®à¯à®•à®ªà¯à®ªà¯',
    'history': 'History',
    'history_te': 'à°šà°°à°¿à°¤à±à°°',
    'history_hi': 'à¤‡à¤¤à¤¿à¤¹à¤¾à¤¸',
    'history_ta': 'à®µà®°à®²à®¾à®±à¯',
    'settings': 'Settings',
    'settings_te': 'à°¸à±†à°Ÿà±à°Ÿà°¿à°‚à°—à±à°²à±',
    'settings_hi': 'à¤¸à¥‡à¤Ÿà¤¿à¤‚à¤—à¥à¤¸',
    'settings_ta': 'à®…à®®à¯ˆà®ªà¯à®ªà¯à®•à®³à¯',
    'sos': 'SOS',
    'sos_te': 'à°…à°¤à±à°¯à°µà°¸à°°à°‚',
    'sos_hi': 'à¤†à¤ªà¤¾à¤¤à¤•à¤¾à¤²',
    'sos_ta': 'à®…à®µà®šà®°à®®à¯',
    'medicine_name': 'Medicine Name',
    'medicine_name_te': 'à°®à°‚à°¦à± à°ªà±‡à°°à±',
    'medicine_name_hi': 'à¤¦à¤µà¤¾ à¤•à¤¾ à¤¨à¤¾à¤®',
    'medicine_name_ta': 'à®®à®°à¯à®¨à¯à®¤à®¿à®©à¯ à®ªà¯†à®¯à®°à¯',
    'dosage': 'Dosage',
    'dosage_te': 'à°®à±‹à°¤à°¾à°¦à±',
    'dosage_hi': 'à¤–à¥à¤°à¤¾à¤•',
    'dosage_ta': 'à®®à®°à¯à®¨à¯à®¤à®³à®µà¯',
    'side_effects': 'Side Effects',
    'side_effects_te': 'à°¦à±à°·à±à°ªà±à°°à°­à°¾à°µà°¾à°²à±',
    'side_effects_hi': 'à¤¦à¥à¤·à¥à¤ªà¥à¤°à¤­à¤¾à¤µ',
    'side_effects_ta': 'à®ªà®•à¯à®• à®µà®¿à®³à¯ˆà®µà¯à®•à®³à¯',
    'warnings': 'Warnings',
    'warnings_te': 'à°¹à±†à°šà±à°šà°°à°¿à°•à°²à±',
    'warnings_hi': 'à¤šà¥‡à¤¤à¤¾à¤µà¤¨à¤¿à¤¯à¤¾à¤',
    'warnings_ta': 'à®Žà®šà¯à®šà®°à®¿à®•à¯à®•à¯ˆà®•à®³à¯',
    'uses': 'Uses',
    'uses_te': 'à°‰à°ªà°¯à±‹à°—à°¾à°²à±',
    'uses_hi': 'à¤‰à¤ªà¤¯à¥‹à¤—',
    'uses_ta': 'à®ªà®¯à®©à¯à®•à®³à¯',
    'next': 'Next',
    'next_te': 'à°¤à°¦à±à°ªà°°à°¿',
    'next_hi': 'à¤…à¤—à¤²à¤¾',
    'next_ta': 'à®…à®Ÿà¯à®¤à¯à®¤à¯',
    'skip': 'Skip',
    'skip_te': 'à°¦à°¾à°Ÿà°µà±‡à°¯à°‚à°¡à°¿',
    'skip_hi': 'à¤›à¥‹à¤¡à¤¼à¥‡à¤‚',
    'skip_ta': 'à®¤à®µà®¿à®°à¯',
    'save': 'Save',
    'save_te': 'à°¸à±‡à°µà± à°šà±‡à°¯à°‚à°¡à°¿',
    'save_hi': 'à¤¸à¤¹à¥‡à¤œà¥‡à¤‚',
    'save_ta': 'à®šà¯‡à®®à®¿',
    'cancel': 'Cancel',
    'cancel_te': 'à°°à°¦à±à°¦à± à°šà±‡à°¯à°‚à°¡à°¿',
    'cancel_hi': 'à¤°à¤¦à¥à¤¦ à¤•à¤°à¥‡à¤‚',
    'cancel_ta': 'à®°à®¤à¯à®¤à¯ à®šà¯†à®¯à¯',
    'add': 'Add',
    'add_te': 'à°œà±‹à°¡à°¿à°‚à°šà°‚à°¡à°¿',
    'add_hi': 'à¤œà¥‹à¤¡à¤¼à¥‡à¤‚',
    'add_ta': 'à®šà¯‡à®°à¯',
  };
}


