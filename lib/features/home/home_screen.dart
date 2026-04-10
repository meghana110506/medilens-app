import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/routes.dart';
import '../../providers/language_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final Map<String, Map<String, String>> _labels = {
    'greeting': {
      'en': 'Good Morning',
      'te': 'శుభోదయం',
      'hi': 'सुप्रभात',
      'ta': 'காலை வணக்கம்'
    },
    'greeting_sub': {
      'en': 'Hello! 👋',
      'te': 'నమస్కారం! 👋',
      'hi': 'नमस्ते! 👋',
      'ta': 'வணக்கம்! 👋'
    },
    'scan': {
      'en': 'Scan Medicine',
      'te': 'మందు స్కాన్ చేయండి',
      'hi': 'दवा स्कैन करें',
      'ta': 'மருந்தை ஸ்கேன் செய்யுங்கள்'
    },
    'scan_sub': {
      'en': 'Tap to scan any medicine label',
      'te': 'మందు లేబుల్ స్కాన్ చేయడానికి నొక్కండి',
      'hi': 'किसी भी दवा लेबल को स्कैन करने के लिए टैप करें',
      'ta': 'எந்த மருந்து லேபலையும் ஸ்கேன் செய்ய தட்டுங்கள்'
    },
    'quick': {
      'en': 'Quick Access',
      'te': 'త్వరిత యాక్సెస్',
      'hi': 'त्वरित पहुँच',
      'ta': 'விரைவு அணுகல்'
    },
    'cabinet': {
      'en': 'Medicine Cabinet',
      'te': 'మందుల క్యాబినెట్',
      'hi': 'दवा कैबिनेट',
      'ta': 'மருந்து அலமாரி'
    },
    'reminders': {
      'en': 'Reminders',
      'te': 'రిమైండర్లు',
      'hi': 'रिमाइंडर',
      'ta': 'நினைவூட்டல்கள்'
    },
    'expiry': {
      'en': 'Expiry Tracker',
      'te': 'గడువు ట్రాకర్',
      'hi': 'समाप्ति ट्रैकर',
      'ta': 'காலாவதி கண்காணிப்பு'
    },
    'interactions': {
      'en': 'Drug Interactions',
      'te': 'మందుల పరస్పర క్రియ',
      'hi': 'दवा परस्पर क्रिया',
      'ta': 'மருந்து தொடர்புகள்'
    },
    'tip': {
      'en': 'Tip of the Day',
      'te': 'నేటి చిట్కా',
      'hi': 'आज की टिप',
      'ta': 'இன்றைய டிப்'
    },
    'tip_text': {
      'en': 'Always scan your medicine before taking it',
      'te': 'మందు తీసుకునే ముందు ఎల్లప్పుడూ స్కాన్ చేయండి',
      'hi': 'दवा लेने से पहले हमेशा स्कैन करें',
      'ta': 'மருந்து எடுப்பதற்கு முன் எப்போதும் ஸ்கேன் செய்யுங்கள்'
    },
    'home': {'en': 'Home', 'te': 'హోమ్', 'hi': 'होम', 'ta': 'முகப்பு'},
    'settings': {
      'en': 'Settings',
      'te': 'సెట్టింగులు',
      'hi': 'सेटिंग्स',
      'ta': 'அமைப்புகள்'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_label('greeting_sub', lang),
                          style: const TextStyle(
                              fontSize: 14, color: AppTheme.teal)),
                      Text(_label('greeting', lang),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white)),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.sos),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('SOS',
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => context.go(AppRoutes.settings),
                        icon: const Icon(Icons.settings, color: AppTheme.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Scan Button
              GestureDetector(
                onTap: () => context.go(AppRoutes.scan),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.accent, Color(0xFF1565C0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.camera_alt,
                          size: 64, color: AppTheme.white),
                      const SizedBox(height: 16),
                      Text(_label('scan', lang),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white)),
                      const SizedBox(height: 4),
                      Text(
                        _label('scan_sub', lang),
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white60),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Access
              Text(_label('quick', lang),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.grey)),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildQuickCard(
                      _label('cabinet', lang),
                      Icons.medical_information,
                      AppTheme.teal,
                      () => context.go(AppRoutes.cabinet)),
                  _buildQuickCard(
                      _label('reminders', lang),
                      Icons.calendar_today,
                      const Color(0xFF9C27B0),
                      () => context.go(AppRoutes.reminders)),
                  _buildQuickCard(
                      _label('expiry', lang),
                      Icons.warning_amber,
                      AppTheme.warning,
                      () => context.go(AppRoutes.expiryTracker)),
                  _buildQuickCard(
                      _label('interactions', lang),
                      Icons.compare_arrows,
                      AppTheme.error,
                      () => context.go(AppRoutes.interactionChecker)),
                ],
              ),
              const SizedBox(height: 24),

              // Tip
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.teal.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: AppTheme.teal, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_label('tip', lang),
                              style: const TextStyle(
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(_label('tip_text', lang),
                              style: const TextStyle(
                                  color: AppTheme.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            switch (index) {
              case 0:
                break;
              case 1:
                context.go(AppRoutes.cabinet);
                break;
              case 2:
                context.go(AppRoutes.scan);
                break;
              case 3:
                context.go(AppRoutes.reminders);
                break;
              case 4:
                context.go(AppRoutes.settings);
                break;
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.accent,
          unselectedItemColor: AppTheme.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: _label('home', lang)),
            BottomNavigationBarItem(
                icon: const Icon(Icons.medical_services),
                label: _label('cabinet', lang)),
            BottomNavigationBarItem(
                icon: const Icon(Icons.camera_alt),
                label: _label('scan', lang)),
            BottomNavigationBarItem(
                icon: const Icon(Icons.alarm),
                label: _label('reminders', lang)),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: _label('settings', lang)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
