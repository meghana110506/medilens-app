import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/core/app_data.dart';
import 'package:medilens/providers/language_provider.dart';

class ExpiryTrackerScreen extends StatelessWidget {
  const ExpiryTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    final font = LanguageProvider.getFontFamily(lang);
    final appData = context.watch<AppData>();
    final medicines = appData.cabinet;

    final Map<String, Map<String, String>> labels = {
      'title': {
        'en': '📅 Expiry Tracker',
        'te': '📅 గడువు ట్రాకర్',
        'hi': '📅 समाप्ति ट्रैकर',
        'ta': '📅 காலாவதி கண்காணிப்பு'
      },
      'sub': {
        'en': 'Monitor all medicine expiry dates',
        'te': 'అన్ని మందుల గడువు తేదీలు పర్యవేక్షించండి',
        'hi': 'सभी दवाओं की समाप्ति तिथि देखें',
        'ta': 'அனைத்து மருந்துகளின் காலாவதி தேதிகளை கண்காணிக்கவும்'
      },
      'overview': {
        'en': 'OVERVIEW',
        'te': 'అవలోకనం',
        'hi': 'अवलोकन',
        'ta': 'கண்ணோட்டம்'
      },
      'valid': {
        'en': 'Valid',
        'te': 'చెల్లుబాటు',
        'hi': 'वैध',
        'ta': 'செல்லுபடியாகும்'
      },
      'expiring': {
        'en': 'Expiring Soon',
        'te': 'త్వరలో గడువు',
        'hi': 'जल्द समाप्त',
        'ta': 'விரைவில் காலாவதி'
      },
      'expired': {
        'en': 'Expired',
        'te': 'గడువు తీరింది',
        'hi': 'समाप्त',
        'ta': 'காலாவதியானது'
      },
      'all': {
        'en': 'All Medicines',
        'te': 'అన్ని మందులు',
        'hi': 'सभी दवाएं',
        'ta': 'அனைத்து மருந்துகள்'
      },
      'empty': {
        'en': 'No medicines to track.\nScan a medicine to track its expiry.',
        'te':
            'ట్రాక్ చేయడానికి మందులు లేవు.\nమందు స్కాన్ చేసి గడువు ట్రాక్ చేయండి.',
        'hi':
            'ट्रैक करने के लिए कोई दवा नहीं।\nदवा स्कैन करके एक्सपायरी ट्रैक करें।',
        'ta':
            'கண்காணிக்க மருந்துகள் இல்லை.\nமருந்தை ஸ்கேன் செய்து காலாவதியை கண்காணிக்கவும்.'
      },
      'scan_add': {
        'en': 'Scan to Add Medicine',
        'te': 'మందు జోడించడానికి స్కాన్ చేయండి',
        'hi': 'दवा जोड़ने के लिए स्कैन करें',
        'ta': 'மருந்து சேர்க்க ஸ்கேன் செய்யுங்கள்'
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
        'hi': 'सेटिंग्s',
        'ta': 'அமைப்புகள்'
      },
    };

    String label(String key) => labels[key]?[lang] ?? labels[key]?['en'] ?? key;

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
                            LangText(label('title'), lang,
                                fontSize: 16, fontWeight: FontWeight.bold),
                            LangText(label('sub'), lang,
                                fontSize: 11, color: AppTheme.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Overview card
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1A2235), Color(0xFF1F2A40)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppTheme.grey.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label('overview'),
                                  style: TextStyle(
                                      fontFamily: font,
                                      color: AppTheme.grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _overviewCard(appData.validCount.toString(),
                                      label('valid'), AppTheme.success, lang),
                                  const SizedBox(width: 8),
                                  _overviewCard(
                                      appData.expiringCount.toString(),
                                      label('expiring'),
                                      AppTheme.warning,
                                      lang),
                                  const SizedBox(width: 8),
                                  _overviewCard(appData.expiredCount.toString(),
                                      label('expired'), AppTheme.error, lang),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(label('all'),
                            style: TextStyle(
                                fontFamily: font,
                                color: AppTheme.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8)),
                        const SizedBox(height: 8),
                        if (medicines.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: AppTheme.grey, size: 64),
                                  const SizedBox(height: 16),
                                  LangText(label('empty'), lang,
                                      fontSize: 14,
                                      color: AppTheme.grey,
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 24),
                                  GestureDetector(
                                    onTap: () => context.go(AppRoutes.scan),
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
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.camera_alt,
                                              color: AppTheme.white, size: 20),
                                          const SizedBox(width: 8),
                                          LangText(label('scan_add'), lang,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...medicines.map((m) => _medicineCard(m, lang)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                  _navItem(Icons.home, label('nav_home'), false,
                      () => context.go(AppRoutes.home), font),
                  _navItem(Icons.qr_code_scanner, label('nav_scan'), false,
                      () => context.go(AppRoutes.scan), font),
                  _navItem(Icons.medical_services, label('nav_cabinet'), false,
                      () => context.go(AppRoutes.cabinet), font),
                  _navItem(Icons.alarm, label('nav_reminders'), false,
                      () => context.go(AppRoutes.reminders), font),
                  _navItem(Icons.settings, label('nav_settings'), false,
                      () => context.go(AppRoutes.settings), font),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewCard(String count, String label, Color color, String lang) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(count,
                style: TextStyle(
                    color: color, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            LangText(label, lang,
                fontSize: 11,
                color: Colors.white70,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _medicineCard(MedicineEntry medicine, String lang) {
    final color = medicine.expiryStatus == 'valid'
        ? AppTheme.success
        : medicine.expiryStatus == 'expiring'
            ? AppTheme.warning
            : AppTheme.error;
    final timeLeft = AppData.getTimeLeft(medicine.expiryDate);
    final progress = medicine.expiryStatus == 'valid'
        ? 0.75
        : medicine.expiryStatus == 'expiring'
            ? 0.15
            : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: medicine.expiryStatus == 'expired'
                ? AppTheme.error.withValues(alpha: 0.3)
                : AppTheme.grey.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(9),
            ),
            child:
                const Center(child: Text('💊', style: TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine.name,
                    style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                Text('Exp: ${medicine.expiryDate}',
                    style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(timeLeft,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.grey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 3,
                  ),
                ),
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
