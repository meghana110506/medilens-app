import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _sosSent = false;

  final List<Map<String, String>> _caregivers = [
    {'name': 'Son - Ravi', 'phone': '+91 98765 43210', 'relation': 'Son'},
    {
      'name': 'Daughter - Priya',
      'phone': '+91 87654 32109',
      'relation': 'Daughter'
    },
  ];

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Emergency SOS',
      'te': 'అత్యవసర SOS',
      'hi': 'आपातकालीन SOS',
      'ta': 'அவசர SOS'
    },
    'subtitle': {
      'en': 'Emergency Help',
      'te': 'అత్యవసర సహాయం',
      'hi': 'आपातकालीन सहायता',
      'ta': 'அவசர உதவி'
    },
    'press': {
      'en': 'Press to send emergency alert',
      'te': 'అత్యవసర అలర్ట్ పంపడానికి నొక్కండి',
      'hi': 'आपातकालीन अलर्ट भेजने के लिए दबाएं',
      'ta': 'அவசர அலர்ட் அனுப்ப அழுத்துங்கள்'
    },
    'sent': {
      'en': 'SOS sent to all caregivers!',
      'te': 'సంరక్షకులందరికీ SOS పంపబడింది!',
      'hi': 'सभी देखभालकर्ताओं को SOS भेजा गया!',
      'ta': 'அனைத்து பராமரிப்பாளர்களுக்கும் SOS அனுப்பப்பட்டது!'
    },
    'emergency': {
      'en': 'Emergency Services',
      'te': 'అత్యవసర సేవలు',
      'hi': 'आपातकालीन सेवाएं',
      'ta': 'அவசர சேவைகள்'
    },
    'call': {
      'en': 'Call 112',
      'te': '112 కి కాల్ చేయండి',
      'hi': '112 पर कॉल करें',
      'ta': '112 அழைக்கவும்'
    },
    'caregivers': {
      'en': 'Caregivers',
      'te': 'సంరక్షకులు',
      'hi': 'देखभालकर्ता',
      'ta': 'பராமரிப்பாளர்கள்'
    },
    'reset': {'en': 'Reset', 'te': 'రీసెట్', 'hi': 'रीसेट', 'ta': 'மீட்டமை'},
    'sos': {'en': 'SOS', 'te': 'అత్యవసరం', 'hi': 'आपातकाल', 'ta': 'அவசரம்'},
    'sent_short': {
      'en': 'SENT!',
      'te': 'పంపబడింది!',
      'hi': 'भेजा!',
      'ta': 'அனுப்பப்பட்டது!'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _sendSOS() async {
    setState(() => _sosSent = true);
    final provider = context.read<LanguageProvider>();
    final lang = provider.language;
    final Map<String, String> sosMessages = {
      'en':
          'Emergency SOS sent. Your caregivers have been notified. Help is on the way.',
      'te':
          'అత్యవసర SOS పంపబడింది. మీ సంరక్షకులకు సందేశం వెళ్ళింది. సహాయం వస్తోంది.',
      'hi':
          'आपातकालीन SOS भेजा गया। आपके देखभालकर्ताओं को सूचित किया गया है। मदद आ रही है।',
      'ta':
          'அவசர SOS அனுப்பப்பட்டது. உங்கள் பராமரிப்பாளர்களுக்கு தெரிவிக்கப்பட்டது. உதவி வருகிறது.',
    };
    await provider.speak(sosMessages[lang] ?? sosMessages['en']!);
  }

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:112');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _callCaregiver(String phone) async {
    final cleanPhone = phone.replaceAll(' ', '').replaceAll('-', '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(_label('title', lang)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(_label('subtitle', lang),
                  style: const TextStyle(fontSize: 14, color: AppTheme.error)),
              const SizedBox(height: 4),
              Text(_label('title', lang),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white)),
              const SizedBox(height: 40),

              // SOS Button
              ScaleTransition(
                scale: _pulseAnimation,
                child: GestureDetector(
                  onTap: _sosSent ? null : _sendSOS,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: _sosSent ? AppTheme.success : AppTheme.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_sosSent ? AppTheme.success : AppTheme.error)
                              .withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_sosSent ? Icons.check_circle : Icons.sos,
                            color: Colors.white, size: 72),
                        const SizedBox(height: 8),
                        Text(
                            _sosSent
                                ? _label('sent_short', lang)
                                : _label('sos', lang),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _sosSent ? _label('sent', lang) : _label('press', lang),
                style: TextStyle(
                    color: _sosSent ? AppTheme.success : AppTheme.grey,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Emergency Call
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_hospital,
                        color: AppTheme.error, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_label('emergency', lang),
                              style: const TextStyle(
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          const Text('112',
                              style: TextStyle(
                                  color: AppTheme.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _callEmergency,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.error,
                        minimumSize: const Size(80, 44),
                      ),
                      child: Text(_label('call', lang)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Caregivers
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_label('caregivers', lang),
                    style: const TextStyle(
                        color: AppTheme.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 12),
              ..._caregivers.map((c) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              color: AppTheme.accent.withOpacity(0.15),
                              shape: BoxShape.circle),
                          child:
                              const Icon(Icons.person, color: AppTheme.accent),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name']!,
                                  style: const TextStyle(
                                      color: AppTheme.white,
                                      fontWeight: FontWeight.w600)),
                              Text(c['phone']!,
                                  style: const TextStyle(
                                      color: AppTheme.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _callCaregiver(c['phone']!),
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.call,
                                color: AppTheme.success, size: 20),
                          ),
                        ),
                      ],
                    ),
                  )),

              if (_sosSent)
                TextButton.icon(
                  onPressed: () => setState(() => _sosSent = false),
                  icon: const Icon(Icons.refresh, color: AppTheme.grey),
                  label: Text(_label('reset', lang),
                      style: const TextStyle(color: AppTheme.grey)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
